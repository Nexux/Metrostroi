


--------------------------------------------------------------------------------
-- Lists of picket signs
--------------------------------------------------------------------------------
if not Metrostroi.PicketSigns then
	Metrostroi.PicketSignByIndex = {}
	Metrostroi.PicketSigns = {}
	Metrostroi.TrafficLights = {}
	Metrostroi.PositionCallbacks = {}
end



--------------------------------------------------------------------------------
-- Add picket sign
--------------------------------------------------------------------------------
function Metrostroi.AddPicketSign(sign,index)
	if not Metrostroi.PicketSigns[sign] then
		Metrostroi.PicketSigns[sign] = sign
		
		-- Add to table of signs
		if index then
			Metrostroi.PicketSignByIndex[index] = sign
		else
			index = #Metrostroi.PicketSignByIndex + 1
			table.insert(Metrostroi.PicketSignByIndex,sign)
		end
		
		-- Set pickets index
		sign:SetPicketIndex(index)

		Metrostroi.UpdateSections()
	end
end




--------------------------------------------------------------------------------
-- Remove picket sign
--------------------------------------------------------------------------------
function Metrostroi.RemovePicketSign(sign)
	if Metrostroi.PicketSigns[sign] then
		Metrostroi.PicketSigns[sign] = nil

		-- Remove from table of signs
		for k, v in pairs(Metrostroi.PicketSignByIndex) do
			if v == sign then
				Metrostroi.PicketSignByIndex[k] = nil
			end
		end
		
		-- Set pickets index
		for k, v in pairs(Metrostroi.PicketSigns) do
			if v.NextPicket == sign then
				v:SetNextPicket(nil)
			end
			if v.PreviousPicket == sign then
				v:SetPreviousPicket(nil)
			end
			if v.AlternatePicket == sign then
				v:SetAlternatePicket(nil)
			end
		end
		
		Metrostroi.UpdateSections()
	end
end


--------------------------------------------------------------------------------
-- Add traffic light
--------------------------------------------------------------------------------
function Metrostroi.AddTrafficLight(ent)
	if not Metrostroi.TrafficLights[ent] then
		Metrostroi.TrafficLights[ent] = ent
		Metrostroi.UpdateTrafficLightPositions()
	end
end


--------------------------------------------------------------------------------
-- Remove traffic light
--------------------------------------------------------------------------------
function Metrostroi.RemoveTrafficLight(ent)
	if Metrostroi.TrafficLights[ent] then
		Metrostroi.TrafficLights[ent] = nil
		Metrostroi.UpdateTrafficLightPositions()
	end
end




--------------------------------------------------------------------------------
-- Update section information for every sign
--------------------------------------------------------------------------------
function Metrostroi.RecursivelyAssignPath(sign,path,checked_signs)
	if checked_signs[sign] then return end
	checked_signs[sign] = true
	
	if not sign.TrackPath then
		if not path then
			path = #Metrostroi.Paths+1
			Metrostroi.Paths[path] = {
				Signs = {},
				Length = 0,
			}
		end
		sign.TrackPath = path
				
		if sign.NextPicket then
			Metrostroi.RecursivelyAssignPath(sign.NextPicket,path,checked_signs)
		end
		if sign.PreviousPicket then
			Metrostroi.RecursivelyAssignPath(sign.PreviousPicket,path,checked_signs)
		end
	end
	
	return sign.TrackPath
end

function Metrostroi.RecursivelyBuildList(sign,path,checked_signs,prepend)
	if checked_signs[sign] then return end
	checked_signs[sign] = true

	-- Add to list
	if prepend == false then
		table.insert(path.Signs,sign)
	else
		table.insert(path.Signs,1,sign)
	end
	
	-- Compute length
	if sign.NextIndex then
		local length = (sign.NextPicket:GetPos() - sign:GetPos()):Length()*0.01905
		path.Length = path.Length + length
		Metrostroi.SectionLength[sign.Index] = length
	else
		Metrostroi.SectionLength[sign.Index] = 0.0
	end
	
	-- Move to next picket
	if sign.NextPicket then
		Metrostroi.RecursivelyBuildList(sign.NextPicket,path,checked_signs,false)
	end
	-- Move to previous picket
	if sign.PreviousPicket then
		Metrostroi.RecursivelyBuildList(sign.PreviousPicket,path,checked_signs,true)
	end
end

