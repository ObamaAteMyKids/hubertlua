--autoupdater--
local script_name = GetScriptName()

file.Delete(script_name)
file.Open(script_name,"w")
file.Write(script_name,http.Get("https://raw.githubusercontent.com/ObamaAteMyKids/hubertlua/main/hubertlua.lua"))

--test

local ref = gui.Reference("RAGEBOT")
local path = gui.Tab(ref, "hubertlua", "hubertlua")
local group = gui.Groupbox(path, "Rage AA Settings", 16,16,296,100)

local RageAAcheckbox = gui.Checkbox(group, "rage_aa", "Rage AA", false)
local FreestandRageCheckbox = gui.Checkbox(group, "freestand_rage_aa", "Freestanding", false)
local JitterRageCheckbox = gui.Checkbox(group, "jitter_rage_aa", "Jitter", false)
local LowDeltaCheckbox = gui.Checkbox(group, "low_delta", "Low Delta", false)
local HalfDeltaCheckbox = gui.Checkbox(group, "half_delta", "Half Delta", false)
local LogicCheckbox = gui.Checkbox(group, "logic", "hubertAA (overrides all other settings)", false)
local LogicInverterCheckbox = gui.Checkbox(group, "logic_inverter", "hubertAA Invert", false)

local group2 = gui.Groupbox(path, "Legit AA Settings", 328,16,296,100)
local LegitAAcheckbox = gui.Checkbox(group2, "legit_aa", "Legit AA", false)
local LegitAAonEcheckbox = gui.Checkbox(group2, "legit_aa_on_e", "Legit AA on E only", false)
local FreestandCheckbox = gui.Checkbox(group2, "freestand_legit_aa", "Freestanding", false)
local JitterCheckbox = gui.Checkbox(group2, "jitter_legit_aa", "Jitter", false)
local SafeLegitAAcheckbox = gui.Checkbox(group2, "safe_legit_aa", "MM mode (no flicking)", false)
local LogicLegitCheckbox = gui.Checkbox(group2, "logic_legit", "hubertAA Legit", false)
local LogicLegitInverterCheckbox = gui.Checkbox(group2, "logic_legit_inverter", "hubertAA Legit Invert", false)

local group3 = gui.Groupbox(path, "Manual Settings", 16,296 + 36,296,100)
local ManualLeftCheckbox = gui.Checkbox(group3, "manual_left", "Manual Left", false)
local ManualRightCheckbox = gui.Checkbox(group3, "manual_right", "Manual Right", false)
local ManualForwardCheckbox = gui.Checkbox(group3, "manual_forward", "Manual Forward", false)
local AAarrowsCheckbox = gui.Checkbox(group3, "aa_arrows", "Manual Arrows", false)

local group4 = gui.Groupbox(path, "Misc Settings", 328,296 + 36,296,100)
local IndicatorsCheckbox = gui.Checkbox(group4, "indicators", "Indicators", false)
local InvertIndicatorCheckbox = gui.Checkbox(group4, "invert_indicator", "Invert Indicator", false)
local WatermarkCheckbox = gui.Checkbox(group4, "watermark", "Watermark", false)
local BuybotCheckbox = gui.Checkbox(group4, "buybot", "Buybot", false)
local BuybotCombo = gui.Combobox(group4, "buybot_items", "Buybot Main","None", "Auto", "Scout", "AWP")
local Buybot2Combo = gui.Combobox(group4, "buybot2_items", "Buybot Secondary", "None", "Heavy Pistol", "Dual Barettas", "Tec9/FiveSeven")
local Buybot3Checkbox1 = gui.Checkbox(group4, "buybot3_nades", "Buy Nades", false)
local Buybot3Checkbox2 = gui.Checkbox(group4, "buybot3_armor", "Buy Armor", false)
local Buybot3Checkbox3 = gui.Checkbox(group4, "buybot3_zeus", "Buy Zeus", false)
local Buybot3Checkbox4 = gui.Checkbox(group4, "buybot3_defuser", "Buy Defuse Kit", false)

static_curtime = globals.CurTime()

function get_flick()
	local flick = false
	if globals.CurTime() - static_curtime >= 0.22 then --credits @sakari
		flick = true
		static_curtime = globals.CurTime()
	end
	return flick
end

