﻿include("shared.lua")


--------------------------------------------------------------------------------
ENT.ClientProps = {}
ENT.ButtonMap = {}


-- Main panel
ENT.ButtonMap["Main"] = {
	pos = Vector(445.5,-35.3,-1.0),
	ang = Angle(0,-97.5,20),
	width = 410,
	height = 145,
	scale = 0.0625,
	
	buttons = {		
		{ID = "DIPonSet",		x=22,  y=19, radius=20, tooltip="Включение ДИП и освещения\nTurn DIP and interior lights on"},
		{ID = "DIPoffSet",		x=66,  y=19, radius=20, tooltip="Выключение ДИП и освещения\nTurn DIP and interior lights off"},
		{ID = "VozvratRPSet",	x=192, y=78, radius=20, tooltip="Возврат реле перегрузки\nReset overload relay"},
		{ID = "VMKToggle",		x=22,  y=85, radius=20, tooltip="Включение мотор-компрессора\nTurn motor-compressor on"},
		
		{ID = "RezMKSet",		x=66,  y=80, radius=20, tooltip="Резервное включение мотор-компрессора\nEmergency motor-compressor startup"},
		{ID = "VAHToggle",		x=187, y=19, radius=20, tooltip="ВАХ: Включение аварийного хода (неисправность реле педали безопасности)\nVAH: Emergency driving mode (failure of RPB relay)"},
		{ID = "VADToggle",		x=226, y=19, radius=20, tooltip="ВАД: Включение аварийного закрытия дверей (неисправность реле контроля дверей)\nVAD: Emergency door close override (failure of KD relay)"},
		
		{ID = "ARSToggle",		x=187+77, y=19, radius=20, tooltip="Включение системы автоматического регулирования скорости"},
		{ID = "ALSToggle",		x=226+77, y=19, radius=20, tooltip="Включение системы автоматической локомотивной сигнализации\nAutomatic locomotive signalling (ALS)"},
		
		{ID = "OtklAVUToggle",	x=349, y=19, radius=20, tooltip="Отключение автоматического выключения управления (неисправность реле АВУ)\nTurn off automatic control disable relay (failure of AVU relay)"},
		{ID = "KRZDSet",		x=393, y=19, radius=20, tooltip="КРЗД: Кнопка резервного закрытия дверей\nKRZD: Emergency door closing"},
		{ID = "VUD1Toggle",		x=393, y=80, radius=20, tooltip="ВУД1: Выключатель управления дверьми\nVUD1: Door control toggle (close doors)"},
		
		{ID = "DoorSelectToggle",x=321, y=75, radius=20, tooltip="Выбор стороны открытия дверей\nSelect side on which doors will open"},
		{ID = "KDLSet",			x=291, y=122, radius=20, tooltip="КДЛ: Кнопка левых дверей\nKDL: Left doors open"},
		{ID = "KDPSet",			x=349, y=122, radius=20, tooltip="КДП: Кнопка правых дверей\nKDP: Right doors open"},
		
		{ID = "KVTSet",			x=240, y=122, radius=20, tooltip=""},
		{ID = "KSNSet",			x=240, y=78, radius=20,  tooltip="КСН: Кнопка сигнализации неисправности\nKSN: Failure indication button"},
		{ID = "KRPSet",			x=192, y=122, radius=20, tooltip="КРП: Кнопка резервного пуска"},
		
		{ID = "Program1Set",	x=112, y=127, radius=20, tooltip=""},
		{ID = "Program2Set",	x=149, y=127, radius=20, tooltip=""},
		
		{ID = "",				x=112, y=30, radius=20, tooltip=""},
		{ID = "",				x=149, y=30, radius=20, tooltip=""},
		{ID = "",				x=112, y=80, radius=20, tooltip=""},
		{ID = "",				x=149, y=80, radius=20, tooltip=""},
		
	}
}

-- Front panel
ENT.ButtonMap["Front"] = {
	pos = Vector(447.6,-35.3,5.0),
	ang = Angle(0,-97.4,74),
	width = 410,
	height = 95,
	scale = 0.0625,
	
	buttons = {
		{ID = "VUSToggle",x=400, y=75, radius=15, tooltip="ВУС: Выключатель усиленого света ходовых фар\nVUS: Head lights bright/dim"},
		--{ID = "CabinLightsToggle",		x=387, y=28, radius=15, tooltip=""},
		{x=25, y=30, w=57, h=40, tooltip="Напряжение цепей управления\nControl circuits voltage"},
	}
}

