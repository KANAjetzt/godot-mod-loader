GDPatch.patch_project_settings(function(settings)
    table.insert(settings, 1, {
        "autoload/ModLoader",
        "*res://addons/mod_loader/mod_loader.gd"
    })
    table.insert(settings, 1, {
        "autoload/ModLoaderStore",
        "*res://addons/mod_loader/mod_loader_store.gd"
    })
    return settings
end, { before = { "gdpatch" } })
