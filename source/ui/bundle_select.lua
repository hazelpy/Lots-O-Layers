-- SMODS.localize_box for localized titles

LOL.current_bundle_page = 1
LOL.changed_bundles = 0

LOL.bundle_select_UIdef = function()
	local options = {}
	for i = 1, #LOL.content_bundles do
		table.insert(options, localize("k_page") .. " " .. tostring(i) .. "/" .. tostring(#LOL.content_bundles))
	end
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.CLEAR, padding = 0.1, align = "cm" },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = UIBox({
										definition = LOL.bundle_display_UIdef(),
										config = {},
									}),
									id = "bundle_display",
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							create_option_cycle({
								options = options,
								w = 4.5,
								cycle_shoulders = true,
								opt_callback = "lol_bundle_select_page",
								current_option = LOL.current_bundle_page,
								colour = G.ACTIVE_MOD_UI
										and (G.ACTIVE_MOD_UI.ui_config or {}).collection_option_cycle_colour
									or G.C.RED,
								no_pips = true,
								focus_args = { snap_to = true, nav = "wide" },
							}),
						},
					},
				},
			},
		},
	}
end

G.FUNCS.lol_bundle_select_page = function(args)
	if not G.OVERLAY_MENU then
		return
	end
	LOL.current_bundle_page = args.to_key
	local element = G.OVERLAY_MENU:get_UIE_by_ID("bundle_display")
	element.config.object:remove()
	element.config.object = UIBox({
		definition = LOL.bundle_display_UIdef(),
		config = {
			parent = element,
		},
	})
end

LOL.bundle_display_UIdef = function()
	local keys = LOL.content_bundles[LOL.current_bundle_page].display
	local enabled = LOL.content_bundles[LOL.current_bundle_page].enabled
	local loc_key = "lol_" .. LOL.content_bundles[LOL.current_bundle_page].key
	local name_nodes =
		localize({ type = "name", key = loc_key, set = "Other", name_nodes = {}, vars = {}, fixed_scale = 1.3 })
	local display = {
		n = G.UIT.T,
		config = {
			text = localize("k_lol_disabled"),
			scale = 1,
			colour = G.C.WHITE,
		},
	}
	if enabled then
		local area = CardArea(
			G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2,
			G.ROOM.T.h,
			4.25 * G.CARD_W,
			G.CARD_H,
			{ card_limit = #keys, type = "title_2", highlight_limit = 0, collection = true }
		)
		for _, key in ipairs(keys) do
			local card =
				Card(area.T.x + area.T.w / 2, area.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[key], {
					bypass_discovery_center = true,
					bypass_lock = true,
					bypass_discovery_ui = true,
				})
			card.no_ui = true
			area:emplace(card)
		end
		display = {
			n = G.UIT.O,
			config = {
				object = area,
			},
		}
	end

	return {
		n = G.UIT.ROOT,
		config = {
			colour = G.C.CLEAR,
			padding = 0.1,
			align = "cm",
		},
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.05 },
				nodes = name_nodes,
			},
			{
				n = G.UIT.R,
				config = {
					colour = G.C.BLACK,
					padding = 0.1,
					align = "cm",
					r = 0.1,
					emboss = 0.05,
					minw = 4.25 * G.CARD_W + 0.2,
					minh = G.CARD_H + 0.2,
				},
				nodes = {
					display,
				},
			},
			{
				n = G.UIT.R,
				config = { padding = 0.1, align = "cm" },
				nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cm" },
                        nodes = {
                            LOL.create_localized_rows(nil, loc_key, { minw = 4.5, minh = 1.8 })
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = {},
                    },
					UIBox_button({
						button = "lol_toggle_bundle",
						label = { localize(enabled and "b_lol_disable_bundle" or "b_lol_enable_bundle") },
						colour = enabled and G.C.RED or G.C.GREEN,
                        minh = 1.4,
						col = true,
					}),
				},
			},
		},
	}
end

