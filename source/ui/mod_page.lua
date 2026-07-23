LOL.theme_suggestion = "";

local https = require "SMODS.https"
function G.FUNCS.lol_submit_theme()
    if not G.GAME then return end
    if #LOL.theme_suggestion < 1 then return end
    local rate_limit = 60
    
    G.GAME.lol_last_submission = G.GAME.lol_last_submission or 0;
    if os.time() > G.GAME.lol_last_submission + rate_limit then
        G.GAME.lol_last_submission = os.time()
    else
        print("Can't submit another theme yet!")
        print("Time remaining: " .. (G.GAME.lol_last_submission - os.time() + rate_limit) .. " seconds")
        return nil;
    end

    --- TODO: submit theme
    --- https://docs.google.com/forms/d/e/1FAIpQLScZ_S2K8X5PDjn6NPiago-rNRPw0gPD2-nqP6_S2pcp2aqrYg/formResponse?usp=pp_url&entry.796930526=Test+submission
    local form = "https://docs.google.com/forms/d/e/1FAIpQLScZ_S2K8X5PDjn6NPiago-rNRPw0gPD2-nqP6_S2pcp2aqrYg/formResponse?usp=pp_url"
    local submission = "entry.796930526=" .. LOL.theme_suggestion
    
    local code, body, headers = https.request(form, {
        method = "POST",
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded"
        },
        data = submission
    })

    if code == 200 or code == 302 then
        print("Form submitted successfully!")
    else
        print("Failed to submit form. Error code: " .. tostring(code))
    end
end

function LOL.custom_ui(nodes)
    nodes[#nodes - 1] = nil;

    table.insert(nodes, {
        n = G.UIT.R,
        config = { align = "cm", padding = 0.05 },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                    create_text_input({
                        prompt_text = localize("b_lol_theme_suggestion"),
                        extended_corpus = true,
                        ref_table = LOL,
                        ref_value = "theme_suggestion",
                        max_length = 24,
                        w = 4
                    }),
                },
            },
            {
                n = G.UIT.C,
                config = { align = "cm", padding = 0.05 },
                nodes = {
                    UIBox_button({
                        button = "lol_submit_theme",
                        label = { localize("b_lol_submit_theme") },
                        minw = 2.75,
                        colour = G.C.RED
                    }),
                },
            },
        }
    })
end

LOL.description_loc_vars = function()
    return {
        text_colour = G.C.WHITE,
        background_colour = G.C.CLEAR,
        scale = 1
    }
end

return {
    en_us = {
        type = "descriptions",
        set  = "Mod",
        key = "layers",
        data = {
            name = "Lots O' Layers",
            text = {
                "{C:dark_edition,E:1,s:1.67}Lizzie's \"Lots O' Layers\"",
                " ",
                "is a mod that periodically receives",
                "updates with varying {C:attention,E:1}themes",
                "suggested by its players.",
                "{s:6.7} ",
                "{s:1.1,C:inactive}Submit a theme suggestion?"
            }
        }
    }
}