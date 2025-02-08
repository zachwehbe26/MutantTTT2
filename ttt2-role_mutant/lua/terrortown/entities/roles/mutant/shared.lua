if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("SendMutantDamage")
end

function ROLE:PreInitialize()
	self.color = Color(0, 101, 51, 255)

	self.abbr = "mut" -- abbreviation

	self.score.killsMultiplier = 2
	self.score.teamKillsMultiplier = -8
	self.unknownTeam = true

	self.defaultTeam = TEAM_INNOCENT

	self.conVarData = {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 6, -- minimum amount of players until this role is able to get selected
		credits = 0, -- the starting credits of a specific role
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 33,
		traitorButton = 0, -- can use traitor buttons
		shopFallback = SHOP_DISABLED
	}
end

-- now link this subrole with its baserole
function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_INNOCENT)
end

if SERVER then
	 -- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		if not GetConVar("ttt2_mut_firedmg"):GetBool() then
			ply:GiveEquipmentItem("item_ttt_nofiredmg")
		end
		if not GetConVar("ttt2_mut_explosivedmg"):GetBool() then
			ply:GiveEquipmentItem("item_ttt_noexplosiondmg")
		end
		if not GetConVar("ttt2_mut_falldmg"):GetBool() then
			ply:GiveEquipmentItem("item_ttt_nofalldmg")
		end
		if not GetConVar("ttt2_mut_propdmg"):GetBool() then
			ply:GiveEquipmentItem("item_ttt_nopropdmg")
		end
		--Give mutant the default status
		STATUS:AddStatus(ply, "ttt2_mut1_icon", false)
		STATUS:AddStatus(ply, "ttt2_mut_regen", false)
		ply.mutant_damage_taken = 0
		ply.mutant_credits_awarded = 0
		MutantSendDamageTaken(ply,0)
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		if not GetConVar("ttt2_mut_firedmg"):GetBool() then
			ply:RemoveEquipmentItem("item_ttt_nofiredmg")
		end
		if not GetConVar("ttt2_mut_explosivedmg"):GetBool() then
			ply:RemoveEquipmentItem("item_ttt_noexplosiondmg")
		end
		if not GetConVar("ttt2_mut_falldmg"):GetBool() then
			ply:RemoveEquipmentItem("item_ttt_nofalldmg")
		end
		if not GetConVar("ttt2_mut_propdmg"):GetBool() then
			ply:RemoveEquipmentItem("item_ttt_nopropdmg")
		end
		if not GetConVar("ttt2_mut_shop"):GetBool() then
			ply:RemoveEquipmentItem("item_ttt_radar")
			ply:RemoveItem("item_mut_speed")
		end
		ply:SetMaxHealth(100)

		timer.Remove("ttt2_mut_regen_timer")
		STATUS:RemoveStatus(ply, "ttt2_mut1_icon")
		STATUS:RemoveStatus(ply, "ttt2_mut2_icon")
		STATUS:RemoveStatus(ply, "ttt2_mut3_icon")
		STATUS:RemoveStatus(ply, "ttt2_mut4_icon")
		STATUS:RemoveStatus(ply, "ttt2_mut_regen")
		STATUS:RemoveStatus(ply, "ttt2_mut_maxhp")
		ply.mutant_damage_taken = 0
		ply.mutant_credits_awarded = 0
		MutantSendDamageTaken(ply,0)
	end
		function MutantSendDamageTaken(mutant_ply, mutant_damage_taken)
		print("Mutant Receive Damage: " .. mutant_damage_taken)
		net.Start("SendMutantDamage")
		net.WriteInt(mutant_damage_taken or 0, 32) -- Send the number (32-bit signed integer)
		net.Send(mutant_ply)
		end
end


