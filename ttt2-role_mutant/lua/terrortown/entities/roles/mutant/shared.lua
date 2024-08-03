if SERVER then
	AddCSLuaFile()
	--Resource files here
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mut.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mut1.png")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mut2.png")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mut3.png")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mut4.png")
end

function ROLE:PreInitialize()
  self.color = Color(42, 54, 41, 255)

  self.abbr = "mut" -- abbreviation
  self.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
  self.scoreKillsMultiplier = 2 -- multiplier for kill of player of another team
  self.scoreTeamKillsMultiplier = -8 -- multiplier for teamkill
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
		--Timer that heals player every five seconds
		timer.Create("ttt2_mut_regen_timer", GetConVar("ttt2_mut_healing_interval"):GetInt(), 0, function()
			if ply:Health() <= ply:GetMaxHealth() - GetConVar("ttt2_mut_healing_amount"):GetInt() then
				ply:SetHealth(ply:Health()+ GetConVar("ttt2_mut_healing_amount"):GetInt())
			else
				ply:SetHealth(ply:GetMaxHealth())
			end
		end)
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:SetMaxHealth(100)
		ply:RemoveEquipmentItem("item_ttt_radar")
		ply:RemoveItem("item_mut_speed")
		timer.Remove("ttt2_mut_regen_timer")
	end
end

hook.Add("EntityTakeDamage", "ttt2_mut_damage_taken", function(target,dmginfo)
	if not IsValid(target) or not target:IsPlayer() then return end
	if not (target:GetRoleString() == "mutant") then return end
	local dmgtaken =  dmginfo:GetDamage()
	print("Ow!!" .. dmgtaken)
	--round float to integer
	dmgtaken = math.floor(dmgtaken + 0.5)
	MUTANT_DATA:AddDamage(dmgtaken)
	PrintMessage(HUD_PRINTTALK, "Total Dmg: " .. MUTANT_DATA:GetDamage())
	computeBuffs()
end)


hook.Add("TTTBeginRound", "MutantBeginRound", function()
    MUTANT_DATA:ResetDamage()
end)

hook.Add("TTTEndRound", "MutantEndRound", function()
	MUTANT_DATA:ResetDamage()
end)

CreateConVar("ttt2_mut_healing_interval", 5, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_healing_amount", 5, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_speed_multiplier", "1.2", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_mut_env_damage", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})

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
      serverConvar = "ttt2_mut_env_damage",
      label = "label_mut_env_damage"
    })
  end
end