callbacks.Register("CreateMove", function(cmd)

	if not RageAAcheckbox:GetValue() then
		return
	end
    
	if LegitAAonEcheckbox:GetValue() and bit.band(cmd.buttons, bit.lshift(1, 5)) == 1 then
		return
	end

	if not cmd.sendpacket then 
		return 
	end

    local rageside = math.random(-1, 1)

	gui.SetValue("rbot.antiaim.advanced.antialign", 1)

    if LogicCheckbox:GetValue() then
		local invert = LogicInverterCheckbox:GetValue()
	        if invert then
		        gui.SetValue("rbot.antiaim.base.rotation", math.random(58, 17))
	        else
		        gui.SetValue("rbot.antiaim.base.rotation", math.random(-58, -17))
	        end

		    gui.SetValue("rbot.antiaim.advanced.autodir.edges", 0)

			if get_flick() then 		
				if invert then			
					gui.SetValue("rbot.antiaim.base", [[90 "Desync"]])	
				else		
					gui.SetValue("rbot.antiaim.base", [[-90 "Desync"]])		
				end	
			else
				gui.SetValue("rbot.antiaim.base", [[180 "Desync"]]) 		
			end    
    else
  
		if ManualLeftCheckbox:GetValue() then
			ManualRightCheckbox:SetValue(0)
			ManualForwardCheckbox:SetValue(0)
			gui.SetValue("rbot.antiaim.base", [[90 "Desync"]])
			gui.SetValue("rbot.antiaim.left", [[90 "Desync"]])
			gui.SetValue("rbot.antiaim.right", [[90 "Desync"]])
		elseif ManualRightCheckbox:GetValue() then
			ManualLeftCheckbox:SetValue(0)
			ManualForwardCheckbox:SetValue(0)
			gui.SetValue("rbot.antiaim.base", [[-90 "Desync"]])   
			gui.SetValue("rbot.antiaim.left", [[-90 "Desync"]])      
			gui.SetValue("rbot.antiaim.right", [[-90 "Desync"]])
		elseif ManualForwardCheckbox:GetValue() then
			ManualLeftCheckbox:SetValue(0)
			ManualRightCheckbox:SetValue(0)
			gui.SetValue("rbot.antiaim.base", [[0 "Desync"]])       		
			gui.SetValue("rbot.antiaim.left", [[0 "Desync"]])        
			gui.SetValue("rbot.antiaim.right", [[0 "Desync"]])
		else
			gui.SetValue("rbot.antiaim.base", [[180 "Desync"]])		
			gui.SetValue("rbot.antiaim.left", [[180 "Desync"]])       
			gui.SetValue("rbot.antiaim.right", [[180 "Desync"]])
		end

		    --LOWDELTA--		   	
		if LowDeltaCheckbox:GetValue() then 	   
			if JitterRageCheckbox:GetValue() then		    
				gui.SetValue("rbot.antiaim.base.rotation", 17 * rageside)			    
				gui.SetValue("rbot.antiaim.advanced.autodir.edges", 0)   
			else		 
				if FreestandRageCheckbox:GetValue() then			
					gui.SetValue("rbot.antiaim.base.rotation", -17)				
					gui.SetValue("rbot.antiaim.left.rotation", -17)				
					gui.SetValue("rbot.antiaim.right.rotation", 17)
					gui.SetValue("rbot.antiaim.advanced.autodir.edges", 1)
				else
					gui.SetValue("rbot.antiaim.base.rotation", -17)			
					gui.SetValue("rbot.antiaim.advanced.autodir.edges", 0)
				end
		    end     
		        
			--HALFDELTA--
        elseif HalfDeltaCheckbox:GetValue() then
			if JitterRageCheckbox:GetValue() then   
				gui.SetValue("rbot.antiaim.base.rotation", 29 * rageside)
				gui.SetValue("rbot.antiaim.advanced.autodir.edges", 0)    
			else
				if FreestandRageheckbox:GetValue() then
					gui.SetValue("rbot.antiaim.base.rotation", -29)
					gui.SetValue("rbot.antiaim.left.rotation", -29)     
					gui.SetValue("rbot.antiaim.right.rotation", 29)    
					gui.SetValue("rbot.antiaim.advanced.autodir.edges", 1)
				else
					gui.SetValue("rbot.antiaim.base.rotation", -29)
					gui.SetValue("rbot.antiaim.advanced.autodir.edges", 0)
				end		
			end
            
				--HIGHDELTA--
		else      
			if JitterRageCheckbox:GetValue() then
				gui.SetValue("rbot.antiaim.base.rotation", 58 * rageside)
				gui.SetValue("rbot.antiaim.advanced.autodir.edges", 0)
			else
				if FreestandRageCheckbox:GetValue() then
					gui.SetValue("rbot.antiaim.base.rotation", -58)	
					gui.SetValue("rbot.antiaim.left.rotation", -58)	
					gui.SetValue("rbot.antiaim.right.rotation", 58)		
					gui.SetValue("rbot.antiaim.advanced.autodir.edges", 1)  		
				else           		
					gui.SetValue("rbot.antiaim.base.rotation", -58)           		
					gui.SetValue("rbot.antiaim.advanced.autodir.edges", 0)		
				end 	
			end
		end
	end
end)


