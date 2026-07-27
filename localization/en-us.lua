local en_us = {
    descriptions = {
        Joker = {},
        Other = {
            lol_reload_popup = {
                text = {
                    "Bundle settings",
                    "have been {C:attention}changed",
                    "Exiting this menu will",
                    "force a {C:red}restart",
                }
            },
            lol_picnic_basket = {
                name = "Picnic Basket",
                text = {
                    "All the finest {C:attention}delicacies",
                    "a Joker could ever want...",
                    "{C:inactive}Theme: {C:dark_edition,E:1}Food and Drinks"
                },
            },
            lol_test_bundle = {
                name = "Test Bundle",
                text = {
                    "Testing description",
                },
            }
        },
    },

    misc = {
        dictionary = {
            b_lol_theme_suggestion = "Suggest a theme...",
            b_lol_submit_theme = "SUBMIT",
            b_lol_bundle_select = "Content Bundles",
            b_lol_enable_bundle = "Enable",
            b_lol_disable_bundle = "Disable",
            k_lol_will_preview = "(preview ready after restart)",
            k_lol_disabled = "Disabled",
            k_lol_from = "From"
        }
    }
};

if LOL.custom_localization_flag then
    en_us = LOL.get_loaded_loc(en_us, "en_us");
end

return en_us;