-- ARS/Speedometer panel
ENT.ButtonMap["ARS"] = {
	pos = Vector(449.1,-37.3,4.9),
	ang = Angle(0,-97.9,69),
	width = 410*10,
	height = 95*10,
	scale = 0.0625/10,

	buttons = {
		{x=2045,y=406,tooltip="Индикатор скорости\nSpeed indicator",radius=130},
		{x=2610,y=363,tooltip="РП: Красная лампа реле перегрузки\nRP: Red overload relay light (power circuits failed to assemble)",radius=120},
		{x=2982,y=363,tooltip="РП: Красная лампа реле перегрузки\nRP: Red overload relay light (power circuits failed to assemble)",radius=120},
		{x=1070+320*0,y=780,tooltip="ЛхРК: Лампа хода реостатного контроллера\nLhRK: Rheostat controller motion light",radius=120},
		{x=1070+320*1,y=780,tooltip="КТ: Контроль тормоза\nKT: ARS braking indicator",radius=120},
		{x=1070+320*2,y=780,tooltip="КВД: Контроль выключения двигателей\nKVD: ARS engine shutdown indicator",radius=120},
		{x=1070+320*3,y=780,tooltip="НР1: Нулевое реле\nNR1: Zero relay state (high voltage enabled)",radius=120},
		{x=1070+320*4,y=780,tooltip="ВПР: Контроль включения поездной радиосвязи\nVPR: Train radio equipment enabled",radius=120},
		{x=1070+320*5,y=780,tooltip="ПЕЧЬ: Индикатор работы печи\nPECH: Cabin heating indicator",radius=120},
		{x=1070+320*6,y=780,tooltip="АВУ: Автоматический выключатель управления\nAVU: Automatic control disabler active",radius=120},
		
		{x=1070+380*0,y=570,tooltip="ОЧ: Отсутствие частоты АРС\nOCh: No ARS frequency",radius=120},
		{x=1070+380*1,y=570,tooltip="0: Сигнал АРС остановки\n0: ARS stop signal",radius=120},
		{x=1070+380*2,y=570,tooltip="40: Ограничение скорости 40 км/ч\nSpeed limit 40 kph",radius=120},
		{x=1070+380*3,y=570,tooltip="60: Ограничение скорости 60 км/ч\nSpeed limit 60 kph",radius=120},
		{x=1070+380*4,y=570,tooltip="75: Ограничение скорости 75 км/ч\nSpeed limit 75 kph",radius=120},
		{x=1070+380*5,y=570,tooltip="80: Ограничение скорости 80 км/ч\nSpeed limit 80 kph",radius=120},
		
		{x=1080+380*0,y=363,tooltip="СД: Сигнализация дверей\nSD: Door state light (doors are closed/door circuits are OK)",radius=120},
		{x=1080+380*1,y=363,tooltip="РП: Зелёная лампа реле перегрузки\nRP: Green overload relay light (overload relay open on current train)",radius=120},
	}
}

-- AV panel
ENT.ButtonMap["AV"] = {
	pos = Vector(394.0,-53.5,44.5),
	ang = Angle(0,90,90),
	width = 520,
	height = 550,
	scale = 0.0625,
	
	buttons = {
		{ID = "A61Toggle", x=16+44*0,  y=110+129*0, radius=30, tooltip="A61 Управление 6ым поездным проводом\nTrain wire 6 control"},
		{ID = "A55Toggle", x=16+44*1,  y=110+129*0, radius=30, tooltip="A55 Управление проводом 10АС\nTrain wire 10AS control"},
		{ID = "A54Toggle", x=16+44*2,  y=110+129*0, radius=30, tooltip="A54 Управление проводом 10АК\nTrain wire 10AK control"},
		{ID = "A56Toggle", x=16+44*3,  y=110+129*0, radius=30, tooltip="A56"},
		{ID = "A27Toggle", x=16+44*4,  y=110+129*0, radius=30, tooltip="A27 Turn on DIP and lighting"},
		{ID = "A21Toggle", x=16+44*5,  y=110+129*0, radius=30, tooltip="A21 Door control"},
		{ID = "A10Toggle", x=16+44*6,  y=110+129*0, radius=30, tooltip="A10 Motor-compressor control"},
		{ID = "A53Toggle", x=16+44*7,  y=110+129*0, radius=30, tooltip="A53 KVC power supply"},
		{ID = "A43Toggle", x=16+44*8,  y=110+129*0, radius=30, tooltip="A43 ARS 12V power supply"},
		{ID = "A45Toggle", x=16+44*9,  y=110+129*0, radius=30, tooltip="A45 ARS train wire 10AU"},
		{ID = "A42Toggle", x=16+44*10, y=110+129*0, radius=30, tooltip="A42 ARS 75V power supply"},
		{ID = "A41Toggle", x=16+44*11, y=110+129*0, radius=30, tooltip="A41 ARS braking"},		
		------------------------------------------------------------------------
		{ID = "VUToggle",  x=16+44*0,  y=110+129*1, radius=30, tooltip="VU  Train control"},
		{ID = "A64Toggle", x=16+44*1,  y=110+129*1, radius=30, tooltip="A64 Cabin lighting"},
		{ID = "A63Toggle", x=16+44*2,  y=110+129*1, radius=30, tooltip="A63 IGLA/BIS"},
		{ID = "A50Toggle", x=16+44*3,  y=110+129*1, radius=30, tooltip="A50 Turn on DIP and lighting"},
		{ID = "A51Toggle", x=16+44*4,  y=110+129*1, radius=30, tooltip="A51 Turn off DIP and lighting"},
		{ID = "A23Toggle", x=16+44*5,  y=110+129*1, radius=30, tooltip="A23 Emergency motor-compressor turn on"},
		{ID = "A14Toggle", x=16+44*6,  y=110+129*1, radius=30, tooltip="A14 Train wire 18"},
		{ID = "A75Toggle", x=16+44*7,  y=110+129*1, radius=30, tooltip="A75 Cabin heating"},
		{ID = "A1Toggle",  x=16+44*8,  y=110+129*1, radius=30, tooltip="A1  XOD-1"},
		{ID = "A2Toggle",  x=16+44*9,  y=110+129*1, radius=30, tooltip="A2  XOD-2"},
		{ID = "A3Toggle",  x=16+44*10, y=110+129*1, radius=30, tooltip="A3  XOD-3"},
		{ID = "A17Toggle", x=16+44*11, y=110+129*1, radius=30, tooltip="A17 Reset overload relay"},
		------------------------------------------------------------------------
		{ID = "A62Toggle", x=16+44*0,  y=110+129*2, radius=30, tooltip="A62 Radio communications"},
		{ID = "A29Toggle", x=16+44*1,  y=110+129*2, radius=30, tooltip="A29 Radio broadcasting"},
		{ID = "A5Toggle",  x=16+44*2,  y=110+129*2, radius=30, tooltip="A5  "},
		{ID = "A6Toggle",  x=16+44*3,  y=110+129*2, radius=30, tooltip="A6  T-1"},
		{ID = "A8Toggle",  x=16+44*4,  y=110+129*2, radius=30, tooltip="A8  Pneumatic valves #1, #2"},
		{ID = "A20Toggle", x=16+44*5,  y=110+129*2, radius=30, tooltip="A20 Drive/brake circuit control, train wire 20"},
		{ID = "A25Toggle", x=16+44*6,  y=110+129*2, radius=30, tooltip="A25 Manual electric braking"},
		{ID = "A22Toggle", x=16+44*7,  y=110+129*2, radius=30, tooltip="A22 Turn on KK"},
		{ID = "A30Toggle", x=16+44*8,  y=110+129*2, radius=30, tooltip="A30 Rheostat controller motor power"},
		{ID = "A39Toggle", x=16+44*9,  y=110+129*2, radius=30, tooltip="A39 Emergency control"},
		{ID = "A44Toggle", x=16+44*10, y=110+129*2, radius=30, tooltip="A44 Emergency train control"},
		{ID = "A80Toggle", x=16+44*11, y=110+129*2, radius=30, tooltip="A80 Power circuit mode switch motor power"},
		------------------------------------------------------------------------
		{ID = "A65Toggle", x=16+44*0,  y=110+129*3, radius=30, tooltip="A65 Interior lighting"},
		--{ID = "A00Toggle", x=16+44*1,  y=110+129*3, radius=30, tooltip="A00"},
		{ID = "A24Toggle", x=16+44*2,  y=110+129*3, radius=30, tooltip="A24 Battery charging"},
		{ID = "A32Toggle", x=16+44*3,  y=110+129*3, radius=30, tooltip="A32 Open right doors"},
		{ID = "A31Toggle", x=16+44*4,  y=110+129*3, radius=30, tooltip="A31 Open left doors"},
		{ID = "A16Toggle", x=16+44*5,  y=110+129*3, radius=30, tooltip="A16 Close doors"},
		{ID = "A13Toggle", x=16+44*6,  y=110+129*3, radius=30, tooltip="A13 Door alarm"},
		{ID = "A12Toggle", x=16+44*7,  y=110+129*3, radius=30, tooltip="A12 Emergency door close"},
		{ID = "A7Toggle",  x=16+44*8,  y=110+129*3, radius=30, tooltip="A7  Red lamp"},
		{ID = "A9Toggle",  x=16+44*9,  y=110+129*3, radius=30, tooltip="A9  Red lamp"},
		{ID = "A46Toggle", x=16+44*10, y=110+129*3, radius=30, tooltip="A46 White lamp"},
		{ID = "A47Toggle", x=16+44*11, y=110+129*3, radius=30, tooltip="A47 White lamp"},
	}
}