--LEGIT AA--

local save = false
local saved_values = {
    ["rbot.antiaim.base"] = gui.GetValue("rbot.antiaim.base"),
    ["rbot.antiaim.base.lby"] = gui.GetValue("rbot.antiaim.base.lby"),
    ["rbot.antiaim.base.rotation"] = gui.GetValue("rbot.antiaim.base.rotation"),
    ["rbot.antiaim.advanced.antialign"] = gui.GetValue("rbot.antiaim.advanced.antialign"),
    ["rbot.antiaim.advanced.autodir.edges"] = gui.GetValue("rbot.antiaim.advanced.autodir.edges"),
    ["rbot.antiaim.advanced.autodir.targets"] = gui.GetValue("rbot.antiaim.advanced.autodir"),
    ["rbot.antiaim.advanced.pitch"] = gui.GetValue("rbot.antiaim.advanced.pitch"),
    ["rbot.antiaim.condition.use"] = gui.GetValue("rbot.antiaim.condition.use")
}

callbacks.Register("CreateMove", function(cmd)

	if not LegitAAcheckbox:GetValue() then 
		if save then
			for i, v in next, saved_values do
				gui.SetValue(i, v)
			end
			save = false
		end
		    return
	end

	if LegitAAcheckbox:GetValue() and not LegitAAonEcheckbox:GetValue() and RageAAcheckbox:GetValue() then 
		if save then
			for i, v in next, saved_values do
				gui.SetValue(i, v)
			end
			save = false
		end
		return
	end

	if LegitAAonEcheckbox:GetValue() and bit.band(cmd.buttons, bit.lshift(1, 5)) == 0 then
		if save then
			for i, v in next, saved_values do
				gui.SetValue(i, v)
			end
			save = false
		end
		return
	end

	if not cmd.sendpacket then 
		return 
	end

	if not save then
		for i, v in next, saved_values do
			saved_values[i] = gui.GetValue(i)
		end
		save = true
	end

	local legitside = math.random(-1, 1)

	gui.SetValue("rbot.antiaim.condition.use", 0)
	gui.SetValue("rbot.antiaim.advanced.pitch", 0)
    
    if SafeLegitAAcheckbox:GetValue() then
		gui.SetValue("rbot.antiaim.advanced.antialign", 1)
	else
		gui.SetValue("rbot.antiaim.advanced.antialign", 0)
	end

    if LogicLegitCheckbox:GetValue() then
		local invert = LogicLegitInverterCheckbox:GetValue()
  
        if invert then
	        gui.SetValue("rbot.antiaim.base.rotation", math.random(58, 17))
	    else
		    gui.SetValue("rbot.antiaim.base.rotation", math.random(-58, -17))
	    end

		gui.SetValue("rbot.antiaim.advanced.autodir.edges", 0)

		if get_flick() then 		
			if invert then			
				gui.SetValue("rbot.antiaim.base", [[-90 "Desync"]])	
			else		
				gui.SetValue("rbot.antiaim.base", [[90 "Desync"]])		
			end	
		else
			gui.SetValue("rbot.antiaim.base", [[0 "Desync"]]) 	
		end    
	 
	else
		if JitterCheckbox:GetValue() then
			gui.SetValue("rbot.antiaim.base", [[0 "Desync"]])
			gui.SetValue("rbot.antiaim.base.rotation", 58 * legitside)
		else
			if FreestandCheckbox:GetValue() then
				gui.SetValue("rbot.antiaim.base.rotation", -58)
				gui.SetValue("rbot.antiaim.left.rotation", 58)
				gui.SetValue("rbot.antiaim.right.rotation", -58)
				gui.SetValue("rbot.antiaim.base", [[0 "Desync"]])
				gui.SetValue("rbot.antiaim.left", [[0 "Desync"]])
				gui.SetValue("rbot.antiaim.right", [[0 "Desync"]])	
				gui.SetValue("rbot.antiaim.advanced.autodir.edges", 1)
			else
				gui.SetValue("rbot.antiaim.base", [[0 "Desync"]])
				gui.SetValue("rbot.antiaim.base.rotation", -58)
				gui.SetValue("rbot.antiaim.advanced.autodir.edges", 0)	
			end
	
		end
	end
end)