--does the math to determine what buffs to give, and what status to give
local function MutantComputeBuffs(mutant_ply)

	local mutant_damage_taken = mutant_ply.mutant_damage_taken
	if GetConVar("ttt2_mut_shop"):GetBool() then
		local mutant_credits_awarded = mutant_ply.mutant_credits_awarded
		while mutant_damage_taken >= GetConVar("ttt2_mut_damage_per_credit"):GetInt() * (1 + mutant_credits_awarded) do
			if mutant_credits_awarded < GetConVar("ttt2_mut_max_credits"):GetInt() then
				mutant_ply:AddCredits(1)
				mutant_ply:PrintMessage(HUD_PRINTTALK, GetConVar("ttt2_mut_damage_per_credit"):GetInt() .. " Damage Taken! You earned 1 credit.")
			else
				mutant_ply:PrintMessage(HUD_PRINTTALK, GetConVar("Credit limit reached!"))
			end
			mutant_credits_awarded = mutant_credits_awarded + 1
			mutant_ply.mutant_credits_awarded = mutant_credits_awarded
			--Update dmg status
			if (1 + mutant_credits_awarded) > 4 then return end
			STATUS:AddStatus(mutant_ply, "ttt2_mut" .. (1 + mutant_credits_awarded) .. "_icon",false)
			STATUS:RemoveStatus(mutant_ply, "ttt2_mut" .. mutant_credits_awarded .. "_icon")
		end
		return
	end

	if mutant_damage_taken >= 50 and not mutant_ply:HasEquipmentItem("item_ttt_radar") then
		mutant_ply:GiveEquipmentItem("item_ttt_radar")
		mutant_ply:PrintMessage(HUD_PRINTTALK, "50 Damage Taken! You now have a radar.")
		if mutant_damage_taken <= 74 then
			STATUS:RemoveStatus(mutant_ply, "ttt2_mut1_icon")
			STATUS:AddStatus(mutant_ply, "ttt2_mut2_icon", false)
		end
	end
	if mutant_damage_taken >= 75 and mutant_ply:GetMaxHealth() <= 100 then
		mutant_ply:SetMaxHealth(150)
		mutant_ply:PrintMessage(HUD_PRINTTALK, "75 Damage Taken! You now have 150 max health")
		STATUS:AddStatus(mutant_ply, "ttt2_mut_maxhp", false)
		if mutant_damage_taken <= 99 then
			STATUS:RemoveStatus(mutant_ply, "ttt2_mut1_icon")
			STATUS:RemoveStatus(mutant_ply, "ttt2_mut2_icon")
			STATUS:AddStatus(mutant_ply, "ttt2_mut3_icon", false)
		end
	end
	if mutant_damage_taken >= 100 and not mutant_ply:HasEquipmentItem("item_mut_speed") then
		mutant_ply:GiveItem("item_mut_speed")
		mutant_ply:PrintMessage(HUD_PRINTTALK, "100 Damage Taken! You are faster.")
		STATUS:RemoveStatus(mutant_ply, "ttt2_mut1_icon")
		STATUS:RemoveStatus(mutant_ply, "ttt2_mut2_icon")
		STATUS:RemoveStatus(mutant_ply, "ttt2_mut3_icon")
		STATUS:AddStatus(mutant_ply, "ttt2_mut4_icon", false)
	end
	--for every 10 dmg the mutant takes after taking 100 damage, increase its health by 1
	if mutant_ply:HasEquipmentItem("item_mut_speed") and ((mutant_damage_taken - 100) / 10 >= 1) then
		local computeNewHealth = math.floor(150 + (mutant_damage_taken - 100) / 10)
		mutant_ply:PrintMessage(HUD_PRINTTALK, "Max Health increased by " .. (computeNewHealth - mutant_ply:GetMaxHealth()))
		mutant_ply:SetMaxHealth(computeNewHealth)
	end
end

if CLIENT then
		net.Receive("SendMutantDamage", function()
				local mutant_damage_taken = net.ReadInt(32) -- Receive the number and set the variable
		LocalPlayer().mutant_damage_taken = mutant_damage_taken
		end)
end

