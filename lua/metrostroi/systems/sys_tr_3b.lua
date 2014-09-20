﻿--------------------------------------------------------------------------------
-- Токоприёмник контактного рельса (ТР-3Б)
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("TR_3B")
TRAIN_SYSTEM.DontAccelerateSimulation = true

function TRAIN_SYSTEM:Initialize()
	-- Output voltage from contact rail
	self.Main750V = 0.0
end

function TRAIN_SYSTEM:Inputs()
	return { }
end

function TRAIN_SYSTEM:Outputs()
	return { "Main750V" }
end

function TRAIN_SYSTEM:CheckContact(ent,pos,dir)
	local trace = {
		start = ent:LocalToWorld(pos),
		endpos = ent:LocalToWorld(pos + dir*10),
		mask = -1,
		filter = { self.Train, ent },
	}
	
	local result = util.TraceLine(trace)
	return result.Hit
end

function TRAIN_SYSTEM:Think(dT)
	-- Don't do logic if train is broken
	if (not IsValid(self.Train.FrontBogey)) or (not IsValid(self.Train.RearBogey)) then
		return
	end

	-- Draw overheat of the engines FIXME
	local smoke_intensity = 
		self.Train.Electric.Overheat1 or
		self.Train.Electric.Overheat2 or 0

	-- Generate smoke
	self.PrevSmokeTime = self.PrevSmokeTime or CurTime()
	if (smoke_intensity > 0.0) and (CurTime() - self.PrevSmokeTime > 0.5+4.0*(1-smoke_intensity)) then
		self.PrevSmokeTime = CurTime()

		ParticleEffect("generic_smoke",
			self.Train:LocalToWorld(Vector(100*math.random(),40,-80)),
			Angle(0,0,0),self.Train)
	end

	-- Check contact states
	self.PlayTime = self.PlayTime or { 0, 0, 0, 0 }
	self.ContactStates = self.ContactStates or { false, false, false, false }
	self.NextStates = self.NextStates or { false,false,false,false }
	self.CheckTimeout = self.CheckTimeout or 0
	if (CurTime() - self.CheckTimeout) > 0.25 then
		self.CheckTimeout = CurTime()
		self.NextStates[1] = self:CheckContact(self.Train.FrontBogey,Vector(0,-61,-14),Vector(0,-1,0))
		self.NextStates[2] = self:CheckContact(self.Train.FrontBogey,Vector(0, 61,-14),Vector(0, 1,0))
		self.NextStates[3] = self:CheckContact(self.Train.RearBogey,Vector(0, -61,-14),Vector(0,-1,0))
		self.NextStates[4] = self:CheckContact(self.Train.RearBogey,Vector(0,  61,-14),Vector(0, 1,0))
	end
	
	-- Voltage spikes
	self.VoltageDrop = self.VoltageDrop or 0
	self.VoltageDrop = math.max(-30,math.min(30,self.VoltageDrop + (0 - self.VoltageDrop)*10*dT))
	
	-- Detect changes in contact states
	for i=1,4 do
		local state = self.NextStates[i]
		if state ~= self.ContactStates[i] then
			self.ContactStates[i] = state
			
			if true then --state then
				local sound_source = (i <= 2) and "front_bogey" or "rear_bogey"
				if state then
					self.VoltageDrop = -40*(0.5 + 0.5*math.random())
				end
				
				local dt = CurTime() - self.PlayTime[i]
				self.PlayTime[i] = CurTime()

				local volume = 0.63
				if dt < 1.0 then volume = 0.53 end
				self.Train:PlayOnce("tr",sound_source,volume,math.random(90,120))
				
				-- Sparking probability
				local probability = math.min(1.0,math.max(0.0,1.80 - (Metrostroi.Voltage/750.0) - (self.Train.Electric.Itotal/800)))

				if state and (math.random() > probability) then
					local effectdata = EffectData()
					if i == 1 then effectdata:SetOrigin(self.Train.FrontBogey:LocalToWorld(Vector(0,-70,-18))) end
					if i == 2 then effectdata:SetOrigin(self.Train.FrontBogey:LocalToWorld(Vector(0, 70,-18))) end
					if i == 3 then effectdata:SetOrigin(self.Train.RearBogey:LocalToWorld( Vector(0,-70,-18))) end
					if i == 4 then effectdata:SetOrigin(self.Train.RearBogey:LocalToWorld( Vector(0, 70,-18))) end
					effectdata:SetNormal(Vector(0,0,-1))
					util.Effect("stunstickimpact", effectdata, true, true)

					local light = ents.Create("light_dynamic")
					light:SetPos(effectdata:GetOrigin())
					light:SetKeyValue("_light","100 220 255")
					light:SetKeyValue("style", 0)
					light:SetKeyValue("distance", 256)
					light:SetKeyValue("brightness", 5)
					light:Spawn()
					light:Fire("TurnOn","","0") 

					timer.Simple(0.1,function() SafeRemoveEntity(light) end)
					self.Train:PlayOnce("zap",sound_source,0.7*volume,50+math.random(90,120))
				end
			end
		end
	end

	-- Non-metrostroi maps
	if (not (GetConVarNumber("metrostroi_train_requirethirdrail") > 0)) or 
	   (not Metrostroi.MapHasFullSupport()) then
		self.Main750V = 750
		return 
	end

	-- Detect voltage
	self.Main750V = 0
	for i=1,4 do
		if self.ContactStates[i] then self.Main750V = (Metrostroi.Voltage or 750) + self.VoltageDrop end
	end
	
	-- Too high current
	if self.Train.Electric.Itotal*self.Main750V > (750*1000) then
		self.Train:PlayOnce("spark","front_bogey",1.0,math.random(100,150))
		self.Train:PlayOnce("spark","rear_bogey",1.0,math.random(100,150))
	end
end
