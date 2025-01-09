local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[MUTANT.name] = "Mutant"
L["info_popup_" .. MUTANT.name] = [[]]
L["body_found_" .. MUTANT.abbr] = "They were a Mutant."
L["search_role_" .. MUTANT.abbr] = "This person was a Mutant!"
L["target_" .. MUTANT.name] = "Mutant"
L["ttt2_desc_" .. MUTANT.name] = [[You are the Mutant! You regen health and get buffs the more damage you take!]]

--CONVAR LANGUAGE STRINGS
L["label_mut_healing_interval"] = "How often the mutant heals(in seconds): "
L["label_mut_healing_amount"] = "How much the mutant heals for: "
L["label_mut_speed_multiplier"] = "The speed multiplier after taking 100 damage: "
L["label_mut_firedmg"] = "Mutant receives fire damage"
L["label_mut_explosivedmg"] = "Mutant receives exposive damage"
L["label_mut_falldmg"] = "Mutant receives fall damage"
L["label_mut_propdmg"] = "Mutant receives prop damage"
L["label_mut_attribute_plydmg_only"] = "Mutant damage only attributed by other player damage" 
L["label_mut_shop"] = "Mutant is rewarded credits and has a shop instead of getting buffs directly for damage" 
L["label_mut_damage_per_credit"] = "[Requires Mutant Shop enabled] Damager per credit" 

L["status_mut1_icon"] = "Take damage to receive buffs!"
L["status_mut2_icon"] = "You have taken 50 damage and received a radar!"
L["status_mut3_icon"] = "You have taken 75 damage and received a health buff!"
L["status_mut4_icon"] = "You have taken 100 damage and received a speed buff! For every 10 damage, gain 1 hp."
L["status_mut_regen"] = "You regenerate health every couple seconds..."
L["status_mut_regen_cooldown"] = "You took damage and must wait before regenerating health again."
L["status_mut_maxhp"] = "You have increased your maximum health."


L["title_item_mutant_health"] = "Mutant Health"
L["desc_item_mutant_health"] = "Increase your maximum Health by 10."
L["title_item_mutant_speed"] = "Mutant Speed"
L["desc_item_mutant_speed"] = "Increase your speed by "..math.Round(GetConVar("ttt2_mut_speed_multiplier"):GetFloat()*100).."%,"