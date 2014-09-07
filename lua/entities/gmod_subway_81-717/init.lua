AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650 -- Needed for gm trainspawner

--------------------------------------------------------------------------------
function ENT:Initialize()
	-- Defined train information
	self.SubwayTrain = {
		Type = "81",
		Name = "81-717",
	}

	-- Set model and initialize
	self.TrainModel = 1
	self:SetModel("models/metrostroi/81/81-717a.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,140))
	
	-- Create seat entities
	self.DriverSeat = self:CreateSeat("driver",Vector(410,0,-23+2.5))
	self.InstructorsSeat = self:CreateSeat("instructor",Vector(410,44,-28+4))
	self.ExtraSeat = self:CreateSeat("instructor",Vector(410,-40,-28+1))

	-- Hide seats
	self.DriverSeat:SetColor(Color(0,0,0,0))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.ExtraSeat:SetColor(Color(0,0,0,0))
	self.ExtraSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	
	-- Create bogeys
	self.FrontBogey = self:CreateBogey(Vector( 325-20,0,-80),Angle(0,180,0),true)
	self.RearBogey  = self:CreateBogey(Vector(-325-10,0,-80),Angle(0,0,0),false)
	
	-- Initialize key mapping
	self.KeyMap = {
		[KEY_1] = "KVSetX1",
		[KEY_2] = "KVSetX2",
		[KEY_3] = "KVSetX3",
		[KEY_4] = "KVSet0",
		[KEY_5] = "KVSetT1",
		[KEY_6] = "KVSetT1A",
		[KEY_7] = "KVSetT2",
		[KEY_8] = "KRP",
		
		[KEY_G] = "VozvratRPSet",
		
		[KEY_0] = "KVReverserUp",
		[KEY_9] = "KVReverserDown",
		[KEY_W] = "KVControllerUp",
		[KEY_S] = "KVControllerDown",
		[KEY_F] = "PneumaticBrakeUp",
		[KEY_R] = "PneumaticBrakeDown",
		
		[KEY_A] = "KDL",
		[KEY_D] = "KDP",
		[KEY_V] = "VUD1Set",
		[KEY_L] = "HornEngage",
		[KEY_N] = "VZ1Set",
		
		[KEY_SPACE] = "PBSet",
		[KEY_BACKSPACE] = "EmergencyBrake",

		[KEY_LSHIFT] = {
			[KEY_A] = "DURASelectAlternate",
			[KEY_D] = "DURASelectMain",
			[KEY_V] = "DURAToggleChannel",
			[KEY_1] = "DIPonSet",
			[KEY_2] = "DIPoffSet",
			[KEY_L] = "DriverValveDisconnectToggle",
			
			[KEY_7] = "KVWrenchNone",
			[KEY_8] = "KVWrenchKRU",
			[KEY_9] = "KVWrenchKV",
			[KEY_0] = "KVWrench0",
		},
		
		[KEY_RSHIFT] = {
			[KEY_7] = "KVWrenchNone",
			[KEY_8] = "KVWrenchKRU",
			[KEY_9] = "KVWrenchKV",
			[KEY_0] = "KVWrench0",
		},
	}
	
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
		{	Pos = Vector(398.0,-56.0+1.5,25.0),
			Radius = 20,
			ID = "VBToggle" },
		{	Pos = Vector(-180,68.5,-50),
			Radius = 20,
			ID = "AirDistributorDisconnectToggle" },
	}

	-- Lights
	local vX = Angle(0,-90-0.2,56.3):Forward() -- For ARS panel
	local vY = Angle(0,-90-0.2,56.3):Right()
	self.Lights = {
		-- Headlight glow
		[1] = { "headlight",		Vector(465,0,-20), Angle(0,0,0), Color(216,161,92), fov = 100 },
		
		-- Head (type 1)
		[2] = { "glow",				Vector(460, 51,-23), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[3] = { "glow",				Vector(460,-51,-23), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[4] = { "glow",				Vector(460, 6, 55), Angle(0,0,0),  Color(255,220,180), brightness = 1, scale = 1.0 },
		[5] = { "glow",				Vector(460,-4, 55), Angle(0,0,0),  Color(255,220,180), brightness = 1, scale = 1.0 },
		[6] = { "glow",				Vector(460, 40, -23), Angle(0,0,0),Color(255,220,180), brightness = 1, scale = 1.0 },
		[7] = { "glow",				Vector(460,-40, -23), Angle(0,0,0),Color(255,220,180), brightness = 1, scale = 1.0 },
		
		-- Head (type 2)
		[92] = { "glow",			Vector(460, 51,-23), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[93] = { "glow",			Vector(460,-51,-23), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[94] = { "glow",			Vector(460,-18,-23), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[95] = { "glow",			Vector(460,-7, -23), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[96] = { "glow",			Vector(460, 7, -23), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[97] = { "glow",			Vector(460, 18,-23), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },

		-- Reverse
		[8] = { "light",			Vector(458,-45, 55), Angle(0,0,0), Color(255,0,0),     brightness = 10, scale = 1.0 },
		[9] = { "light",			Vector(458, 45, 55), Angle(0,0,0), Color(255,0,0),     brightness = 10, scale = 1.0 },
		
		-- Cabin
		[10] = { "dynamiclight",	Vector( 420, 0, 35), Angle(0,0,0), Color(255,255,255), brightness = 0.1, distance = 550 },
		
		-- Interior
		[11] = { "dynamiclight",	Vector( 250, 0, 5), Angle(0,0,0), Color(255,255,255), brightness = 3, distance = 400 },
		[12] = { "dynamiclight",	Vector(   0, 0, 5), Angle(0,0,0), Color(255,255,255), brightness = 3, distance = 400 },
		[13] = { "dynamiclight",	Vector(-350, 0, 5), Angle(0,0,0), Color(255,255,255), brightness = 3, distance = 400 },
		
		-- Side lights
		[14] = { "light",			Vector(-50, 68, 54), Angle(0,0,0), Color(255,0,0), brightness = 0.9, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[15] = { "light",			Vector(4,   68, 54), Angle(0,0,0), Color(150,255,255), brightness = 0.9, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[16] = { "light",			Vector(1,   68, 54), Angle(0,0,0), Color(0,255,0), brightness = 0.9, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[17] = { "light",			Vector(-2,  68, 54), Angle(0,0,0), Color(255,255,0), brightness = 0.9, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		
		[18] = { "light",			Vector(-50, -69, 54), Angle(0,0,0), Color(255,0,0), brightness = 0.9, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[19] = { "light",			Vector(5,   -69, 54), Angle(0,0,0), Color(150,255,255), brightness = 0.9, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[20] = { "light",			Vector(2,   -69, 54), Angle(0,0,0), Color(0,255,0), brightness = 0.9, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },
		[21] = { "light",			Vector(-1,  -69, 54), Angle(0,0,0), Color(255,255,0), brightness = 0.9, scale = 0.10, texture = "models/metrostroi_signals/signal_sprite_002.vmt" },

		-- Green RP
		[22] = { "light",			Vector(439.8,12.5+1.5-9.6,-6.1), Angle(0,0,0), Color(100,255,0), brightness = 1.0, scale = 0.020 },
		-- AVU
		[23] = { "light",			Vector(441.6,12.5+1.5-20.3,-4.15), Angle(0,0,0), Color(255,40,0), brightness = 1.0, scale = 0.020 },
		-- LKVP
		[24] = { "light",			Vector(441.6,12.5+1.5-23.0,-4.15), Angle(0,0,0), Color(255,160,0), brightness = 1.0, scale = 0.020 },
		-- Pneumatic brake
		[25] = { "light",			Vector(438.7,-26.1,-5.35), Angle(0,0,0), Color(255,160,0), brightness = 1.0, scale = 0.020 },
		-- Cabin heating
		[26] = { "light",			Vector(438.7,-21.1,-5.35), Angle(0,0,0), Color(255,160,0), brightness = 1.0, scale = 0.020 },
		-- Door left open (#1)
		[27] = { "light",			Vector(437.8,4.4,-8.0), Angle(0,0,0), Color(255,160,0), brightness = 1.0, scale = 0.024 },
		-- Door left open (#2)
		[28] = { "light",			Vector(437.8,10.8,-8.0), Angle(0,0,0), Color(255,160,0), brightness = 1.0, scale = 0.024 },
		-- Door right open 
		[29] = { "light",			Vector(438.7,-23.3,-5.35), Angle(0,0,0), Color(255,160,0), brightness = 1.0, scale = 0.024 },

		-- Cabin texture light
		[30] = { "headlight", 		Vector(390.0,16,45), Angle(60,-50,0), Color(176,161,132), farz = 128, nearz = 1, shadows = 0, brightness = 0.20, fov = 140 },
		-- Manometers
		[31] = { "headlight", 		Vector(450.00,5,3.0), Angle(0,-90,0), Color(216,161,92), farz = 32, nearz = 1, shadows = 0, brightness = 0.4, fov = 30 },
		-- Voltmeter
		[32] = { "headlight", 		Vector(449.00,10,7.0), Angle(28,90,0), Color(216,161,92), farz = 16, nearz = 1, shadows = 0, brightness = 0.4, fov = 40 },
		-- Ampermeter
		[33] = { "headlight", 		Vector(445.0,-35,9.0), Angle(-90,0,0), Color(216,161,92), farz = 10, nearz = 1, shadows = 0, brightness = 4.0, fov = 60 },
		-- Voltmeter
		[34] = { "headlight", 		Vector(445.0,-35,13.0), Angle(-90,0,0), Color(216,161,92), farz = 10, nearz = 1, shadows = 0, brightness = 4.0, fov = 60 },
		
		-- Custom D
		[35] = { "light", 			Vector(443.2,25.0-1.8*0,1.15), Angle(0,0,0), Color(255,0,0), brightness = 1.0, scale = 0.020 },
		-- Custom E
		[36] = { "light", 			Vector(443.2,25.0-1.8*1,1.15), Angle(0,0,0), Color(255,160,0), brightness = 1.0, scale = 0.020 },
		-- Custom F
		[37] = { "light", 			Vector(443.2,25.0-1.8*2,1.15), Angle(0,0,0), Color(255,160,0), brightness = 1.0, scale = 0.020 },
		-- Custom G
		[38] = { "light", 			Vector(443.2,25.0-1.8*3,1.15), Angle(0,0,0), Color(100,255,0), brightness = 1.0, scale = 0.020 },
		
		-- LSP
		[39] = { "light",			Vector(444.55,11.3-23.0,-1.45), Angle(0,0,0), Color(255,0,0), brightness = 1.0, scale = 0.020 },
	
		-- ARS panel lights
		[40] = { "light", Vector(448.26,11.0,7.84)+vY*5.15+vX*3.14,				Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[41] = { "light", Vector(448.26,11.0,7.84)+vY*5.15+vX*4.28,				Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[42] = { "light", Vector(448.26,11.0,7.84)+vY*5.18+vX*5.49,				Angle(0,0,0), Color(255,190,0), brightness = 1.0, scale = 0.008 },
		[43] = { "light", Vector(448.26,11.0,7.84)+vY*5.22+vX*7.74,				Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[44] = { "light", Vector(448.26,11.0,7.84)+vY*5.23+vX*11.07,			Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[45] = { "light", Vector(448.26,11.0,7.84)+vY*2.63+vX*(5.52+1.10*0),	Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[46] = { "light", Vector(448.26,11.0,7.84)+vY*2.63+vX*(5.52+1.10*1),	Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[47] = { "light", Vector(448.26,11.0,7.84)+vY*2.63+vX*(5.52+1.10*2),	Angle(0,0,0), Color(255,190,0), brightness = 1.0, scale = 0.008 },
		[48] = { "light", Vector(448.26,11.0,7.84)+vY*2.63+vX*(5.52+1.10*3),	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[49] = { "light", Vector(448.26,11.0,7.84)+vY*2.63+vX*(5.52+1.10*4),	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[50] = { "light", Vector(448.26,11.0,7.84)+vY*2.63+vX*(5.52+1.10*5),	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[51] = { "light", Vector(448.26,11.0,7.84)+vY*(1.37+1.29*0)+vX*12.70,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[52] = { "light", Vector(448.26,11.0,7.84)+vY*(1.37+1.29*1)+vX*12.71,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[53] = { "light", Vector(448.26,11.0,7.84)+vY*(1.37+1.29*2)+vX*12.72,	Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[54] = { "light", Vector(448.26,11.0,7.84)+vY*(1.37+1.29*3)+vX*12.73,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[55] = { "light", Vector(448.26,11.0,7.84)+vY*(1.37+1.29*0)+vX*16.05,	Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[56] = { "light", Vector(448.26,11.0,7.84)+vY*(1.37+1.29*1)+vX*16.06,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[57] = { "light", Vector(448.26,11.0,7.84)+vY*(1.37+1.29*2)+vX*16.07,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[58] = { "light", Vector(448.26,11.0,7.84)+vY*(1.37+1.29*3)+vX*16.08,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },		
		
		-- Interior lights
		[60+0] = { "headlight", Vector(290-130*0,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+1] = { "headlight", Vector(290-130*1,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+2] = { "headlight", Vector(290-130*2,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+3] = { "headlight", Vector(290-130*3,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+4] = { "headlight", Vector(290-130*4,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+5] = { "headlight", Vector(290-130*5,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+6] = { "headlight", Vector(270-230*0,0,20), Angle(-90,0,0), Color(255,255,255), farz = 120, nearz = 1, shadows = 0, brightness = 0.1, fov = 170 },
		[60+7] = { "headlight", Vector(270-230*1,0,20), Angle(-90,0,0), Color(255,255,255), farz = 120, nearz = 1, shadows = 0, brightness = 0.1, fov = 170 },
		[60+8] = { "headlight", Vector(270-230*2,0,20), Angle(-90,0,0), Color(255,255,255), farz = 120, nearz = 1, shadows = 0, brightness = 0.1, fov = 170 },
		[60+9] = { "headlight", Vector(270-230*3,0,20), Angle(-90,0,0), Color(255,255,255), farz = 120, nearz = 1, shadows = 0, brightness = 0.1, fov = 170 },
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
	
	-- KV wrench mode
	self.KVWrenchMode = 0
	
	-- BPSN type
	self.BPSNType = 2+math.floor(Metrostroi.PeriodRandomNumber()*5+0.5)
	self:SetNWInt("BPSNType",self.BPSNType)
	
	-- ARS type
	self.ARSType = 1
	self:SetNWInt("ARSType",1)
end


--------------------------------------------------------------------------------
function ENT:Think()
	local retVal = self.BaseClass.Think(self)

	-- Check if wrench was pulled out
	if self.DriversWrenchPresent then
		self.KV:TriggerInput("Enabled",self:IsWrenchPresent() and 1 or 0)
	end
	
	-- Set wrench sounds
	if not self.DriversWrenchSoundsInit then
		self.KV:TriggerInput("Type",2)
		self.DriversWrenchSoundsInit = true
	end
	
	-- Headlights
	local brightness = (math.min(1,self.Panel["HeadLights1"])*0.50 + 
						math.min(1,self.Panel["HeadLights2"])*0.25 + 
						math.min(1,self.Panel["HeadLights3"])*0.25)
	self:SetLightPower(1, (self.Panel["HeadLights3"] > 0.5) and (self.L_4.Value > 0.5),brightness)
	if self.TrainModel == 2 then
		self:SetLightPower(2, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(3, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(4, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(5, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(6, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(7, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(92, false)
		self:SetLightPower(93, false)
		self:SetLightPower(94, false)
		self:SetLightPower(95, false)
		self:SetLightPower(96, false)
		self:SetLightPower(97, false)
	else
		self:SetLightPower(92, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(93, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(94, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(95, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(96, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(97, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
		self:SetLightPower(2, false)
		self:SetLightPower(3, false)
		self:SetLightPower(4, false)
		self:SetLightPower(5, false)
		self:SetLightPower(6, false)
		self:SetLightPower(7, false)
	end
	
	-- Reverser lights
	self:SetLightPower(8, self.Panel["RedLightRight"] > 0.5)
	self:SetLightPower(9, self.Panel["RedLightLeft"] > 0.5)
	
	-- Interior/cabin lights
	self:SetLightPower(10, (self.Panel["CabinLight"] > 0.5) and (self.L_2.Value > 0.5))
	self:SetLightPower(30, (self.Panel["CabinLight"] > 0.5), 0.03 + 0.97*self.L_2.Value)
	
	local lightsActive1 = (self.PowerSupply.XT3_4 > 65.0) and
		((self:ReadTrainWire(33) > 0) or (self:ReadTrainWire(34) > 0))
	local lightsActive2 = (self.PowerSupply.XT3_4 > 65.0) and
		(self:ReadTrainWire(33) > 0)
	self:SetLightPower(11, lightsActive1, 0.2*self:ReadTrainWire(34) + 0.8*self:ReadTrainWire(33))
	self:SetLightPower(12, lightsActive2, 0.2*self:ReadTrainWire(34) + 0.8*self:ReadTrainWire(33))
	self:SetLightPower(13, lightsActive1, 0.2*self:ReadTrainWire(34) + 0.8*self:ReadTrainWire(33))
	--[[self:SetLightPower(12, (self.Panel["EmergencyLight"] > 0.5) and ((self.L_1.Value > 0.5) or (self.L_5.Value > 0.5)),
		0.5*self.L_5.Value + ((self.PowerSupply.XT3_4 > 65.0) and 0.5 or 0))]]
		
	--[[for i=60,69 do
		self:SetLightPower(i,
			(self.Panel["EmergencyLight"] > 0.5) and ((self.L_1.Value > 0.5) or (self.L_5.Value > 0.5)),
			0.1*self.L_5.Value + ((self.PowerSupply.XT3_4 > 65.0) and 1 or 0))
	end]]--
	--self:SetLightPower(12, self.Panel["EmergencyLight"] > 0.5)
	--self:SetLightPower(13, self.PowerSupply.XT3_4 > 65.0)	
	self:SetLightPower(31, (self.Panel["CabinLight"] > 0.5) and (self.L_3.Value > 0.5))
	self:SetLightPower(32, (self.Panel["CabinLight"] > 0.5) and (self.L_3.Value > 0.5))
	self:SetLightPower(33, (self.Panel["CabinLight"] > 0.5) and (self.L_3.Value > 0.5))
	self:SetLightPower(34, (self.Panel["CabinLight"] > 0.5) and (self.L_3.Value > 0.5))

	-- Door button lights
	self:SetLightPower(27, (self.Panel["HeadLights2"] > 0.5) and (self.DoorSelect.Value == 0))
	self:SetLightPower(28, (self.Panel["HeadLights2"] > 0.5) and (self.DoorSelect.Value == 0))
	self:SetLightPower(29, (self.Panel["HeadLights2"] > 0.5) and (self.DoorSelect.Value == 1))
	
	-- Side lights
	self:SetLightPower(15, self.Panel["TrainDoors"] > 0.5)
	self:SetLightPower(19, self.Panel["TrainDoors"] > 0.5)
	
	self:SetLightPower(16, self.Panel["GreenRP"] > 0.5)
	self:SetLightPower(20, self.Panel["GreenRP"] > 0.5)
	
	self:SetLightPower(17, self.Panel["TrainBrakes"] > 0.5)
	self:SetLightPower(21, self.Panel["TrainBrakes"] > 0.5)
	self:SetLightPower(25, self.Panel["TrainBrakes"] > 0.5)
	
	-- Switch and button states
	self:SetPackedBool(0,self:IsWrenchPresent())
	self:SetPackedBool(1,self.VUS.Value == 1.0)
	self:SetPackedBool(2,self.VozvratRP.Value == 1.0)
	self:SetPackedBool(3,self.DIPon.Value == 1.0)
	self:SetPackedBool(4,self.DIPoff.Value == 1.0)
	self:SetPackedBool(5,self.GV.Value == 1.0)
	self:SetPackedBool(6,self.DriverValveDisconnect.Value == 1.0)
	self:SetPackedBool(7,self.VB.Value == 1.0)
	self:SetPackedBool(8,self.RezMK.Value == 1.0)
	self:SetPackedBool(9,self.VMK.Value == 1.0)
	self:SetPackedBool(10,self.VAH.Value == 1.0)
	self:SetPackedBool(11,self.VAD.Value == 1.0)
	self:SetPackedBool(12,self.VUD1.Value == 1.0)
	self:SetPackedBool(13,self.VUD2.Value == 1.0)
	self:SetPackedBool(14,self.VDL.Value == 1.0)
	self:SetPackedBool(15,self.KDL.Value == 1.0)
	self:SetPackedBool(16,self.KDP.Value == 1.0)
	self:SetPackedBool(17,self.KRZD.Value == 1.0)
	self:SetPackedBool(18,self.KSN.Value == 1.0)
	self:SetPackedBool(19,self.OtklAVU.Value == 1.0)
	self:SetPackedBool(20,self.Pneumatic.Compressor == 1.0)
	self:SetPackedBool(21,self.Pneumatic.LeftDoorState[1] > 0.5)
	self:SetPackedBool(22,self.Pneumatic.ValveType == 2)
	--23
	self:SetPackedBool(24,self.DURA.Power ~= 0)
	self:SetPackedBool(25,self.Pneumatic.RightDoorState[1] > 0.5)
	self:SetPackedBool(27,self.KVWrenchMode == 2)
	self:SetPackedBool(28,self.KVT.Value == 1.0)
	self:SetPackedBool(29,self.DURA.SelectAlternate == false)
	self:SetPackedBool(30,self.DURA.SelectAlternate == true)
	self:SetPackedBool(31,self.DURA.Channel == 2)
	self:SetPackedBool(56,self.ARS.Value == 1.0)
	self:SetPackedBool(57,self.ALS.Value == 1.0)
	self:SetPackedBool(58,(self.Panel["CabinLight"] > 0.5) and (self.L_2.Value > 0.5))
	self:SetPackedBool(59,self.BPSNon.Value == 1.0)
	self:SetPackedBool(60,self.L_1.Value == 1.0)
	self:SetPackedBool(61,self.L_2.Value == 1.0)
	self:SetPackedBool(62,self.L_3.Value == 1.0)
	self:SetPackedBool(63,self.L_4.Value == 1.0)
	self:SetPackedBool(53,self.L_5.Value == 1.0)
	self:SetPackedBool(55,self.DoorSelect.Value == 1.0)
	self:SetPackedBool(112,(self.RheostatController.Velocity ~= 0.0))
	self:SetPackedBool(113,self.KRP.Value == 1.0)
	self:SetPackedBool(114,self.Custom1.Value == 1.0)
	self:SetPackedBool(115,self.Custom2.Value == 1.0)
	self:SetPackedBool(116,self.Custom3.Value == 1.0)
	self:SetPackedBool(117,self.Custom4.Value == 1.0)
	self:SetPackedBool(118,self.Custom5.Value == 1.0)
	self:SetPackedBool(119,self.Custom6.Value == 1.0)
	self:SetPackedBool(120,self.Custom7.Value == 1.0)
	self:SetPackedBool(121,self.Custom8.Value == 1.0)
	self:SetPackedBool(122,self.CustomA.Value == 1.0)
	self:SetPackedBool(123,self.CustomB.Value == 1.0)
	self:SetPackedBool(124,self.CustomC.Value == 1.0)
	self:SetLightPower(35,self.CustomD.Value == 1.0)
	self:SetLightPower(36,self.CustomE.Value == 1.0)
	self:SetLightPower(37,self.CustomF.Value == 1.0)
	self:SetLightPower(38,self.CustomG.Value == 1.0)
	self:SetPackedBool(125,self.R_G.Value == 1.0)
	self:SetPackedBool(126,self.R_Radio.Value == 1.0)
	self:SetPackedBool(127,self.R_ZS.Value == 1.0)
	self:SetPackedBool(128,self.R_Program1.Value == 1.0)
	self:SetPackedBool(129,self.R_Program2.Value == 1.0)
	self:SetPackedBool(130,self.RC1.Value == 1.0)	
	
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
	
	-- DIP/power
	self:SetPackedBool(32,self.Panel["V1"] > 0.5)
	-- LxRK
	self:SetPackedBool(33,self:ReadTrainWire(2) > 0.5)--self.RheostatController.MotorCoilState ~= 0.0)
	-- NR1
	self:SetPackedBool(34,(self.NR.Value == 1.0) or (self.RPU.Value == 1.0))
	-- Red RP
	self:SetPackedBool(35,self.Panel["RedRP"] > 0.5)
	-- Green RP
	self:SetPackedBool(36,self.Panel["GreenRP"] > 0.5)
	self:SetLightPower(22,self.Panel["GreenRP"] > 0.5)
	-- Cabin heating
	self:SetPackedBool(37,self.Panel["KUP"] > 0.5)
	self:SetLightPower(26,self.Panel["KUP"] > 0.5)
	-- AVU
	self:SetPackedBool(38,self.Panel["AVU"] > 0.5)
	self:SetLightPower(23,self.Panel["AVU"] > 0.5)
	-- Ring
	self:SetPackedBool(39,self.Panel["Ring"] > 0.5)
	-- SD
	self:SetPackedBool(40,self.Panel["SD"] > 0.5)
	-- OCh
	self:SetPackedBool(41,self.ALS_ARS.NoFreq)
	-- 0
	self:SetPackedBool(42,self.ALS_ARS.Signal0)
	-- 40
	self:SetPackedBool(43,self.ALS_ARS.Signal40)
	-- 60
	self:SetPackedBool(44,self.ALS_ARS.Signal60)
	-- 75
	self:SetPackedBool(45,self.ALS_ARS.Signal70)
	-- 80
	self:SetPackedBool(46,self.ALS_ARS.Signal80)
	-- KT
	self:SetPackedBool(47,self.ALS_ARS.LKT)
	-- KVD
	self:SetPackedBool(48,self:ReadTrainWire(21) > 0.5)--self.ALS_ARS.LVD)
	-- LST
	self:SetPackedBool(49,self:ReadTrainWire(6) > 0.5)
	-- LVD
	self:SetPackedBool(50,self:ReadTrainWire(1) > 0.5)
	-- LKVC
	self:SetPackedBool(51,self.KVC.Value < 0.5)
	-- BPSN
	self:SetLightPower(24,(self.PowerSupply.XT3_1 > 0) and (self.Panel["V1"] > 0.5))
	self:SetPackedBool(52,self.PowerSupply.XT3_1 > 0)
	-- LRS
	self:SetPackedBool(54,(self.Panel["V1"] > 0.5) and 
		(self.ALS.Value > 0.5) and 
		(self.ALS_ARS.NextLimit >= self.ALS_ARS.SpeedLimit))
	
	-- AV states
	for i,v in ipairs(self.Panel.AVMap) do
		if tonumber(v) 
		then self:SetPackedBool(64+(i-1),self["A"..v].Value == 1.0)
		else self:SetPackedBool(64+(i-1),self[v].Value == 1.0)
		end
	end
	
	-- Non-standard ARS logic
	self:SetBodygroup(2,(self.ARSType or 1)-1)
	if self.ARSType == 2 then
		-- LSD
		self:SetLightPower(40,self:GetPackedBool(40) and self:GetPackedBool(32))
		self:SetLightPower(41,self:GetPackedBool(40) and self:GetPackedBool(32))
		-- LHRK
		self:SetLightPower(42,self:GetPackedBool(33) and self:GetPackedBool(32))
		-- RP LSN
		self:SetLightPower(43,self:GetPackedBool(35) and self:GetPackedBool(32))
		self:SetLightPower(44,self:GetPackedBool(35) and self:GetPackedBool(32))
		-- Och
		self:SetLightPower(45,self:GetPackedBool(41) and self:GetPackedBool(32))
		-- 0
		self:SetLightPower(46,self:GetPackedBool(42) and self:GetPackedBool(32))
		-- 40
		self:SetLightPower(47,self:GetPackedBool(43) and self:GetPackedBool(32))
		-- 60
		self:SetLightPower(48,self:GetPackedBool(44) and self:GetPackedBool(32))
		-- 70
		self:SetLightPower(49,self:GetPackedBool(45) and self:GetPackedBool(32))
		-- 80
		self:SetLightPower(50,self:GetPackedBool(46) and self:GetPackedBool(32))
		-- LEKK
		self:SetLightPower(51,false)
		-- LN
		self:SetLightPower(52,false)
		-- LKVD
		self:SetLightPower(53,self:GetPackedBool(48) and self:GetPackedBool(32))
		-- LKT
		self:SetLightPower(54,self:GetPackedBool(47) and self:GetPackedBool(32))
		-- LKVC
		self:SetLightPower(55,self:GetPackedBool(51) and self:GetPackedBool(32))
		-- LRS
		self:SetLightPower(56,self:GetPackedBool(54) and self:GetPackedBool(32))
		-- LVD
		self:SetLightPower(57,self:GetPackedBool(50) and self:GetPackedBool(32))
		-- LST
		self:SetLightPower(58,self:GetPackedBool(49) and self:GetPackedBool(32))
	else
		for i=40,58 do
			self:SetLightPower(i,false)
		end
	end
	
	-- Total temperature
	local IGLA_Temperature = math.max(self.Electric.T1,self.Electric.T2)
    
	-- Feed packed floats
	self:SetPackedRatio(0, 1-self.Pneumatic.DriverValvePosition/7)
	self:SetPackedRatio(1, (self.KV.ControllerPosition+3)/7)
	if self.KVWrenchMode == 2 then
		self:SetPackedRatio(2, self.KRU.Position)
	else
		self:SetPackedRatio(2, 1-(self.KV.ReverserPosition+1)/2)	
	end
	if self.Pneumatic.ValveType == 1 then
		self:SetPackedRatio(4, self.Pneumatic.ReservoirPressure/16.0)
	else
		self:SetPackedRatio(4, self.Pneumatic.BrakeLinePressure/16.0)	
	end	
	self:SetPackedRatio(5, self.Pneumatic.TrainLinePressure/16.0)
	self:SetPackedRatio(6, math.min(2.7,self.Pneumatic.BrakeCylinderPressure)/6.0)
	self:SetPackedRatio(7, self.Electric.Power750V/1000.0)
	self:SetPackedRatio(8, 0.5 + 0.5*(self.Electric.I24/500.0))
	if self.Pneumatic.TrainLineOpen then
		self:SetPackedRatio(9, (self.Pneumatic.TrainLinePressure_dPdT or 0)*6)
	else
		self:SetPackedRatio(9, self.Pneumatic.BrakeLinePressure_dPdT or 0)
	end
	self:SetPackedRatio(10,(self.Panel["V1"] * self.Battery.Voltage) / 150.0)
	self:SetPackedRatio(11,IGLA_Temperature)
	self:SetLightPower(39,(self.Electric.Overheat1 > 0) or (self.Electric.Overheat2 > 0))

	-- Update ARS system
	self:SetPackedRatio(3, self.ALS_ARS.Speed/100.0)
	if (self.ALS_ARS.Ring == true) or (self:ReadTrainWire(21) > 0) or 
		((IGLA_Temperature > 500) and ((CurTime() % 2.0) > 1.0)) then
		self:SetPackedBool(39,true)
	end
	
	-- RUT test
	local weightRatio = 2.00*math.max(0,math.min(1,(self:GetPassengerCount()/300)))
	if math.abs(self:GetAngles().pitch) > 2.5 then weightRatio = weightRatio + 1.00 end
	self.YAR_13A:TriggerInput("WeightLoadRatio",math.max(0,math.min(2.50,weightRatio)))
	
	-- Exchange some parameters between engines, pneumatic system, and real world
	self.Engines:TriggerInput("Speed",self.Speed)
	if IsValid(self.FrontBogey) and IsValid(self.RearBogey) then
		self.FrontBogey.MotorForce = 35300
		self.FrontBogey.Reversed = (self.RKR.Value > 0.5)
		self.RearBogey.MotorForce  = 35300
		self.RearBogey.Reversed = (self.RKR.Value < 0.5)
	
		-- These corrections are required to beat source engine friction at very low values of motor power
		local A = 2*self.Engines.BogeyMoment
		local P = math.max(0,0.04449 + 1.06879*math.abs(A) - 0.465729*A^2)
		if math.abs(A) > 0.4 then P = math.abs(A) end
		if math.abs(A) < 0.05 then P = 0 end
		if self.Speed < 10 then P = P*(1.0 + 0.5*(10.0-self.Speed)/10.0) end
		self.RearBogey.MotorPower  = P*0.5*((A > 0) and 1 or -1)
		self.FrontBogey.MotorPower = P*0.5*((A > 0) and 1 or -1)
		--self.Acc = (self.Acc or 0)*0.95 + self.Acceleration*0.05
		--print(self.Acc)
		
		-- Apply brakes
		self.FrontBogey.PneumaticBrakeForce = 40000.0
		self.FrontBogey.BrakeCylinderPressure = self.Pneumatic.BrakeCylinderPressure
		self.FrontBogey.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
		self.RearBogey.PneumaticBrakeForce = 40000.0
		self.RearBogey.BrakeCylinderPressure = self.Pneumatic.BrakeCylinderPressure
		self.RearBogey.BrakeCylinderPressure_dPdT = -self.Pneumatic.BrakeCylinderPressure_dPdT
	end
	
	-- Temporary hacks
	--self:SetNWFloat("V",self.Speed)
	--self:SetNWFloat("A",self.Acceleration)

	-- Send networked variables
	self:SendPackedData()
	return retVal
end


--------------------------------------------------------------------------------
function ENT:OnButtonPress(button)
	if (self.KVWrenchMode == 2) and (button == "KVReverserUp") then
		self.KRU:TriggerInput("Up",1)
		self:OnButtonPress("KRUUp")
	end
	if (self.KVWrenchMode == 2) and (button == "KVReverserDown") then
		self.KRU:TriggerInput("Down",1)
		self:OnButtonPress("KRUDown")
	end
	if (self.KVWrenchMode == 2) and (button == "KVSetX1") then
		self.KRU:TriggerInput("SetX1",1)
		self:OnButtonPress("KRUSetX1")
	end
	if (self.KVWrenchMode == 2) and (button == "KVSetX2") then
		self.KRU:TriggerInput("SetX2",1)
		self:OnButtonPress("KRUSetX2")
	end
	if (self.KVWrenchMode == 2) and (button == "KVSetX3") then
		self.KRU:TriggerInput("SetX3",1)
		self:OnButtonPress("KRUSetX3")
	end
	if (self.KVWrenchMode == 2) and (button == "KVSet0") then
		self.KRU:TriggerInput("Set0",1)
		self:OnButtonPress("KRUSet0")
	end		

	if button == "KVSetT1A" then
		if self.KV.ControllerPosition == -2 then
			self.KV:TriggerInput("ControllerSet",-1)
			timer.Simple(0.20,function()
				self.KV:TriggerInput("ControllerSet",-2)			
			end)
		end
	end
	if button == "KVWrench0" then 
		self.KVWrenchMode = 0
		self.DriversWrenchPresent = false
		self.DriversWrenchMissing = false
		self.KV:TriggerInput("Enabled",1)
		self.KRU:TriggerInput("Enabled",0)
		self:PlayOnce("kv1","cabin",0.7,120.0)
	end
	if button == "KVWrenchKV" then
		self.KVWrenchMode = 1
		self.DriversWrenchPresent = true
		self.DriversWrenchMissing = false
		self.KV:TriggerInput("Enabled",1)
		self.KRU:TriggerInput("Enabled",0)
		self:PlayOnce("kv1","cabin",0.7,120.0)
	end
	if button == "KVWrenchKRU" then
		self.KVWrenchMode = 2
		self.DriversWrenchPresent = false
		self.DriversWrenchMissing = true
		self.KV:TriggerInput("Enabled",0)
		self.KRU:TriggerInput("Enabled",1)
		self.KRU:TriggerInput("LockX3",1)
		self:PlayOnce("kv1","cabin",0.7,120.0)
	end
	if button == "KVWrenchNone" then
		self.KVWrenchMode = 3
		self.DriversWrenchPresent = false
		self.DriversWrenchMissing = true
		self.KV:TriggerInput("Enabled",0)
		self.KRU:TriggerInput("Enabled",0)
		self:PlayOnce("kv1","cabin",0.7,120.0)
	end
	if button == "KVT2Set" then self.KVT:TriggerInput("Close",1) end
	if button == "KDL" then self.KDL:TriggerInput("Close",1) self:OnButtonPress("KDLSet") end
	if button == "KDP" then self.KDP:TriggerInput("Close",1) self:OnButtonPress("KDPSet") end
	if button == "VDL" then self.VDL:TriggerInput("Close",1) self:OnButtonPress("VDLSet") end
	if button == "KRP" then 
		self.KRP:TriggerInput("Set",1)
		self:OnButtonPress("KRPSet")
	end
	if button == "EmergencyBrake" then
		self.KV:TriggerInput("ControllerSet",-3)
		self.Pneumatic:TriggerInput("BrakeSet",7)
		return
	end
	
	-- Special logic
	if (button == "VDL") or (button == "KDL") or (button == "KDP") then
		self.VUD1:TriggerInput("Open",1)
		--self.VUD2:TriggerInput("Open",1)
	end
	if (button == "VDL") or (button == "KDL") then
		self.DoorSelect:TriggerInput("Open",1)
	end
	if (button == "KDP") then
		self.DoorSelect:TriggerInput("Close",1)
	end
	if (button == "VUD1Set") or (button == "VUD1Toggle") or
	   (button == "VUD2Set") or (button == "VUD2Toggle") then
		self.VDL:TriggerInput("Open",1)
		self.KDL:TriggerInput("Open",1)
		self.KDP:TriggerInput("Open",1)
	end
	
	-- Special sounds
	if (button == "VUToggle") or ((string.sub(button,1,1) == "A") and (tonumber(string.sub(button,2,2)))) then
		local name = string.sub(button,1,(string.find(button,"Toggle") or 0)-1)
		if self[name] then
			if self[name].Value > 0.5 then
				self:PlayOnce("av_off","cabin")
			else
				self:PlayOnce("av_on","cabin")
			end
		end
		return
	end
	if button == "PBSet" then self:PlayOnce("switch6","cabin",0.55,100) return end
	if button == "GVToggle" then self:PlayOnce("switch4",nil,0.7) return end
	if button == "DURASelectMain" then self:PlayOnce("switch","cabin") return end
	if button == "DURASelectAlternate" then self:PlayOnce("switch","cabin") return end
	if button == "VUD1Toggle" then 
		if self.VUD1.Value > 0.5 then
			self:PlayOnce("switch_door_off","cabin")
		else
			self:PlayOnce("switch_door_on","cabin")
		end
		return
	end
	if button == "VUD1Set" then 
		self:PlayOnce("switch_door_on","cabin")
		return
	end
	
	if button == "DriverValveDisconnectToggle" then
		if self.DriverValveDisconnect.Value == 1.0 then
			self:PlayOnce("pneumo_disconnect2","cabin",0.9)
		else
			self:PlayOnce("pneumo_disconnect1","cabin",0.9)
		end
	end
	if (not string.find(button,"KVT")) and string.find(button,"KV") then return end
	if string.find(button,"KRU") then return end
	if string.find(button,"Brake") then self:PlayOnce("switch","cabin") return end

	-- Generic button or switch sound
	if string.find(button,"Set") then
		self:PlayOnce("button_press","cabin")
	end
	if string.find(button,"Toggle") then
		self:PlayOnce("switch2","cabin",0.7)
	end
end

function ENT:OnButtonRelease(button)
	if button == "KVT2Set" then self.KVT:TriggerInput("Open",1) end
	if button == "KDL" then self.KDL:TriggerInput("Open",1) self:OnButtonRelease("KDLSet") end
	if button == "KDP" then self.KDP:TriggerInput("Open",1) self:OnButtonRelease("KDPSet") end
	if button == "VDL" then self.VDL:TriggerInput("Open",1) self:OnButtonRelease("VDLSet") end
	if button == "KRP" then 
		self.KRP:TriggerInput("Set",0)
		self:OnButtonRelease("KRPSet")
	end
	
	if button == "PBSet" then self:PlayOnce("switch6_off","cabin",0.55,100) return end
	if (button == "PneumaticBrakeDown") and (self.Pneumatic.DriverValvePosition == 1) then
		self.Pneumatic:TriggerInput("BrakeSet",2)
	end	
	if self.Pneumatic.ValveType == 1 then
		if (button == "PneumaticBrakeUp") and (self.Pneumatic.DriverValvePosition == 5) then
			self.Pneumatic:TriggerInput("BrakeSet",4)
		end
	end
	if button == "VUD1Set" then 
		self:PlayOnce("switch_door_off","cabin")
		return
	end
	
	if (not string.find(button,"KVT")) and string.find(button,"KV") then return end
	if string.find(button,"KRU") then return end

	if string.find(button,"Set") then
		self:PlayOnce("button_release","cabin")
	end
end

function ENT:OnCouple(train,isfront)
	self.BaseClass.OnCouple(self,train,isfront)
	
	if isfront 
	then self.FrontBrakeLineIsolation:TriggerInput("Open",1.0)
	else self.RearBrakeLineIsolation:TriggerInput("Open",1.0)
	end
end

function ENT:OnTrainWireError(k)
	if k == 4 then
		--self.VU:TriggerInput("Open",1.0)
		--self:PlayOnce("av_off","cabin")
	end
end