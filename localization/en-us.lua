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
            lol_test_bundle = {
                name = "Test Bundle",
                text = {
                    "Testing description",
                },
            },
            lol_test_bundle_two = {
                name = "Test Bundle 2",
                text = {
                    "{X:mult,C:white}Xmult{} text",
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

en_us = LOL.get_loaded_loc(en_us, "en_us");
return en_us;

