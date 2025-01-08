if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "title_item_mutant_speed",
    desc = "desc_item_mutant_speed",
}
ITEM.CanBuy = { }

ITEM.material = "vgui/ttt/icon_speedrun"
ITEM.builtin = false

hook.Add("TTTPlayerSpeedModifier", "TTT2MutantSpeedrunGood", function(ply, _, _, speedMultiplierModifier)
    if not IsValid(ply) or not ply:HasEquipmentItem("item_mut_speed") then
        return
    end

    speedMultiplierModifier[1] = speedMultiplierModifier[1] * GetConVar("ttt2_mut_speed_multiplier"):GetFloat()
end)