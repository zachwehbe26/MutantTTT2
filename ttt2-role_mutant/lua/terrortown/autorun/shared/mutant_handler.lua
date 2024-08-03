MUTANT_DATA = {}
MUTANT_DATA.damage_taken = 0

--Transforming statuses go here
if CLIENT then
	hook.Add("Initialize", "ttt2_mut_init", function()
		
		STATUS:RegisterStatus("ttt2_mut1_icon", {
			hud = Material("vgui/ttt/icons/icon_mut1.png"),
			type = "good",
			name = "Mutant",
			sidebarDescription = "status_mut2_icon"
		})
		
		STATUS:RegisterStatus("ttt2_mut2_icon", {
			hud = Material("vgui/ttt/icons/icon_mut2.png"),
			type = "good",
			name = "Mutant",
			sidebarDescription = "status_mut2_icon"
		})
		
		STATUS:RegisterStatus("ttt2_mut3_icon", {
			hud = Material("vgui/ttt/icons/icon_mut3.png"),
			type = "good",
			name = "Mutant",
			sidebarDescription = "status_mut3_icon"
		})
		
		STATUS:RegisterStatus("ttt2_mut4_icon", {
			hud = Material("vgui/ttt/icons/icon_mut4.png"),
			type = "good",
			name = "Mutant",
			sidebarDescription = "status_mut4_icon"
		})
		
	end)
end

--------------------------------

--Getters and Setters
function MUTANT_DATA:AddDamage(dmgTaken)
	self.damage_taken = self.damage_taken + dmgTaken
end

function MUTANT_DATA:GetDamage()
	return self.damage_taken
end

function MUTANT_DATA:ResetDamage()
	MUTANT_DATA.damage_taken = 0
end

--functions
function computeBuffs()
--iterate through players, find mutant
	if MUTANT_DATA:GetDamage() < 50 then return end
	for _, ply in ipairs( player.GetAll() ) do
		-- check if player is valid
		if not IsValid(ply) then return end
		-- check if player is mutant
		if ply:GetSubRole() == ROLE_MUTANT then
			mutant_ply = ply
		end
	end
	--Give buffs and status depending on damage taken
	if MUTANT_DATA:GetDamage() >= 50 and not mutant_ply:HasEquipmentItem("item_ttt_radar") then
		mutant_ply:GiveEquipmentItem("item_ttt_radar")
		PrintMessage(HUD_PRINTTALK, "50 Damage Taken! You now have a radar.")
		if MUTANT_DATA:GetDamage() <= 74 then
			STATUS:RemoveStatus(mutant_ply, "ttt2_mut1_icon")
			STATUS:AddStatus(mutant_ply, "ttt2_mut2_icon", false)
		end
	end
	if MUTANT_DATA:GetDamage() >= 75 and mutant_ply:GetMaxHealth() <= 100 then
		mutant_ply:SetMaxHealth(150)
		PrintMessage(HUD_PRINTTALK, "75 Damage Taken! You now have 150 max health")
		if MUTANT_DATA:GetDamage() <= 99 then
			STATUS:RemoveStatus(mutant_ply, "ttt2_mut1_icon")
			STATUS:RemoveStatus(mutant_ply, "ttt2_mut2_icon")
			STATUS:AddStatus(mutant_ply, "ttt2_mut3_icon", false)
		end
	end
	if MUTANT_DATA:GetDamage() >= 100 and not mutant_ply:HasEquipmentItem("item_mut_speed") then
		mutant_ply:GiveItem("item_mut_speed")
		PrintMessage(HUD_PRINTTALK, "100 Damage Taken! You are faster.")
		STATUS:RemoveStatus(mutant_ply, "ttt2_mut1_icon")
		STATUS:RemoveStatus(mutant_ply, "ttt2_mut2_icon")
		STATUS:RemoveStatus(mutant_ply, "ttt2_mut3_icon")
		STATUS:AddStatus(mutant_ply, "ttt2_mut4_icon", false)
	end
	--for every 10 dmg the mutant takes after taking 100 damage, increase its health by 1
	if mutant_ply:HasEquipmentItem("item_mut_speed") then
		if(MUTANT_DATA:GetDamage() - 100) / 10 >= 1 then 
			local computeNewHealth = math.floor(150 + (MUTANT_DATA:GetDamage() - 100) / 10)
			PrintMessage(HUD_PRINTTALK, "Max Health increased by " .. (computeNewHealth - mutant_ply:GetMaxHealth()))
			mutant_ply:SetMaxHealth(computeNewHealth)
		end
	end
end