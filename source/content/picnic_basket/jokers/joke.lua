SMODS.Joker({
    key = "joke",
    lol_bundle = "picnic_basket",
    lol_art_credit = "Lizzie",
    lol_code_credit = "Lizzie",

    atlas = "picnic_FoodJokers",
    pos = { x = 0, y = 0},
    rarity = 2,
    cost = 6,

    perishable_compat = true,
    eternal_compat = false,

    config = {
        extra = {
            tags = 5
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.tags_remaining ~= 1 and tostring(card.ability.extra.tags_remaining) .. " " or "",
                (card.ability.extra.tags_remaining) ~= 1 and "s" or ""
            }
        }
    end,

    set_ability = function (self, card, initial, delay_sprites)
        card.ability.extra.tags_remaining = card.ability.extra.tags
    end,

    calculate = function (self, card, context)
        if context.using_consumeable then
            if card.ability.extra.tags_remaining > 0 then
                card.ability.extra.tags_remaining = card.ability.extra.tags_remaining - 1
            
                return {
                    func = function(e)
                        add_tag({key = get_next_tag_key(self.key)})
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    
                        return true;
                    end,

                    extra = (card.ability.extra.tags_remaining < 1) and {
                        pre_func = function()
                            SMODS.destroy_cards(card, nil, nil, true)
                            return true;
                        end,
                        
                        message = localize('k_eaten_ex'),
                        colour = G.C.FILTER
                    }
                }
            end
        end
    end
})

return {
    en_us = {
        type = "descriptions",
        set  = "Joker",
        key  = "j_lots_joke",
        data = {
            name = "Joke Can",
            text = {
                "Creates a random {C:attention}Tag",
                "for free when using the",
                "next {C:attention}#1#{}consumable#2#",
            }
        }
    }
}