-- Battery panel
ENT.ButtonMap["Battery"] = {
	pos = Vector(394.5,24.0-5,28.0+5),
	ang = Angle(0,90,90),
	width = 210+10/0.0625,
	height = 90+10/0.0625,
	scale = 0.0625,
	
	buttons = {
		{ID = "VBToggle", x=0, y=0, w=210+10/0.0625, h=90+10/0.0625, tooltip="ВБ: Выключатель батареи\nVB: Battery on/off"},
	}
}

-- Train driver helpers panel
ENT.ButtonMap["HelperPanel"] = {
	pos = Vector(444.7,62,30.4),
	ang = Angle(0,-50,90),
	width = 64,
	height = 144,
	scale = 0.0625,
	
	buttons = {
		{ID = "VUD2Toggle", x=32, y=42, radius=32, tooltip="ВУД2: Выключатель управления дверьми\nVUD2: Door control toggle (close doors)"},
		{ID = "VDLSet",     x=32, y=108, radius=32, tooltip="ВДЛ: Выключатель левых дверей\nVDL: Left doors open"},
	}
}

-- Help panel
ENT.ButtonMap["Help"] = {
	pos = Vector(445.0,-36.0,30.0),
	ang = Angle(40+180,0,0),
	width = 20,
	height = 20,
	scale = 1,
	
	buttons = {
		{ID = "ShowHelp", x=10, y=10, radius=15, tooltip="Show help on driving the train"}, -- NEEDS TRANSLATING
	}
}

