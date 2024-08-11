if SERVER then
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mut.vmt")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mut1.png")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mut2.png")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mut3.png")
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mut4.png")
end

--heal timer that sets the time to the current time plus the number of seconds we want to wait
heal_time = (CurTime() + GetConVar("ttt2_mut_healing_interval"):GetInt())

--Think hook that iterates through players
--Heals each mutant every time we need to
hook.Add("Think","MutHealThink", function()
	if GetRoundState() ~= ROUND_ACTIVE then return end
	if heal_time > CurTime() then return end
	for _, ply in ipairs( player.GetAll() ) do
		if not ply:Alive() or ply:IsSpec() then continue end
		if ply:GetSubRole() ~= ROLE_MUTANT then continue end
		if ply:Health() <= ply:GetMaxHealth() - GetConVar("ttt2_mut_healing_amount"):GetInt() then
			ply:SetHealth(ply:Health()+ GetConVar("ttt2_mut_healing_amount"):GetInt())
		else 
			ply:SetHealth(ply:GetMaxHealth())
		end
	end
	heal_time = (CurTime() + GetConVar("ttt2_mut_healing_interval"):GetInt())
end) 