--calls this hook when someone takes damage
--if the player that took damage is the mutant, only add damage to that player, then run the compute buffs function
hook.Add("EntityTakeDamage", "ttt2_mut_damage_taken", function(target,dmginfo)
	if not IsValid(target) or not target:IsPlayer() then return end
	if target:GetSubRole() ~= ROLE_MUTANT then return end

	local attacker = dmginfo:GetAttacker()
	if IsValid(attacker) and attacker:IsPlayer() and (
		attacker:GetSubRole() == ROLE_DEFECTOR
		or attacker:GetSubRole() == ROLE_JESTER
	) then return end

	--If we have the right resistance item, we are not counting this damage.
	if dmginfo:IsDamageType(DMG_BLAST) and target:HasEquipmentItem("item_ttt_noexplosiondmg") then return end
	if dmginfo:IsDamageType(DMG_FALL) and target:HasEquipmentItem("item_ttt_nofalldmg") then return end
	if dmginfo:IsDamageType(DMG_DROWN) and target:HasEquipmentItem("item_ttt_nodrowningdmg") then return end
	if dmginfo:IsDamageType(DMG_CRUSH) and target:HasEquipmentItem("item_ttt_nopropdmg") then return end
	if dmginfo:IsDamageType(DMG_BURN) and target:HasEquipmentItem("item_ttt_nofiredmg") then return end
	if dmginfo:IsDamageType(DMG_SHOCK + DMG_SONIC + DMG_ENERGYBEAM + DMG_PHYSGUN + DMG_PLASMA)	and target:HasEquipmentItem("item_ttt_noenergydmg") then return end
	if dmginfo:IsDamageType(DMG_POISON + DMG_NERVEGAS + DMG_RADIATION + DMG_ACID + DMG_DISSOLVE) and target:HasEquipmentItem("item_ttt_nohazarddmg") then return end

	local dmgtaken = dmginfo:GetDamage()
	if GetConVar("ttt2_mut_attribute_plydmg_only"):GetBool() and ((not dmginfo:GetAttacker():IsPlayer()) or (dmginfo:GetAttacker() == target)) then return end --If damage is not from another player or is the mutant, do not add to damage

	--round float to nearest integer
	dmgtaken = math.floor(dmgtaken + 0.5)
	target.mutant_damage_taken = target.mutant_damage_taken + dmgtaken
	--target:PrintMessage(HUD_PRINTTALK, "Total Dmg: " .. target.mutant_damage_taken)
	MutantSendDamageTaken(target, target.mutant_damage_taken)
	MutantComputeBuffs(target)
	--no healing for 5 seconds after taking damage
	mutant_heal_time = (CurTime() + 5)
	STATUS:AddTimedStatus(target, "ttt2_mut_healing_cooldown", 5, true)
	STATUS:RemoveStatus(target, "ttt2_mut_regen")
end)