-- Pneumatic instrument panel
ENT.ButtonMap["PneumaticPanels"] = {
	pos = Vector(448,-30,16.0),
	ang = Angle(0,-77,90),
	width = 140,
	height = 160,
	scale = 0.0625,
	
	buttons = {
		{x=60,y=45,radius=30,tooltip="Давление в тормозных цилиндрах (ТЦ)\nBrake cylinder pressure"},
		{x=80,y=105,radius=30,tooltip="Давление в магистралях (красная: тормозной, чёрная: напорной)\nPressure in pneumatic lines (red: brake line, black: train line)"},
	}
}
ENT.ButtonMap["DriverValveDisconnect"] = {
	pos = Vector(420,-57.0,-25),
	ang = Angle(0,0,0),
	width = 200,
	height = 90,
	scale = 0.0625,
	
	buttons = {
		{ID = "DriverValveDisconnectToggle", x=0, y=0, w=200, h=90, tooltip="Клапан разобщения\nDriver valve disconnect valve"},
	}
}
ENT.ButtonMap["DURA"] = {
	pos = Vector(412.5,-58.0,-2.6),
	ang = Angle(0,0,0),
	width = 240,
	height = 80,
	scale = 0.0625,
	
	buttons = {
		{ID = "DURASelectMain", x=95, y=43, radius=20, tooltip="DURA Select Main"}, -- NEEDS TRANSLATING
		{ID = "DURASelectAlternate", x=60, y=43, radius=20, tooltip="DURA Select Alternate"}, -- NEEDS TRANSLATING
		{ID = "DURAToggleChannel", x=140, y=30, radius=20, tooltip="DURA Toggle Channel"}, -- NEEDS TRANSLATING
	}
}

ENT.ButtonMap["Meters"] = {
	pos = Vector(449.3,-53,27.5),
	ang = Angle(0,-125,90),
	width = 170,
	height = 110,
	scale = 0.0625,
	
	buttons = {
		{x=22, y=24, w=55, h=45, tooltip="Highvoltage Meter (kV)"}, -- NEEDS TRANSLATING
		{x=90, y=24, w=58, h=45, tooltip="Total Amperemeter (A)"}, -- NEEDS TRANSLATING
	}
}


--These values should be identical to those drawing the schedule
local col1w = 80 -- 1st Column width
local col2w = 32 -- The other column widths
local rowtall = 30 -- Row height, includes -only- the usable space and not any lines

local rowamount = 16 -- How many rows to show (total)
ENT.ButtonMap["Schedule"] = {
	pos = Vector(442.1,-60.7,26),
	ang = Angle(0,-110,90),
	width = (col1w + 2 + (1 + col2w) * 3),
	height = (rowtall+1)*rowamount+1,
	scale = 0.0625/2,
	
	buttons = {
		{x=1, y=1, w=col1w, h=rowtall, tooltip="М №\nRoute number"},
		{x=1, y=rowtall*2+3, w=col1w, h=rowtall, tooltip="П №\nPath number"},
		
		{x=col1w+2, y=1, w=col2w*3+2, h=rowtall, tooltip="ВРЕМЯ ХОДА\nTotal schedule time"},
		{x=col1w+2, y=rowtall+2, w=col2w*3+2, h=rowtall, tooltip="ИНТ\nTrain interval"},
		
		{x=col1w+2, y=rowtall*2+3, w=col2w, h=rowtall, tooltip="ЧАС\nHour"},
		{x=col1w+col2w+3, y=rowtall*2+3, w=col2w, h=rowtall, tooltip="МИН\nMinute"},
		{x=col1w+col2w*2+4, y=rowtall*2+3, w=col2w, h=rowtall, tooltip="СЕК\nSecond"},
		{x=col1w+2, y=rowtall*3+4, w=col2w*3+2, h=(rowtall+1)*(rowamount-3)-1, tooltip="Arrival times"}, -- NEEDS TRANSLATING
		
		{x=1, y=rowtall*3+4, w=col1w, h=(rowtall+1)*(rowamount-3)-1, tooltip="Station name"}, -- NEEDS TRANSLATING
	}
}

-- Temporary panels (possibly temporary)
ENT.ButtonMap["FrontPneumatic"] = {
	pos = Vector(459.0,-45.0,-50.0),
	ang = Angle(0,90,90),
	width = 900,
	height = 100,
	scale = 0.1,
}
ENT.ButtonMap["RearPneumatic"] = {
	pos = Vector(-481.0,45.0,-50.0),
	ang = Angle(0,270,90),
	width = 900,
	height = 100,
	scale = 0.1,
}




--------------------------------------------------------------------------------
ENT.ClientPropsInitialized = false
ENT.ClientProps["brake"] = {
	model = "models/metrostroi/81-717/brake.mdl",
	pos = Vector(431,-59.5,2.7),
	ang = Angle(0,180,0)
}
ENT.ClientProps["controller"] = {
	model = "models/metrostroi/81-717/controller.mdl",
	pos = Vector(446,-25,2.0),
	ang = Angle(0,-45,90)
}
ENT.ClientProps["reverser"] = {
	model = "models/metrostroi/81-717/reverser.mdl",
	pos = Vector(446,-25,1.2),
	ang = Angle(0,45,90)
}
ENT.ClientProps["brake_disconnect"] = {
	model = "models/metrostroi/81-717/uava.mdl",
	pos = Vector(429.5,-61.0,-25),
	ang = Angle(-30,0,0)
}
--------------------------------------------------------------------------------
ENT.ClientProps["train_line"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(449.20,-35.00,9.45),
	ang = Angle(90,0,180-14)
}
ENT.ClientProps["brake_line"] = {
	model = "models/metrostroi/81-717/red_arrow.mdl",
	pos = Vector(449.15,-35.05,9.45),
	ang = Angle(90,0,180-14)
}
ENT.ClientProps["brake_cylinder"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(450.5,-32.9,13.4),
	ang = Angle(90,0,180-18)
}
--------------------------------------------------------------------------------
ENT.ClientProps["ampermeter"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(445.5,-59.5,23.3),
	ang = Angle(90,0,-45+180+80)
}
ENT.ClientProps["voltmeter"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(448.1,-55.7,23.3),
	ang = Angle(90,0,-45+180+80)
}
ENT.ClientProps["volt1"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(447.10,-38.15,0.4),
	ang = Angle(90-18,180,7)
}
ENT.ClientProps["volt2"] = {
	model = "models/metrostroi/81-717/black_arrow.mdl",
	pos = Vector(452.3,-19.4,18.2),
	ang = Angle(90,0,180)
}




