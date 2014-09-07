--------------------------------------------------------------------------------
-- Internal systems simulations - auto-generated by gen.lua
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("Gen_Int")

-- Node values
local S = {}
-- Converts boolean expression to a number
local function C(x) return x and 1 or 0 end

local min = math.min

function TRAIN_SYSTEM.SolveEzh3(Train,Triggers)
	local P		= Train.PositionSwitch.SelectedPosition
	local RK	= Train.RheostatController.SelectedPosition
	local B		= (Train.Battery.Voltage > 55) and 1 or 0
	local T		= Train.SolverTemporaryVariables
	if not T then
		T = {}
		for i=1,100 do T[i] = 0 end
		Train.SolverTemporaryVariables = T
	end
	
	-- Solve all circuits
	T["SDRK_ShortCircuit"] = -10*Train.RheostatController.RKP*(Train.RUT.Value+Train.RRT.Value+(1.0-Train.SR1.Value) )
	Triggers["SDRK_Shunt"]( 1.0 - (0.20+0.20*C((RK >= 2) and (RK <= 7))*C(P == 1))*Train.LK2.Value )
	S["33-33Aa"] = Train.KD.Value+Train.VAD.Value
	S["U2-20"] = Train.KV["U2-20a"]+Train.KV["U2-20b"]
	S["31V'-31V"] = Train.KDL.Value+Train.VDL.Value
	S["10AK-VAH1"] = Train.VAH.Value+Train.RPB.Value
	S["33B-33AVU"] = Train.AVU.Value+Train.OtklAVU.Value
	S["1T-1P"] = Train.NR.Value+Train.RPU.Value
	S["2Zh-2A"] = (1.0-Train.KSB1.Value)+(1.0-Train.TR1.Value)
	S["2Zh-2A"] = Train.KSB2.Value+S["2Zh-2A"]
	S["8A-8Ye"] = C(RK == 1)+(1.0-Train.LK4.Value)
	S["15A-15B"] = Train.KV["15A-15B"]+Train.KD.Value
	S["10AYa-10E"] = (1.0-Train.LK3.Value)+Train.Rper.Value
	S["10AP-10AD"] = Train.LK2.Value+C((P == 3) or (P == 4))
	S["10AE-10B"] = Train.TR1.Value+Train.RV1.Value
	S["10AE-10B"] = Train.RV1.Value+S["10AE-10B"]
	S["D1-32V"] = Train.ALS_ARS["32"]+1*Train.KDP.Value
	S["2V-2G"] = C((RK >= 5) and (RK <= 18))+C((RK >= 2) and (RK <= 4))*Train.KSH1.Value
	S["2A-2G"] = C((P == 2) or (P == 4))*S["2V-2G"]+C((P == 1) or (P == 3))*C((RK >= 1) and (RK <= 17))
	S["1A-1M"] = C((RK >= 1) and (RK <= 5))+C(RK == 6)*Train.RheostatController.RKM1
	S["TW[15]-15A"] = 1+Train.KRU["15/2-D8"]*Train.KV["D8-15A"]
	S["10Zh-10N"] = Train.RheostatController.RKM1+(1.0-Train.RUT.Value)*Train.SR1.Value*(1.0-Train.RRT.Value)
	S["D1-31V"] = 1*S["31V'-31V"]+Train.ALS_ARS["31"]
	S["10-8"] = Train.KV["10-8"]+Train.KV["FR1-10"]*(1.0-Train.RPB.Value)*(1.0-Train.VAH.Value)
	S["1E-1Yu"] = Train.KSB2.Value*Train.KSB1.Value+Train.KSH2.Value
	S["10AD-10AG"] = Train.TR2.Value*Train.TR1.Value*C((P == 1) or (P == 2) or (P == 4))+(1.0-Train.TR2.Value)*(1.0-Train.TR1.Value)*C((P == 2) or (P == 3) or (P == 4))
	S["10AG-10E"] = C((P == 1))*Train.LK3.Value*C(RK == 18)+S["10AD-10AG"]*(1.0-Train.LK1.Value)*S["10AP-10AD"]
	S["1Zh-1G"] = S["1E-1Yu"]*C((P == 1) or (P == 3))*Train.LK5.Value*C(RK == 1)+Train.LK3.Value
	S["1R-1A"] = C((P == 2))*S["1A-1M"]+(1.0-Train.RV1.Value)*C((P == 1))
	S["10"] = 1*Train:ReadTrainWire(10)
	S["8"] = S["10"]*S["10-8"]+Train.ALS_ARS["8"]
	S["B12"] = 1*Train.VB.Value*B
	S["FR1/2"] = S["10"]*Train.KV["FR1-10"]
	S["10AN"] = 1*(1.0-Train.RPvozvrat.Value)*Train.A14.Value*1
	S["20B"] = (1.0-Train.RPvozvrat.Value)*Train.A20.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*Train:ReadTrainWire(20)
	S["10AL"] = S["10"]*Train.VU.Value
	S["10ALa"] = S["10AL"]*Train.A64.Value
	S["Sh1-43"] = S["10AL"]*Train.A45.Value
	S["10AS"] = S["10AL"]*Train.A55.Value
	S["10AK"] = S["10AL"]*Train.A54.Value
	S["6P"] = S["10AL"]*Train.A61.Value
	S["6"] = S["6P"]*Train.RVT.Value
	S["2-7R-24"] = S["6P"]*(1.0-Train.AVU.Value)
	S["29"] = S["2-7R-24"]*(1.0-Train.OtklAVU.Value)+Train.ALS_ARS["29"]
	S["4B"] = (1.0-Train.RKR.Value)*Train:ReadTrainWire(4)
	S["5B"] = Train.RKR.Value*Train:ReadTrainWire(5)
	S["5V"] = Train.RKR.Value*Train:ReadTrainWire(4)+T[9]*(1.0-Train.RKR.Value)
	S["5B'"] = S["5V"]*Train.LK3.Value
	S["6A"] = Train.A6.Value*Train:ReadTrainWire(6)
	S["8A"] = Train.A8.Value*Train:ReadTrainWire(8)
	S["8Zh"] = S["8A"]*C((RK >= 17) and (RK <= 18))+T[11]*1
	S["12A"] = Train.A12.Value*Train:ReadTrainWire(12)
	S["17A"] = Train.A17.Value*Train:ReadTrainWire(17)
	S["24V"] = (1.0-Train.LK4.Value)*Train:ReadTrainWire(24)
	S["25A"] = Train.A25.Value*Train:ReadTrainWire(25)
	S["27A"] = Train.A50.Value*Train:ReadTrainWire(27)
	S["28A"] = Train.A51.Value*Train:ReadTrainWire(28)
	S["31A"] = Train.A31.Value*Train:ReadTrainWire(31)+T[3]*1
	S["32A"] = Train.A32.Value*Train:ReadTrainWire(32)+T[4]*1
	S["3A"] = Train.A3.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*Train:ReadTrainWire(3)
	S["1-7R-8"] = S["10AS"]*Train.KV["10AS-U4"]*Train.VozvratRP.Value
	S["1A"] = Train.A1.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*Train:ReadTrainWire(1)
	S["18A"] = Train.A14.Value*(1.0-Train.RPvozvrat.Value)*Train.LK4.Value*1
	S["16V"] = Train.A16.Value*(1.0-Train.RD.Value)*Train:ReadTrainWire(16)
	S["6Yu"] = S["6A"]*C((P == 3) or (P == 4))*C((RK >= 1) and (RK <= 5))
	S["33Aa"] = S["10AS"]*Train.KV["10AS-33"]*S["33-33Aa"]
	S["10/4"] = S["B12"]*Train.VB.Value*Train.A56.Value+(1-Train.VB.Value)*Train:ReadTrainWire(10)
	S["11B"] = S["10/4"]*Train.KV["10/4-C3"]*(1.0-Train.NR.Value)+T[1]*1
	S["B2"] = 1*Train.VB.Value*B
	S["22A"] = Train.A23.Value*1*Train:ReadTrainWire(23)+T[7]*Train.A22.Value
	S["2Ye"] = Train.A2.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*S["2Zh-2A"]*Train.LK4.Value*S["2A-2G"]*Train:ReadTrainWire(2)+T[5]*(1.0-Train.LK4.Value)
	S["15B"] = S["15A-15B"]*S["TW[15]-15A"]*Train:ReadTrainWire(15)
	S["33V"] = S["10AK"]*1*S["10AK-VAH1"]*Train.RV2.Value*S["33B-33AVU"]
	S["B8"] = S["B2"]*Train.A53.Value
	S["B22"] = S["B8"]*Train.A75.Value
	S["B28"] = S["B8"]*Train.KUP.Value
	S["36Ya"] = S["B8"]*Train.KVC.Value
	S["10/4a"] = S["10/4"]*Train.VB.Value
	S["B13"] = S["B12"]*Train.A24.Value
	S["B3"] = S["B2"]*Train.A44.Value
	S["1-7R-29"] = S["B3"]*Train.RezMK.Value
	S["22K"] = S["10/4"]*Train.A10.Value
	S["U0"] = S["10/4"]*Train.A27.Value
	S["U0a"] = S["U0"]*1+(-10*S["10AN"])
	S["s3"] = S["U0"]*Train.DIPon.Value
	S["s10"] = S["U0"]*Train.DIPoff.Value
	S["F1"] = S["10/4"]*Train.KV["10/4-F1"]
	S["D4"] = S["10/4"]*Train.A13.Value
	S["15"] = S["D4"]*Train.KV["D4-15"]+(-10*Train:ReadTrainWire(11)) + Train.KRU["14/1-B3"]*S["B3"]*20
	S["D4/3"] = S["D4"]*1
	S["4"] = S["10AK"]*Train.KV["10AK-4"]
	S["5"] = S["10AK"]*Train.KV["10AK-5"]+(-10*Train.KRU["5/3-ZM31"]*0 + Train.KRU["14/1-B3"]*S["B3"]*1)
	S["1P"] = S["1A"]*C((P == 1) or (P == 2))*S["1T-1P"]+T[2]*C((P == 3) or (P == 4))
	S["8G"] = S["8A"]*(1.0-Train.RT2.Value)*S["8A-8Ye"]
	S["U2"] = S["10AS"]*Train.KV["U2-10AS"]
	S["24"] = S["U2"]*Train.KSN.Value
	S["2-7R-21"] = S["U2"]*1+(-10*Train:ReadTrainWire(18))
	S["2"] = S["10AK"]*Train.KV["10AK-2"]+Train.ALS_ARS["2"]+(-10*Train.KRU["2/3-ZM31"])
	S["3"] = S["U2"]*Train.KV["U2-3"]+(-10*Train.KRU["3/3-ZM31"])
	S["D1"] = S["10/4"]*Train.A21.Value*Train.KV["D-D1"]+(1*Train.KRU["11/3-D1/1"]*Train.KRU["14/1-B3"]*S["B3"])
	S["1"] = S["10AS"]*Train.R1_5.Value*Train.KV["10AS-33D"]*Train.ALS_ARS["33D"]+(-10*Train.KRU["1/3-ZM31"])
	S["1R"] = S["1A"]*S["1R-1A"]
	S["1Zh"] = S["1P"]*S["1Zh-1G"]*Train.AVT.Value*(1.0-Train.RPvozvrat.Value)
	S["12"] = S["D1"]*Train.KRZD.Value
	S["F2a"] = S["F1"]*Train.A7.Value
	S["F1a"] = S["F1"]*Train.A9.Value
	S["22V"] = S["22A"]*(1.0-Train.TRK.Value)
	S["ST/1+ST/2"] = S["D4/3"]*Train.BPT.Value
	S["16V/1+16V/2"] = S["D4/3"]*(1.0-Train.RD.Value)
	S["D6/1"] = S["D4/3"]*Train.BD.Value
	S["1K"] = S["1Zh"]*C((P == 1) or (P == 2))
	S["1N"] = S["1Zh"]*C((P == 1) or (P == 3))
	S["11A"] = S["B2"]*(1.0-Train.RD.Value)
	S["10AYa"] = S["B2"]*Train.A80.Value
	S["10AE"] = S["B2"]*Train.A30.Value
	S["10I"] = S["10AE"]*Train.RheostatController.RKM2
	S["10AH"] = S["10I"]*(1.0-Train.LK1.Value)+0
	S["10H"] = S["10I"]*Train.LK4.Value
	S["20"] = S["U2"]*S["U2-20"]+Train.ALS_ARS["20"]+(-10*Train.KRU["20/3-ZM31"])
	S["10B"] = S["10AE"]*S["10AE-10B"]
	S["25"] = S["U2"]*Train.KV["U2-25"]*Train.K25.Value
	S["1-7R-31"] = S["B3"]*Train.KRU["14/1-B3"]*Train.KRP.Value
	S["22E'"] = S["10/4"]*Train.VMK.Value*Train.AK.Value
	S["16"] = S["D1"]*Train.VUD1.Value*Train.VUD2.Value
	S["32V"] = S["D1"]*S["D1-32V"]
	S["10AV"] = S["10AYa"]*(1.0-Train.LK3.Value)*C((RK >= 2) and (RK <= 18))
	S["31V"] = S["D1"]*S["D1-31V"]
	S["10N"] = S["10AE"]*1*S["10Zh-10N"]+T["SDRK_ShortCircuit"]
	S["10AG"] = S["10AYa"]*S["10AG-10E"]*S["10AYa-10E"]
	S["F7"] = S["10"]*Train.KV["F7-10"]+(1*Train.KRU["11/3-FR1"]*Train.KRU["14/1-B3"]*S["B3"])
	S["F7/1"] = S["10"]*Train.KV["F7-10"]+(1*Train.KRU["11/3-FR1"]*Train.KRU["14/1-B3"]*S["B3"])
	S["33G"] = 1*Train.ALS_ARS["33G"]+S["U2"]*Train.KV["U2-33G"]
	S["F13"] = S["F7"]*Train.A46.Value
	S["F10"] = S["F7/1"]*Train.VUS.Value*Train.A47.Value

	-- Call all triggers
	Train.RVT:TriggerInput("Set",S["33G"])
	Train.Panel["TrainBrakes"] = S["ST/1+ST/2"]
	Train.RV1:TriggerInput("Set",S["2Ye"])
	T[7] = min(1,Train:ReadTrainWire(22))
	Train.SR1:TriggerInput("Set",S["2Ye"])
	Train.Panel["Ring"] = S["11B"]
	Train:WriteTrainWire(15,S["15"])
	Train.Panel["TrainDoors"] = S["16V/1+16V/2"]
	Train.Panel["HeadLights3"] = S["F13"]
	Train.Panel["EmergencyLight"] = S["B12"]
	Triggers["RPvozvrat"](S["17A"])
	Train:WriteTrainWire(16,S["16"])
	Train:WriteTrainWire(10,S["10/4a"])
	Triggers["XR3.7"](S["36Ya"])
	Train:WriteTrainWire(32,S["32V"])
	Train:WriteTrainWire(5,S["5"])
	Triggers["XR3.2"](S["27A"])
	Triggers["XR3.4"](S["36Ya"])
	Triggers["RUTpod"](S["10H"])
	Train.Panel["HeadLights2"] = S["F13"]
	Train:WriteTrainWire(25,S["25"])
	Train.LK3:TriggerInput("Set",S["1Zh"])
	Train.Panel["V1"] = S["10/4"]
	Train.PneumaticNo2:TriggerInput("Set",S["8G"])
	Train:WriteTrainWire(3,S["3"])
	Train:WriteTrainWire(6,S["6"])
	Triggers["KSH2"](S["1R"])
	Train:WriteTrainWire(8,S["8"])
	Train.Panel["HeadLights1"] = S["F10"]
	Triggers["SDRK"](S["10N"])
	Triggers["KSB1"](S["6Yu"])
	Train:WriteTrainWire(11,S["11A"])
	Train.Panel["RedLightRight"] = S["F2a"]
	Train:WriteTrainWire(31,S["31V"])
	Triggers["KSH1"](S["1R"])
	Train.RPU:TriggerInput("Set",S["27A"])
	T[9] = min(1,Train:ReadTrainWire(5))
	Triggers["ReverserBackward"](S["4B"])
	T[8] = min(1,S["5V"])
	Train:WriteTrainWire(23,S["1-7R-29"])
	Train.R1_5:TriggerInput("Set",S["33V"])
	T[6] = min(1,S["22A"])
	T[5] = min(1,S["10AV"])
	T[4] = min(1,S["12A"])
	T[3] = min(1,S["12A"])
	Train.KK:TriggerInput("Set",S["22V"])
	Train:WriteTrainWire(17,S["1-7R-8"])
	Triggers["KSB2"](S["6Yu"])
	T[2] = min(1,S["6A"])
	Train.Panel["GreenRP"] = S["U0a"]
	Train.RZ_2:TriggerInput("Set",S["24V"])
	T[1] = min(1,S["27A"])
	Train.Panel["CabinLight"] = S["10ALa"]
	Triggers["ReverserForward"](S["5B"])
	Triggers["RRTpod"](S["10AH"])
	Train:WriteTrainWire(28,S["s10"])
	Triggers["XT3.1"](S["B13"])
	Train:WriteTrainWire(14,S["1-7R-31"])
	Triggers["SDPP"](S["10AG"])
	Train.VDOP:TriggerInput("Set",S["32A"])
	Train.VDOL:TriggerInput("Set",S["31A"])
	Train:WriteTrainWire(9,S["10/4a"])
	Train:WriteTrainWire(27,S["s3"])
	Triggers["KPP"](S["27A"])
	T[10] = min(1,S["8Zh"])
	Triggers["RRTuderzh"](S["25A"])
	Train.KD:TriggerInput("Set",S["15B"])
	Train.Panel["SD"] = S["15B"]
	Train:WriteTrainWire(18,S["18A"])
	Train.VDZ:TriggerInput("Set",S["16V"])
	Train.LK2:TriggerInput("Set",S["20B"])
	Train.Rper:TriggerInput("Set",S["3A"])
	Train.LK5:TriggerInput("Set",S["20B"])
	Train:WriteTrainWire(24,S["24"])
	Train.PneumaticNo1:TriggerInput("Set",S["8Zh"])
	Triggers["SDRK_Coil"](S["10B"])
	Train:WriteTrainWire(12,S["12"])
	Train.RUP:TriggerInput("Set",S["6Yu"])
	Train.TR2:TriggerInput("Set",S["6A"])
	Train.LK4:TriggerInput("Set",S["5B'"])
	Train.TR1:TriggerInput("Set",S["6A"])
	T[11] = min(1,Train:ReadTrainWire(29))
	Train.Panel["AVU"] = S["2-7R-24"]
	Train.Panel["KUP"] = S["B28"]
	Train:WriteTrainWire(29,S["29"])
	Train.KVC:TriggerInput("Set",S["B8"])
	Train.RV2:TriggerInput("Set",S["33Aa"])
	Triggers["XR3.6"](S["36Ya"])
	Train:WriteTrainWire(2,S["2"])
	Train.RRP:TriggerInput("Set",Train:ReadTrainWire(14))
	Train:WriteTrainWire(20,S["20"])
	Train.Panel["RedRP"] = S["2-7R-21"]
	Triggers["XR3.3"](S["28A"])
	Train.K25:TriggerInput("Set",Train.ALS_ARS["33Zh"])
	Train.RD:TriggerInput("Set",S["D6/1"])
	Train:WriteTrainWire(22,S["22E'"])
	Train.RR:TriggerInput("Set",S["1N"])
	Train.LK1:TriggerInput("Set",S["1K"])
	Train.Panel["RedLightLeft"] = S["F1a"]
	Train.Panel["TrainRP"] = S["2-7R-21"]
	Train:WriteTrainWire(1,S["1"])
	Train:WriteTrainWire(4,S["4"])
	Train.KUP:TriggerInput("Set",S["B22"])
	return S