-- -- -- -- --
-- STATUSES -- 
-- -- -- -- --
if CLIENT then
	hook.Add("Initialize", "ttt2_mut_init", function()
		STATUS:RegisterStatus("ttt2_mut1_icon", {
			hud = Material("vgui/ttt/icons/icon_mut1.png"),
			type = "good",
			DrawInfo = function()
				if LocalPlayer().mutant_damage_taken then
					return math.floor(LocalPlayer().mutant_damage_taken)
				else
					return 0
				end
			end,
			name = "Mutant",
			sidebarDescription = "status_mut1_icon"
		})
		STATUS:RegisterStatus("ttt2_mut2_icon", {
			hud = Material("vgui/ttt/icons/icon_mut2.png"),
			type = "good",
			DrawInfo = function()
				if LocalPlayer().mutant_damage_taken then
					return math.floor(LocalPlayer().mutant_damage_taken)
				else
					return 0
				end
			end,
			name = "Mutant",
			sidebarDescription = "status_mut2_icon"
		})
		STATUS:RegisterStatus("ttt2_mut3_icon", {
			hud = Material("vgui/ttt/icons/icon_mut3.png"),
			type = "good",
			DrawInfo = function()
				if LocalPlayer().mutant_damage_taken then
					return math.floor(LocalPlayer().mutant_damage_taken)
				else
					return 0
				end
			end,
			name = "Mutant",
			sidebarDescription = "status_mut3_icon"
		})
		STATUS:RegisterStatus("ttt2_mut4_icon", {
			hud = Material("vgui/ttt/icons/icon_mut4.png"),
			type = "good",
			DrawInfo = function()
				if LocalPlayer().mutant_damage_taken then
					return math.floor(LocalPlayer().mutant_damage_taken)
				else
					return 0
				end
			end,
			name = "Mutant",
			sidebarDescription = "status_mut4_icon"
		})
		STATUS:RegisterStatus("ttt2_mut_regen", {
			hud = Material("vgui/ttt/icons/regen_mut.png"),
			type = "good",
			DrawInfo = function()
				if GetConVar("ttt2_mut_healing_amount"):GetInt() then
					return "+" .. (math.Round(GetConVar("ttt2_mut_healing_amount"):GetInt() * 100 / GetConVar("ttt2_mut_healing_interval"):GetInt()) / 100) .. "/s"
				else
					return 0
				end
			end,
			name = "Mutant",
			sidebarDescription = "status_mut_regen"
		})
		STATUS:RegisterStatus("ttt2_mut_healing_cooldown", {
			hud = Material("vgui/ttt/icons/regen_mut.png"),
			type = "bad",
			name = "Mutant",
			sidebarDescription = "status_mut_regen_cooldown"
		})
		STATUS:RegisterStatus("ttt2_mut_maxhp", {
			hud = Material("vgui/ttt/icons/hpmax_mut.png"),
			type = "good",
			DrawInfo = function()
				return "+" .. (LocalPlayer():GetMaxHealth() - 100)
			end,
			name = "Mutant",
			sidebarDescription = "status_mut_maxhp"
		})
	end)
end


-- -- -- -- -
-- CONVARS --
-- -- -- -- -
CreateConVar("ttt2_mut_healing_interval", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_healing_amount", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_speed_multiplier", "1.2", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_firedmg", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_explosivedmg", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_falldmg", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_propdmg", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_attribute_plydmg_only", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_shop", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_damage_per_credit", 50, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_max_credits", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY})

--Adds convars to the F1 menu
if CLIENT then
	function ROLE:AddToSettingsMenu(parent)
		local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

		form:MakeSlider({
			serverConvar = "ttt2_mut_healing_interval",
			label = "label_mut_healing_interval",
			min = 1,
			max = 10,
			decimal = 0
	})

	form:MakeSlider({
			serverConvar = "ttt2_mut_healing_amount",
			label = "label_mut_healing_amount",
			min = 1,
			max = 10,
			decimal = 0
	})

	form:MakeSlider({
			serverConvar = "ttt2_mut_speed_multiplier",
			label = "label_mut_speed_multiplier",
			min = 1.0,
			max = 2.0,
			decimal = 2
	})

	form:MakeCheckBox({
			serverConvar = "ttt2_mut_firedmg",
			label = "label_mut_firedmg"
		})

	form:MakeCheckBox({
			serverConvar = "ttt2_mut_explosivedmg",
			label = "label_mut_explosivedmg"
		})

	form:MakeCheckBox({
			serverConvar = "ttt2_mut_falldmg",
			label = "label_mut_falldmg"
		})

	form:MakeCheckBox({
			serverConvar = "ttt2_mut_propdmg",
			label = "label_mut_propdmg"
		})

	form:MakeCheckBox({
			serverConvar = "ttt2_mut_attribute_plydmg_only",
			label = "label_mut_attribute_plydmg_only"
		})

	form:MakeCheckBox({
			serverConvar = "ttt2_mut_shop",
			label = "label_mut_shop"
		})

	form:MakeSlider({
			serverConvar = "ttt2_mut_damage_per_credit",
			label = "label_mut_damage_per_credit",
			min = 1,
			max = 100,
			decimal = 0
	})

	form:MakeSlider({
		serverConvar = "ttt2_mut_max_credits",
		label = "label_mut_max_credits",
		min = 1,
		max = 20,
		decimal = 0
		})
	end
end