function LOL.create_localized_rows(set, key, args)
	args = args or {}
	args.text_scale = args.text_scale or 1
	local desc_nodes = {}
	localize({
		type = "descriptions",
		set = set or "Other",
		key = key,
		nodes = desc_nodes,
		fixed_scale = args.text_scale,
		text_colour = args.text_colour,
		vars = args.loc_vars or {},
	})
	local rows = {}
	for _, v in ipairs(desc_nodes) do
		rows[#rows + 1] = { n = G.UIT.R, config = { align = (args.align or "c") .. "m" }, nodes = v }
	end
	return {
		n = G.UIT.R,
		config = {
			align = "cm",
			colour = args.bg_colour or (args.empty and G.C.CLEAR or G.C.UI.BACKGROUND_WHITE),
			r = 0.1,
			padding = not args.empty and 0.04 or nil,
			minw = args.minw or 2,
			minh = args.minh or 0.8,
			emboss = not args.empty and 0.05 or nil,
			filler = true,
		},
		nodes = {
			{ n = G.UIT.R, config = { align = "cm", padding = 0.03 }, nodes = rows },
		},
	}
end

function LOL.restart_popup()
	return {
		n = G.UIT.ROOT,
		config = { r = 0.1, colour = G.C.RED, padding = 0.05, emboss = 0.05 },
		nodes = {
			{
				n = G.UIT.R,
				config = { padding = 0.1, colour = G.C.WHITE, r = 0.1 },
				nodes = {
					LOL.create_localized_rows(nil, "lol_reload_popup", { empty = true }),
				},
			},
		},
	}
end

function LOL.update_restart_popup()
	if G.lol_restart_popup and LOL.changed_bundles == 0 then
		G.lol_restart_popup:remove()
		G.lol_restart_popup = nil
	elseif not G.lol_restart_popup and LOL.changed_bundles ~= 0 and G.OVERLAY_MENU then
		G.lol_restart_popup = UIBox({
			definition = LOL.restart_popup(),
			config = {
				major = G.OVERLAY_MENU.UIRoot.children[1],
				align = "tri",
				instance_type = "ALERT",
				r_bond = "Weak",
				offset = { x = 1.6, y = -0.4 },
			},
		})
		G.lol_restart_popup.T.r = 0.1
	end
end

local exit_mods_hook = G.FUNCS.exit_mods
function G.FUNCS.exit_mods(e, ...)
	if G.ACTIVE_MOD_UI == LOL and LOL.changed_bundles ~= 0 then
		SMODS.save_all_config()
		SMODS.restart_game()
	end
	exit_mods_hook(e, ...)
end

local mod_menu_hook = G.FUNCS.mods_button
function G.FUNCS.mods_button(e, ...)
	if G.ACTIVE_MOD_UI == LOL and LOL.changed_bundles ~= 0 then
		SMODS.save_all_config()
		SMODS.restart_game()
	end
	mod_menu_hook(e, ...)
end

G.FUNCS.lol_toggle_bundle = function(e)
	if not G.OVERLAY_MENU then
		return
	end
	LOL.content_bundles[LOL.current_bundle_page].enabled = not LOL.content_bundles[LOL.current_bundle_page].enabled
	if LOL.content_bundles[LOL.current_bundle_page].enabled then
		LOL.changed_bundles = LOL.changed_bundles + 2 ^ LOL.current_bundle_page
	else
		LOL.changed_bundles = LOL.changed_bundles - 2 ^ LOL.current_bundle_page
	end
	LOL.save_content_bundle_config()
	local element = G.OVERLAY_MENU:get_UIE_by_ID("bundle_display")
	element.config.object:remove()
	element.config.object = UIBox({
		definition = LOL.bundle_display_UIdef(),
		config = {
			parent = element,
		},
	})
	LOL.update_restart_popup()
end

function LOL.save_content_bundle_config()
	LOL.config = LOL.config or {}
	LOL.config.content_bundles = LOL.config.content_bundles or {}

	for _, bundle in ipairs(LOL.content_bundles) do
		LOL.config.content_bundles[bundle.key] = bundle.enabled
	end
end

LOL.extra_tabs = function()
	return {
		{
			label = localize("b_lol_bundle_select"),
			tab_definition_function = LOL.bundle_select_UIdef,
		},
	}
end
