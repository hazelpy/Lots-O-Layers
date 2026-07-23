-- SMODS.localize_box for localized titles

function LOL.setup_bundle_select(args)
    args = args or {}
    args.w_mod = args.w_mod or 1
    args.h_mod = args.h_mod or 1
    args.card_scale = args.card_scale or 1
    args.page = args.page or 1
    LOL.current_bundle_page = LOL.current_bundle_page or args.page;

    local bundle_hud    = {};
    G.lol_bundle_select = {};

    function G.FUNCS.lol_check_current_bundle()
        LOL.current_bundle_enabled = LOL.content_bundles[LOL.current_bundle_page].enabled and localize("b_lol_disable_bundle") or localize("b_lol_enable_bundle")
        if LOL.content_bundles[LOL.current_bundle_page].enabled then
            -- Bundle select page should show cards from enabled bundle
            G.lol_bundle_select[#G.lol_bundle_select + 1] = {
                n = G.UIT.O, config = { object = CardArea(
                    G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
                    #LOL.content_bundles[LOL.current_bundle_page]*G.CARD_W * 1.25,
                    args.h_mod*G.CARD_H,
                    {card_limit = #LOL.content_bundles[LOL.current_bundle_page].display, type = args.area_type or 'title', highlight_limit = 0, collection = false}
                )}
            }

            return true;
        else
            local no_display = DynaText({
                string = { localize("b_lol_unloaded_bundle") },
                colours = { G.C.UI.TEXT_INACTIVE },
                scale = 0.6,
                shadow = true,
                bump = true
            })

            G.lol_bundle_select[#G.lol_bundle_select + 1] = {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.07, no_fill = true },
                nodes = {
                    { n = G.UIT.O, config = { object = no_display }}
                }
            }

            return false;
        end
    end

    local options = {}
    for i = 1, #LOL.content_bundles do
        table.insert(options, localize('k_page')..' '..tostring(i)..'/'..tostring(#LOL.content_bundles))
    end

    function G.FUNCS.lol_bundle_select_page(e)
        if not e or not e.cycle_config then return end
        LOL.current_bundle_page = e.cycle_config.current_option or 1;

        if #G.lol_bundle_select > 0 then
            if G.lol_bundle_select[1].config.object and getmetatable(G.lol_bundle_select[1].config.object) == CardArea then
                local area = G.lol_bundle_select[1].config.object
                for i = #area.cards, 1, -1 do
                    local c = area:remove_card(area.cards[i])
                    c:remove()
                    c = nil
                end

                area:remove();
            else
                G.lol_bundle_select[1].nodes[1].config.object:remove();
            end
            
            G.lol_bundle_select = {};
        end
        
        local element = G.OVERLAY_MENU:get_UIE_by_ID("uibox_bundle_display")

        if element then
            element.config.object:remove();
            element.config.object = UIBox({ definition = G.FUNCS.generate_UIBox_bundle_display(), config = {align = "cm", parent = element} });
        end

        local bundle_active = G.FUNCS.lol_check_current_bundle();

        if bundle_active then
            local display_cards = LOL.content_bundles[LOL.current_bundle_page].display;
            local area = G.lol_bundle_select[1].config.object
            for i = 1, #display_cards do
                local center = G.P_CENTERS[display_cards[i]]
                if not center then break end
                local card = Card(area.T.x + area.T.w/2, area.T.y, G.CARD_W*args.card_scale, G.CARD_H*args.card_scale, G.P_CARDS.empty, (args.center and G.P_CENTERS[args.center]) or center)
                if not args.no_materialize then card:start_materialize(nil, i > 1) end
                area:emplace(card)
            end
        end
    end

    G.FUNCS.lol_bundle_select_page({ cycle_config = { current_option = 1 } });

    return {
        n = G.UIT.ROOT, config = {align = "cm", colour = G.C.CLEAR}, nodes = {
            {
                n = G.UIT.C, config = {align = "cm"}, nodes = {
                    {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = {
                        {
                            n = G.UIT.O,
                            config = {
                                id = "uibox_bundle_display",
                                object = UIBox({ definition = G.FUNCS.generate_UIBox_bundle_display(),  config = {align = "cm"} })
                            }
                        }
                    }},
                    
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.05 },
                        nodes = {
                            {
                                n = G.UIT.C,
                                config = {
                                    button = "lol_toggle_bundle",
                                    colour = G.C.BLUE,
                                    padding = 0.1,
                                    emboss = 0.1,
                                    r = 0.1
                                },
                                -- label = { LOL.content_bundles[LOL.current_bundle_page].enabled and localize("b_lol_disable_bundle") or localize("b_lol_enable_bundle") },
                                minw = 2.75,
                                -- colour = LOL.content_bundles[LOL.current_bundle_page].enabled and G.C.GREEN or G.C.RED,
                                nodes = {
                                    {
                                        n = G.UIT.O,
                                        config = {
                                            object = DynaText({
                                                string = { { ref_table = LOL, ref_value = "current_bundle_enabled" } },
                                                colours = { G.C.WHITE },
                                                scale = 0.7,
                                                shadow = true,
                                                bump = true
                                            })
                                        }
                                    }
                                }
                            },
                        },
                    },

                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        create_option_cycle({options = options, w = 4.5, cycle_shoulders = true, opt_callback = 'lol_bundle_select_page', current_option = 1, colour = G.ACTIVE_MOD_UI and (G.ACTIVE_MOD_UI.ui_config or {}).collection_option_cycle_colour or G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
                    }} or nil,
                }
            }
        }
    }; -- TODO: return page
end

G.FUNCS.generate_UIBox_bundle_display = function(e)
    return {
        n = G.UIT.R,
        config = { minw = 3.75, minh = 2 },
        nodes = {
            G.lol_bundle_select
        }
    }
end

G.FUNCS.lol_toggle_bundle = function(e)
    LOL.content_bundles[LOL.current_bundle_page].enabled = not LOL.content_bundles[LOL.current_bundle_page].enabled;
    LOL.current_bundle_enabled = LOL.content_bundles[LOL.current_bundle_page].enabled and localize("b_lol_disable_bundle") or localize("b_lol_enable_bundle")
    LOL.save_content_bundle_config()
end

function LOL.save_content_bundle_config()
    LOL.config = LOL.config or {}
    LOL.config.content_bundles = LOL.config.content_bundles or {};

    for _, bundle in ipairs(LOL.content_bundles) do
        LOL.config.content_bundles[bundle.key] = bundle.enabled
    end
end

LOL.extra_tabs = function()
    return {
        {
            label = localize("b_lol_bundle_select"),
            tab_definition_function  = LOL.setup_bundle_select
        }
    }
end