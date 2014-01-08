--------------------------------------------------------------------------------
-- Ящик с контакторами (ЯК-36)
--------------------------------------------------------------------------------
Metrostroi.DefineSystem("YAK_36")

function TRAIN_SYSTEM:Initialize()
	-- КВЦ (контактор высоковольтных цепей)
	self.Train:LoadSystem("KVC","Relay","KPP-110","750V")
	-- КК (контактор мотор-компрессора)
	self.Train:LoadSystem("KK","Relay","KPP-110")
	-- КУП (включение прогрева кабины машиниста)
	self.Train:LoadSystem("KUP","Relay","KPP-110")
	-- ТРК (защита мотор-компрессора от перегрузки)
	self.Train:LoadSystem("TPK","Relay","TRTP-115")
end

function TRAIN_SYSTEM:Inputs()
	return { }
end

function TRAIN_SYSTEM:Outputs()
	return { }
end

function TRAIN_SYSTEM:TriggerInput(name,value)	
	
end

function TRAIN_SYSTEM:Think()

end
