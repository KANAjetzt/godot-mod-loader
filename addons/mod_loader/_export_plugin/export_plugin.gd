extends EditorExportPlugin


const HOOK_DATA_PATH := "res://addons/mod_loader/_export_plugin/hook_data.json"

static var hook_pre_processor: _ModLoaderModHookPreProcessor
static var script_count: int
static var script_count_processed: int


func _get_name() -> String:
	return "Godot Mod Loader Export Plugin"


func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	script_count_processed = 0

	hook_pre_processor = _ModLoaderModHookPreProcessor.new()
	hook_pre_processor.process_begin()

	var all_scripts := _ModLoaderPath.get_flat_view_dict("res://", ["res://addons"], "(\\.gd)$", true)
	script_count = all_scripts.size()


func _export_file(path: String, type: String, features: PackedStringArray) -> void:
	if path.begins_with("res://addons") or path.begins_with("res://mods-unpacked"):
		return

	if type != "GDScript":
		return

	skip()
	add_file(
		path,
		hook_pre_processor.process_script(path, false).to_utf8_buffer(),
		false
	)

	script_count_processed += 1

	if script_count_processed == script_count:
		add_file(HOOK_DATA_PATH, JSON.stringify(hook_pre_processor.hashmap.keys()).to_utf8_buffer(), false)
