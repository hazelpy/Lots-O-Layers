-------------------------------
--- Lizzie's Lots O' Layers ---
-------------------------------

LOL = SMODS.current_mod;
LOL.source_index = {
    --- Add file paths (or folders) here to load them automatically
    --- "FUCK.lua"
    
    "source/ui",
    "source/content"
};

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
        name = "Picnic Basket",
        key = "picnic_basket",
        content_paths = {
            -- " ... " --- Path to file that must load
            "source/content/picnic_basket"
        },
    
        -- requires = { "bundle_name" }, --- Any other content bundles that this one needs enabled
        display = { "j_lots_joke", "j_lots_flan", "j_lots_avocado" },
        enabled = true,
        colour = G.C.ORANGE,
    },
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
}

function LOL.load_content_bundle_config()
    LOL.config = LOL.config or {}
    LOL.config.content_bundles = LOL.config.content_bundles or {}
    for key, enabled in pairs(LOL.config.content_bundles) do
        for index, bundle in ipairs(LOL.content_bundles) do
            if bundle.key == key then bundle.enabled = enabled end
        end
    end
end

--- Loading
function LOL.load_file(path)
    LOL.load_results = LOL.load_results or {}; --- For Localization / Utility

    local helper, load_error = SMODS.load_file("./" .. path)
    if not load_error and type(helper) == "function" then
        local result = helper();
        LOL.load_results[#LOL.load_results + 1] = { path = path, result = result };
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

function LOL.load_any(path)
    if string.sub(path, #path - 3, #path) == ".lua" then
        LOL.load_file(path);
    else
        local files = NFS.getDirectoryItems(LOL.path .. path)
        
        for _, filename in ipairs(files) do
            LOL.load_file(path .. "/" .. filename);
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
        if entry and entry[lang] then
            loc_table = LOL.load_loc_entry(entry, loc_table, lang) 
        end
    end

    return loc_table;
end

LOL.custom_localization_flag = false;
G.E_MANAGER:add_event(Event({
    trigger = "after",
    func = function(e)
        LOL.custom_localization_flag = true;
        G:set_language()
        G:init_item_prototypes()
        
        return true;
    end
}))