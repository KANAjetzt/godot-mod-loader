extends SceneTree


const LOG_NAME := "ModLoader:Setup"

# IMPORTANT: use the ModLoaderLog via this variable within this script!
# Otherwise, script compilation will break on first load since the class is not defined.
var ModLoaderSetupLog: Object = load("res://addons/mod_loader/setup/setup_log.gd")
var ModLoaderSetupUtils: Object = load("res://addons/mod_loader/setup/setup_utils.gd")

var is_setup_create_override_cfg: bool = ModLoaderSetupUtils.is_running_with_command_line_arg(
	"--setup-create-override-cfg"
)


func _init() -> void:
	ModLoaderSetupLog.debug("ModLoader setup initialized", LOG_NAME)

	var mod_loader_index: int = ModLoaderSetupUtils.get_autoload_index("ModLoader")
	var mod_loader_store_index: int = ModLoaderSetupUtils.get_autoload_index("ModLoaderStore")

	# Avoid doubling the setup work
	# Checks if the ModLoaderStore is the first autoload and ModLoader the second
	if mod_loader_store_index == 0 and mod_loader_index == 1:
		modded_start()
		return

	# Check if --setup-create-override-cfg is passed,
	# in that case the ModLoader and ModLoaderStore just have to be somewhere in the autoloads.
	if is_setup_create_override_cfg and mod_loader_index != -1 and mod_loader_store_index != -1:
		modded_start()
		return

	change_scene_to_file("res://addons/mod_loader/setup/setup.tscn")


# ModLoader already setup - switch to the main scene
func modded_start() -> void:
	ModLoaderSetupLog.info("ModLoader is available, mods can be loaded!", LOG_NAME)

	root.set_title("%s (Modded)" % ProjectSettings.get_setting("application/config/name"))

	change_scene_to_file.call_deferred(ProjectSettings.get_setting("application/run/main_scene"))
