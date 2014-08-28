TOOL.AddToMenu = false
TOOL.ClientConVar["train"] = 1
TOOL.ClientConVar["wagnum"] = 3
TOOL.ClientConVar["paint"] = 1
TOOL.ClientConVar["ars"] = 1
TOOL.ClientConVar["skin"] = 1
TOOL.ClientConVar["cran"] = 1
TOOL.ClientConVar["prom"] = 1
TOOL.ClientConVar["mask"] = 1
TOOL.ClientConVar["nm"] = 8.2
TOOL.ClientConVar["battery"] = 0
TOOL.ClientConVar["switches"] = 1
TOOL.ClientConVar["switchesr"] = 1
TOOL.ClientConVar["doorsl"] = 0
TOOL.ClientConVar["doorsr"] = 0
TOOL.ClientConVar["gv"] = 1
TOOL.ClientConVar["oldt"] = ""
TOOL.ClientConVar["oldw"] = ""

local Trains = {{"81-717","81-714"},{"Ezh3","Ema508T"},{"81-7036","81-7037"}}
local Switches = {	"A61","A55","A54","A56","A27","A21","A10","A53","A43","A45","A42","A41",
					"VU","A64","A63","A50","A51","A23","A14","A1","A2","A3","A17",
					"A62","A29","A5","A6","A8","A20","A25","A22","A30","A39","A44","A80"
					,"A65","A24","A32","A31","A16","A13","A12","A7","A9","A46","A47"}
if CLIENT then
	language.Add("Tool.train_spawner.name", "Train Spawner")
	language.Add("Tool.train_spawner.desc", "Spawn a train")
	language.Add("Tool.train_spawner.0", "Primary: Spawns a full train. Secondary: Reverse facing (yellow ed when facing the opposite side).")
	language.Add("Undone_81-7036", "Undone 81-7036 (does not work)")
	language.Add("Undone_81-7037", "Undone 81-7037 (does not work)")
	language.Add("Undone_81-717", "Undone 81-717")
	language.Add("Undone_81-714", "Undone 81-714")
	language.Add("Undone_Ezh3", "Undone Ezh3")
	language.Add("Undone_Ema508T", "Undone Em508T")
end

local function Trace(ply,tr)
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
	return {pos,ang,inhibitrerail}
end

function TOOL:GetCurrentModel(trNum,head,pr)
	if trNum == 1 then
		if not pr then
			if head == 1 then
				return "models/metrostroi/81/81-717a.mdl"
			else
				return "models/metrostroi/81/81-717b.mdl"
			end
		else
			return "models/metrostroi/81/81-714.mdl"
		end
	elseif trNum == 2 then
			return "models/metrostroi/e/"..(pr and "ema508t" or "em508")..".mdl"
	else
		return "models/metrostroi/81/81-703"..(pr and 7 or 6)..".mdl"
	end
end

function TOOL:GetConvar()
	local tbl = {}
	tbl.Train = self:GetClientNumber("train")
	tbl.WagNum = self:GetClientNumber("wagnum")
	tbl.Paint = self:GetClientNumber("paint")
	tbl.ARS = self:GetClientNumber("ars")
	tbl.Skin = self:GetClientNumber("skin")
	tbl.Cran = self:GetClientNumber("cran")
	tbl.Prom = self:GetClientNumber("prom")
	tbl.Mask = self:GetClientNumber("mask")
	tbl.NM = self:GetClientNumber("nm")
	tbl.Battery = self:GetClientNumber("battery")
	tbl.Switches = self:GetClientNumber("switches")
	tbl.SwitchesR = self:GetClientNumber("switchesr")
	tbl.DoorsL = self:GetClientNumber("doorsl")
	tbl.DoorsR = self:GetClientNumber("doorsr")
	tbl.GV = self:GetClientNumber("gv")
	return tbl
end

local CLpos,CLang = Vector(0,0,0),Angle(0,0,0)

