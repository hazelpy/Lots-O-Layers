local h_popup_hook = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card, ...)
	local ret = h_popup_hook(card, ...)
	local center = (card.config.center or {})
	if center.lol_art_credit and center.lol_code_credit and center.lol_bundle then
		local bundle = nil
		for _, b in ipairs(LOL.content_bundles) do
			if b.key == center.lol_bundle then
				bundle = b
				break
			end
		end
		if bundle then
			table.insert(ret.nodes[1].nodes, {
				n = G.UIT.R,
				config = { colour = G.C.CLEAR, padding = 0.1, align = "cm", w = 0 },
				nodes = {
					{
						n = G.UIT.R,
						config = { padding = 0.05, colour = lighten(G.C.JOKER_GREY, 0.7), r = 0.1, emboss = 0.07 },
						nodes = {
							{
								n = G.UIT.C,
								config = {
									padding = 0.1,
									colour = bundle.colour,
									align = "cm",
									minw = 2,
									r = 0.1,
								},
								nodes = {
									{
										n = G.UIT.R,
										config = {
											align = "cm",
										},
										nodes = {
											{
												n = G.UIT.T,
												config = {
													scale = 0.3,
													text = "Art: " .. center.lol_art_credit,
													colour = G.C.UI.TEXT_LIGHT,
												},
											},
										},
									},
									{
										n = G.UIT.R,
										config = {
											align = "cm",
										},
										nodes = {
											{
												n = G.UIT.T,
												config = {
													scale = 0.3,
													text = "Code: " .. center.lol_code_credit,
													colour = G.C.UI.TEXT_LIGHT,
												},
											},
										},
									},
								},
							},
						},
					},
				},
			})
			local old = ret.nodes[1].nodes[1]
			ret.nodes[1].nodes[1] = {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					old,
				},
			}
		end
	end
	return ret
end

local create_mod_badges_hook = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges, ...)
	create_mod_badges_hook(obj, badges, ...)
	local bundle
	if obj and obj.lol_bundle then
		for _, b in ipairs(LOL.content_bundles) do
			if b.key == obj.lol_bundle then
				bundle = b
				break
			end
		end
	end
	if bundle then
		local bundle_str = {
			n = G.UIT.R,
			config = { align = "tm" },
			nodes = {
				{
					n = G.UIT.R,
					config = { align = "cm", padding = 0.03 },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = localize("k_lol_from") .. " ",
										shadow = true,
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.27,
									},
								},
								{
									n = G.UIT.T,
									config = {
										text = localize({
											type = "name_text",
											key = "lol_" .. bundle.key,
											set = "Other",
											vars = {},
										}),
										shadow = true,
										colour = bundle.colour,
										scale = 0.27,
									},
								},
							},
						},
					},
				},
			},
		}
		badges[#badges + 1] = bundle_str
	end
end
