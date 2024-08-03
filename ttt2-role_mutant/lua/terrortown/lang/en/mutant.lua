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