end


function TRAIN_SYSTEM.Solve81_717(Train,Triggers)
	local P		= Train.PositionSwitch.SelectedPosition
	local RK	= Train.RheostatController.SelectedPosition
	local B		= (Train.Battery.Voltage > 55) and 1 or 0
	local T		= Train.SolverTemporaryVariables
	if not T then
		T = {}
		for i=1,100 do T[i] = 0 end
		Train.SolverTemporaryVariables = T
	end
	
	-- Solve all circuits
	T["SDRK_ShortCircuit"] = -10*Train.RheostatController.RKP*(Train.RUT.Value+Train.RRT.Value+(1.0-Train.SR1.Value)+C(RK == 6)*C(P == 2)*(1.0-Train.Rper.Value)*Train.LK3.Value)
	Triggers["SDRK_Shunt"]( 1.0 - (0.20+0.20*C((RK >= 2) and (RK <= 7))*C(P == 1))*Train.LK2.Value )
	S["33-33Aa"] = Train.KD.Value+Train.VAD.Value
	S["U2-20"] = Train.KV["U2-20a"]+Train.KV["U2-20b"]
	S["31V'-31V"] = Train.KDL.Value+Train.VDL.Value
	S["10AK-VAH1"] = Train.VAH.Value+Train.RPB.Value
	S["33B-33AVU"] = Train.AVU.Value+Train.OtklAVU.Value
	S["1T-1P"] = Train.NR.Value+Train.RPU.Value
	S["2Zh-2A"] = (1.0-Train.KSB1.Value)+(1.0-Train.TR1.Value)
	S["2Zh-2A"] = Train.ThyristorBU5_6.Value+S["2Zh-2A"]
	S["8A-8Ye"] = C(RK == 1)+(1.0-Train.LK4.Value)
	S["15A-15B"] = Train.KV["15A-15B"]+Train.KD.Value
	S["10AYa-10E"] = (1.0-Train.LK3.Value)+C((P == 1))
	S["10AP-10AD"] = Train.LK2.Value+C((P == 3) or (P == 4))
	S["10AE-10B"] = Train.TR1.Value+Train.RV1.Value
	S["10AE-10B"] = Train.RV1.Value+S["10AE-10B"]
	S["D1-32V"] = Train.ALS_ARS["32"]+Train.DoorSelect.Value*Train.KDP.Value
	S["2V-2G"] = C((RK >= 5) and (RK <= 18))+C((RK >= 2) and (RK <= 4))*Train.KSH1.Value
	S["2A-2G"] = C((P == 2) or (P == 4))*S["2V-2G"]+C((P == 1) or (P == 3))*C((RK >= 1) and (RK <= 17))
	S["1A-1M"] = C((RK >= 1) and (RK <= 5))+C(RK == 6)*Train.RheostatController.RKM1
	S["TW[15]-15A"] = 1+Train.KRU["15/2-D8"]*Train.KV["D8-15A"]
	S["10Zh-10N"] = Train.RheostatController.RKM1+(1.0-Train.RUT.Value)*Train.SR1.Value*(1.0-Train.RRT.Value)
	S["D1-31V"] = Train.ALS_ARS["31"]+(1.0-Train.DoorSelect.Value)*S["31V'-31V"]
	S["10-8"] = Train.KV["10-8"]+(1.0-Train.VAH.Value)*Train.KV["FR1-10"]*(1.0-Train.RPB.Value)
	S["1E-1Yu"] = Train.KSB2.Value*Train.KSB1.Value+Train.KSH2.Value
	S["10AD-10AG"] = Train.TR2.Value*Train.TR1.Value*C((P == 1) or (P == 2) or (P == 4))+(1.0-Train.TR2.Value)*(1.0-Train.TR1.Value)*C((P == 2) or (P == 3) or (P == 4))
	S["10AG-10E"] = S["10AD-10AG"]*(1.0-Train.LK1.Value)*S["10AP-10AD"]+C((P == 1))*Train.LK3.Value*C(RK == 18)
	S["1Zh-1G"] = S["1E-1Yu"]*C((P == 1) or (P == 3))*Train.LK5.Value*C(RK == 1)+Train.LK3.Value
	S["1R-1A"] = C((P == 2))*S["1A-1M"]+(1.0-Train.RV1.Value)*C((P == 1))
	S["10"] = 1*Train:ReadTrainWire(10)
	S["8"] = S["10"]*S["10-8"]+Train.ALS_ARS["8"]
	S["B12"] = 1*Train.VB.Value*B
	S["FR1/2"] = S["10"]*Train.KV["FR1-10"]
	S["10AN"] = 1*(1.0-Train.RPvozvrat.Value)*Train.A14.Value*1
	S["20B"] = (1.0-Train.RPvozvrat.Value)*Train.A20.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*Train:ReadTrainWire(20)
	S["2Ye"] = Train.A2.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*S["2Zh-2A"]*Train.LK4.Value*S["2A-2G"]*Train:ReadTrainWire(2)+T[15]*(1.0-Train.LK4.Value)
	S["10AL"] = S["10"]*Train.VU.Value
	S["10ALa"] = S["10AL"]*Train.A64.Value
	S["Sh1-43"] = S["10AL"]*Train.A45.Value
	S["10AS"] = S["10AL"]*Train.A55.Value
	S["10AK"] = S["10AL"]*Train.A54.Value
	S["6P"] = S["10AL"]*Train.A61.Value
	S["6"] = S["6P"]*Train.RVT.Value
	S["2-7R-24"] = S["6P"]*(1.0-Train.AVU.Value)
	S["29"] = S["2-7R-24"]*(1.0-Train.OtklAVU.Value)+Train.ALS_ARS["29"]
	S["4B"] = (1.0-Train.RKR.Value)*Train:ReadTrainWire(4)
	S["5B"] = Train.RKR.Value*Train:ReadTrainWire(5)
	S["5V"] = Train.RKR.Value*Train:ReadTrainWire(4)+T[21]*(1.0-Train.RKR.Value)
	S["5B'"] = S["5V"]*Train.LK3.Value
	S["6A"] = Train.A6.Value*Train:ReadTrainWire(6)
	S["8A"] = Train.A8.Value*Train:ReadTrainWire(8)
	S["8Zh"] = S["8A"]*C((RK >= 17) and (RK <= 18))+T[23]*1
	S["12A"] = Train.A12.Value*Train:ReadTrainWire(12)
	S["17A"] = Train.A17.Value*Train:ReadTrainWire(17)
	S["24V"] = (1.0-Train.LK4.Value)*Train:ReadTrainWire(24)
	S["25A"] = Train.A25.Value*Train:ReadTrainWire(25)
	S["27A"] = Train.A50.Value*Train:ReadTrainWire(27)
	S["31A"] = Train.A31.Value*Train:ReadTrainWire(31)+T[13]*1
	S["32A"] = Train.A32.Value*Train:ReadTrainWire(32)+T[14]*1
	S["3A"] = Train.A3.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*Train:ReadTrainWire(3)
	S["1-7R-8"] = S["10AS"]*Train.KV["10AS-U4"]*Train.VozvratRP.Value
	S["1A"] = Train.A1.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*Train:ReadTrainWire(1)
	S["18A"] = Train.A14.Value*(1.0-Train.RPvozvrat.Value)*Train.LK4.Value*1
	S["16V"] = Train.A16.Value*(1.0-Train.RD.Value)*Train:ReadTrainWire(16)
	S["6Yu"] = S["6A"]*C((P == 3) or (P == 4))*C((RK >= 1) and (RK <= 5))
	S["10/4"] = S["B12"]*Train.VB.Value*Train.A56.Value+(1-Train.VB.Value)*Train:ReadTrainWire(10)
	S["11B"] = S["10/4"]*Train.KV["10/4-C3"]*0+T[17]*1
	S["33Aa"] = S["10AS"]*Train.KV["10AS-33"]*S["33-33Aa"]
	S["B2"] = 1*Train.VB.Value*B
	S["22A"] = Train.A23.Value*1*Train:ReadTrainWire(23)+T[19]*Train.A22.Value
	S["15B"] = S["15A-15B"]*S["TW[15]-15A"]*Train:ReadTrainWire(15)
	S["33V"] = S["10AK"]*1*S["10AK-VAH1"]*Train.RV2.Value*S["33B-33AVU"]
	S["B8"] = S["B2"]*Train.A53.Value
	S["B22"] = S["B8"]*Train.A75.Value
	S["B28"] = S["B8"]*Train.KUP.Value
	S["36Ya"] = S["B8"]*Train.KVC.Value
	S["10/4a"] = S["10/4"]*Train.VB.Value
	S["B13"] = S["B12"]*Train.A24.Value
	S["B3"] = S["B2"]*Train.A44.Value
	S["1-7R-29"] = S["B3"]*Train.RezMK.Value
	S["22K"] = S["10/4"]*Train.A10.Value
	S["U0"] = S["10/4"]*Train.A27.Value
	S["U0a"] = S["U0"]*1+(-10*S["10AN"])
	S["s10"] = S["U0"]*Train.DIPoff.Value
	S["s3"] = S["U0"]*Train.BPSNon.Value
	S["L_1'"] = S["U0"]*Train.L_1.Value
	S["L_5'"] = S["U0"]*Train.L_5.Value
	S["F1"] = S["10/4"]*Train.KV["10/4-F1"]
	S["D4"] = S["10/4"]*Train.A13.Value
	S["15"] = S["D4"]*Train.KV["D4-15"]+(-10*Train:ReadTrainWire(11)) + Train.KRU["14/1-B3"]*S["B3"]*20
	S["D4/3"] = S["D4"]*1
	S["4"] = S["10AK"]*Train.KV["10AK-4"]
	S["5"] = S["10AK"]*Train.KV["10AK-5"]+(-10*Train.KRU["5/3-ZM31"]*0 + Train.KRU["14/1-B3"]*S["B3"]*1)
	S["1P"] = S["1A"]*C((P == 1) or (P == 2))*S["1T-1P"]+T[12]*C((P == 3) or (P == 4))
	S["8G"] = S["8A"]*(1.0-Train.RT2.Value)*S["8A-8Ye"]
	S["U2"] = S["10AS"]*Train.KV["U2-10AS"]
	S["24"] = S["U2"]*Train.KSN.Value
	S["2-7R-21"] = S["U2"]*1+(-10*Train:ReadTrainWire(18))
	S["2"] = S["10AK"]*Train.KV["10AK-2"]+Train.ALS_ARS["2"]+(-10*Train.KRU["2/3-ZM31"])
	S["1R"] = S["1A"]*S["1R-1A"]
	S["3"] = S["U2"]*Train.KV["U2-3"]+(-10*Train.KRU["3/3-ZM31"])
	S["D1"] = S["10/4"]*Train.A21.Value*Train.KV["D-D1"]+(1*Train.KRU["11/3-D1/1"]*Train.KRU["14/1-B3"]*S["B3"])
	S["1"] = S["10AS"]*Train.R1_5.Value*Train.KV["10AS-33D"]*Train.ALS_ARS["33D"]+(-10*Train.KRU["1/3-ZM31"])
	S["1Zh"] = S["1P"]*S["1Zh-1G"]*Train.AVT.Value*(1.0-Train.RPvozvrat.Value)
	S["12"] = S["D1"]*Train.KRZD.Value
	S["F2a"] = S["F1"]*Train.A7.Value
	S["F1a"] = S["F1"]*Train.A9.Value
	S["22V"] = S["22A"]*(1.0-Train.TRK.Value)
	S["ST/1+ST/2"] = S["D4/3"]*Train.BPT.Value
	S["16V/1+16V/2"] = S["D4/3"]*(1.0-Train.RD.Value)
	S["D6/1"] = S["D4/3"]*Train.BD.Value
	S["1K"] = S["1Zh"]*C((P == 1) or (P == 2))
	S["1N"] = S["1Zh"]*C((P == 1) or (P == 3))
	S["11A"] = S["B2"]*(1.0-Train.RD.Value)
	S["10AYa"] = S["B2"]*Train.A80.Value
	S["10AE"] = S["B2"]*Train.A30.Value
	S["10I"] = S["10AE"]*Train.RheostatController.RKM2
	S["10AH"] = S["10I"]*(1.0-Train.LK1.Value)+0
	S["10H"] = S["10I"]*Train.LK4.Value
	S["20"] = S["U2"]*S["U2-20"]+Train.ALS_ARS["20"]+(-10*Train.KRU["20/3-ZM31"])
	S["10B"] = S["10AE"]*S["10AE-10B"]
	S["25"] = S["U2"]*Train.KV["U2-25"]*Train.K25.Value
	S["1-7R-31"] = S["B3"]*Train.KRU["14/1-B3"]*Train.KRP.Value
	S["22E'"] = S["10/4"]*Train.VMK.Value*Train.AK.Value
	S["16"] = S["D1"]*Train.VUD1.Value*Train.VUD2.Value
	S["32V"] = S["D1"]*S["D1-32V"]
	S["10AV"] = S["10AYa"]*(1.0-Train.LK3.Value)*C((RK >= 2) and (RK <= 18))
	S["31V"] = S["D1"]*S["D1-31V"]
	S["10AG"] = S["10AYa"]*S["10AG-10E"]*S["10AYa-10E"]
	S["10N"] = S["10AE"]*1*S["10Zh-10N"]+T["SDRK_ShortCircuit"]
	S["F7"] = S["10"]*Train.KV["F7-10"]+(1*Train.KRU["11/3-FR1"]*Train.KRU["14/1-B3"]*S["B3"])
	S["F7/1"] = S["10"]*Train.KV["F7-10"]+(1*Train.KRU["11/3-FR1"]*Train.KRU["14/1-B3"]*S["B3"])
	S["33G"] = 1*Train.ALS_ARS["33G"]+S["U2"]*Train.KV["U2-33G"]
	S["F13"] = S["F7"]*Train.A46.Value
	S["F10"] = S["F7/1"]*Train.VUS.Value*Train.A47.Value

	-- Call all triggers
	Train.RVT:TriggerInput("Set",S["33G"])
	Train.Panel["TrainBrakes"] = S["ST/1+ST/2"]
	Train.RV1:TriggerInput("Set",S["2Ye"])
	T[13] = min(1,S["12A"])
	Train.SR1:TriggerInput("Set",S["2Ye"])
	Train.Panel["Ring"] = S["11B"]
	Train:WriteTrainWire(15,S["15"])
	Train.Panel["TrainDoors"] = S["16V/1+16V/2"]
	Train.Panel["HeadLights3"] = S["F13"]
	Triggers["RPvozvrat"](S["17A"])
	Train:WriteTrainWire(16,S["16"])
	Train.K25:TriggerInput("Set",Train.ALS_ARS["33Zh"])
	Triggers["XR3.7"](S["36Ya"])
	Train:WriteTrainWire(32,S["32V"])
	Train:WriteTrainWire(5,S["5"])
	Triggers["XR3.2"](S["27A"])
	Triggers["XR3.4"](S["36Ya"])
	Triggers["RUTpod"](S["10H"])
	T[21] = min(1,Train:ReadTrainWire(5))
	Train.Panel["HeadLights2"] = S["F13"]
	Train:WriteTrainWire(25,S["25"])
	Train.LK3:TriggerInput("Set",S["1Zh"])
	Train.Panel["V1"] = S["10/4"]
	Train.PneumaticNo2:TriggerInput("Set",S["8G"])
	Train:WriteTrainWire(3,S["3"])
	Train:WriteTrainWire(6,S["6"])
	Train.KSH2:TriggerInput("Set",S["1R"])
	Train:WriteTrainWire(8,S["8"])
	Train.Panel["HeadLights1"] = S["F10"]
	Triggers["SDRK"](S["10N"])
	Train.KSB1:TriggerInput("Set",S["6Yu"])
	Train:WriteTrainWire(34,S["L_5'"])
	T[23] = min(1,Train:ReadTrainWire(29))
	Train:WriteTrainWire(31,S["31V"])
	Train.KSH1:TriggerInput("Set",S["1R"])
	T[14] = min(1,S["12A"])
	T[22] = min(1,S["8Zh"])
	Triggers["ReverserBackward"](S["4B"])
	T[20] = min(1,S["5V"])
	Train:WriteTrainWire(23,S["1-7R-29"])
	Train.R1_5:TriggerInput("Set",S["33V"])
	T[19] = min(1,Train:ReadTrainWire(22))
	Triggers["RRTpod"](S["10AH"])
	T[17] = min(1,Train:ReadTrainWire(28))
	T[16] = min(1,S["11B"])
	Train.KK:TriggerInput("Set",S["22V"])
	Train:WriteTrainWire(17,S["1-7R-8"])
	Train.KSB2:TriggerInput("Set",S["6Yu"])
	T[15] = min(1,S["10AV"])
	Train.Panel["GreenRP"] = S["U0a"]
	Train.RZ_2:TriggerInput("Set",S["24V"])
	T[12] = min(1,S["6A"])
	Train.Panel["CabinLight"] = S["10ALa"]
	Triggers["ReverserForward"](S["5B"])
	T[18] = min(1,S["22A"])
	Train:WriteTrainWire(27,S["s3"])
	Triggers["XT3.1"](S["B13"])
	Train.TR2:TriggerInput("Set",S["6A"])
	Triggers["SDPP"](S["10AG"])
	Train.VDOP:TriggerInput("Set",S["32A"])
	Train.VDOL:TriggerInput("Set",S["31A"])
	Train:WriteTrainWire(9,S["10/4a"])
	Triggers["KPP"](S["27A"])
	Triggers["RRTuderzh"](S["25A"])
	Train:WriteTrainWire(11,S["11A"])
	Train.RR:TriggerInput("Set",S["1N"])
	Train:WriteTrainWire(18,S["18A"])
	Train.VDZ:TriggerInput("Set",S["16V"])
	Train.Panel["SD"] = S["15B"]
	Train.KD:TriggerInput("Set",S["15B"])
	Train.LK2:TriggerInput("Set",S["20B"])
	Train.Rper:TriggerInput("Set",S["3A"])
	Train.LK5:TriggerInput("Set",S["20B"])
	Train.PneumaticNo1:TriggerInput("Set",S["8Zh"])
	Train:WriteTrainWire(14,S["1-7R-31"])
	Triggers["SDRK_Coil"](S["10B"])
	Train:WriteTrainWire(12,S["12"])
	Train.RUP:TriggerInput("Set",S["6Yu"])
	Train.TR1:TriggerInput("Set",S["6A"])
	Train.LK4:TriggerInput("Set",S["5B'"])
	Train:WriteTrainWire(2,S["2"])
	Train.Panel["RedLightRight"] = S["F2a"]
	Train.Panel["AVU"] = S["2-7R-24"]
	Train.Panel["KUP"] = S["B28"]
	Train.RV2:TriggerInput("Set",S["33Aa"])
	Train.KVC:TriggerInput("Set",S["B8"])
	Train:WriteTrainWire(24,S["24"])
	Triggers["XR3.6"](S["36Ya"])
	Train:WriteTrainWire(28,S["s10"])
	Train.RRP:TriggerInput("Set",Train:ReadTrainWire(14))
	Train:WriteTrainWire(20,S["20"])
	Train.Panel["RedRP"] = S["2-7R-21"]
	Train.LK1:TriggerInput("Set",S["1K"])
	Train:WriteTrainWire(10,S["10/4a"])
	Train.RD:TriggerInput("Set",S["D6/1"])
	Train:WriteTrainWire(22,S["22E'"])
	Train.Panel["TrainRP"] = S["2-7R-21"]
	Train.Panel["RedLightLeft"] = S["F1a"]
	Train:WriteTrainWire(33,S["L_1'"])
	Train:WriteTrainWire(29,S["29"])
	Train:WriteTrainWire(1,S["1"])
	Train:WriteTrainWire(4,S["4"])
	Train.KUP:TriggerInput("Set",S["B22"])
	return S
