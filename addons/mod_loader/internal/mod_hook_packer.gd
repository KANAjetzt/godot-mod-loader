class_name ModLoaderModHookPacker
extends RefCounted


const ModHookPreprocessorScript = preload("res://addons/mod_loader/internal/mod_hook_preprocessor.gd")
static var ModHookPreprocessor


#func _ready() -> void:
	#run_script()
	#await get_tree().process_frame
	#get_tree().quit()


func run_script() -> String:
	ModHookPreprocessor = ModHookPreprocessorScript.new()
	ModHookPreprocessor.process_begin()

	var res := _ModLoaderPath.get_local_folder_dir()
	if OS.has_feature("editor"):
		res = ProjectSettings.globalize_path("res://").rsplit("/", true, 2)[0]

	var save_base_path := res.path_join("godot_mod_loader/")

	if FileAccess.file_exists(save_base_path.path_join("temp_test_mod.zip")):
		return save_base_path.path_join("temp_test_mod.zip")

	print("Saved to:", save_base_path)
	DirAccess.make_dir_recursive_absolute(save_base_path)

	var zip_writer := ZIPPacker.new()
	var err := zip_writer.open(save_base_path.path_join("temp_test_mod.zip"))
	if err != OK:
		printerr(err)

	transform_scripts_recursive(ModHookPreprocessor.process_script, zip_writer)

	zip_writer.close()

	return save_base_path.path_join("temp_test_mod.zip")


func transform_scripts_recursive(callback: Callable, zip_writer: ZIPPacker, path := "res://") -> void:
	var dir := DirAccess.open(path)
	if not dir:
		print("An error occurred when trying to access the path:", path)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if path.begins_with("res://addons") or path.begins_with("res://mods-unpacked") or path.begins_with("res://.godot"):
			file_name = dir.get_next()
			continue

		if dir.current_is_dir():
			transform_scripts_recursive(callback, zip_writer, dir.get_current_dir().path_join(file_name))
			file_name = dir.get_next()
			continue

		if file_name.get_extension() != "gd":
			file_name = dir.get_next()
			continue

		var processed: String = callback.call(dir.get_current_dir().path_join(file_name))
		zip_writer.start_file(path.trim_prefix("res://").path_join(file_name))
		zip_writer.write_file(processed.to_utf8_buffer())
		zip_writer.close_file()

		file_name = dir.get_next()