--MISC SHIT--

--BUYBOT--

callbacks.Register("FireGameEvent", function(event)

	if not BuybotCheckbox:GetValue() then
		return
	end
 

	if event:GetName() == "round_prestart" then

		--MAIN--
		if BuybotCombo:GetValue() == 1 then
			client.Command("buy scar20")
		elseif BuybotCombo:GetValue() == 2 then
			client.Command("buy ssg08")
		elseif BuybotCombo:GetValue() == 3 then
			client.Command("buy awp") 
		end

		--SECONDARYY--
		if Buybot2Combo:GetValue() == 1 then
			client.Command("buy deagle")
		elseif Buybot2Combo:GetValue() == 2 then
			client.Command("buy elite")
		elseif Buybot2Combo:GetValue() == 3 then
			client.Command("buy tec9") 
		end

		--MISC--
		if Buybot3Checkbox1:GetValue() then
			client.Command("buy incgrenade; buy molotov; buy hegrenade; buy smokegrenade")
		end
		if Buybot3Checkbox2:GetValue() then
			client.Command("buy vest; buy vesthelm")
		end
		if Buybot3Checkbox3:GetValue() then
			client.Command("buy taser")
		end
		if Buybot3Checkbox4:GetValue() then
			client.Command("buy defuser")
		end
	end
end)

client.AllowListener("round_prestart");

--INDICATORS--

local function get_active_gun()
    local lpaw = entities.GetLocalPlayer():GetWeaponID()
    
	if lpaw == 2 or lpaw == 3 or lpaw == 4 or lpaw == 30 or lpaw == 32 or lpaw == 36 or lpaw == 61 or lpaw == 63 then
        wclass="pistol"
    elseif lpaw == 9 then
        wclass="sniper"
    elseif lpaw == 40 then
        wclass="scout"
    elseif lpaw == 1 or lpaw == 64 then
        wclass="hpistol"
    elseif lpaw == 17 or lpaw == 19 or lpaw == 23 or lpaw == 24 or lpaw == 26 or lpaw == 33 or lpaw == 34 then
        wclass="smg"
    elseif lpaw == 7 or lpaw == 8 or lpaw == 10 or lpaw == 13 or lpaw == 16 or lpaw == 39 or lpaw == 61 then
        wclass="rifle"
    elseif lpaw == 25 or lpaw == 27 or lpaw == 29 or lpaw == 35 then
        wclass="shotgun"
    elseif lpaw == 38 or lpaw == 11 then
        wclass="asniper"
    elseif lpaw == 28 or lpaw == 14 then
        wclass="lmg"
    else
        wclass="other"
    end
	return wclass
end

function dt_enabled()
	if entities.GetLocalPlayer() ~=nil and entities.GetLocalPlayer():IsAlive() then

		local AwpDtEnable = gui.GetValue("rbot.accuracy.weapon.sniper.doublefire")
		local Ssg08DtEnable = gui.GetValue("rbot.accuracy.weapon.scout.doublefire")
		local PistolDtEnable = gui.GetValue("rbot.accuracy.weapon.pistol.doublefire")
		local AutoDtEnable = gui.GetValue("rbot.accuracy.weapon.asniper.doublefire")
		local HeavypistolDtEnable = gui.GetValue("rbot.accuracy.weapon.hpistol.doublefire")
		local SmgDtEnable = gui.GetValue("rbot.accuracy.weapon.smg.doublefire")
		local RifleDtEnable = gui.GetValue("rbot.accuracy.weapon.rifle.doublefire")
		local ShotgunDtEnable = gui.GetValue("rbot.accuracy.weapon.shotgun.doublefire")
		local Lightmgenable = gui.GetValue("rbot.accuracy.weapon.lmg.doublefire")
	    local Knifeenable = gui.GetValue("rbot.accuracy.weapon.knife.doublefire")

        wclass = get_active_gun()

		if wclass=="pistol" and (PistolDtEnable==1 or PistolDtEnable==2)  then
			is_dt_on = true
		elseif wclass=="hpistol" and (HeavypistolDtEnable==1 or HeavypistolDtEnable==2) then
			is_dt_on = true
		elseif wclass=="smg" and (SmgDtEnable==1 or SmgDtEnable==2) then
			is_dt_on = true
		elseif wclass=="sniper" and (AwpDtEnable==1 or AwpDtEnable==2) then
			is_dt_on = true
		elseif wclass=="scout" and (Ssg08DtEnable==1 or Ssg08DtEnable==2) then
			is_dt_on = true
		elseif wclass=="rifle" and (RifleDtEnable==1 or RifleDtEnable==2) then
			is_dt_on = true
		elseif wclass=="shotgun" and (ShotgunDtEnable==1 or ShotgunDtEnable==2) then
			is_dt_on = true
		elseif wclass=="asniper" and (AutoDtEnable==1 or AutoDtEnable==2) then
			is_dt_on = true
		elseif wclass=="lmg" and (Lightmgenable==1 or Lightmgenable==2) then
			is_dt_on = true
        elseif (Knifeenable==1 or Knifeenable==2) then
			is_dt_on = true
		else
			is_dt_on = false
		end
		return(is_dt_on)
	end
