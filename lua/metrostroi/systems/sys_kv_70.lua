--------------------------------------------------------------------------------
-- Кулачковый контроллер КВ-70
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("KV_70")

function TRAIN_SYSTEM:Initialize()
	self.ControllerPosition = 0
	self.ReverserPosition = 0
	self.RealControllerPosition = 0

	self.ReverserMatrix = {
		{"D",		"D1"	},
		{	1,	0,	1		},
		{"10/4",	"C3"	},
		{	0,	0,	1		},
		{"10/4",	"F1"	},
		{	1,	1,	0		},
		{"D4",		"15"	},
		{	1,	0,	1		},
		{"D8",		"15A"	},
		{	0,	1,	0		},
		{"3M35",	"4"		},
		{	0,	0,	1		},
		{"10AK",	"4"		},
		{	1,	0,	0		},
		{"10AK",	"5"		},
		{	0,	0,	1		},
		{"FR1",		"10"	},
		{	1,	0,	1		},
		{"F7",		"10"	},
		{	1,	0,	1		},
	}
	self.ControllerMatrix = {
		{"10",						"8"	},
		{	1,	0,	0,	0,	0,	0,	0	},
		{"U2",						"10AS"},
		{	1,	1,	1,	0,	1,	1,	1	},
		{"0",						"0"	},
		{	0,	0,	0,	1,	0,	0,	0	},
		{"10AK",					"2"	},
		{	1,	1,	0,	0,	0,	1,	1	},
		{"U2",						"3"	},
		{	0,	0,	0,	0,	0,	0,	1	},
		{"0",						"0"	},
		{	0,	0,	0,	1,	1,	1,	1	},
		{"10AS",					"33"},
		{	0,	0,	0,	0,	1,	1,	1	},
		{"10AS",					"33D"},
		{	0,	0,	0,	1,	1,	1,	1	},
		{"U2",						"33G"},
		{	1,	1,	1,	0,	0,	0,	0	},
		{"U2",						"20a"},
		{	0,	0,	0,	0,	1,	1,	1	},
		{"U2",						"25"},
		{	0,	1,	0,	0,	0,	0,	0	},
		{"10AS",					"U4"},
		{	0,	0,	0,	1,	0,	0,	0	},
		{"15A",						"15B"},
		{	1,	1,	1,	1,	0,	0,	0	},
		{"U2",						"20b"},
		{	1,	1,	1,	0,	0,	0,	0	},
	}
	
	-- Initialize contacts values
	for i=1,#self.ReverserMatrix/2 do
		local v = self.ReverserMatrix[i*2-1]
		self[v[1].."-"..v[2]] = 0
	end	
	for i=1,#self.ControllerMatrix/2 do
		local v = self.ControllerMatrix[i*2-1]
		self[v[1].."-"..v[2]] = 0
	end
end

function TRAIN_SYSTEM:Inputs()
	return { "ControllerSet", "ReverserSet",
			 "ControllerUp","ControllerDown","ReverserUp","ReverserDown",
			 "SetX1", "SetX2", "SetX3", "Set0", "SetT1", "SetT1A", "SetT2" }
end

function TRAIN_SYSTEM:Outputs()
	return { "ControllerPosition", "ReverserPosition" }
end

function TRAIN_SYSTEM:TriggerInput(name,value)
	local prevReverserPosition = self.ReverserPosition
	
	-- Change position
	if name == "ControllerSet" then
		if (self.ReverserPosition ~= 0) and (math.floor(value) ~= self.ControllerPosition) then
			local prevControllerPosition = self.ControllerPosition
			self.ControllerPosition = math.floor(value)
			
			-- Limit motion
			if self.ControllerPosition >  3 then self.ControllerPosition =  3 end
			if self.ControllerPosition < -3 then self.ControllerPosition = -3 end
			
			-- Play sounds
			local dC = math.abs(prevControllerPosition - self.ControllerPosition)
			if dC == 1 then self.Train:PlayOnce("kv1","cabin",0.8) end
			if dC == 2 then self.Train:PlayOnce("kv2","cabin",0.8) end
			if dC >= 3 then self.Train:PlayOnce("kv3","cabin",0.8) end
		end		
		
	elseif name == "ReverserSet" then
		if math.floor(value) ~= self.ReverserPosition then
			local prevReverserPosition = self.ReverserPosition
			self.ReverserPosition = math.floor(value)
			if self.ReverserPosition >  1 then self.ReverserPosition =  1 end
			if self.ReverserPosition < -1 then self.ReverserPosition = -1 end
			
			if prevReverserPosition ~= self.ReverserPosition then
				self.Train:PlayOnce("kv1","cabin",0.7,120.0)
			end
		end
	elseif (name == "ControllerUp") and (value > 0.5) then
		self:TriggerInput("ControllerSet",self.ControllerPosition+1)
	elseif (name == "ControllerDown") and (value > 0.5) then
		self:TriggerInput("ControllerSet",self.ControllerPosition-1)
		elseif (name == "ReverserUp") and (value > 0.5) then
		self:TriggerInput("ReverserSet",self.ReverserPosition+1)
	elseif (name == "ReverserDown") and (value > 0.5) then
		self:TriggerInput("ReverserSet",self.ReverserPosition-1)
	elseif (name == "SetX1") and (value > 0.5) then
		self:TriggerInput("ControllerSet",1)
	elseif (name == "SetX2") and (value > 0.5) then
		self:TriggerInput("ControllerSet",2)
	elseif (name == "SetX3") and (value > 0.5) then
		self:TriggerInput("ControllerSet",3)
	elseif (name == "Set0") and (value > 0.5) then
		self:TriggerInput("ControllerSet",0)		
	elseif (name == "SetT1") and (value > 0.5) then
		self:TriggerInput("ControllerSet",-1)
	elseif (name == "SetT1A") and (value > 0.5) then
		self:TriggerInput("ControllerSet",-2)
	elseif (name == "SetT2") and (value > 0.5) then
		self:TriggerInput("ControllerSet",-3)
	end
end


function TRAIN_SYSTEM:Think()
	local Train = self.Train
	if (self.ReverserPosition == 0) and (self.ControllerPosition ~= 0) then
		self.ControllerPosition = 0
		self.Train:PlayOnce("kv1","cabin",0.6)
	end
	
	-- Move controller
	self.Timer = self.Timer or CurTime()
	if ((CurTime() - self.Timer > 0.15) and (self.ControllerPosition > self.RealControllerPosition)) then
		self.Timer = CurTime()
		self.RealControllerPosition = self.RealControllerPosition + 1
	end
	if ((CurTime() - self.Timer > 0.15) and (self.ControllerPosition < self.RealControllerPosition)) then
		self.Timer = CurTime()
		self.RealControllerPosition = self.RealControllerPosition - 1
	end
	
	-- Update contacts
	for i=1,#self.ReverserMatrix/2 do
		local v = self.ReverserMatrix[i*2-1]
		local d = self.ReverserMatrix[i*2]
		self[v[1].."-"..v[2]] = d[self.ReverserPosition+2]
	end	
	for i=1,#self.ControllerMatrix/2 do
		local v = self.ControllerMatrix[i*2-1]
		local d = self.ControllerMatrix[i*2]
		self[v[1].."-"..v[2]] = d[self.RealControllerPosition+4]
	end
end