function UpdateGhostPos(pl)
	local trace = util.TraceLine(util.GetPlayerTrace(pl))
	
	local tbl =  Metrostroi.RerailGetTrackData(trace.HitPos,pl:GetAimVector())
	
	if not tbl then tbl = Trace(pl, trace) end
	
	local pos,ang = Vector(0,0,0),Angle(0,0,0)
	if tbl[3] ~= nil then
		pos = tbl[1]+Vector(0,0,55)
		ang = tbl[2]
	else
		pos = tbl.centerpos + Vector(0,0,112)
		ang = tbl.right:Angle()+Angle(0,90,0)
	end
	return pos,ang
end

local Rev
function TOOL:UpdateGhost(pl, ent)
	local pos,ang
	if SERVER then
		pos, ang = UpdateGhostPos(pl)
	else
		pos, ang = CLpos, CLang
	end
	if not ent then return end
	if self.tbl.Train == 2 then
		ent:SetSkin(self.tbl.Paint == 1 and math.random(0,2) or self.tbl.Paint-2)
	elseif self.tbl.Train == 1 then
		ent:SetSkin(self.tbl.Paint-1)
	end
	ent:SetColor(Rev and Color(255	,255,0) or Color(255,255,255))
	ent:SetPos(pos)
	ent:SetAngles(ang + Angle(0,Rev and 180 or 0,0))
end

local owner
function TOOL:Think()
	owner = self:GetOwner()
	self.tbl = self:GetConvar()
	self.int = self.tbl.Prom > 0 or !Trains[self.tbl.Train][1]:find("Ezh")
	if (!IsValid(self.GhostEntity) or self.GhostEntity:GetModel() ~= self:GetCurrentModel(self.tbl.Train,self.tbl.Mask)) then
		self:MakeGhostEntity(self:GetCurrentModel(self.tbl.Train,self.tbl.Mask), Vector( 0, 0, 0 ), Angle( 0, 0, 0 ))
	end
	self:UpdateGhost(self:GetOwner(), self.GhostEntity)
	if SERVER then Rev = self.Rev end
end

local function SendCodeToCL()
	local pos,ang = UpdateGhostPos(owner)
	net.Start("TOOLGHOSTS")
		net.WriteVector(pos)
		net.WriteAngle(ang)
		net.WriteBit(Rev)
	net.Send(owner)
end

function TOOL:Spawn(ply, tr, clname, i)
	local rot = false
	if i > 1 then
		rot = i == self.tbl.WagNum and true or math.random() > 0.5
	end
	local pos,ang = Vector(0,0,0),Angle(0,0,0)
	if i == 1 then
		local tbl = Trace(ply, tr)
		pos = tbl[1]
		ang = tbl[2]
		rerail = tbl[3]
	else
		local dir = self.fent:GetAngles():Forward() * -1
		local add = clname:find("714")
		local wagheg = math.abs(self.oldent:OBBMaxs().x - self.oldent:OBBMins().x)+ 30 + ((rot or self.Rev) and 30 or 0)
		pos = self.oldent:GetPos() + dir*wagheg - Vector(0,0,140)
		ang = self.fent:GetAngles() + Angle(0,rot and 180 or 0,0)
	end
	local ent = ents.Create(clname)
	ent:SetPos(pos)
	ent:SetAngles(ang + Angle(0,(self.Rev and !rot) and 180 or 0,0))
	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	if IsValid(ent) then
		Metrostroi.RerailTrain(ent)
	end
	self.rot = rot
	return ent
end