--------------------------------------------------------------------------------
ENT.ClientProps["headlights"] = {
	model = "models/metrostroi/81-717/switch04.mdl",
	pos = Vector(443.1,-60.0,0.5),
	ang = Angle(-90,0,0)
}
ENT.ClientProps["panellights"] = {
	model = "models/metrostroi/81-717/switch04.mdl",
	pos = Vector(444.1,-59.3,3.3),
	ang = Angle(-90,0,0)
}
ENT.ClientProps["dura"] = {
	model = "models/metrostroi/81-717/dura.mdl",
	pos = Vector(420.0,-58.3,-5.0),
	ang = Angle(0,0,90)
}
--------------------------------------------------------------------------------
Metrostroi.ClientPropForButton("DIPon",{
	panel = "Main",
	button = "DIPonSet",	
	model = "models/metrostroi/81-717/button07.mdl",
})
Metrostroi.ClientPropForButton("DIPoff",{
	panel = "Main",
	button = "DIPoffSet",	
	model = "models/metrostroi/81-717/button10.mdl",
})
Metrostroi.ClientPropForButton("VozvratRP",{
	panel = "Main",
	button = "VozvratRPSet",	
	model = "models/metrostroi/81-717/button07.mdl",
})
Metrostroi.ClientPropForButton("VMK",{
	panel = "Main",
	button = "VMKToggle",	
	model = "models/metrostroi/81-717/switch01.mdl",
	z = -9.8,
})
Metrostroi.ClientPropForButton("RezMK",{
	panel = "Main",
	button = "RezMKSet",	
	model = "models/metrostroi/81-717/button07.mdl",
})
Metrostroi.ClientPropForButton("VAH",{
	panel = "Main",
	button = "VAHToggle",	
	model = "models/metrostroi/81-717/switch04.mdl",
})
Metrostroi.ClientPropForButton("VAD",{
	panel = "Main",
	button = "VADToggle",	
	model = "models/metrostroi/81-717/switch04.mdl",
})
Metrostroi.ClientPropForButton("ALS",{
	panel = "Main",
	button = "ALSToggle",	
	model = "models/metrostroi/81-717/switch04.mdl",
})
Metrostroi.ClientPropForButton("ARS",{
	panel = "Main",
	button = "ARSToggle",	
	model = "models/metrostroi/81-717/switch04.mdl",
})
Metrostroi.ClientPropForButton("OtklAVU",{
	panel = "Main",
	button = "OtklAVUToggle",	
	model = "models/metrostroi/81-717/switch04.mdl",
})
Metrostroi.ClientPropForButton("KRZD",{
	panel = "Main",
	button = "KRZDSet",	
	model = "models/metrostroi/81-717/button07.mdl",
})
Metrostroi.ClientPropForButton("VUD1",{
	panel = "Main",
	button = "VUD1Toggle",	
	model = "models/metrostroi/81-717/switch01.mdl",
	z = -9.8,
})
Metrostroi.ClientPropForButton("DoorSelect",{
	panel = "Main",
	button = "DoorSelectToggle",	
	model = "models/metrostroi/81-717/switch04.mdl",
	ang = 0
})
Metrostroi.ClientPropForButton("KDL",{
	panel = "Main",
	button = "KDLSet",	
	model = "models/metrostroi/81-717/button08.mdl",
})
Metrostroi.ClientPropForButton("KDP",{
	panel = "Main",
	button = "KDPSet",	
	model = "models/metrostroi/81-717/button08.mdl",
})
Metrostroi.ClientPropForButton("KVT",{
	panel = "Main",
	button = "KVTSet",	
	model = "models/metrostroi/81-717/button07.mdl",
})
Metrostroi.ClientPropForButton("KSN",{
	panel = "Main",
	button = "KSNSet",	
	model = "models/metrostroi/81-717/button10.mdl",
})
Metrostroi.ClientPropForButton("KRP",{
	panel = "Main",
	button = "KRPSet",	
	model = "models/metrostroi/81-717/button07.mdl",
})
Metrostroi.ClientPropForButton("Program1",{
	panel = "Main",
	button = "Program1Set",	
	model = "models/metrostroi/81-717/button08.mdl",
})
Metrostroi.ClientPropForButton("Program2",{
	panel = "Main",
	button = "Program2Set",	
	model = "models/metrostroi/81-717/button08.mdl",
})

Metrostroi.ClientPropForButton("SelectMain",{
	panel = "DURA",
	button = "DURASelectMain",	
	model = "models/metrostroi/81-717/button07.mdl",
})
Metrostroi.ClientPropForButton("SelectAlternate",{
	panel = "DURA",
	button = "DURASelectAlternate",	
	model = "models/metrostroi/81-717/button07.mdl",
})
Metrostroi.ClientPropForButton("SelectChannel",{
	panel = "DURA",
	button = "DURAToggleChannel",	
	model = "models/metrostroi/81-717/switch04.mdl",
})