end

function dt_mode()
	if entities.GetLocalPlayer() ~=nil and entities.GetLocalPlayer():IsAlive() then

		if not dt_enabled() then
			return(0)
		end  	
    
		local AwpDtEnable = gui.GetValue("rbot.accuracy.weapon.sniper.doublefire")
		local Ssg08DtEnable = gui.GetValue("rbot.accuracy.weapon.scout.doublefire")
		local PistolDtEnable = gui.GetValue("rbot.accuracy.weapon.pistol.doublefire")
		local AutoDtEnable = gui.GetValue("rbot.accuracy.weapon.asniper.doublefire")
		local HeavypistolDtEnable = gui.GetValue("rbot.accuracy.weapon.hpistol.doublefire")
		local SmgDtEnable = gui.GetValue("rbot.accuracy.weapon.smg.doublefire")
		local RifleDtEnable = gui.GetValue("rbot.accuracy.weapon.rifle.doublefire")
		local ShotgunDtEnable = gui.GetValue("rbot.accuracy.weapon.shotgun.doublefire")
		local Lightmgenable = gui.GetValue("rbot.accuracy.weapon.lmg.doublefire")
	    local Knifeenable = gui.GetValue("rbot.accuracy.weapon.knife.doublefire")
 
        wclass = get_active_gun()

		if wclass == "pistol" and (PistolDtEnable == 1) or wclass == "hpistol" and (HeavypistolDtEnable == 1) or wclass == "smg" and (SmgDtEnable == 1) or wclass == "sniper" and (AwpDtEnable == 1) or wclass == "scout" and (Ssg08DtEnable == 1) or wclass == "rifle" and (RifleDtEnable == 1) or wclass == "shotgun" and (ShotgunDtEnable == 1) or wclass == "asniper" and (AutoDtEnable == 1) or wclass == "lmg" and (Lightmgenable == 1) or wclass == "knife" and (Knifeenable == 1) then
			doubletap_mode = 1 
		else
			doubletap_mode = 2 
		end
		return(doubletap_mode)
	end
end


function get_aa_text()
	local rage_aa = RageAAcheckbox:GetValue()
	local hubert_aa = LogicCheckbox:GetValue()
	local jitter = JitterRageCheckbox:GetValue() 	
	local freestanding = FreestandRageCheckbox:GetValue()
	
	aa_text = "aimware aa"

	if rage_aa and not hubert_aa then
		if jitter then
			if LowDeltaCheckbox:GetValue() then
				aa_text = "jitter low"
			elseif HalfDeltaCheckbox:GetValue() then
				aa_text = "jitter half"
			else
				aa_text = "jitter max"
			end
		else
			if freestanding then
				if LowDeltaCheckbox:GetValue() then
					aa_text = "freestand low"
				elseif HalfDeltaCheckbox:GetValue() then
					aa_text = "freestand half"
				else
					aa_text = "freestand max"
				end
			else
				if LowDeltaCheckbox:GetValue() then
					aa_text = "normal low"
				elseif HalfDeltaCheckbox:GetValue() then
					aa_text = "normal half"
				else
					aa_text = "normal max"
				end
			end
		end
	elseif hubert_aa then
		aa_text = "hubert aa"
	end
	return aa_text
