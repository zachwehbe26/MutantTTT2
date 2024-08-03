local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[MUTANT.name] = "Mutant"
L["info_popup_" .. PATIENT.name] = [[]]
L["body_found_" .. PATIENT.abbr] = "They were a Mutant."
L["search_role_" .. PATIENT.abbr] = "This person was a Mutant!"
L["target_" .. PATIENT.name] = "Mutant"
L["ttt2_desc_" .. PATIENT.name] = [[You are the Mutant! You regen health and get buffs the more damage you take!]]

--CONVAR LANGUAGE STRINGS
L["label_mut_healing_interval"] = "How often the mutant heals(in seconds): "
L["label_mut_healing_amount"] = "How much the mutant heals for: "
L["label_mut_speed_multiplier"] = "The speed multiplier after taking 100 damage: "
L["label_mut_env_damage"] = "Should the mutant take environmental damage: "

L["status_mut1_icon"] = "Take damage to receive buffs!"
L["status_mut2_icon"] = "You have taken 50 damage and received a radar!"
L["status_mut3_icon"] = "You have taken 75 damage and received a health buff!"
L["status_mut4_icon"] = "You have taken 100 damage and received a speed buff! For every 10 damage, gain 1 hp."