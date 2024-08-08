MUTANT_DATA = {}
if CLIENT then
	MUTANT_DATA.damage_taken = 0
end
MUTANT_DATA.heal_time = (CurTime() + GetConVar("ttt2_mut_healing_interval"):GetInt())
--Table of all mutant players


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

-- function MUTANT_DATA:ResetTable()
	-- MUTANT_DATA.mutant_players = {}
-- end

--functions
--pass in mutant player from the the entity take damage hook as a target
function computeBuffs(mutant_ply)
	-- PrintTable(MUTANT_DATA.mutant_players)
	if MUTANT_DATA:GetDamage() >= 50 and not mutant_ply:HasEquipmentItem("item_ttt_radar") then
		mutant_ply:GiveEquipmentItem("item_ttt_radar")
		mutant_ply:PrintMessage(HUD_PRINTTALK, "50 Damage Taken! You now have a radar.")
		if MUTANT_DATA:GetDamage() <= 74 then
			STATUS:RemoveStatus(mutant_ply, "ttt2_mut1_icon")
			STATUS:AddStatus(mutant_ply, "ttt2_mut2_icon", false)
		end
	end
	if MUTANT_DATA:GetDamage() >= 75 and mutant_ply:GetMaxHealth() <= 100 then
		mutant_ply:SetMaxHealth(150)
		mutant_ply:PrintMessage(HUD_PRINTTALK, "75 Damage Taken! You now have 150 max health")
		if MUTANT_DATA:GetDamage() <= 99 then
			STATUS:RemoveStatus(mutant_ply, "ttt2_mut1_icon")
			STATUS:RemoveStatus(mutant_ply, "ttt2_mut2_icon")
			STATUS:AddStatus(mutant_ply, "ttt2_mut3_icon", false)
		end
	end
	if MUTANT_DATA:GetDamage() >= 100 and not mutant_ply:HasEquipmentItem("item_mut_speed") then
		mutant_ply:GiveItem("item_mut_speed")
		mutant_ply:PrintMessage(HUD_PRINTTALK, "100 Damage Taken! You are faster.")
		STATUS:RemoveStatus(mutant_ply, "ttt2_mut1_icon")
		STATUS:RemoveStatus(mutant_ply, "ttt2_mut2_icon")
		STATUS:RemoveStatus(mutant_ply, "ttt2_mut3_icon")
		STATUS:AddStatus(mutant_ply, "ttt2_mut4_icon", false)
	end
	--for every 10 dmg the mutant takes after taking 100 damage, increase its health by 1
	if mutant_ply:HasEquipmentItem("item_mut_speed") then
		if(MUTANT_DATA:GetDamage() - 100) / 10 >= 1 then 
			local computeNewHealth = math.floor(150 + (MUTANT_DATA:GetDamage() - 100) / 10)
			mutant_ply:PrintMessage(HUD_PRINTTALK, "Max Health increased by " .. (computeNewHealth - mutant_ply:GetMaxHealth()))
			mutant_ply:SetMaxHealth(computeNewHealth)
		end
	end
end

hook.Add("EntityTakeDamage", "ttt2_mut_damage_taken", function(target,dmginfo)
	if not IsValid(target) or not target:IsPlayer() then return end
	if not (target:GetRoleString() == "mutant") then return end
	local dmgtaken =  dmginfo:GetDamage()
	--End function if damage is fire and/or explosive with cvar
	if not GetConVar("ttt2_mut_firedmg"):GetBool() and dmginfo:IsDamageType( 8 ) then return end
	if not GetConVar("ttt2_mut_explosivedmg"):GetBool() and dmginfo:IsDamageType( 64 ) then return end
	--print("Ow!!" .. dmgtaken)
	--round float to nearest integer
	dmgtaken = math.floor(dmgtaken + 0.5)
	MUTANT_DATA:AddDamage(dmgtaken)
	target:PrintMessage(HUD_PRINTTALK, "Total Dmg: " .. MUTANT_DATA:GetDamage())
	computeBuffs(target)
end)


hook.Add("Think","MutHealThink", function()
	if GetRoundState() ~= ROUND_ACTIVE then return end
	for _, ply in ipairs( player.GetAll() ) do
		if not ply:Alive() or ply:IsSpec() then continue end
		if ply:GetSubRole() == ROLE_MUTANT then
			if MUTANT_DATA.heal_time <= CurTime() then
			if ply:Health() <= ply:GetMaxHealth() - GetConVar("ttt2_mut_healing_amount"):GetInt() then
				ply:SetHealth(ply:Health()+ GetConVar("ttt2_mut_healing_amount"):GetInt())
				MUTANT_DATA.heal_time = (CurTime() + GetConVar("ttt2_mut_healing_interval"):GetInt())
			else 
				ply:SetHealth(ply:GetMaxHealth())
			end
		end
		end
	end
end) 

hook.Add("TTTBeginRound", "MutantBeginRound", function()
    MUTANT_DATA:ResetDamage()
end)

hook.Add("TTTEndRound", "MutantEndRound", function()
	MUTANT_DATA:ResetDamage()
end)