Metrostroi.ClientPropForButton("VUD2",{
	panel = "HelperPanel",
	button = "VUD2Toggle",	
	model = "models/metrostroi/81-717/switch01.mdl",
})
Metrostroi.ClientPropForButton("VDL",{
	panel = "HelperPanel",
	button = "VDLSet",	
	model = "models/metrostroi/81-717/switch01.mdl",
})



--------------------------------------------------------------------------------
ENT.ClientProps["gv"] = {
	model = "models/metrostroi/81-717/gv.mdl",
	pos = Vector(154,62.5,-65),
	ang = Angle(180,0,-90)
}
ENT.ClientProps["gv_wrench"] = {
	model = "models/metrostroi/81-717/reverser.mdl",
	pos = Vector(154,62.5,-65),
	ang = Angle(-50,0,0)
}
--------------------------------------------------------------------------------
for x=0,11 do
	for y=0,3 do
		ENT.ClientProps["a"..(x+12*y)] = {
			model = "models/metrostroi/81-717/circuit_breaker.mdl",
			pos = Vector(393.8,-52.5+x*2.75,37.5-y*8),
			ang = Angle(90,0,0)
		}
	end
end
ENT.ClientProps["bat1"] = {
	model = "models/metrostroi/81-717/switch01.mdl",
	pos = Vector(393.6,26.0+4.6*0,24.9),
	ang = Angle(90,0,0)
}
ENT.ClientProps["bat2"] = {
	model = "models/metrostroi/81-717/switch01.mdl",
	pos = Vector(393.6,26.0+4.6*1,24.9),
	ang = Angle(90,0,0)
}
ENT.ClientProps["bat3"] = {
	model = "models/metrostroi/81-717/switch01.mdl",
	pos = Vector(393.6,26.0+4.6*2,24.9),
	ang = Angle(90,0,0)
}
--------------------------------------------------------------------------------
ENT.ClientProps["book"] = {
	model = "models/props_lab/binderredlabel.mdl",
	pos = Vector(449.0,-40.0,45.0),
	ang = Angle(-135,0,85)
}




--------------------------------------------------------------------------------
-- Add doors
local function GetDoorPosition(i,k,j)
	if j == 0 
	then return Vector(353.0 - 35*k     - 231*i,-65*(1-2*k),-1.8)
	else return Vector(353.0 - 35*(1-k) - 231*i,-65*(1-2*k),-1.8)
	end
end
for i=0,3 do
	for k=0,1 do
		ENT.ClientProps["door"..i.."x"..k.."a"] = {
			model = "models/metrostroi/e/em508_door1.mdl",
			pos = GetDoorPosition(i,k,0),
			ang = Angle(0,180*k,0)
		}
		ENT.ClientProps["door"..i.."x"..k.."b"] = {
			model = "models/metrostroi/e/em508_door2.mdl",
			pos = GetDoorPosition(i,k,1),
			ang = Angle(0,180*k,0)
		}
	end
end
table.insert(ENT.ClientProps,{
	model = "models/metrostroi/e/em508_door5.mdl",
	pos = Vector(456.5,0.4,-3.8),
	ang = Angle(0,0,0)
})
table.insert(ENT.ClientProps,{
	model = "models/metrostroi/e/em508_door5.mdl",
	pos = Vector(-479.5,-0.5,-3.8),
	ang = Angle(0,180,0)
})
table.insert(ENT.ClientProps,{
	model = "models/metrostroi/e/em508_door4.mdl",
	pos = Vector(386.5,0.4,5.2),
	ang = Angle(0,0,0)
})
table.insert(ENT.ClientProps,{
	model = "models/metrostroi/e/em508_door3.mdl",
	pos = Vector(425.6,65.2,-2.2),
	ang = Angle(0,0,0)
})




