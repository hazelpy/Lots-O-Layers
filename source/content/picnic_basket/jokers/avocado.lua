SMODS.Joker {
    key = "avocado",
    lol_bundle = "picnic_basket",
    lol_art_credit = "Ginger",
    lol_code_credit = "Lizzie",

    atlas = "picnic_FoodJokers",
    pos = { x = 2, y = 0 },
    rarity = 2,
    cost = 6,

    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,

    config = { extra = { card_count = 3 } },
    loc_vars = function (self, info_queue, card)
        -- TODO: vars
    end,

    calculate = function (self, card, context)
        -- TODO: effect
    end
}

return {
    en_us = {
        type = "descriptions",
        set  = "Joker",
        key  = "j_lots_avocado",
        data = {
            name = "Avocado",
            text = {
                "{C:inactive}Placeholder description"
            }
        }
    }
}