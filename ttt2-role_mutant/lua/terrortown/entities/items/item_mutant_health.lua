if SERVER then
    AddCSLuaFile()
end

ITEM.EquipMenuData = {
    type = "item_passive",
    name = "title_item_mutant_health",
    desc = "desc_item_mutant_health",
}

ITEM.material = "vgui/ttt/icon_mutant_health"
ITEM.CanBuy = { ROLE_MUTANT }
ITEM.limited = false

if SERVER then
    ---
    -- @ignore
    function ITEM:Equip(buyer)
        buyer:SetMaxHealth(buyer:GetMaxHealth()+10)
    end
end