end


function TRAIN_SYSTEM.Solve81_714(Train,Triggers)
	local P		= Train.PositionSwitch.SelectedPosition
	local RK	= Train.RheostatController.SelectedPosition
	local B		= (Train.Battery.Voltage > 55) and 1 or 0
	local T		= Train.SolverTemporaryVariables
	if not T then
		T = {}
		for i=1,100 do T[i] = 0 end
		Train.SolverTemporaryVariables = T
	end
	
	-- Solve all circuits
	T["SDRK_ShortCircuit"] = -10*Train.RheostatController.RKP*(Train.RUT.Value+Train.RRT.Value+(1.0-Train.SR1.Value)+C(RK == 6)*C(P == 2)*(1.0-Train.Rper.Value)*Train.LK3.Value)
	Triggers["SDRK_Shunt"]( 1.0 - (0.20+0.20*C((RK >= 2) and (RK <= 7))*C(P == 1))*Train.LK2.Value )
	S["1T-1P"] = Train.NR.Value+Train.RPU.Value
	S["2Zh-2A"] = (1.0-Train.KSB1.Value)+(1.0-Train.TR1.Value)
	S["2Zh-2A"] = Train.ThyristorBU5_6.Value+S["2Zh-2A"]
	S["8A-8Ye"] = C(RK == 1)+(1.0-Train.LK4.Value)
	S["10AYa-10E"] = (1.0-Train.LK3.Value)+C((P == 1))
	S["10AP-10AD"] = Train.LK2.Value+C((P == 3) or (P == 4))
	S["10AE-10B"] = Train.TR1.Value+Train.RV1.Value
	S["10AE-10B"] = S["10AE-10B"]+Train.RV1.Value
	S["1A-1M"] = C((RK >= 1) and (RK <= 5))+C(RK == 6)*Train.RheostatController.RKM1
	S["2V-2G"] = C((RK >= 5) and (RK <= 18))+C((RK >= 2) and (RK <= 4))*Train.KSH1.Value
	S["2A-2G"] = C((P == 1) or (P == 3))*C((RK >= 1) and (RK <= 17))+C((P == 2) or (P == 4))*S["2V-2G"]
	S["1A-1R"] = (1.0-Train.RV1.Value)*C((P == 1))+C((P == 2))*S["1A-1M"]
	S["1E-1Yu"] = Train.KSH2.Value+Train.KSB2.Value*Train.KSB1.Value
	S["10AG-10AD"] = (1.0-Train.TR1.Value)*C((P == 2) or (P == 3) or (P == 4))*(1.0-Train.TR2.Value)+Train.TR1.Value*C((P == 1) or (P == 2) or (P == 4))*Train.TR2.Value
	S["1G-1Zh"] = Train.LK3.Value+C(RK == 1)*S["1E-1Yu"]*C((P == 1) or (P == 3))*Train.LK5.Value
	S["10N-10Zh"] = (1.0-Train.RRT.Value)*(1.0-Train.RUT.Value)*Train.SR1.Value+Train.RheostatController.RKM1
	S["10E-10AG"] = S["10AP-10AD"]*(1.0-Train.LK1.Value)*S["10AG-10AD"]+Train.LK3.Value*C(RK == 18)*C((P == 1))
	S["10"] = 1*Train:ReadTrainWire(10)
	S["18A"] = (1.0-Train.RPvozvrat.Value)*Train.LK4.Value*Train.A14.Value*1
	S["16V"] = Train.A16.Value*(1.0-Train.RD.Value)*Train:ReadTrainWire(16)
	S["22A"] = Train.A23.Value*1*Train:ReadTrainWire(23)+T[29]*Train.A22.Value
	S["B12"] = 1*Train.VB.Value*B
	S["4B"] = (1.0-Train.RKR.Value)*Train:ReadTrainWire(4)
	S["5B"] = Train.RKR.Value*Train:ReadTrainWire(5)
	S["5V"] = Train.RKR.Value*Train:ReadTrainWire(4)+T[31]*(1.0-Train.RKR.Value)
	S["5B'"] = S["5V"]*Train.LK3.Value
	S["6A"] = Train.A6.Value*Train:ReadTrainWire(6)
	S["3A"] = Train.A3.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*Train:ReadTrainWire(3)
	S["1A"] = Train.A1.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*Train:ReadTrainWire(1)
	S["8A"] = Train.A8.Value*Train:ReadTrainWire(8)
	S["8Zh"] = S["8A"]*C((RK >= 17) and (RK <= 18))+T[33]*1
	S["12A"] = Train.A12.Value*Train:ReadTrainWire(12)
	S["10AN"] = (1.0-Train.RPvozvrat.Value)*Train.A14.Value*1*1
	S["1P"] = S["1A"]*C((P == 1) or (P == 2))*S["1T-1P"]+T[24]*C((P == 3) or (P == 4))
	S["1R"] = S["1A"]*S["1A-1R"]
	S["17A"] = Train.A17.Value*Train:ReadTrainWire(17)
	S["8G"] = S["8A"]*S["8A-8Ye"]*(1.0-Train.RT2.Value)
	S["10/4"] = S["B12"]*Train.VB.Value*Train.A56.Value
	S["24V"] = (1.0-Train.LK4.Value)*Train:ReadTrainWire(24)
	S["25A"] = Train.A25.Value*Train:ReadTrainWire(25)
	S["27A"] = Train.A50.Value*Train:ReadTrainWire(27)
	S["1Zh"] = S["1P"]*Train.AVT.Value*(1.0-Train.RPvozvrat.Value)*S["1G-1Zh"]
	S["31A"] = Train.A31.Value*Train:ReadTrainWire(31)+T[25]*1
	S["32A"] = Train.A32.Value*Train:ReadTrainWire(32)+T[26]*1
	S["20B"] = Train.A20.Value*(1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*(1.0-Train.RPvozvrat.Value)*Train:ReadTrainWire(20)
	S["2Ye"] = (1-2*Train.RRP.Value)*((1-Train.RRP.Value) + Train.RRP.Value*Train.A39.Value)*S["2Zh-2A"]*Train.A2.Value*S["2A-2G"]*Train.LK4.Value*Train:ReadTrainWire(2)+T[27]*(1.0-Train.LK4.Value)
	S["B2"] = 1*Train.VB.Value*B
	S["10AE"] = S["B2"]*Train.A30.Value
	S["10I"] = S["10AE"]*Train.RheostatController.RKM2
	S["10AH"] = S["10I"]*(1.0-Train.LK1.Value)
	S["10H"] = S["10I"]*Train.LK4.Value
	S["B8"] = S["B2"]*Train.A53.Value
	S["B22"] = S["B8"]*Train.A75.Value
	S["B28"] = S["B8"]*Train.KUP.Value
	S["36Ya"] = S["B8"]*Train.KVC.Value
	S["10/4a"] = S["10/4"]*Train.VB.Value
	S["B13"] = S["B12"]*Train.A24.Value
	S["D"] = S["10/4"]*Train.A21.Value
	S["10AK"] = S["10/4"]*Train.A54.Value
	S["1/1p"] = S["10AK"]*Train.PMP["3-4"]
	S["20/1p"] = S["10AK"]*Train.PMP["9-10"]
	S["10AKl"] = S["10AK"]*Train.KRP.Value
	S["4/1p"] = S["10AKl"]*Train.PMP["5-6"]
	S["5/1p"] = S["10AKl"]*Train.PMP["7-8"]
	S["22V"] = S["22A"]*(1.0-Train.TRK.Value)
	S["22E'"] = S["10/4"]*Train.VMK.Value*Train.AK.Value
	S["U0"] = S["10/4"]*Train.A27.Value
	S["U0a"] = S["U0"]*1+(-10*S["10AN"])
	S["22K"] = S["10/4"]*Train.A10.Value
	S["6Yu"] = S["6A"]*C((P == 3) or (P == 4))*C((RK >= 1) and (RK <= 5))
	S["s3"] = S["U0"]*Train.BPSNon.Value
	S["1K"] = S["1Zh"]*C((P == 1) or (P == 2))
	S["1N"] = S["1Zh"]*C((P == 1) or (P == 3))
	S["10B"] = S["10AE"]*S["10AE-10B"]
	S["D4/3"] = S["10/4"]*Train.A13.Value*1
	S["17/1p"] = S["10AK"]*(1.0-Train.KRP.Value)*Train.VozvratRP.Value
	S["11A"] = S["B2"]*(1.0-Train.RD.Value)
	S["1-7R-29"] = S["U0"]*Train.A23.Value*Train.RezMK.Value
	S["10AYa"] = S["B2"]*Train.A80.Value
	S["10N"] = S["10AE"]*S["10N-10Zh"]*1+T["SDRK_ShortCircuit"]
	S["10AG"] = S["10AYa"]*S["10AYa-10E"]*S["10E-10AG"]
	S["ST/1+ST/2"] = S["D4/3"]*Train.BPT.Value
	S["16V/1+16V/2"] = S["D4/3"]*(1.0-Train.RD.Value)
	S["D6/1"] = S["D4/3"]*Train.BD.Value
	S["10AV"] = S["10AYa"]*(1.0-Train.LK3.Value)*C((RK >= 2) and (RK <= 18))

	-- Call all triggers
	Train.Panel["TrainBrakes"] = S["ST/1+ST/2"]
	Train.RV1:TriggerInput("Set",S["2Ye"])
	Train.SR1:TriggerInput("Set",S["2Ye"])
	Train:WriteTrainWire(18,S["18A"])
	Train.Panel["TrainDoors"] = S["16V/1+16V/2"]
	T[30] = min(1,S["5V"])
	T[24] = min(1,S["6A"])
	Train.Panel["EmergencyLight"] = S["B12"]
	Triggers["RPvozvrat"](S["17A"])
	Triggers["RRTpod"](S["10AH"])
	Train:WriteTrainWire(10,S["10/4a"])
	Train.VDZ:TriggerInput("Set",S["16V"])
	Train:WriteTrainWire(5,S["5/1p"])
	Triggers["XR3.2"](S["27A"])
	Triggers["XR3.4"](S["36Ya"])
	Triggers["RUTpod"](S["10H"])
	Train.RR:TriggerInput("Set",S["1N"])
	Train.LK3:TriggerInput("Set",S["1Zh"])
	Train.PneumaticNo2:TriggerInput("Set",S["8G"])
	Train.KSH2:TriggerInput("Set",S["1R"])
	Triggers["SDRK"](S["10N"])
	Train.KSB1:TriggerInput("Set",S["6Yu"])
	Train:WriteTrainWire(11,S["11A"])
	T[29] = min(1,Train:ReadTrainWire(22))
	Train.KSH1:TriggerInput("Set",S["1R"])
	T[33] = min(1,Train:ReadTrainWire(29))
	Triggers["ReverserBackward"](S["4B"])
	Train:WriteTrainWire(23,S["1-7R-29"])
	Train.KK:TriggerInput("Set",S["22V"])
	Triggers["SDPP"](S["10AG"])
	Train.KSB2:TriggerInput("Set",S["6Yu"])
	Train.Panel["GreenRP"] = S["U0a"]
	Train.RZ_2:TriggerInput("Set",S["24V"])
	Triggers["ReverserForward"](S["5B"])
	Train:WriteTrainWire(27,S["s3"])
	Triggers["XT3.1"](S["B13"])
	T[25] = min(1,S["12A"])
	Train:WriteTrainWire(9,S["10/4a"])
	Train.LK2:TriggerInput("Set",S["20B"])
	Train.TR2:TriggerInput("Set",S["6A"])
	Train.LK5:TriggerInput("Set",S["20B"])
	Triggers["SDRK_Coil"](S["10B"])
	T[32] = min(1,S["8Zh"])
	Train.RUP:TriggerInput("Set",S["6Yu"])
	T[31] = min(1,Train:ReadTrainWire(5))
	Train.LK4:TriggerInput("Set",S["5B'"])
	T[28] = min(1,S["22A"])
	T[27] = min(1,S["10AV"])
	T[26] = min(1,S["12A"])
	Train.Panel["KUP"] = S["B28"]
	Train:WriteTrainWire(17,S["17/1p"])
	Train.KVC:TriggerInput("Set",S["B8"])
	Train.TR1:TriggerInput("Set",S["6A"])
	Triggers["XR3.6"](S["36Ya"])
	Triggers["RRTuderzh"](S["25A"])
	Train.RRP:TriggerInput("Set",Train:ReadTrainWire(14))
	Train:WriteTrainWire(20,S["20/1p"])
	Train.LK1:TriggerInput("Set",S["1K"])
	Triggers["XR3.7"](S["36Ya"])
	Train.VDOP:TriggerInput("Set",S["32A"])
	Train.RD:TriggerInput("Set",S["D6/1"])
	Train:WriteTrainWire(22,S["22E'"])
	Train.VDOL:TriggerInput("Set",S["31A"])
	Triggers["KPP"](S["27A"])
	Train.Rper:TriggerInput("Set",S["3A"])
	Train.PneumaticNo1:TriggerInput("Set",S["8Zh"])
	Train:WriteTrainWire(1,S["1/1p"])
	Train:WriteTrainWire(4,S["4/1p"])
	Train.KUP:TriggerInput("Set",S["B22"])
	return S
end


