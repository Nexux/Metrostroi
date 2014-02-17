AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



--------------------------------------------------------------------------------
function ENT:Initialize()
	-- Initialize physics for the selected model
	if self:GetModel() == "models/error.mdl" then
		self:SetModel("models/props_lab/reciever01a.mdl")
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	-- Train wires
	self:ResetTrainWires()
	-- Systems defined in the train
	self.Systems = {}
	-- Initialize train systems
	self:InitializeSystems()
	
	-- Prop-protection related
	if CPPI and self.Owner then
		self:CPPISetOwner(self.Owner)
	end

	-- Initialize wire interface
	if Wire_CreateInputs then
		local inputs = {}
		local outputs = {}
		local inputTypes = {}
		local outputTypes = {}
		for k,v in pairs(self.Systems) do
			local i = v:Inputs()
			local o = v:Outputs()
			
			for _,v2 in pairs(i) do 
				if type(v2) == "string" then
					table.insert(inputs,(v.Name or "")..v2) 
					table.insert(inputTypes,"NORMAL")
				elseif type(v2) == "table" then
					table.insert(inputs,(v.Name or "")..v2[1])
					table.insert(inputTypes,v2[2])
				else
					ErrorNoHalt("Invalid wire input for metrostroi subway entity")
				end
			end
			
			for _,v2 in pairs(o) do 
				if type(v2) == "string" then
					table.insert(outputs,(v.Name or "")..v2) 
					table.insert(outputTypes,"NORMAL")
				elseif type(v2) == "table" then
					table.insert(outputs,(v.Name or "")..v2[1])
					table.insert(outputTypes,v2[2])
				else
					ErrorNoHalt("Invalid wire output for metrostroi subway entity")
				end
			end
		end
		
		-- Add input for a custom driver seat
		table.insert(inputs,"DriverSeat")
		table.insert(inputTypes,"ENTITY")
		
		self.Inputs = WireLib.CreateSpecialInputs(self,inputs,inputTypes)
		self.Outputs = WireLib.CreateSpecialOutputs(self,outputs,outputTypes)
	end


	-- Setup drivers controls
	self.ButtonBuffer = {}
	self.KeyBuffer = {}
	self.KeyMap = {}
	
	-- External interaction areas
	self.InteractionAreas = {}

	-- Joystick module support
	if joystick then
		self.JoystickBuffer = {}
	end
	self.DebugVars = {}

	-- Entities that belong to train and must be cleaned up later
	self.TrainEntities = {}
	-- All the sitting positions in train
	self.Seats = {}
	-- List of headlights, dynamic lights, sprite lights
	self.Lights = {}
	
	-- Cross-connections in train wires
	self.TrainWireCrossConnections = {}

	-- Load sounds
	self:InitializeSounds()
	
	-- Is this train 'odd' or 'even' in coupled set
	self.TrainCoupledIndex = 0
	
	-- Initialize train
	if Turbostroi then
		Turbostroi.InitializeTrain(self)
	end
	
	-- Passenger related data (must be set by derived trains to allow boarding)
	self.LeftDoorsOpen = false
	self.LeftDoorsBlocked = false
	self.LeftDoorPositions = { Vector(0,0,0) }
	self.RightDoorsOpen = false
	self.RightDoorsBlocked = false
	self.RightDoorPositions = { Vector(0,0,0) }
	self:SetPassengerCount(0)
	
	-- Get default train mass
	self.NormalMass = self:GetPhysicsObject():GetMass()
end

-- Remove entity
function ENT:OnRemove()
	-- Remove all linked objects
	constraint.RemoveAll(self)
	if self.TrainEntities then
		for k,v in pairs(self.TrainEntities) do
			SafeRemoveEntity(v)
		end
	end
	
	-- Deinitialize train
	if Turbostroi then
		Turbostroi.DeinitializeTrain(self)
	end
end

-- Interaction zones
function ENT:Use(ply)
	local tr = ply:GetEyeTrace()
	if not tr.Hit then return end
	local hitpos = self:WorldToLocal(tr.HitPos)
	
	if self.InteractionZones then
		for k,v in pairs(self.InteractionZones) do
			if hitpos:Distance(v.Pos) < v.Radius then
				self:ButtonEvent(v.ID)
			end
		end
	end
end

-- Trigger output
function ENT:TriggerOutput(name,value)
	if Wire_TriggerOutput then
		Wire_TriggerOutput(self,name,tonumber(value) or 0)
	end
