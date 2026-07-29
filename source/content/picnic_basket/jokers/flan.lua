SMODS.Joker {
    key = "flan",
    lol_bundle = "picnic_basket",
    lol_art_credit = "Incognito",
    lol_code_credit = "Lizzie",

    atlas = "picnic_FoodJokers",
    pos = { x = 1, y = 0 },
    rarity = 2,
    cost = 6,

    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,

    config = { extra = { card_count = 3 } },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra.card_count,
                localize { type = "name_text", set = "Edition", key = "e_negative" }
            }
        }
    end,

    calculate = function (self, card, context)
        if context.selling_self and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function (e)
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    SMODS.calculate_effect({ message = localize('k_eaten_ex'), instant = true }, card)

                    for i = 1, card.ability.extra.card_count do
                        G.E_MANAGER:add_event(Event({
                            func = function(e)
                                local potential_cards = {};
                                
                                for _, _card in ipairs(G.hand.cards) do
                                    if not _card.edition then
                                        potential_cards[#potential_cards+1] = _card
                                    end
                                end

                                if #potential_cards > 0 then
                                    local _card = pseudorandom_element(potential_cards, "lots_flan_card")
                                    local chosen_edition = SMODS.poll_edition { key = "lots_flan_edition", guaranteed = true, no_negative = true };

                                            _card:set_edition(chosen_edition, true)
                                    
                                end

                                return true;
                            end,
                            delay = 0.3,
                            trigger = "after"
                        }))
                    end
                    
                    return true;
                end
            }))
        end
    end
}

return {
    en_us = {
        type = "descriptions",
        set  = "Joker",
        key  = "j_lots_flan",
        data = {
            name = "Flan",
            text = {
                "When sold, applies a random",
                "{C:dark_edition}Edition{} to up to",
                "{C:attention}#1#{} playing cards",
                "held in hand",
                "{C:inactive}({C:dark_edition}#2#{C:inactive} excluded)"
            }
        }
    }
}