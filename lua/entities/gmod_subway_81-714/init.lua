AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650 -- Needed for gm trainspawner

--------------------------------------------------------------------------------
function ENT:Initialize()
	-- Defined train information
	self.SubwayTrain = {
		Type = "81",
		Name = "81-714",
	}

	-- Set model and initialize
	self:SetModel("models/metrostroi/81/81-714.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,140))

	-- Create bogeys
	self.FrontBogey = self:CreateBogey(Vector( 325-20,0,-75),Angle(0,180,0),true)
	self.RearBogey  = self:CreateBogey(Vector(-325-10,0,-75),Angle(0,0,0),false)
	
	self.InteractionZones = {
		{	Pos = Vector(458,-30,-55),
			Radius = 16,
			ID = "FrontBrakeLineIsolationToggle" },
		{	Pos = Vector(458, 30,-55),
			Radius = 16,
			ID = "FrontTrainLineIsolationToggle" },
		{	Pos = Vector(-482,30,-55),
			Radius = 16,
			ID = "RearBrakeLineIsolationToggle" },
		{	Pos = Vector(-482, -30,-55),
			Radius = 16,
			ID = "RearTrainLineIsolationToggle" },
		{	Pos = Vector(154,62.5,-65),
			Radius = 16,
			ID = "GVToggle" },
		{	Pos = Vector(446.0,-3.0,55),
			Radius = 16,
			ID = "VBToggle" },
	}

	-- Lights
	self.Lights = {
		-- Head
		[1] = { "headlight",		Vector(465,0,-20), Angle(0,0,0), Color(176,161,132), fov = 100 },
		[2] = { "glow",				Vector(460, 51,-23), Angle(0,0,0), Color(255,255,255), brightness = 2 },
		[3] = { "glow",				Vector(460,-51,-23), Angle(0,0,0), Color(255,255,255), brightness = 2 },
		[4] = { "glow",				Vector(460,-8, 55), Angle(0,0,0), Color(255,255,255), brightness = 0.3 },
		[5] = { "glow",				Vector(460,-8, 55), Angle(0,0,0), Color(255,255,255), brightness = 0.3 },
		[6] = { "glow",				Vector(460, 2, 55), Angle(0,0,0), Color(255,255,255), brightness = 0.3 },
		[7] = { "glow",				Vector(460, 2, 55), Angle(0,0,0), Color(255,255,255), brightness = 0.3 },
		
		-- Reverse
		[8] = { "light",			Vector(458,-45, 55), Angle(0,0,0), Color(255,0,0),     brightness = 10, scale = 1.0 },
		[9] = { "light",			Vector(458, 45, 55), Angle(0,0,0), Color(255,0,0),     brightness = 10, scale = 1.0 },
		
		-- Cabin
		[10] = { "dynamiclight",	Vector( 420, 0, 35), Angle(0,0,0), Color(255,255,255), brightness = 0.1, distance = 550 },
		
		-- Interior
		--[11] = { "dynamiclight",	Vector( 250, 0, 5), Angle(0,0,0), Color(255,255,255), brightness = 3, distance = 250 },
		[12] = { "dynamiclight",	Vector(   0, 0, 5), Angle(0,0,0), Color(255,255,255), brightness = 3, distance = 400 },
		--[13] = { "dynamiclight",	Vector(-250, 0, 5), Angle(0,0,0), Color(255,255,255), brightness = 3, distance = 250 },
		
		-- Side lights
		[14] = { "light",			Vector(-50, 68, 54), Angle(0,0,0), Color(255,0,0), brightness = 0.5, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[15] = { "light",			Vector(4,   68, 54), Angle(0,0,0), Color(150,255,255), brightness = 0.6, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[16] = { "light",			Vector(1,   68, 54), Angle(0,0,0), Color(0,255,0), brightness = 0.5, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[17] = { "light",			Vector(-2,  68, 54), Angle(0,0,0), Color(255,255,0), brightness = 0.5, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		
		[18] = { "light",			Vector(-50, -69, 54), Angle(0,0,0), Color(255,0,0), brightness = 0.5, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[19] = { "light",			Vector(5,   -69, 54), Angle(0,0,0), Color(150,255,255), brightness = 0.6, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[20] = { "light",			Vector(2,   -69, 54), Angle(0,0,0), Color(0,255,0), brightness = 0.5, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[21] = { "light",			Vector(-1,  -69, 54), Angle(0,0,0), Color(255,255,0), brightness = 0.5, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },

		-- Green RP
		[22] = { "light",			Vector(439.4,12.5-9.6,-5.7), Angle(0,0,0), Color(100,255,0), brightness = 1.0, scale = 0.020 },
		-- AVU
		[23] = { "light",			Vector(441.2,12.5-20.3,-3.7), Angle(0,0,0), Color(255,40,0), brightness = 1.0, scale = 0.020 },
		-- LKTP
		[24] = { "light",			Vector(441.2,12.5-23.0,-3.7), Angle(0,0,0), Color(255,40,0), brightness = 1.0, scale = 0.020 },
	}
	
	-- Cross connections in train wires
	self.TrainWireCrossConnections = {
		[5] = 4, -- Reverser F<->B
		[31] = 32, -- Doors L<->R
	}
	
	-- Setup door positions
	self.LeftDoorPositions = {}
	self.RightDoorPositions = {}
	for i=0,3 do
		table.insert(self.LeftDoorPositions,Vector(353.0 - 35*0.5 - 231*i,65,-1.8))
		table.insert(self.RightDoorPositions,Vector(353.0 - 35*0.5 - 231*i,-65,-1.8))
	end
end


--------------------------------------------------------------------------------
function ENT:Think()
	local retVal = self.BaseClass.Think(self)
	
	self.Electric:TriggerInput("TrainMode",1)

	-- Switch and button states
	self:SetPackedBool(0,self:IsWrenchPresent())
	self:SetPackedBool(5,self.GV.Value == 1.0)
	self:SetPackedBool(7,self.VB.Value == 1.0)
	self:SetPackedBool(20,self.Pneumatic.Compressor == 1.0)
	self:SetPackedBool(21,self.Pneumatic.LeftDoorState[1] > 0.5)
	self:SetPackedBool(22,self.Pneumatic.LeftDoorState[2] > 0.5)
	self:SetPackedBool(23,self.Pneumatic.LeftDoorState[3] > 0.5)
	self:SetPackedBool(24,self.Pneumatic.LeftDoorState[4] > 0.5)
	self:SetPackedBool(25,self.Pneumatic.RightDoorState[1] > 0.5)
	self:SetPackedBool(26,self.Pneumatic.RightDoorState[2] > 0.5)
	self:SetPackedBool(27,self.Pneumatic.RightDoorState[3] > 0.5)
	self:SetPackedBool(28,self.Pneumatic.RightDoorState[4] > 0.5)

	-- Signal if doors are open or no to platform simulation
	self.LeftDoorsOpen = 
		(self.Pneumatic.LeftDoorState[1] > 0.5) or
		(self.Pneumatic.LeftDoorState[2] > 0.5) or
		(self.Pneumatic.LeftDoorState[3] > 0.5) or
		(self.Pneumatic.LeftDoorState[4] > 0.5)
	self.RightDoorsOpen = 
		(self.Pneumatic.RightDoorState[1] > 0.5) or
		(self.Pneumatic.RightDoorState[2] > 0.5) or
		(self.Pneumatic.RightDoorState[3] > 0.5) or
		(self.Pneumatic.RightDoorState[4] > 0.5)
	
	-- BPSN
	self:SetPackedBool(52,self.PowerSupply.XT3_1 > 0)
	
	-- AV states
	for i,v in ipairs(self.Panel.AVMap) do
		if tonumber(v) 
		then self:SetPackedBool(64+(i-1),self["A"..v].Value == 1.0)
		else self:SetPackedBool(64+(i-1),self[v].Value == 1.0)
		end
	end
    
	-- Feed packed floats
	self:SetPackedRatio(0, 1-self.Pneumatic.DriverValvePosition/5)
	--self:SetPackedRatio(1, (self.KV.ControllerPosition+3)/7)
	--self:SetPackedRatio(2, 1-(self.KV.ReverserPosition+1)/2)
	self:SetPackedRatio(4, self.Pneumatic.ReservoirPressure/16.0)
	self:SetPackedRatio(5, self.Pneumatic.TrainLinePressure/16.0)
	self:SetPackedRatio(6, self.Pneumatic.BrakeCylinderPressure/6.0)
	self:SetPackedRatio(7, self.Electric.Power750V/1000.0)
	self:SetPackedRatio(8, math.abs(self.Electric.I24)/1000.0)	
	self:SetPackedRatio(9, self.Pneumatic.BrakeLinePressure_dPdT or 0)
	--self:SetPackedRatio(10,(self.Panel["V1"] * self.Battery.Voltage) / 100.0)

	local speed,acceleration = 0,0
	if IsValid(self.FrontBogey) and IsValid(self.RearBogey) then
		speed = (self.FrontBogey.Speed + self.RearBogey.Speed)/2
		acceleration = (self.FrontBogey.Acceleration + self.RearBogey.Acceleration)/2
	end
	self.DebugVars["Speed"] = speed
	self.DebugVars["Acceleration"] = acceleration
	
	-- RUT test
	local weightRatio = 2.00*math.max(0,math.min(1,(self:GetPassengerCount()/300)))
	if math.abs(self:GetAngles().pitch) > 2.5 then weightRatio = weightRatio + 0.75 end
	self.YAR_13A:TriggerInput("WeightLoadRatio",math.max(0,math.min(2.00,weightRatio)))
	
	-- Exchange some parameters between engines, pneumatic system, and real world
	self.Engines:TriggerInput("Speed",speed)
	if IsValid(self.FrontBogey) and IsValid(self.RearBogey) then
		self.FrontBogey.MotorForce = 42000
		self.FrontBogey.Reversed = (self.RKR.Value > 0.5)
		self.RearBogey.MotorForce  = 42000
		self.RearBogey.Reversed = (self.RKR.Value < 0.5)
	
		self.RearBogey.MotorPower  = self.Engines.BogeyMoment
		self.FrontBogey.MotorPower = self.Engines.BogeyMoment
		
		-- Apply brakes
		self.FrontBogey.PneumaticBrakeForce = 140000.0
		self.FrontBogey.BrakeCylinderPressure = self.Pneumatic.BrakeCylinderPressure
		self.FrontBogey.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
		self.RearBogey.PneumaticBrakeForce = 140000.0
		self.RearBogey.BrakeCylinderPressure = self.Pneumatic.BrakeCylinderPressure
		self.RearBogey.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
	end
	return retVal
end


--------------------------------------------------------------------------------
function ENT:OnCouple(train,isfront)
	self.BaseClass.OnCouple(self,train,isfront)
	
	if isfront 
	then self.FrontBrakeLineIsolation:TriggerInput("Open",1.0)
	else self.RearBrakeLineIsolation:TriggerInput("Open",1.0)
	end
end
function ENT:OnButtonPress(button)
	-- Generic button or switch sound
	if string.find(button,"Set") then
		self:PlayOnce("switch")
	end
	if string.find(button,"Toggle") then
		self:PlayOnce("switch2")
	end
end