end

-- Trigger input
function ENT:TriggerInput(name, value)
	-- Custom seat 
	if name == "DriverSeat" then
		if IsValid(value) and value:IsVehicle() then
			self.DriverSeat = value
		else
			self.DriverSeat = nil
		end
	end

	-- Propagate inputs to relevant systems
	for k,v in pairs(self.Systems) do
		if v.Name and (string.sub(name,1,#v.Name) == v.Name) then
			local subname = string.sub(name,#v.Name+1)
			if v.IsInput[subname] then
				v:TriggerInput(subname,value)
			end
		elseif v.IsInput[name] then
			v:TriggerInput(name,value)
		end
	end
end

-- The debugger will call this
function ENT:GetDebugVars()
	return self.DebugVars 
end

--Debugging function, call via the console or something
function ENT:ShowInteractionZones()
	for k,v in pairs(self.InteractionZones) do
		debugoverlay.Sphere(self:LocalToWorld(v.Pos),v.Radius,15,Color(255,185,0),true)
	end
end


--------------------------------------------------------------------------------
-- Train wire I/O
--------------------------------------------------------------------------------
function ENT:TrainWireCanWrite(k)
	local lastwrite = self.TrainWireWriters[k]
	if lastwrite ~= nil then
		-- Check if someone else wrote recently
		--for writer,v in pairs(lastwrite) do
		local writer = lastwrite.e
		local v = lastwrite.t or 0
			if (writer ~= self) and (CurTime() - v < 0.25) then
				return false
			end
		--end
	end
	return true
end

function ENT:IsTrainWireCrossConnected(k)
	local lastwrite = self.TrainWireWriters[k]
	local lastTime = 0
	local ent = nil
	if lastwrite then
		--for writer,v in pairs(lastwrite) do
		local writer = lastwrite.e
		local v = lastwrite.t or 0
			if v > lastTime then
				lastTime = v
				ent = writer
			end
		--end
	end

	return ent and (ent.TrainCoupledIndex ~= self.TrainCoupledIndex)
end

function ENT:WriteTrainWire(k,v)
	-- Check if line is write-able
	local can_write = self:TrainWireCanWrite(k)
	local wrote = false
	
	-- Writing rules for different wires
	local allowed_write = v > 0 -- Normally positive values override others
	if k == 18 then allowed_write = v <= 0 end -- For wire 18, zero values override others
	for a,b in pairs(self.TrainWireCrossConnections) do
		if self:IsTrainWireCrossConnected(a) or self:IsTrainWireCrossConnected(b) then
			    if k == a then k = b
			elseif k == b then k = a end
		end
	end
	
	-- Write only if can write (no-one else occupies it) or allowed to write (legal value)
	if can_write then
		self.TrainWires[k] = v
		wrote = true
	elseif allowed_write then
		self.TrainWires[k] = v
		wrote = true
	end
	
	-- Record us as last writer
	if wrote and (allowed_write or can_write) then
		self.TrainWireWriters[k] = self.TrainWireWriters[k] or {}
		self.TrainWireWriters[k].t = CurTime()
		self.TrainWireWriters[k].e = self
	end
end

function ENT:ReadTrainWire(k)
	-- Cross-commutate some wires
	for a,b in pairs(self.TrainWireCrossConnections) do
		if self:IsTrainWireCrossConnected(a) or self:IsTrainWireCrossConnected(b) then
			    if k == a then k = b
			elseif k == b then k = a end
		end
	end
	return self.TrainWires[k] or 0
end

function ENT:OnTrainWireError(k)

end

function ENT:ResetTrainWires()
	-- Remember old train wires reference
	local trainWires = self.TrainWires
	
	-- Create new train wires
	self.TrainWires = {}
	self.TrainWireWriters = {}
	
	-- Initialize train wires to zero values
	for i=1,128 do self.TrainWires[i] = 0 end
	
	-- Update train wires in all connected trains
	local function updateWires(train,checked)
		if not train then return end
		if checked[train] then return end
		checked[train] = true
		
		if train.TrainWires == trainWires then
			train.TrainWires = self.TrainWires
			train.TrainWireWriters = self.TrainWireWriters
		end
		updateWires(train.FrontTrain,checked)
		updateWires(train.RearTrain,checked)
	end
	updateWires(self,{})
end

function ENT:SetTrainWires(coupledTrain)
	-- Get train wires from train
	self.TrainWires = coupledTrain.TrainWires
	self.TrainWireWriters = coupledTrain.TrainWireWriters
	
	-- Update train wires in all connected trains
	local function updateWires(train,checked)
		if not train then return end
		if checked[train] then return end
		checked[train] = true
		
		if train.TrainWires ~= coupledTrain.TrainWires then
			train.TrainWires = coupledTrain.TrainWires
			train.TrainWireWriters = coupledTrain.TrainWireWriters
		end
		updateWires(train.FrontTrain,checked)
		updateWires(train.RearTrain,checked)
	end
	updateWires(self,{})
end




--------------------------------------------------------------------------------
-- Coupling logic
--------------------------------------------------------------------------------
function ENT:UpdateIndexes()
	local function updateIndexes(train,checked,newIndex)
		if not train then return end
		if checked[train] then return end
		checked[train] = true
		
		train.TrainCoupledIndex = newIndex
		
		if train.FrontTrain and (train.FrontTrain.FrontTrain == train) then
			updateIndexes(train.FrontTrain,checked,1-newIndex)
		else
			updateIndexes(train.FrontTrain,checked,newIndex)
		end
		if train.RearTrain and (train.RearTrain.RearTrain == train) then
			updateIndexes(train.RearTrain,checked,1-newIndex)
		else
			updateIndexes(train.RearTrain,checked,newIndex)
		end
	end
	updateIndexes(self,{},0)
end

function ENT:OnCouple(bogey,isfront)
	--print(self,"Coupled with ",bogey," at ",isfront)
	if isfront then
		self.FrontCoupledBogey = bogey
	else
		self.RearCoupledBogey = bogey
	end
	
	local train = bogey:GetNWEntity("TrainEntity")
	if not IsValid(train) then return end
	--Don't update train wires when there's no parent train 
	
	self:UpdateCoupledTrains()

	if ((train.FrontTrain == self) or (train.RearTrain == self)) then
		self:UpdateIndexes()
	end
	
	-- Update train wires
	self:SetTrainWires(train)
end

function ENT:OnDecouple(isfront)
	--print(self,"Decoupled from front?:" ,isfront)	
	if isfront then
		self.FrontCoupledBogey = nil
	else 
		self.RearCoupledBogey = nil
	end
	
	self:UpdateCoupledTrains()
	self:UpdateIndexes()
	self:ResetTrainWires()
end

function ENT:UpdateCoupledTrains()
	if self.FrontCoupledBogey then
		self.FrontTrain = self.FrontCoupledBogey:GetNWEntity("TrainEntity")
	else
		self.FrontTrain = nil
	end
	
	if self.RearCoupledBogey then
		self.RearTrain = self.RearCoupledBogey:GetNWEntity("TrainEntity")
	else
		self.RearTrain = nil
	end
end




--------------------------------------------------------------------------------
-- Create a bogey for the train
--------------------------------------------------------------------------------
function ENT:CreateBogey(pos,ang,forward,type)
	-- Create bogey entity
	local bogey = ents.Create("gmod_train_bogey")
	bogey:SetPos(self:LocalToWorld(pos))
	bogey:SetAngles(self:GetAngles() + ang)
	bogey.BogeyType = type
	bogey:Spawn()

	-- Assign ownership
	if CPPI then bogey:CPPISetOwner(self:CPPIGetOwner()) end
	
	-- Some shared general information about the bogey
	bogey:SetNWBool("IsForwardBogey", forward)
	bogey:SetNWEntity("TrainEntity", self)

	-- Constraint bogey to the train
	constraint.Axis(bogey,self,0,0,
		Vector(0,0,0),Vector(0,0,0),
		0,0,0,1,Vector(0,0,1),false)

	-- Add to cleanup list
	table.insert(self.TrainEntities,bogey)
	return bogey
end


--------------------------------------------------------------------------------
-- Create an entity for the seat
--------------------------------------------------------------------------------
function ENT:CreateSeatEntity(seat_info)
	-- Create seat entity
	local seat = ents.Create("prop_vehicle_prisoner_pod")
	seat:SetModel("models/nova/jeep_seat.mdl") --jalopy
	seat:SetPos(self:LocalToWorld(seat_info.offset))
	seat:SetAngles(self:GetAngles()+Angle(0,-90,0)+seat_info.angle)
	seat:SetKeyValue("limitview",0)
	seat:Spawn()
	seat:GetPhysicsObject():SetMass(10)
	seat:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	--Assign ownership
	if CPPI then seat:CPPISetOwner(self:CPPIGetOwner()) end
	
	-- Hide the entity visually
	--if seat_info.type ~= "instructor" then
		--seat:SetColor(Color(0,0,0,0))
		--seat:SetRenderMode(RENDERMODE_TRANSALPHA)
	--end

	-- Set some shared information about the seat
	self:SetNWEntity("seat_"..seat_info.type,seat)
	seat:SetNWString("SeatType", seat_info.type)
	seat:SetNWEntity("TrainEntity", self)
	seat_info.entity = seat

	-- Constrain seat to this object
	-- constraint.NoCollide(self,seat,0,0)
	seat:SetParent(self)
	
	-- Add to cleanup list
	table.insert(self.TrainEntities,seat)
	return seat
end


--------------------------------------------------------------------------------
-- Create a seat position
--------------------------------------------------------------------------------
function ENT:CreateSeat(type,offset,angle)
	-- Add a new seat
	local seat_info = {
		type = type,
		offset = offset,
		angle = angle or Angle(0,0,0),
	}
	table.insert(self.Seats,seat_info)
	
	-- If needed, create an entity for this seat
	if (type == "driver") or (type == "instructor") then
		return self:CreateSeatEntity(seat_info)
	end
end

-- Returns if KV/reverser wrench is present in cabin
function ENT:IsWrenchPresent()
	for k,v in pairs(self.Seats) do
		if IsValid(v.entity) and v.entity.GetPassenger and
			((v.type == "driver") or (v.type == "instructor")) then
			local player = self.DriverSeat:GetPassenger(0)
			if player and player:IsValid() then return true end
		end
	end
	return false
end




--------------------------------------------------------------------------------
-- Turn light on or off
--------------------------------------------------------------------------------
function ENT:SetLightPower(index,power,brightness)
	local lightData = self.Lights[index]
	self.GlowingLights = self.GlowingLights or {}
	self.LightBrightness = self.LightBrightness or {}
	brightness = brightness or 1

	-- Check if light already glowing
	if (power and (self.GlowingLights[index])) and 
	   (brightness == self.LightBrightness[index]) then return end
	
	-- Turn off light
	SafeRemoveEntity(self.GlowingLights[index])
	self.GlowingLights[index] = nil
	self.LightBrightness[index] = brightness
	
	-- Create light
	if (lightData[1] == "headlight") and (power) then
		local light = ents.Create("env_projectedtexture")
		light:SetParent(self)
		light:SetLocalPos(lightData[2])
		light:SetLocalAngles(lightData[3])

		-- Set parameters
		light:SetKeyValue("enableshadows", 1)
		light:SetKeyValue("farz", 2048)
		light:SetKeyValue("nearz", 16)
		light:SetKeyValue("lightfov", lightData.fov or 120)

		-- Set Brightness
		local brightness = brightness * (lightData.brightness or 1.25)
		light:SetKeyValue("lightcolor",
			Format("%i %i %i 255",
				lightData[4].r*brightness,
				lightData[4].g*brightness,
				lightData[4].b*brightness
			)
		)

		-- Turn light on
		light:Spawn() --"effects/flashlight/caustics"
		light:Input("SpotlightTexture",nil,nil,lightData.texture or "effects/flashlight001")
		self.GlowingLights[index] = light
	end
	if (lightData[1] == "glow") and (power) then
		local light = ents.Create("env_sprite")
		light:SetParent(self)
		light:SetLocalPos(lightData[2])
		light:SetLocalAngles(lightData[3])
	
		-- Set parameters
		local brightness = brightness * (lightData.brightness or 0.5)
		light:SetKeyValue("rendercolor",
			Format("%i %i %i",
				lightData[4].r*brightness,
				lightData[4].g*brightness,
				lightData[4].b*brightness
			)
		)
		light:SetKeyValue("rendermode", lightData.type or 3) -- 9: WGlow, 3: Glow
		light:SetKeyValue("model", lightData.texture or "sprites/glow1.vmt")
--		light:SetKeyValue("model", "sprites/light_glow02.vmt")
--		light:SetKeyValue("model", "sprites/yellowflare.vmt")
		light:SetKeyValue("scale", lightData.scale or 1.0)
		light:SetKeyValue("spawnflags", 1)
	
		-- Turn light on
		light:Spawn()
		self.GlowingLights[index] = light
	end
	if (lightData[1] == "light") and (power) then
		local light = ents.Create("env_sprite")
		light:SetParent(self)
		light:SetLocalPos(lightData[2])
		light:SetLocalAngles(lightData[3])
	
		-- Set parameters
		local brightness = brightness * (lightData.brightness or 0.5)
		light:SetKeyValue("rendercolor",
			Format("%i %i %i",
				lightData[4].r*brightness,
				lightData[4].g*brightness,
				lightData[4].b*brightness
			)
		)
		light:SetKeyValue("rendermode", lightData.type or 9) -- 9: WGlow, 3: Glow
--		light:SetKeyValue("model", "sprites/glow1.vmt")
		light:SetKeyValue("model", lightData.texture or "sprites/light_glow02.vmt")
--		light:SetKeyValue("model", "sprites/yellowflare.vmt")
		light:SetKeyValue("scale", lightData.scale or 1.0)
		light:SetKeyValue("spawnflags", 1)
	
		-- Turn light on
		light:Spawn()
		self.GlowingLights[index] = light
	end
	if (lightData[1] == "dynamiclight") and (power) then
		local light = ents.Create("light_dynamic")
		light:SetParent(self)

		-- Set position
		light:SetLocalPos(lightData[2])
		light:SetLocalAngles(lightData[3])

		-- Set parameters
		light:SetKeyValue("_light",
			Format("%i %i %i",
				lightData[4].r,
				lightData[4].g,
				lightData[4].b
			)
		)
		light:SetKeyValue("style", 0)
		light:SetKeyValue("distance", lightData.distance or 300)
		light:SetKeyValue("brightness", lightData.brightness or 2)

		-- Turn light on
		light:Spawn()
		light:Fire("TurnOn","","0")
		self.GlowingLights[index] = light
	end
end




--------------------------------------------------------------------------------
-- Joystick input
--------------------------------------------------------------------------------
function ENT:HandleJoystickInput(ply)
	for k,v in pairs(jcon.binds) do
		if v:GetCategory() == "Metrostroi" then
			local jvalue = Metrostroi.GetJoystickInput(ply,k)
			if (jvalue != nil) and (self.JoystickBuffer[k] ~= jvalue) then
				local inputname = Metrostroi.JoystickSystemMap[k]
				self.JoystickBuffer[k] = jvalue
				if inputname then
					if type(jvalue) == "boolean" then
						if jvalue then
							jvalue = 1.0
						else
							jvalue = 0.0
						end
					end
					self:TriggerInput(inputname,jvalue)
				end
			end
		end
	end
end




--------------------------------------------------------------------------------
-- Keyboard input
--------------------------------------------------------------------------------
function ENT:IsModifier(key)
	return type(self.KeyMap[key]) == "table"
end

function ENT:HasModifier(key)
	return self.KeyMods[key] ~= nil
end

function ENT:GetActiveModifiers(key)
	local tbl = {}
	local mods = self.KeyMods[key]
	for k,v in pairs(mods) do
		if self.KeyBuffer[k] ~= nil then
			table.insert(tbl,k)
		end
	end
	return tbl
end

function ENT:OnKeyEvent(key,state)
	
	if state then
		self:OnKeyPress(key)
	else
		self:OnKeyRelease(key)
	end
	
	if self:HasModifier(key) then
		--If we have a modifier
		local actmods = self:GetActiveModifiers(key)
		if #actmods > 0 then
			--Modifier is being preseed
			for k,v in pairs(actmods) do
				if self.KeyMap[v][key] ~= nil then
					self:ButtonEvent(self.KeyMap[v][key],state)
				end
			end
		elseif self.KeyMap[key] ~= nil then
			self:ButtonEvent(self.KeyMap[key],state)
		end
		
	elseif self:IsModifier(key) and not state then
		--Release modified keys
		for k,v in pairs(self.KeyMap[key]) do
			self:ButtonEvent(v,false)
		end
		
	elseif self.KeyMap[key] ~= nil and type(self.KeyMap[key]) == "string" then
		--If we're a regular binded key
		self:ButtonEvent(self.KeyMap[key],state)
	end
end

function ENT:OnKeyPress(key)

end

function ENT:OnKeyRelease(key)

end

function ENT:ProcessKeyMap()
	self.KeyMods = {}

	for mod,v in pairs(self.KeyMap) do
		if type(v) == "table" then
			for k,_ in pairs(v) do
				if not self.KeyMods[k] then
					self.KeyMods[k]={}
				end
				self.KeyMods[k][mod]=true
			end
		end
	end
end


local function HandleKeyHook(ply,k,state)
	local train = ply:GetTrain()
	if IsValid(train) then
		train.KeyMap[k] = state or nil
	end
end

function ENT:HandleKeyboardInput(ply)
	if not self.KeyMods and self.KeyMap then
		self:ProcessKeyMap()
	end

	-- Check for newly pressed keys
	for k,v in pairs(ply.keystate) do
		if self.KeyBuffer[k] == nil then
			self.KeyBuffer[k] = true
			self:OnKeyEvent(k,true)
		end
	end

	-- Check for newly released keys
	for k,v in pairs(self.KeyBuffer) do
		if ply.keystate[k] == nil then
			self.KeyBuffer[k] = nil
			self:OnKeyEvent(k,false)
		end
	end

end

--------------------------------------------------------------------------------
-- Process train logic
--------------------------------------------------------------------------------
-- Think and execute systems stuff
function ENT:Think()
	self.PrevTime = self.PrevTime or CurTime()
	self.DeltaTime = (CurTime() - self.PrevTime)
	self.PrevTime = CurTime()
	
	-- Calculate train acceleration
	--[[self.PreviousVelocity = self.PreviousVelocity or self:GetVelocity()
	local accelerationVector = 0.01905*(self:GetPhysicsObject():GetVelocity() - self.PreviousVelocity) / self.DeltaTime
	accelerationVector:Rotate(self:GetAngles())
	self:SetTrainAcceleration(accelerationVector)
	self.PreviousVelocity = self:GetVelocity()]]--
	
	-- Get angular velocity
	--self:SetTrainAngularVelocity(math.pi*self:GetPhysicsObject():GetAngleVelocity()/180)
	
	-- Apply mass of passengers
	self:GetPhysicsObject():SetMass(self.NormalMass + 80*self:GetPassengerCount())
	
	-- Calculate turn information, unused right now
	if self.FrontBogey and self.RearBogey then
		self.BogeyDistance = self.BogeyDistance or self.FrontBogey:GetPos():Distance(self.RearBogey:GetPos())
		local a = math.AngleDifference(self.FrontBogey:GetAngles().y,self.RearBogey:GetAngles().y+180)
		self.TurnRadius = (self.BogeyDistance/2)/math.sin(math.rad(a/2))
		
		--If we're pretty much going straight, correct massive values
		if math.abs(self.TurnRadius) > 1e4 then
			self.TurnRadius = 0 
		end
		
		--[[ -- Debug output
			local right = self:GetAngles():Right()
			right.z = 0
			right:Normalize()
			debugoverlay.Line(self:GetPos(),self:GetPos()+right*-self.TurnRadius,1,Color(255,0,0),true)
		--]]		
	end

	-- Process the keymap for modifiers 
	-- TODO: Need a neat way of calling this once after self.KeyMap is populated
	if not self.KeyMods and self.KeyMap then
		self:ProcessKeyMap()
	end
	
	-- Keyboard input is done via PlayerButtonDown/Up hooks that call ENT:OnKeyEvent
	
	-- Joystick input
	if IsValid(self.DriverSeat) then
		local ply = self.DriverSeat:GetPassenger(0) 
		
		if IsValid(ply) then
			if self.KeyMap then self:HandleKeyboardInput(ply) end
			if joystick then self:HandleJoystickInput(ply) end
		end
	end
	
	if Turbostroi then
		-- Simulate systems which don't need to be simulated with turbostroi
		for k,v in pairs(self.Systems) do
			if v.Think then v:Think(self.DeltaTime / (v.SubIterations or 1),i) end
		end
	else
		-- Run iterations on systems simulation
		local iterationsCount = 1
		if (not self.Schedule) or (iterationsCount ~= self.Schedule.IterationsCount) then
			self.Schedule = { IterationsCount = iterationsCount }
			
			-- Find max number of iterations
			local maxIterations = 0
			for k,v in pairs(self.Systems) do maxIterations = math.max(maxIterations,(v.SubIterations or 1)) end

			-- Create a schedule of simulation
			for iteration=1,maxIterations do self.Schedule[iteration] = {} end

			-- Populate schedule
			for k,v in pairs(self.Systems) do
				local simIterationsPerIteration = (v.SubIterations or 1) / maxIterations
				local iterations = 0
				for iteration=1,maxIterations do
					iterations = iterations + simIterationsPerIteration
					while iterations >= 1 do
						table.insert(self.Schedule[iteration],v)
						iterations = iterations - 1
					end
				end
			end
		end
		
		-- Simulate according to schedule
		for i,s in ipairs(self.Schedule) do
			for k,v in ipairs(s) do
				v:Think(self.DeltaTime / (v.SubIterations or 1),i)
			end
		end
	end
	
	
	-- Add interesting debug variables
	for i=1,32 do
		self.DebugVars["TW"..i] = self:ReadTrainWire(i)
	end
	for k,v in pairs(self.Systems) do
		for _,output in pairs(v.OutputsList) do
			self.DebugVars[(v.Name or "")..output] = v[output] or 0
		end
	end

	self:NextThink(CurTime()+0.01)
	return true
end




--------------------------------------------------------------------------------
-- Default spawn function
--------------------------------------------------------------------------------
function ENT:SpawnFunction(ply, tr)
	local verticaloffset = 5 -- Offset for the train model
	local distancecap = 2000 -- When to ignore hitpos and spawn at set distanace
	local pos, ang = nil
	local inhibitrerail = false
	
	--TODO: Make this work better for raw base ent
	
	if tr.Hit then
		-- Setup trace to find out of this is a track
		local tracesetup = {}
		tracesetup.start=tr.HitPos
		tracesetup.endpos=tr.HitPos+tr.HitNormal*80
		tracesetup.filter=ply

		local tracedata = util.TraceLine(tracesetup)

		if tracedata.Hit then
			-- Trackspawn
			pos = (tr.HitPos + tracedata.HitPos)/2 + Vector(0,0,verticaloffset)
			ang = tracedata.HitNormal
			ang:Rotate(Angle(0,90,0))
			ang = ang:Angle()
			-- Bit ugly because Rotate() messes with the orthogonal vector | Orthogonal? I wrote "origional?!" :V
		else
			-- Regular spawn
			if tr.HitPos:Distance(tr.StartPos) > distancecap then
				-- Spawnpos is far away, put it at distancecap instead
				pos = tr.StartPos + tr.Normal * distancecap
				inhibitrerail = true
			else
				-- Spawn is near
				pos = tr.HitPos + tr.HitNormal * verticaloffset
			end
			ang = Angle(0,tr.Normal:Angle().y,0)
		end
	else
		-- Trace didn't hit anything, spawn at distancecap
		pos = tr.StartPos + tr.Normal * distancecap
		ang = Angle(0,tr.Normal:Angle().y,0)
	end

	local ent = ents.Create(self.ClassName)

	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	
	if not inhibitrerail then Metrostroi.RerailTrain(ent) end
	
	-- Debug mode
	--Metrostroi.DebugTrain(ent,ply)
	return ent
end




--------------------------------------------------------------------------------
-- Process Cabin button and keyboard input
--------------------------------------------------------------------------------
function ENT:OnButtonPress(button)

end

function ENT:OnButtonRelease(button)

end

-- Clears the serverside keybuffer and fires events
function ENT:ClearKeyBuffer()
	for k,v in pairs(self.KeyBuffer) do
		local button = self.KeyMap[k]
		if button ~= nil then
			if type(button) == "string" then
				self:ButtonEvent(button,false)
			else
				--Check modifiers as well
				for k2,v2 in pairs(button) do
					self:ButtonEvent(v2,false)
				end
			end
		end
	end
	self.KeyBuffer = {}
end

local function ShouldWriteToBuffer(buffer,state)
	if state == nil then return false end
	if state == false and buffer == nil then return false end
	return true
end

local function ShouldFireEvents(buffer,state)
	if state == nil then return true end
	if buffer == nil and state == false then return false end
	return (state ~= buffer) 
end

-- Checks a button with the buffer and calls 
-- OnButtonPress/Release as well as TriggerInput

function ENT:ButtonEvent(button,state)
	if ShouldFireEvents(self.ButtonBuffer[button],state) then
		if state == false then
			self:TriggerInput(button,0.0)
			self:OnButtonRelease(button)
		else
			self:TriggerInput(button,1.0)
			self:OnButtonPress(button)
		end
	end
	
	if ShouldWriteToBuffer(self.ButtonBuffer[button],state) then
		self.ButtonBuffer[button]=state
	end
end




--------------------------------------------------------------------------------
-- Handle cabin buttons
--------------------------------------------------------------------------------
-- Receiver for CS buttons, Checks if people are the legit driver and calls buttonevent on the train
net.Receive("metrostroi-cabin-button", function(len, ply)
	local button = net.ReadString()
	local eventtype = net.ReadBit()
	local seat = ply:GetVehicle()
	local train 
	
	if seat and IsValid(seat) then 
		-- Player currently driving
		train = seat:GetNWEntity("TrainEntity")
		if (not train) or (not train:IsValid()) then return end
		if seat != train.DriverSeat then return end
	else
		-- Player not driving, check recent train
		train = ply.lastVehicleDriven:GetNWEntity("TrainEntity")
		if !IsValid(train) then return end
		if ply != train.DriverSeat.lastDriver then return end
		if CurTime() - train.DriverSeat.lastDriverTime > 1	then return end
	end
	
	train:ButtonEvent(button,(eventtype > 0))
end)

-- Denies entry if player recently sat in the same train seat
-- This prevents getting stuck in seats when trying to exit
local function CanPlayerEnter(ply,vec,role)
	local train = vec:GetNWEntity("TrainEntity")
	
	if IsValid(train) and IsValid(ply.lastVehicleDriven) and ply.lastVehicleDriven.lastDriverTime != nil then
		if CurTime() - ply.lastVehicleDriven.lastDriverTime < 1 then return false end
	end
end

-- Exiting player hook, stores some vars and moves player if vehicle was train seat
local function HandleExitingPlayer(ply, vehicle)
	vehicle.lastDriver = ply
	vehicle.lastDriverTime = CurTime()
	ply.lastVehicleDriven = vehicle

	local train = vehicle:GetNWEntity("TrainEntity")
	if IsValid(train) then
		
		-- Move exiting player
		local seattype = vehicle:GetNWString("SeatType")
		local offset 
		
		if (seattype == "driver") then
			offset = Vector(0,10,-17)
		elseif (seattype == "instructor") then
			offset = Vector(5,-10,-17)
		elseif (seattype == "passenger") then
			offset = Vector(10,0,-17)
		end
		
		offset:Rotate(train:GetAngles())
		ply:SetPos(vehicle:GetPos()+offset)
		
		ply:SetEyeAngles(vehicle:GetForward():Angle())
		
		-- Server
		train:ClearKeyBuffer()
		
		-- Client
		net.Start("metrostroi-cabin-reset")
		net.WriteEntity(train)
		net.Send(ply)
	end
end




--------------------------------------------------------------------------------
-- Register joystick buttons
-- Won't get called if joystick isn't installed
-- I've put it here for now, trains will likely share these inputs anyway
local function JoystickRegister()
	Metrostroi.RegisterJoystickInput("met_controller",true,"Controller",-3,3)
	Metrostroi.RegisterJoystickInput("met_reverser",true,"Reverser",-1,1)
	Metrostroi.RegisterJoystickInput("met_pneubrake",true,"Pneumatic Brake",1,5)
	Metrostroi.RegisterJoystickInput("met_headlight",false,"Headlight Toggle")
	
--	Metrostroi.RegisterJoystickInput("met_reverserup",false,"Reverser Up")
--	Metrostroi.RegisterJoystickInput("met_reverserdown",false,"Reverser Down")
--	Will make this somewhat better later
--	Uncommenting these somehow makes the joystick addon crap itself

	Metrostroi.JoystickSystemMap["met_controller"] = "KVControllerSet"
	Metrostroi.JoystickSystemMap["met_reverser"] = "KVReverserSet"
	Metrostroi.JoystickSystemMap["met_pneubrake"] = "PneumaticBrakeSet"
	Metrostroi.JoystickSystemMap["met_headlight"] = "HeadLightsToggle"
--	Metrostroi.JoystickSystemMap["met_reverserup"] = "KVReverserUp"
--	Metrostroi.JoystickSystemMap["met_reverserdown"] = "KVReverserDown"
end

hook.Add("JoystickInitialize","metroistroi_cabin",JoystickRegister)

hook.Add("PlayerLeaveVehicle", "gmod_subway_81-717-cabin-exit", HandleExitingPlayer )
hook.Add("CanPlayerEnterVehicle","gmod_subway_81-717-cabin-entry", CanPlayerEnter )