--------------------------------------------------------------------------------
function ENT:Think()
	self.BaseClass.Think(self)

	-- Simulate pressure gauges getting stuck a little
	self:Animate("brake", 			self:GetPackedRatio(0)^0.5, 		0.00, 0.65,  256,24)
	self:Animate("controller",		self:GetPackedRatio(1),				0.30, 0.70,  384,24)
	self:Animate("reverser",		self:GetPackedRatio(2),				0.20, 0.55,  4,false)
	self:Animate("volt1", 			self:GetPackedRatio(10),			0.38,0.64)
	self:ShowHide("reverser",		self:GetPackedBool(0))

	self:Animate("brake_line",		self:GetPackedRatio(4),				0.16, 0.84,  256,2,0.01)
	self:Animate("train_line",		self:GetPackedRatio(5),				0.16, 0.84,  256,2,0.01)
	self:Animate("brake_cylinder",	self:GetPackedRatio(6),	 			0.17, 0.86,  256,2,0.03)
	self:Animate("voltmeter",		self:GetPackedRatio(7),				0.38, 0.63)
	self:Animate("ampermeter",		self:GetPackedRatio(8),				0.38, 0.63)
	self:Animate("volt2",			0, 									0.38, 0.63)
	
	self:Animate("headlights",		self:GetPackedBool(1) and 1 or 0, 	0,1, 8, false)
	self:Animate("VozvratRP",		self:GetPackedBool(2) and 1 or 0, 	0,1, 16, false)
	self:Animate("DIPon",			self:GetPackedBool(3) and 1 or 0, 	0,1, 16, false)
	self:Animate("DIPoff",			self:GetPackedBool(4) and 1 or 0, 	0,1, 16, false)	
	self:Animate("brake_disconnect",self:GetPackedBool(6) and 1 or 0, 	0,0.7, 3, false)
	self:Animate("bat1",			self:GetPackedBool(7) and 1 or 0, 	0,1, 16, false)
	self:Animate("bat2",			self:GetPackedBool(7) and 1 or 0, 	0,1, 16, false)
	self:Animate("bat3",			self:GetPackedBool(7) and 1 or 0, 	0,1, 16, false)
	self:Animate("RezMK",			self:GetPackedBool(8) and 1 or 0, 	0,1, 16, false)
	self:Animate("VMK",				self:GetPackedBool(9) and 1 or 0, 	0,1, 16, false)
	self:Animate("VAH",				self:GetPackedBool(10) and 1 or 0, 	0,1, 16, false)
	self:Animate("VAD",				self:GetPackedBool(11) and 1 or 0, 	0,1, 16, false)
	self:Animate("VUD1",			self:GetPackedBool(12) and 1 or 0, 	0,1, 16, false)
	self:Animate("VUD2",			self:GetPackedBool(13) and 1 or 0, 	0,1, 16, false)
	self:Animate("VDL",				self:GetPackedBool(14) and 1 or 0, 	0,1, 16, false)
	self:Animate("KDL",				self:GetPackedBool(15) and 1 or 0, 	0,1, 16, false)
	self:Animate("KDP",				self:GetPackedBool(16) and 1 or 0, 	0,1, 16, false)
	self:Animate("KRZD",			self:GetPackedBool(17) and 1 or 0, 	0,1, 16, false)
	self:Animate("KSN",				self:GetPackedBool(18) and 1 or 0, 	0,1, 16, false)
	self:Animate("OtklAVU",			self:GetPackedBool(19) and 1 or 0, 	0,1, 16, false)
	self:Animate("SelectMain",		self:GetPackedBool(29) and 1 or 0, 	0,1, 16, false)
	self:Animate("SelectAlternate",	self:GetPackedBool(30) and 1 or 0, 	0,1, 16, false)
	self:Animate("SelectChannel",	self:GetPackedBool(31) and 1 or 0, 	0,1, 16, false)
	self:Animate("ARS",				self:GetPackedBool(56) and 1 or 0, 	0,1, 16, false)
	self:Animate("ALS",				self:GetPackedBool(57) and 1 or 0, 	0,1, 16, false)
	
	-- Animate AV switches
	for i,v in ipairs(self.Panel.AVMap) do
		local value = self:GetPackedBool(64+(i-1)) and 1 or 0
		self:Animate("a"..(i-1),value,0,1,8,false)
	end	
	
	-- Main switch
	if self.LastValue ~= self:GetPackedBool(5) then
		self.ResetTime = CurTime()+2.0
		self.LastValue = self:GetPackedBool(5)
	end	
	self:Animate("gv_wrench",	1-(self:GetPackedBool(5) and 1 or 0), 	0,0.35, 32,  4,false)
	self:ShowHide("gv_wrench",	CurTime() < self.ResetTime)
	
	-- Animate doors
	for i=0,3 do
		for k=0,1 do
			local n_l = "door"..i.."x"..k.."a"
			local n_r = "door"..i.."x"..k.."b"
			local animation = self:Animate(n_l,self:GetPackedBool(21+i+4-k*4) and 1 or 0,0,1, 0.8 + (-0.2+0.4*math.random()),0)
			local offset_l = Vector(math.abs(31*animation),0,0)
			local offset_r = Vector(math.abs(32*animation),0,0)
			if self.ClientEnts[n_l] then
				self.ClientEnts[n_l]:SetPos(self:LocalToWorld(self.ClientProps[n_l].pos + (1.0 - 2.0*k)*offset_l))
			end
			if self.ClientEnts[n_r] then
				self.ClientEnts[n_r]:SetPos(self:LocalToWorld(self.ClientProps[n_r].pos - (1.0 - 2.0*k)*offset_r))
			end
		end
	end

	
	-- Brake-related sounds
	local brakeLinedPdT = self:GetPackedRatio(9)
	if (brakeLinedPdT > -0.001)
	then self:SetSoundState("release2",0,0)
	else self:SetSoundState("release2",-0.3*brakeLinedPdT,1.0)
	end
	if (brakeLinedPdT < 0.001)
	then self:SetSoundState("release3",0,0)
	else self:SetSoundState("release3",0.02*brakeLinedPdT,1.0)
	end

	-- Compressor
	local state = self:GetPackedBool(20)
	self.PreviousCompressorState = self.PreviousCompressorState or false
	if self.PreviousCompressorState ~= state then
		self.PreviousCompressorState = state
		if state then
			self:SetSoundState("compressor",1,1)
		else
			self:SetSoundState("compressor",0,0)
			self:PlayOnce("compressor_end",nil,0.75)		
		end
	end
	
	-- ARS/ringer alert
	local state = self:GetPackedBool(39)
	self.PreviousAlertState = self.PreviousAlertState or false
	if self.PreviousAlertState ~= state then
		self.PreviousAlertState = state
		if state then
			self:SetSoundState("ring",0.20,1)
		else
			self:SetSoundState("ring",0,0)
			self:PlayOnce("ring_end","cabin",0.45)		
		end
	end
	
	-- DIP sound
	--self:SetSoundState("bpsn2",self:GetPackedBool(32) and 1 or 0,1.0)
end

surface.CreateFont("MetrostroiSubway_LargeText", {
  font = "Arial",
  size = 100,
  weight = 500,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
})
surface.CreateFont("MetrostroiSubway_SmallText", {
  font = "Arial",
  size = 70,
  weight = 1000,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false
})


