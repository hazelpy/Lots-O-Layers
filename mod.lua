-------------------------------
--- Lizzie's Lots O' Layers ---
-------------------------------

LOL = SMODS.current_mod;
LOL.source_index = {
    --- Add file paths (or folders) here to load them automatically
    --- "FUCK.lua"
    
    "source/ui"
};

-- TODO: implement bundle select
LOL.content_bundles = {
    -- Add groups of source to load
    -- {
    --     name = "bundle_name",
    --     content_paths = {
    --         " ... " --- Path to file that must load
    --     },
    --
    --     requires = { "bundle_name" }, --- Any other content bundles that this one needs enabled
    --     display = { "c_strength" },
    --     enabled = true
    -- }
    {
        name = "Test Bundle",
        key = "test_bundle",
        content_paths = {
            -- " ... " --- Path to file that must load
            "source/content/test_bundle"
        },
    
        -- requires = { "bundle_name" }, --- Any other content bundles that this one needs enabled
        display = { "j_lots_test" },
        enabled = true,
        colour = G.C.RED,
    },
    {
        name = "Test Bundle 2",
        key = "test_bundle_two",
        content_paths = {
            -- " ... " --- Path to file that must load
        },
    
        -- requires = { "bundle_name" }, --- Any other content bundles that this one needs enabled
        display = { "c_death" },
        enabled = true,
        colour = G.C.BLUE
    }
}

function LOL.load_content_bundle_config()
    LOL.config = LOL.config or {}
    LOL.config.content_bundles = LOL.config.content_bundles or {}
    for key, enabled in pairs(LOL.config.content_bundles) do
        for index, bundle in ipairs(LOL.content_bundles) do
            if bundle.key == key then bundle.enabled = enabled end
        end
    end
    print(LOL.content_bundles);
end

--- Loading
function LOL.load_file(path)
    LOL.load_results = LOL.load_results or {}; --- For Localization / Utility

    local helper, load_error = SMODS.load_file("./" .. path)
    if not load_error and type(helper) == "function" then
        LOL.load_results[#LOL.load_results + 1] = { path = path, result = helper() };
    end
end

function LOL.load_source_index()
    for _, path in ipairs(LOL.source_index) do
        if string.sub(path, #path - 3, #path) == ".lua" then
            LOL.load_file(path);
        else
            local files = NFS.getDirectoryItems(LOL.path .. path)
            
            for _, filename in ipairs(files) do
                LOL.load_file(path .. "/" .. filename);
            end
        end
    end
end

function LOL.load_content_bundles()
    LOL.loaded_content_bundles = {}
    for _, bundle in ipairs(LOL.content_bundles) do
        if bundle.enabled then
            print("Loading content bundle with key '" .. bundle.key .. "'...")
            
            for _, path in ipairs(bundle.content_paths) do
                if string.sub(path, #path - 3, #path) == ".lua" then
                    LOL.load_file(path);
                else
                    local files = NFS.getDirectoryItems(LOL.path .. path)
                    
                    for _, filename in ipairs(files) do
                        LOL.load_file(path .. "/" .. filename);
                    end
                end
            end

            LOL.loaded_content_bundles[#LOL.loaded_content_bundles+1] = bundle.key
        end
    end
end

LOL.load_source_index();
LOL.load_content_bundle_config();
LOL.load_content_bundles();

--- Localization
function LOL.load_loc_entry(entry, loc_table, lang)
    loc_table.descriptions = loc_table.descriptions or {}
    loc_table.misc = loc_table.misc or {}

    if not entry[lang] then return loc_table end

    local data = entry[lang].data;
    if not data then return loc_table end

    if data.label then
        loc_table.misc.dictionary = loc_table.misc.dictionary or {}
        loc_table.misc.dictionary[data.label_key or entry[lang].key] = data.label;
    end

    loc_table[entry[lang].type] = loc_table[entry[lang].type] or {}
    loc_table[entry[lang].type][entry[lang].set] = loc_table[entry[lang].type][entry[lang].set] or {}
    loc_table[entry[lang].type][entry[lang].set][entry[lang].key] = data

    return loc_table;
end

function LOL.get_loaded_loc(loc_table, lang)
    for _, v in ipairs(LOL.load_results) do
        local entry = v.result;
        if entry and entry[lang] then loc_table = LOL.load_loc_entry(entry, loc_table, lang) end
    end

    return loc_table;
end