end


function get_dt_text()
	if not dt_enabled() then
		return ""
	end

	local hs_enabled = gui.GetValue("rbot.antiaim.condition.shiftonshot")

	dt_text = ""

	if hs_enabled then
		if dt_mode() == 1 then 
			dt_text = "defensive dt | slow"
		elseif dt_mode() == 2 then
			dt_text = "offensive dt | slow"
		end
	else
		if dt_mode() == 1 then
			dt_text = "defensive dt"
		elseif dt_mode() == 2 then
			dt_text = "offensive dt"
		end
	end
	return dt_text
end

function get_mindmg()
	if entities.GetLocalPlayer() ~=nil and entities.GetLocalPlayer():IsAlive() then

		local AwpMinDmg = gui.GetValue("rbot.accuracy.weapon.sniper.mindmg")
		local SsgMinDmg = gui.GetValue("rbot.accuracy.weapon.scout.mindmg")
		local PistolMinDmg = gui.GetValue("rbot.accuracy.weapon.pistol.mindmg")
		local AutoMinDmg = gui.GetValue("rbot.accuracy.weapon.asniper.mindmg")
		local HeavypistolMinDmg = gui.GetValue("rbot.accuracy.weapon.hpistol.mindmg")
		local SmgMinDmg = gui.GetValue("rbot.accuracy.weapon.smg.mindmg")
		local RifleMinDmg = gui.GetValue("rbot.accuracy.weapon.rifle.mindmg")
		local ShotgunMinDmg = gui.GetValue("rbot.accuracy.weapon.shotgun.mindmg")
		local LightmgMinDmg = gui.GetValue("rbot.accuracy.weapon.lmg.mindmg")

        wclass = get_active_gun()

		if wclass=="pistol" then
			min_dmg = PistolMinDmg
		elseif wclass=="hpistol"  then
	        min_dmg = HeavypistolMinDmg
		elseif wclass=="smg"  then
            min_dmg = SmgMinDmg
		elseif wclass=="sniper" then
			min_dmg = AwpMinDmg
		elseif wclass=="scout"  then
			min_dmg = SsgMinDmg
		elseif wclass=="rifle"  then
			min_dmg = RifleMinDmg
		elseif wclass=="shotgun" then
			min_dmg = ShotgunMinDmg
		elseif wclass=="asniper" then
			min_dmg = AutoMinDmg
		elseif wclass=="lmg" then
			min_dmg = LightmgMinDmg   
		else
			min_dmg = 0
		end
		return(min_dmg)
	end
end

--DRAW--

callbacks.Register("Draw", function()
	if not IndicatorsCheckbox:GetValue() then
		return
	end
    
    if not entities.GetLocalPlayer() ~=nil and not entities.GetLocalPlayer():IsAlive() then
        return
	end

	local width,height = draw.GetScreenSize()

	local hs = gui.GetValue("rbot.antiaim.condition.shiftonshot")

	local offset = 15
	local offset2 = 0

	draw.Color(110, 103, 214, 255)
	draw.Text(width / 2 - (string.len(get_aa_text()) * 3), height / 2 + 10, get_aa_text())

	if dt_enabled() then
		draw.Color(49, 204, 67, 255)
		draw.Text(width / 2 - (string.len(get_dt_text()) * 3), height / 2 + 10 + offset, get_dt_text())
		offset2 = 15
	elseif hs then
		draw.Color(49, 204, 67, 255)
		draw.Text(width / 2 - (string.len("hideshots") * 3), height / 2 + 10 + offset, "hideshots")
		offset2 = 15
	else
		offset2 = 0
	end 

	local mindmg = tostring(get_mindmg())

	if get_mindmg() == 0 then
		mindmg = ""
	end

	draw.Color(214, 103, 146, 255)
	draw.Text(width / 2 - (string.len(mindmg) * 3), height/2 + 10 + offset + offset2, mindmg)
end)

--AA ARROWS--