function Metrostroi.UpdateSections()
	if Metrostroi.InhibitSectionUpdates == true then return end
	Metrostroi.Paths = {}
	Metrostroi.SectionLength = {}
	Metrostroi.SectionOffset = {}
	
	-- Remove information about track paths
	for idx,sign in pairs(Metrostroi.PicketSigns) do sign.TrackPath = nil end

	-- Build new paths
	local checked_signs = {}
	for idx,sign in pairs(Metrostroi.PicketSignByIndex) do
		local path = Metrostroi.Paths[Metrostroi.RecursivelyAssignPath(sign,nil,{})]

		-- Build a list of signs
		Metrostroi.RecursivelyBuildList(sign,path,checked_signs)
		
		
		-- Compute length of path
--[[		if sign.NextIndex then
			local length = (sign.NextPicket:GetPos() - sign:GetPos()):Length()*0.01905
			path.Length = path.Length + length
			
			-- Write section length in meters
			Metrostroi.SectionLength[sign.Index] = length
			
			-- Insert sign in proper order into the path
			local inserted = false
			for i,v in ipairs(path.Signs) do
				if (v == sign.NextPicket) then
					print("INSERTED",v.Index,sign.NextIndex)
					inserted = true
					table.insert(path.Signs,i,sign)
					break
				end
			end
			
			if not inserted then -- Append in the end
				table.insert(path.Signs,sign)
			end
			
--			print(sign.Index.."->"..sign.NextIndex.." = ",length,"m")
--			print("PATH",sign.TrackPath,path.Length,"m")
		else
			-- Add last sign
			--table.insert(path.Signs,sign)
			
			-- This section has no length
			Metrostroi.SectionLength[sign.Index] = 0.0
		end]]--
	end
	
	-- Find lowest sign in path and build coordinate system from it
	for k,path in pairs(Metrostroi.Paths) do
		-- Check if path loops onto itself
		if (#path.Signs > 0) and (path.Signs[#path.Signs].NextPicket == path.Signs[1]) then
--			print("LOOP")
			path.Loops = true
		else
			path.Loops = false
		end
	
		local min_i = nil
		local min_v = nil
		if path.Loops then
			for i,v in ipairs(path.Signs) do
				if v.Index < (min_v or 1e99) then
					min_v = v.Index
					min_i = i
				end
			end
		else
			if path.Signs[1] then
				min_i = 1
				min_v = path.Signs[1].Index
			end
		end

		if min_i then
			local i = min_i
			Metrostroi.SectionOffset[path.Signs[i].Index] = 0.0
			path.Signs[i].SectionOffset = 0.0
			
			local prev_i = i
			i = i + 1
			while true do
				if i > #path.Signs then i = 1 end
				if i == min_i then break end
				
				Metrostroi.SectionOffset[path.Signs[i].Index] =
					Metrostroi.SectionOffset[path.Signs[prev_i].Index] +
					Metrostroi.SectionLength[path.Signs[prev_i].Index]
					
--				print(i,prev_i)
					
				path.Signs[i].SectionOffset = Metrostroi.SectionOffset[path.Signs[i].Index]

				prev_i = i
				i = i + 1
			end
		end
	end
	
	-- Set offsets for the signs
	for k,v in pairs(Metrostroi.SectionOffset) do
		Metrostroi.PicketSignByIndex[k]:SetPicketOffset(v)
	end
	for k,v in pairs(Metrostroi.SectionOffset) do -- Hacks
		Metrostroi.PicketSignByIndex[k]:SetPicketOffset(v)
	end
end

function Metrostroi.PrintPaths()
	local total = 0
	for k,v in pairs(Metrostroi.Paths) do
		print("PATH",k)
		for k2,v2 in ipairs(v.Signs) do
--			print(" ",v2.Index,math.floor(v2.SectionOffset/10)*10)
		end
		print(" ","END ("..v.Length.." m)")
		total = total + v.Length
	end
	print("\nTotal length of all tracks: "..total.." m")
end




--------------------------------------------------------------------------------
-- Update position of entity (find its position on tracks)
--
-- Saves the ent position to table
--------------------------------------------------------------------------------
function Metrostroi.UpdateEntityPosition(pos_table,ent)
	local X_PAD = 0
	local Y_PAD = 384
	local Z_PAD = 192

--	for idx1,sign1 in pairs(Metrostroi.PicketSignByIndex) do
	local radius = 8192
	local equipment = ents.FindInSphere(ent:GetPos(),radius)
	for k,sign1 in pairs(equipment) do
		if (sign1:GetClass() == "gmod_track_equipment") and sign1.IsPicketSign then
			local idx1 = sign1.Index
			local sign2 = sign1.NextPicket
			
			if sign2 then
				local idx2 = sign2.Index
	
				-- Get line connecting two pickets
				local line = sign2:GetPos() - sign1:GetPos()
				local length = line:Length()
	
				-- Get local coordinate system of section
				local forward = line
				forward:Normalize()
				local up = Vector(0,0,1)
				local right = forward:Cross(up)
	
				-- Calculate ent position in local coords of section
				local ent_pos = ent:GetPos() - sign1:GetPos()
				local ent_x = ent_pos:Dot(forward)
				local ent_y = ent_pos:Dot(right)
				local ent_z = ent_pos:Dot(up)
				local delta = math.sqrt(ent_y^2 + ent_z^2)
	
				local ent_dir = ent:GetAngles():Forward()
				local dir_delta = ent_dir:Dot(forward)
				
				local dir_forward = true
				if dir_delta > 0 then dir_forward = false end
				if ent.SubwayTrain then dir_forward = not dir_forward end
				
				-- If ent has a nearest picket defined, check if this is it
				local nearest_picket_override = false
				if ent.NearestPicket and (ent.NearestPicket == sign1) then
					nearest_picket_override = true
				end
	
				-- See if ent is located on segment
				if ((ent_x > -X_PAD) and (ent_x < length+X_PAD) and
						(ent_y > -Y_PAD) and (ent_y < Y_PAD) and
						(ent_z > -Z_PAD) and (ent_z < Z_PAD)) or (nearest_picket_override) then
	
					if (not pos_table[ent]) or
						 (pos_table[ent] and (pos_table[ent].delta > delta)) or
						 (nearest_picket_override) then
						if nearest_picket_override then
	--						print("OVERRIDE",ent,ent_x,ent_y,ent_z,idx1)
						elseif pos_table[ent] and (pos_table[ent].override) then
	--						print("RESET",ent)
						end
						 
						local base_offset = 0.0
						if Metrostroi.SectionOffset and Metrostroi.SectionOffset[idx1] then
							base_offset = Metrostroi.SectionOffset[idx1]
						end
						local pos = base_offset + ent_x*0.01905
						
						if not (pos_table[ent] and pos_table[ent].override) then
							pos_table[ent] = {
								position = pos,
								x = ent_x, y = ent_y, z = ent_z,
								path = sign1.TrackPath or 0,
								section = idx1, start_picket = sign1, end_picket = sign2,
								forward_facing = dir_forward,
								delta = delta,
								override = nearest_picket_override }
								
							if ent.DebugSetNearestPicket then
								ent:DebugSetNearestPicket(sign1)
							end
							
							for name,func in pairs(Metrostroi.PositionCallbacks) do
								func(ent,pos_table[ent])
							end
						end
					end
				end
			end
		end
	end
end

function Metrostroi.PrintPositions()
	print("Train","Position","Section","Path")
	for k,v in pairs(Metrostroi.TrainPositions) do
		print(k:EntIndex(),v.position,v.section,v.path)
		print("",k.Speed,k.ARSSpeed,k.Mode)
	end
end

function Metrostroi.Stats()
	local equipment = ents.FindByClass("gmod_track_equipment")
	local a,b,c = 0,0,0
	for k,v in pairs(equipment) do
		if v.TrafficLight then
			c = c + 1
		elseif v.IsPicketSign then
			a = a + 1
		else
			b = b + 1
		end
	end
	print("Traffic lights: "..c)
	print("Pickets: "..a)
	print("Other: "..b)
end




--------------------------------------------------------------------------------
-- Update all positions of interesting entities
--------------------------------------------------------------------------------
function Metrostroi.UpdateEntityPositions()
	Metrostroi.TrainPositions = {}
--	Metrostroi.TrafficLightPositions = {}
	Metrostroi.TrainsAtSection = {}
--	Metrostroi.TrafficLightsAtSection = {}

	-- Query all train types
	local classes = {
		"gmod_subway_81-717",
		"gmod_subway_81-714",
		"gmod_subway_base",
		"gmod_subway_em508"
	}

	for _,class in pairs(classes) do
		local trains = ents.FindByClass(class)
		for k,v in pairs(trains) do
			Metrostroi.UpdateEntityPosition(Metrostroi.TrainPositions,v)
		end
	end

	-- Update list of trains in sections
	for k,v in pairs(Metrostroi.TrainPositions) do
		Metrostroi.TrainsAtSection[v.section] = Metrostroi.TrainsAtSection[v.section] or {}
		table.insert(Metrostroi.TrainsAtSection[v.section],k)
	end

	-- Query all equipment
--[[	local equipment = ents.FindByClass("gmod_track_equipment")
	for k,v in pairs(equipment) do
		if v.TrafficLight then
			Metrostroi.UpdateEntityPosition(
				Metrostroi.TrafficLightPositions,Metrostroi.TrafficLightsAtSection,v)
		end
	end ]]--
--	Metrostroi.UpdateTrafficLightPositions()

	-- Print positions
	if Metrostroi.TrafficLightPositions then
		for k,v in pairs(Metrostroi.TrafficLightPositions) do
			Metrostroi.UpdateTrafficLight(k)
		end
	end
end
timer.Create("Metrostroi_PositionTimer",1.0,0,Metrostroi.UpdateEntityPositions)


function Metrostroi.UpdateTrafficLightPositions()
	if Metrostroi.InhibitSectionUpdates == true then return end

	Metrostroi.TrafficLightPositions = {}
	Metrostroi.TrafficLightsAtSection = {}
	Metrostroi.SignPositions = {}
	Metrostroi.SignsAtSection = {}

	-- Query all traffic lights
	for k,v in pairs(Metrostroi.TrafficLights) do
		Metrostroi.UpdateEntityPosition(Metrostroi.TrafficLightPositions,v)
	end

	-- Query all signs
	local equipment = ents.FindByClass("gmod_track_equipment")
	for k,v in pairs(equipment) do
		if (not v.TrafficLight) and (not v.IsPicketSign) then
			Metrostroi.UpdateEntityPosition(Metrostroi.SignPositions,v)
		end
	end
	
	-- Update lists of things in sections
	for k,v in pairs(Metrostroi.TrafficLightPositions) do
		Metrostroi.TrafficLightsAtSection[v.section] = Metrostroi.TrafficLightsAtSection[v.section] or {}
		table.insert(Metrostroi.TrafficLightsAtSection[v.section],k)
	end
	
	for k,v in pairs(Metrostroi.SignPositions) do
		Metrostroi.SignsAtSection[v.section] = Metrostroi.SignsAtSection[v.section] or {}
		table.insert(Metrostroi.SignsAtSection[v.section],k)
	end
end




--------------------------------------------------------------------------------
-- Update values of traffic light
--------------------------------------------------------------------------------
function Metrostroi.FindTrainOrLight(source,min_offset,index,checkedPickets,facing,firstSwitch)
	if checkedPickets[index] then return end
	checkedPickets[index] = true

	-- Get actual sign
	local sign = Metrostroi.PicketSignByIndex[index]
	if not sign then return nil,nil,nil,nil,firstSwitch end
	
	-- Find a train or traffic light
	local min_index,min_type,min_v,v_offset
	if Metrostroi.TrainsAtSection[sign.Index] then
		for k,v in pairs(Metrostroi.TrainsAtSection[sign.Index]) do
			local pos = Metrostroi.TrainPositions[v].position
			local within_bounds = (pos > min_offset) and (pos < (v_offset or 1e99))
			if facing == false then
				within_bounds = (pos < min_offset) and (pos > (v_offset or (-1e99)))
			end
			
			if within_bounds then
				min_index = index
				min_type = "train"
				min_v = v
				v_offset = pos
			end
		end
	end
		
	if Metrostroi.TrafficLightsAtSection[sign.Index] then
		for k,v in pairs(Metrostroi.TrafficLightsAtSection[sign.Index]) do
			local pos = Metrostroi.TrafficLightPositions[v].position
			local face = Metrostroi.TrafficLightPositions[v].forward_facing
			
			local within_bounds = (pos > min_offset) and (pos < (v_offset or 1e99))
			if facing == false then
				within_bounds = (pos < min_offset) and (pos > (v_offset or (-1e99)))
			end
			
			if (not v.Disabled) and (v ~= source) and within_bounds and (facing ==	face) then
				min_index = index
				min_type = "light"
				min_v = v
				v_offset = pos
			end
		end
	end
	
	-- Check if there are any prohibitive signs in this section
	if Metrostroi.SignsAtSection and Metrostroi.SignsAtSection[sign.Index] then
		for k,v in pairs(Metrostroi.SignsAtSection[sign.Index]) do
			local pos = Metrostroi.SignPositions[v].position
			local face = Metrostroi.SignPositions[v].forward_facing

			local within_bounds = (pos > min_offset) and (pos < (v_offset or 1e99))
			if facing == false then
				within_bounds = (pos < min_offset) and (pos > (v_offset or (-1e99)))
			end

			if (v ~= source) and within_bounds and (facing == face) then
				if v.ProhibitPath then
--					print("TRIP",sign.Index)
					return nil,nil,nil,nil,firstSwitch
				end
			end
		end
	end
	
	-- Current picket has a track switch
	if sign.TrackSwitchName and (sign:GetTrackSwitchState() == true) then
		firstSwitch = firstSwitch or sign
	end
	
	-- Return some object
	if min_index then
		return min_index,min_type,min_v,v_offset,firstSwitch
	end
	
	local nextIndex = sign.NextIndex
	local nextPicket = sign.NextPicket
	if facing == false then
		nextIndex = sign.PreviousIndex
		nextPicket = sign.PreviousPicket
	end
	
	-- 1. Check if next track switch is active, and the alternate path it leads to was not checked
	--		(the last part avoids search from travelling back over active junction)
	if sign and (sign.NextIndex) and (not checkedPickets[sign.AlternateIndex]) then

		-- Follow the alternate path if not blocking
		if sign.TrackSwitchName and (sign:GetTrackSwitchState() == true) then
			local backupCheckedPickets = {}
			for k,v in pairs(checkedPickets) do
				backupCheckedPickets[k] = v
			end
			
			local i,t,v,o,s = Metrostroi.FindTrainOrLight(source,
				sign.AlternatePicket.SectionOffset or min_offset,
				sign.AlternateIndex,checkedPickets,facing,firstSwitch or sign)

			-- If the next light is green, check other way too
			if (t == "light") or (not t) then
				if (not t) or (not v.TrainBlocksNext) then
					for k,v in pairs(backupCheckedPickets) do
						checkedPickets[k] = v
					end
					checkedPickets[sign.AlternateIndex] = nil

					local i2,t2,v2,o2,s2 = Metrostroi.FindTrainOrLight(source,
							sign.AlternatePicket.SectionOffset or min_offset,
							sign.AlternateIndex,checkedPickets,not facing,firstSwitch or sign)
							
					if i2 then return i2,t2,v2,o2,s2 end
				end
			end

			return i,t,v,o,s
		end
	end

	-- 2. Check if no next index is available, but a track switch is active
	if (not nextIndex) and (sign.AlternatePicket) then
		if sign.TrackSwitchName and (sign:GetTrackSwitchState() == true) then
			return Metrostroi.FindTrainOrLight(source,
				sign.AlternatePicket.SectionOffset or min_offset,
				sign.AlternateIndex,checkedPickets,facing,firstSwitch or sign)
		end
	end
	

	-- 3. Check if any next index is available
	if nextIndex then
		if facing == true then -- Facing forward and there's a discontinuity
			local new_offset = Metrostroi.SectionOffset[nextIndex]
			if new_offset and (new_offset < min_offset) then
				min_offset = new_offset
			end
		else -- Facing backwards
			local new_offset = Metrostroi.SectionOffset[nextIndex]
			if new_offset and (new_offset > min_offset) then
				min_offset = new_offset
			end
		end

		return Metrostroi.FindTrainOrLight(source,min_offset,nextIndex,checkedPickets,facing,firstSwitch)
	end
end

function Metrostroi.UpdateTrafficLight(ent)
	if not Metrostroi.TrafficLightPositions[ent] then return end
	if not ent.TrafficLight then return end
	
	local startOffset = Metrostroi.TrafficLightPositions[ent].position
	local startIndex = Metrostroi.TrafficLightPositions[ent].section
	
	if not Metrostroi.PicketSignByIndex[startIndex] then return end
	if not Metrostroi.PicketSignByIndex[startIndex].NextIndex then return end
	local facing = Metrostroi.TrafficLightPositions[ent].forward_facing
	
	-- Find train or light
	local c = {}
	local foundIndex,foundType,foundEnt,foundOffset,foundSwitch = Metrostroi.FindTrainOrLight(ent,startOffset,startIndex,c,facing)
	-- Find track switch
--	local foundSwitch = Metrostroi.GetNextTrackSwitch(ent,true)

	-- React properly
	if foundIndex and (foundType == "train") then
		ent:UpdateTrafficLight(true,false,nil,nil,foundSwitch)
	elseif foundIndex and (foundType == "light") then
		ent:UpdateTrafficLight(false,false,foundEnt,nil,foundSwitch)
	else
		ent:UpdateTrafficLight(false,false,nil,nil,foundSwitch)
	end
	

	
--	PrintTable(Metrostroi.TrafficLightPositions[ent])
--	print("TRAIN OR LIGHT",startIndex,foundIndex,foundType,foundEnt)
end




--------------------------------------------------------------------------------
-- Finds next track switch
--------------------------------------------------------------------------------
function Metrostroi.GetNextTrackSwitch(ent,noMinDistance)
	local train_pos = Metrostroi.TrainPositions[ent] or Metrostroi.TrafficLightPositions[ent]
	if not train_pos then return nil end
	
	-- Should check in reverse
	local reverse = not train_pos.forward_facing--ent.Reverse or false
	if ent.Reverse then reverse = not reverse end

--	if ent:EntIndex() == 561 then
--		print(ent,reverse,train_pos.forward_facing)
--	end
--	reverse = not reverse

	-- Find next track switch
	local checkedPickets = {}
	local picket = train_pos.start_picket
	while picket and (not checkedPickets[picket]) do
--		if ent:EntIndex() == 561 then
--			print("CHECK",picket.Index,train_pos.section,picket.TrackSwitchName,
--				picket:DistanceToSwitch(ent:GetPos()))
--		end
		if picket.TrackSwitchName then
			if picket:DistanceToSwitch(ent:GetPos()) > 15 then
				break
			end
		end
	
		-- Check the picket and move onto the next one
		checkedPickets[picket] = true
		if reverse == true then
			picket = picket.PreviousPicket
		else
			picket = picket.NextPicket
		end
	end
	
	-- No pickets found
	if not picket then return nil end
	
	-- Compute distance to track switch
	local distance = picket:DistanceToSwitch(ent:GetPos())
	
--	print(Metrostroi.SectionOffset[picket.Index],picket.Index)
--	print(train_pos.position)
	-- Check if track switch is not too far
--	print("DISTANCE",distance,reverse,noMinDistance)
--	print(picket.Index,distance)
	if (distance < 15.0) and (not noMinDistance) then return nil end
	if distance > 150.0 then return nil end
	
	-- Return it
	if picket and picket.TrackSwitchName then
		return picket
	else
		return nil
	end
end




--------------------------------------------------------------------------------
-- Assign train IDs
--------------------------------------------------------------------------------
if not Metrostroi.WagonID then
	Metrostroi.WagonID = 1
end
function Metrostroi.NextWagonID()
	local id = Metrostroi.WagonID
	Metrostroi.WagonID = Metrostroi.WagonID + 1
	if Metrostroi.WagonID > 99 then Metrostroi.WagonID = 1 end
	return id
end

if not Metrostroi.EquipmentID then
	Metrostroi.EquipmentID = 1
end
function Metrostroi.NextEquipmentID()
	local id = Metrostroi.EquipmentID
	Metrostroi.EquipmentID = Metrostroi.EquipmentID + 1
	return id
end

--------------------------------------------------------------------------------
-- Register Joystick Controlls
-- Author: HunterNL
--------------------------------------------------------------------------------

if not Metrostroi.JoystickValueRemap then
	Metrostroi.JoystickValueRemap = {}
	Metrostroi.JoystickSystemMap = {}
end

Metrostroi.RegisterJoystickInput = function(uid,analog,desc,min,max) 
	if not joystick then
		Error("Joystick Input registered without joystick addon installed, get it at https://github.com/MattJeanes/Joystick-Module") 
	end
	--If this is only called in a JoystickRegister hook it should never even happen
	
	if #uid > 20 then 
		print("Metrostroi Joystick UID too long, trimming") 
		local uid = string.Left(uid,20)
	end
	
	
	local atype 
	if analog then
		atype = "analog"
	else
		atype = "digital"
	end
	
	local temp = {
		uid = uid,
		type = atype,
		description = desc,
		category = "Metrostroi" --Just Metrostroi for now, seperate catagories for different trains later?
		--Catergory is also checked in subway base, don't just change
	}
	
	
	--Joystick addon's build-in remapping doesn't work so well, so we're doing this instead
	if min ~= nil and max ~= nil and analog then
		Metrostroi.JoystickValueRemap[uid]={min,max}
	end
	
	jcon.register(temp)
end

--Wrapper around joystick get to implement our own remapping
Metrostroi.GetJoystickInput = function(ply,uid) 
	local remapinfo = Metrostroi.JoystickValueRemap[uid]
	local jvalue = joystick.Get(ply,uid)
	if remapinfo == nil then
		return jvalue
	elseif jvalue ~= nil then
		return math.Remap(joystick.Get(ply,uid),0,255,remapinfo[1],remapinfo[2])
	else
		return jvalue
	end
end

--------------------------------------------------------------------------------
-- Player meta table magic
-- Author: HunterNL
--------------------------------------------------------------------------------

local Player = FindMetaTable("Player")
function Player:CanDriveTrains()
	return IsValid(self:GetWeapon("train_reverser_switch")) or self:IsAdmin()
end

--------------------------------------------------------------------------------
-- Rerail tool
-- Author: HunterNL
--------------------------------------------------------------------------------
-- Z Offset for rerailing bogeys
local bogeyOffset = 31

local function dirdebug(v1,v2)
	debugoverlay.Line(v1,v1+v2*30,10,Color(255,0,0),true)
end

--Takes datatable from getTrackData
local function debugtrackdata(data) 
	dirdebug(data.centerpos,data.forward)
	dirdebug(data.centerpos,data.right)
	dirdebug(data.centerpos,data.up)
end

--Helper for commonly used trace
local function traceWorldOnly(pos,dir)
	local tr = util.TraceLine({
		start = pos,
		endpos = pos+dir,
		mask = MASK_NPCWORLDSTATIC
	})
	if false then -- Shows all traces done by rerailer
		debugoverlay.Line(tr.StartPos,tr.HitPos,10,Color(0,0,255),true)
		debugoverlay.Sphere(tr.StartPos,2,10,Color(0,255,255),true)
	end
	return tr
end

--Go over the enttable, bogeys and train and reset them
local function resetSolids(enttable,train)
	for k,v in pairs(enttable) do
		if IsValid(k) then
			k:SetSolid(v)
			k:GetPhysicsObject():EnableMotion(true)
		end
	end
	if train ~= nil and IsValid(train) then
		train.FrontBogey:GetPhysicsObject():EnableMotion(true)
		train.RearBogey:GetPhysicsObject():EnableMotion(true)
		
		train:GetPhysicsObject():EnableMotion(true)
	end
end

--Elevates a position to track level
--Requires a position in the center of the track
local function ElevateToTrackLevel(pos,right,up)
	local tr1 = traceWorldOnly(pos+up*200+right*42,-up*500)
	local tr2 = traceWorldOnly(pos+up*200-right*42,-up*500)
	if not tr1.Hit or not tr2.Hit then return false end
	return (tr1.HitPos + tr2.HitPos)/2
end

--Takes position and initial rough forward vector, return table of track data
--Position needs to be between/below the tracks already, don't use a props origin
--Only needs a rough forward vector, ent:GetAngles():Forward() suffices
local function getTrackData(pos,forward)	
	--Trace down
	--debugoverlay.Cross(pos,5,10,Color(255,0,255),true)
	local tr = traceWorldOnly(pos,Vector(0,0,-100))
	if !tr or !tr.Hit then return false end
	
	--debugoverlay.Line(tr.StartPos,tr.HitPos,10,Color(0,255,0),true)
	local floor = tr.HitPos
	local updir = tr.HitNormal
	local right = forward:Cross(updir)
	
	--Trace right
	local tr = traceWorldOnly(pos,right*500)
	if not tr or not tr.Hit then return false end
	
	--debugoverlay.Line(tr.StartPos,tr.HitPos,10,Color(0,255,0),true)
	
	local trackforward = tr.HitNormal:Cross(updir)
	local trackright = trackforward:Cross(updir)
	
	debugoverlay.Axis(floor,trackforward:Angle(),10,5,true)
	
	--debugoverlay.Line(pos,pos+trackforward*30,10,Color(255,0,0),true)
	
	--Trace right with proper right
	local tr1 = traceWorldOnly(floor,trackright*80)
	local tr2 = traceWorldOnly(floor,-trackright*80)
	if not tr1 or not tr2 then return false end
	
	local floor = (tr1.HitPos+tr2.HitPos)/2
	
	debugoverlay.Cross(floor,5,10,Color(0,255,0),true)

	local centerpos = ElevateToTrackLevel(floor,trackright,updir)

	if not centerpos then return false end

	debugoverlay.Cross(centerpos,5,10,Color(255,0,0),true)
	
	local data = {
		forward = trackforward,
		right = trackright,
		up = updir,
		centerpos = centerpos
	}

	return data

end

--Helper function that tries to find trackdata at -z or -ent:Up()
local function getTrackDataBelowEnt(ent)
	local forward = ent:GetAngles():Forward()
	
	local tr = traceWorldOnly(ent:GetPos(),Vector(0,0,-500))
	if tr.Hit then
		local td = getTrackData(tr.HitPos,forward)
		if td then return td end
	end
	
	local tr = traceWorldOnly(ent:GetPos(),ent:GetAngles():Up()*-500)
	if tr.Hit then
		local td = getTrackData(tr.HitPos,forward)
		if td then return td end
	end
	
	return false 
end

local function PlayerCanRerail(ply,ent)
	if CPPI then
		return ent:CPPICanTool(ply,"metrostroi_rerailer")
	else
		return ply:IsAdmin() or (ent.Owner and ent.Owner == ply)
	end
end

--ConCMD for rerailer
local function RerailConCMDHandler(ply,cmd,args,fullstring)
	local train = ply:GetEyeTrace().Entity
	if not IsValid(train) then return end
	
	
	--If we're aiming at bogeys or wheels
	local nwent = train:GetNWEntity("TrainEntity")
	if nwent and nwent.SubwayTrain ~= nil then 
		train = nwent
	end
	
	if not PlayerCanRerail(ply,train) then return end
	
	if train:GetClass() == "gmod_train_bogey" then
		Metrostroi.RerailBogey(train)
	else
		Metrostroi.RerailTrain(train)
	end
end
concommand.Add("metrostroi_rerail",RerailConCMDHandler)

Metrostroi.RerailBogey = function(bogey)
	if timer.Exists("metrostroi_rerailer_solid_reset_"..bogey:EntIndex()) then return false end
	
	local trackData = getTrackDataBelowEnt(bogey)
	if not trackData then return false end
	
	bogey:SetPos(trackData.centerpos+trackData.up*bogeyOffset)
	bogey:SetAngles(trackData.forward:Angle())
	
	bogey:GetPhysicsObject():EnableMotion(false)
	
	local solids = {}
	local wheels = bogey.Wheels
	
	solids[bogey]=bogey:GetSolid()
	bogey:SetSolid(SOLID_NONE)
	
	if wheels ~= nil then
		solids[wheels]=wheels:GetSolid()
		wheels:SetSolid(SOLID_NONE)
	end
	
	timer.Create("metrostroi_rerailer_solid_reset_"..bogey:EntIndex(),1,1,function() resetSolids(solids) end )
	return true
end

--Rerails given train entity
Metrostroi.RerailTrain = function(train)

	--Safety checks
	if not IsValid(train) or train.SubwayTrain == nil then return false end
	if timer.Exists("metrostroi_rerailer_solid_reset_"..train:EntIndex()) then return false end
	--[[
	--Trace down to get the track
	local tr = traceWorldOnly(train:GetPos(),Vector(0,0,-500))
	if !tr or !tr.Hit then 
		tr = traceWorldOnly(train:GetPos(),train:GetAngles():Up()*-500)
		if !tr or !tr.Hit then return false end
	end
	
	--Get track data below the train
	local trackdata = getTrackData(tr.HitPos+tr.HitNormal*3,train:GetAngles():Forward()) 
	if !trackdata then return false end
	--]]
	
	local trackdata = getTrackDataBelowEnt(train)
	if not trackdata then return false end
	local ang = trackdata.forward:Angle()

	
	--Get the positions of the bogeys if we'd rerail the train now
	local frontoffset=train:WorldToLocal(train.FrontBogey:GetPos())
	frontoffset:Rotate(ang)
	local frontpos = frontoffset+train:GetPos()
	
	local rearoffset = train:WorldToLocal(train.RearBogey:GetPos())
	rearoffset:Rotate(ang)
	local rearpos=rearoffset+train:GetPos()

	--Get thet track data at these locations
	local tr = traceWorldOnly(frontpos,-trackdata.up*500)
	if !tr or !tr.Hit then return false end
	local frontdata = getTrackData(tr.HitPos+tr.HitNormal*3,trackdata.forward)
	if !frontdata then return false end
	
	local tr = traceWorldOnly(rearpos,-trackdata.up*500)
	if !tr or !tr.Hit then return false end
	local reardata = getTrackData(tr.HitPos+tr.HitNormal*3,trackdata.forward)
	if !reardata then return false end
	
	--Find the current difference between the bogeys and the train's model center
	local TrainOriginToBogeyOffset = (train:WorldToLocal(train.FrontBogey:GetPos())+train:WorldToLocal(train.RearBogey:GetPos()))/2
	
	--Final trains pos is the average of the 2 bogey locations
	local trainpos = (frontdata.centerpos+reardata.centerpos)/2
	
	--Apply bogey-origin and bogey-track offsets
	trainpos = LocalToWorld(TrainOriginToBogeyOffset*-1,ang,trainpos,ang) + Vector(0,0,bogeyOffset)
	--Not sure if this is neccesary anymore, but I'm not touching this anytime soon
	
	--Store and set solids
	local entlist = {
		train,
		train.FrontBogey,
		train.RearBogey,
		train.FrontBogey.Wheels,
		train.RearBogey.Wheels
	}
	
	local solids = {}
	for k,v in pairs(entlist) do
		solids[v]=v:GetSolid()
		v:SetSolid(SOLID_NONE)
	end
	
	train:SetPos(trainpos)
	train:SetAngles(ang)
	
	train.FrontBogey:SetPos(frontdata.centerpos+frontdata.up*bogeyOffset)
	train.RearBogey:SetPos(reardata.centerpos+reardata.up*bogeyOffset)
	
	train.FrontBogey:SetAngles((frontdata.forward*-1):Angle())
	train.RearBogey:SetAngles(reardata.forward:Angle())
	
	train:GetPhysicsObject():EnableMotion(false)
	
	train.FrontBogey:GetPhysicsObject():EnableMotion(false)
	train.RearBogey:GetPhysicsObject():EnableMotion(false)
	
	timer.Create("metrostroi_rerailer_solid_reset_"..train:EntIndex(),1,1,function() resetSolids(solids,train) end )
	return true
end