function TOOL:SetSettings(ent, ply, i)
	local rot = false
	if i > 1 then
		rot = i == self.tbl.WagNum and true or math.random() > 0.5
	end
	undo.Create(Trains[self.tbl.Train][i>1 and i<self.tbl.WagNum and self.int and 2 or 1])
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
	undo.Finish()
	
	if not ent:GetClass():find("1-703") then
		if not ent:GetClass():find("81") then
			ent:SetSkin(self.tbl.Paint == 1 and math.random(0,2) or self.tbl.Paint-2)
		else
			ent:SetSkin(self.tbl.Paint-1)
		end
		ent.Pneumatic.ValveType = self.tbl.Cran
		ent.Pneumatic.TrainLinePressure = self.tbl.NM
		ent.ARSType = self.tbl.ARS
		ent:SetNWInt("ARSType", ent.ARSType)
		for k,v in pairs(Switches) do
			if i == 1 or i == self.tbl.WagNum or !self.int  then ent:TriggerInput(v.."Set", self.tbl.Switches > 0 and (math.random() > math.random(0.1,0.4) or self.tbl.SwitchesR == 0)) end
		end
		local rot = (self.fent:GetAngles().yaw - ent:GetAngles().yaw) ~= 0
		--local rot = 
		--print
		local DoorsL = self.tbl.DoorsL
		local DoorsR = self.tbl.DoorsR
		for I=1,4 do
			ent.Pneumatic.LeftDoorState[I] = ((DoorsL > 0 and !rot) or (DoorsR > 0 and rot)) and 1 or 0
			ent.Pneumatic.RightDoorState[I] = ((DoorsL > 0 and rot) or (DoorsR > 0 and !rot)) and 1 or 0
		end
	
		ent:TriggerInput("VBSet", self.tbl.Battery)
		ent:TriggerInput("GVSet", self.tbl.GV)
		
		if ent:GetClass() == "gmod_subway_81-717" then
			ent.TrainModel = self.tbl.Mask
			if ent.TrainModel == 1 then
				ent:SetModel("models/metrostroi/81/81-717a.mdl")
			else
				ent:SetModel("models/metrostroi/81/81-717b.mdl")
			end
		end
	end
end

function TOOL:SpawnWagon(trace)
	local ply = self:GetOwner()
	self.oldent = NULL
	for i=1,self.tbl.WagNum do
		local ent = self:Spawn(ply, trace, "gmod_subway_"..Trains[self.tbl.Train][i>1 and i<self.tbl.WagNum and self.int and 2 or 1]:lower(), i)
		self.fent = i == 1 and ent or self.fent
		if ent and ent:IsValid() then
			self:SetSettings(ent,ply,i)
		end
		self.oldent = ent
	end
	self.rot = false
end
function TOOL:LeftClick(trace)
	if CLIENT then timer.Simple(0.5,function() if self.GhostEntity then self.GhostEntity:Remove() end end) return end
	self:SpawnWagon(trace)
	self:GetOwner():SelectWeapon(self:GetClientInfo("oldW"))
	RunConsoleCommand("gmod_toolmode", self:GetClientInfo("oldT"))
end

function TOOL:RightClick(trace)
	if CLIENT then return end
	self.Rev = not self.Rev
	SendCodeToCL()
end

function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", { Text = "#Tool.train_spawner.name", Description = "#Tool.train_spawner.desc" })
end

if SERVER then 
	util.AddNetworkString "TOOLGHOSTS"
	timer.Create("TOOLGHOSTS",0.3,0,
		function()
			if owner and IsValid(owner) then
				SendCodeToCL()
			end
		end
	)
	return
end
--[[ 
function TOOL:Think()
	self.tbl = self:GetConvar()
	if (!IsValid(self.GhostEntity) or self.GhostEntity:GetModel() ~= self:GetCurrentModel(self.tbl.Train,self.tbl.Mask)) then
		self:MakeGhostEntity(self:GetCurrentModel(self.tbl.Train,self.tbl.Mask), Vector( 0, 0, 0 ), Angle( 0, 0, 0 ))
	end
	if not self.GhostEntity then return end
	self.GhostEntity:SetPos(pos)
	self.GhostEntity:SetAngles(ang)
end]]
local function CLGhost()
	CLpos = net.ReadVector()
	CLang = net.ReadAngle()
	Rev = net.ReadBit() > 0
end
net.Receive("TOOLGHOSTS",CLGhost)