callbacks.Register("Draw", function()
	is_manual_left = ManualLeftCheckbox:GetValue() 
	is_manual_right = ManualRightCheckbox:GetValue() 
	is_manual_forward = ManualForwardCheckbox:GetValue() 

	if not AAarrowsCheckbox:GetValue() then
		return
	end
    
	if not entities.GetLocalPlayer() ~=nil and not entities.GetLocalPlayer():IsAlive() then
        return
	end

	local width,height = draw.GetScreenSize()
	local offset_to_center = 45

	local red = math.sin(globals.RealTime() * 4) * 127 + 128;
	local green = math.sin(globals.RealTime() * 4 + 2) * 127 + 128;
	local blue = math.sin(globals.RealTime() * 4 + 4) * 127 + 128;

	draw.Color(red,green,blue, 255)

	if is_manual_left then
		draw.Triangle(width / 2 - offset_to_center, height / 2 - 10, width / 2 - offset_to_center, height / 2 + 10, width / 2 - offset_to_center - 20, height / 2)
	elseif is_manual_right then
		draw.Triangle(width / 2 + offset_to_center, height / 2 - 10, width / 2 + offset_to_center, height / 2 + 10, width / 2 + offset_to_center + 20, height / 2)
	elseif is_manual_forward then
		draw.Triangle(width / 2 - 10, height / 2 - offset_to_center, width / 2 + 10, height / 2 - offset_to_center, width / 2, height / 2 - offset_to_center - 20)
	end
end)

--INVERT INDICATOR--

callbacks.Register("Draw", function()

	if not InvertIndicatorCheckbox:GetValue() then
		return
	end

	if not RageAAcheckbox:GetValue() and not LegitAAcheckbox:GetValue() then
		return
	end
    
	if not entities.GetLocalPlayer() ~=nil and not entities.GetLocalPlayer():IsAlive() then
        return
	end

	local side = 0

	if not RageAAcheckbox:GetValue() and not LegitAAonEcheckbox:GetValue() and LegitAAcheckbox:GetValue() then 
		if not FreestandCheckbox:GetValue() and not JitterCheckbox:GetValue() then
			if gui.GetValue("rbot.antiaim.base.rotation") >= 1 then
				side = 1
			elseif gui.GetValue("rbot.antiaim.base.rotation") <= -1 then
				side = -1
			end     
		end
	end

	if RageAAcheckbox:GetValue() then 
		if not FreestandRageCheckbox:GetValue() and not JitterRageCheckbox:GetValue() then
			if gui.GetValue("rbot.antiaim.base.rotation") >= 1 then
				side = 1
			elseif gui.GetValue("rbot.antiaim.base.rotation") <= -1 then
				side = -1
			end     
		end
	end

	local width,height = draw.GetScreenSize()
	local offset_to_center = 40

	local red = math.sin(globals.RealTime() * 4) * 127 + 128;
	local green = math.sin(globals.RealTime() * 4 + 2) * 127 + 128;
	local blue = math.sin(globals.RealTime() * 4 + 4) * 127 + 128;

	draw.Color(red,green,blue, 255)

	if side == 1 then
		draw.FilledRect(width / 2 + offset_to_center, height / 2 - 10, width / 2 + offset_to_center + 4, height / 2 + 10)
	elseif side == -1 then
		draw.FilledRect(width / 2 - offset_to_center, height / 2 - 10, width / 2 - offset_to_center + 4, height / 2 + 10)
	end
end)

--WATERMARK--

callbacks.Register("Draw", function()
	if not WatermarkCheckbox:GetValue() then
		return
	end

    text = "aimware.net | hubertlua"
    
    textlen = string.len(text) * 7

	local width,height = draw.GetScreenSize()
    
	local red = math.sin(globals.RealTime() * 4) * 127 + 128;
	local green = math.sin(globals.RealTime() * 4 + 2) * 127 + 128;
	local blue = math.sin(globals.RealTime() * 4 + 4) * 127 + 128;

	--top
	draw.Color(red, green, blue, 255)
	draw.FilledRect(width - textlen - 18, 8, width - 18, 10)
	
	--bottom
	draw.Color(red, green, blue, 255)
	draw.FilledRect(width - textlen - 18, textlen / 6 + 3, width - 18, textlen / 6 + 5)
	
    --left
	draw.Color(red, green, blue, 255)
	draw.FilledRect(width - textlen - 20, 8, width - 18, textlen / 6 + 5)

	--right
	draw.Color(red, green, blue, 255)
	draw.FilledRect(width - 18, 8, width - 16, textlen / 6 + 5)
	
	--background
	draw.Color(30, 30, 30, 255)
    draw.FilledRect(width - textlen - 18, 10, width - 18, textlen / 6 + 3)
	
	--text
	draw.Color(red, green, blue, 255)
	draw.Text(width - textlen - 13, 14, text)

end)