function ENT:Draw()
	self.BaseClass.Draw(self)
	
	self:DrawOnPanel("ARS",function()
		if not self:GetPackedBool(32) then return end
	
		local speed = self:GetPackedRatio(3)*100.0
		local d1 = math.floor(speed) % 10
		local d2 = math.floor(speed / 10) % 10
		self:DrawDigit((196+0) *10,	35*10, d2, 0.75, 0.55)
		self:DrawDigit((196+10)*10,	35*10, d1, 0.75, 0.55)
		
		local b = self:Animate("light_rRP",self:GetPackedBool(35) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(253*10,33*10,16*10,8*10)
			draw.DrawText("РП","MetrostroiSubway_LargeText",253*10+30,33*10-19,Color(0,0,0,255))
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(290*10,33*10,16*10,8*10)
			draw.DrawText("РП","MetrostroiSubway_LargeText",290*10+30,33*10-19,Color(0,0,0,255))
		end
		
		b = self:Animate("light_gRP",self:GetPackedBool(36) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(140*10,33*10,16*10,8*10)
			draw.DrawText("РП","MetrostroiSubway_LargeText",140*10+30,33*10-19,Color(0,0,0,255))
		end
		
		--[[if self:GetNWBool("LKT") then
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(133*10,73*10,16*10,8*10)
			draw.DrawText("КТ","MetrostroiSubway_LargeText",133*10+30,73*10-20,Color(0,0,0,255))
		end			
		if self:GetNWBool("KVD") then
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(165*10,73*10,16*10,8*10)
			draw.DrawText("КВД","MetrostroiSubway_LargeText",165*10,73*10-20,Color(0,0,0,255))
		end]]--	
		
		b = self:Animate("light_LhRK",self:GetPackedBool(33) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(101*10,73*10,16*10,8*10)
		end
		
		b = self:Animate("light_NR1",self:GetPackedBool(34) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(196*10,73*10,16*10,8*10)
			draw.DrawText("НР1","MetrostroiSubway_LargeText",196*10,73*10-20,Color(0,0,0,255))
		end
		
		b = self:Animate("light_PECH",self:GetPackedBool(37) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(260*10,73*10,16*10,8*10)
			draw.DrawText("ПЕЧЬ","MetrostroiSubway_SmallText",260*10,73*10-5,Color(0,0,0,255))
		end
		
		b = self:Animate("light_AVU",self:GetPackedBool(38) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(295*10,73*10,16*10,8*10)
			draw.DrawText("АВУ","MetrostroiSubway_LargeText",295*10,73*10-20,Color(0,0,0,255))
		end
		
		b = self:Animate("light_SD",self:GetPackedBool(40) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(102*10,33*10,16*10,8*10)
			draw.DrawText("СД","MetrostroiSubway_LargeText",102*10+30,33*10-20,Color(0,0,0,255))
		end
	
		------------------------------------------------------------------------
		b = self:Animate("light_OCh",self:GetPackedBool(41) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(102*10,53*10,16*10,8*10)
			draw.DrawText("ОЧ","MetrostroiSubway_LargeText",102*10+30,53*10-15,Color(0,0,0,255))
		end
		
		b = self:Animate("light_0",self:GetPackedBool(42) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(140*10,53*10,16*10,8*10)
			draw.DrawText("0","MetrostroiSubway_LargeText",140*10+55,53*10-10,Color(0,0,0,255))
		end
		
		b = self:Animate("light_40",self:GetPackedBool(43) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(255,50,0)
			surface.DrawRect(176*10,53*10,16*10,8*10)
			draw.DrawText("40","MetrostroiSubway_LargeText",176*10+30,53*10-10,Color(0,0,0,255))
		end
			
		b = self:Animate("light_60",self:GetPackedBool(44) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(217*10,53*10,16*10,8*10)
			draw.DrawText("60","MetrostroiSubway_LargeText",217*10+30,53*10-10,Color(0,0,0,255))
		end
			
		b = self:Animate("light_75",self:GetPackedBool(45) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(255*10,53*10,16*10,8*10)
			draw.DrawText("75","MetrostroiSubway_LargeText",255*10+30,53*10-10,Color(0,0,0,255))
		end
			
		b = self:Animate("light_80",self:GetPackedBool(46) and 1 or 0,0,1,5,false)
		if b > 0.0 then
			surface.SetAlphaMultiplier(b)
			surface.SetDrawColor(50,255,50)
			surface.DrawRect(294*10,53*10,16*10,8*10)
			draw.DrawText("80","MetrostroiSubway_LargeText",294*10+30,53*10-10,Color(0,0,0,255))
		end
		
		surface.SetAlphaMultiplier(1.0)
	end)
	
	self:DrawOnPanel("FrontPneumatic",function()
		draw.DrawText(self:GetNWBool("FI") and "Isolated" or "Open","Trebuchet24",150,30,Color(0,0,0,255))
	end)
	self:DrawOnPanel("RearPneumatic",function()
		draw.DrawText(self:GetNWBool("RI") and "Isolated" or "Open","Trebuchet24",150,30,Color(0,0,0,255))
	end)
	--self:DrawOnPanel("DURA",function()
		--surface.SetDrawColor(50,255,50)
		--surface.DrawRect(0,0,240,80)
	--end)
end

function ENT:OnButtonPressed(button)
	if button == "ShowHelp" then
		RunConsoleCommand("metrostroi_train_manual")
	end
end