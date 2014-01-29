﻿--------------------------------------------------------------------------------
-- Тяговый электродвигатель постоянного тока (ДК-117ДМ)
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("DK_117DM")

function TRAIN_SYSTEM:Initialize()
	self.Name = "DK_117DM"
	
	-- Winding resistance
	self.Rw = 0.0691 -- Ohms
	
	-- Voltage generated by engine
	self.E13 = 0.0 -- Volts
	self.E24 = 0.0 -- Volts
	
	-- Rotation rate
	self.RotationRate = 0.0
	
	-- Magnetic flux in the engine
	self.MagneticFlux13 = 0.0
	self.MagneticFlux24 = 0.0
	
	-- Moment generated by the engine
	self.Moment13 = 0.0
	self.Moment24 = 0.0
end

function TRAIN_SYSTEM:Inputs()
	return { }
end

function TRAIN_SYSTEM:Outputs()
	return { "MagneticFlux13", "MagneticFlux24", "RotationRate", 
			"E13", "E24", "Moment13", "Moment24","FieldReduction13","FieldReduction24" }
end

function TRAIN_SYSTEM:Think(dT)
	local Train = self.Train
	local minimumFlux = 0.3 -- Подмагничивание при низких токах

	-- Calculate magnetic flux in the engine
	--currentMagneticFlux13 = (1.0/100.0) * 300.0*(1-math.exp(-2.5*Train.Electric.Istator13/300))
	--currentMagneticFlux24 = (1.0/100.0) * 300.0*(1-math.exp(-2.5*Train.Electric.Istator24/300))
	currentMagneticFlux13 = (1.0/40.0) * Train.Electric.Istator13
	currentMagneticFlux24 = (1.0/40.0) * Train.Electric.Istator24
	currentMagneticFlux13 = math.min(2.0,math.max(minimumFlux,currentMagneticFlux13))
	currentMagneticFlux24 = math.min(2.0,math.max(minimumFlux,currentMagneticFlux24))
	
	self.MagneticFlux13 = self.MagneticFlux13 + 10.0 * (currentMagneticFlux13 - self.MagneticFlux13) * dT
	self.MagneticFlux24 = self.MagneticFlux24 + 10.0 * (currentMagneticFlux24 - self.MagneticFlux24) * dT

	-- Get rate of engine rotation
	local currentRotationRate = 2200 * ((Train.FrontBogey.Speed + Train.RearBogey.Speed)/90) / 2
	self.RotationRate = self.RotationRate + 5.0 * (currentRotationRate - self.RotationRate) * dT
	
	-- Calculate voltage generated by engines from magnetic flux
	self.E13 = 0.370 * self.RotationRate * self.MagneticFlux13
	self.E24 = 0.370 * self.RotationRate * self.MagneticFlux24
	
	self.E13 = math.max(-2000,math.min(2000,self.E13))
	self.E24 = math.max(-2000,math.min(2000,self.E24))
	
	--print(self.E13 / Train.Electric.I13)
	
	-- Calculate engine force (moment)
	self.Moment13 = (1.0/600.0) * Train.Electric.I13 * self.MagneticFlux13
	self.Moment24 = (1.0/600.0) * Train.Electric.I24 * self.MagneticFlux24
	
	-- Apply moment
	Train.FrontBogey.MotorForce = 40000
	Train.FrontBogey.Reversed = (Train.RKR.Value > 0.5)
	Train.RearBogey.MotorForce  = 40000
	Train.RearBogey.Reversed = (Train.RKR.Value < 0.5)
	
	if (math.abs(Train.Electric.I13) > 1.0) or (math.abs(Train.Electric.I24) > 1.0) then
		Train.RearBogey.MotorPower  = (self.Moment13 + self.Moment24) / 2
		Train.FrontBogey.MotorPower = (self.Moment13 + self.Moment24) / 2
	else
		Train.RearBogey.MotorPower  = 0.0
		Train.FrontBogey.MotorPower = 0.0
	end
	
	-- Output things
	self:TriggerOutput("Moment13",self.Moment13)
	self:TriggerOutput("Moment24",self.Moment24)
	self:TriggerOutput("MagneticFlux13",self.MagneticFlux13)
	self:TriggerOutput("MagneticFlux24",self.MagneticFlux24)
	self:TriggerOutput("FieldReduction13",100 * Train.Electric.Istator13 / (Train.Electric.I13+1e-9))
	self:TriggerOutput("FieldReduction24",100 * Train.Electric.Istator24 / (Train.Electric.I24+1e-9))
	self:TriggerOutput("RotationRate",self.RotationRate)
	self:TriggerOutput("E13",self.E13)
	self:TriggerOutput("E24",self.E24)
end
