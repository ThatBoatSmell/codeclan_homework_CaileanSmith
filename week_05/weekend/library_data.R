library(jsonlite)
library(tidyverse)
library(data.table)

large_list_cards <- jsonlite::fromJSON("yugioh_card_data/_yugioh_card_data.json")
cards <- enframe(unlist(large_list_cards)) 

cards_long <- cards %>% 
  separate_wider_regex(col = name, patterns = c(card_name = "^[A-Za-z0-9\\-]+\\.{1}", element = "[[:print:]]+") , too_few = "align_start")

cards_long <- cards_long %>% mutate(card_name = str_remove(card_name, "[.]"))

cards_wide <- pivot_wider(cards_long, names_from = element, values_from = value)

cards_wide <- cards_wide %>% 
  select(card_name, name, type, desc, race, misc_info.tcg_date, misc_info.ocg_date, ban_status, atk, def, level, attribute, konami_type) %>%
  mutate(atk = as.numeric(atk),
         def = as.numeric(def)) %>%
  mutate(stat_total = atk+def, .after = def) %>%
  rename("tcg_release" = misc_info.tcg_date, "ocg_release" = misc_info.ocg_date) %>%
  mutate(tcg_release = as.Date(tcg_release),
         ocg_release = as.Date(ocg_release))

monsters <- cards_wide %>% 
  select(type) %>% 
  filter(!grepl("Spell Card", type)) %>% 
  filter(!grepl("Trap Card", type))

monster_choices <- unique(monsters)