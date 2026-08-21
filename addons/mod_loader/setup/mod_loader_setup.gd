extends Node

## IDEAS
## - Setup with override.cfg
## - [autoload_prepend] the setup scene
## - Download dependencies
## 		- GDRE
## 		- GDPatch
##		- Download latest Mod Loader
## - Generate GDPatch Mod to setup Autoloads and class cache
## - Set it up in the GDPatch Mod
## - Delete the override.cfg

const LOG_NAME := "ModLoader:Setup"
const LINK_GDRE_LATEST_WIN := "https://github.com/GDRETools/gdsdecomp/releases/download/v2.6.4/GDRE_tools-v2.6.4-windows.zip"
const LINK_GDPATCH_LATEST := "https://github.com/GDPatch/GDPatch/releases/latest/download/gdpatch_loader.dll"
const LINK_MODLOADER_LATEST := "https://github.com/GodotModding/godot-mod-loader/archive/refs/heads/4.x-dev.zip"
const DEPENDENCY_ID_GDRE = "gdre"
const DEPENDENCY_ID_GDPATCH = "gdpatch"
const DEPENDENCY_ID_MODLOADER = "modloader"


# C:/path/to/game/game.exe
var path_exe := OS.get_executable_path()
# C:/path/to/game/
var path_exe_base_dir := path_exe.get_base_dir()
var path_dependencies_temp := path_exe_base_dir.path_join("dependencies_temp")
var path_dependencies_temp_gdre := path_dependencies_temp.path_join(DEPENDENCY_ID_GDRE)
var path_dependencies_temp_gdpatch := path_dependencies_temp.path_join(DEPENDENCY_ID_GDPATCH)
var path_dependencies_temp_modloader := path_dependencies_temp.path_join(DEPENDENCY_ID_MODLOADER)

var downloads_completed_count := 0 :
	set(new_value):
		downloads_completed_count = new_value
		if downloads_completed_count == 3:
			continue_setup()



func _ready() -> void:
	print("path_exe: ", path_exe)
	print("path_exe_base_dir: ", path_exe_base_dir)
	#get_dependencies()
	continue_setup()


func continue_setup() -> void:
	# Unpack Mod Loader
	extract_all_from_zip(path_dependencies_temp_modloader.path_join("modloader.zip"), path_dependencies_temp_modloader.path_join("modloader"))

	# Create GDPatch Mod Dir
	DirAccess.make_dir_recursive_absolute(path_exe_base_dir.path_join("GDPatch/mods/GodotModLoader/data/addons"))
	DirAccess.make_dir_recursive_absolute(path_exe_base_dir.path_join("GDPatch/mods/GodotModLoader/data/.godot"))

	# Copy Mod Loader
	var mod_loader_file_paths := get_flat_view_dict(path_dependencies_temp_modloader.path_join("modloader/godot-mod-loader-4.x-dev/addons"))

	for path in mod_loader_file_paths:
		copy_file(path, path_exe_base_dir.path_join("GDPatch/mods/GodotModLoader/data/addons").path_join(path.trim_prefix(path_dependencies_temp_modloader.path_join("modloader/godot-mod-loader-4.x-dev/addons"))))
		if path.ends_with("global_script_class_cache_mod_loader.cfg"):
			copy_file(path, path_exe_base_dir.path_join("GDPatch/mods/GodotModLoader/data/.godot/global_script_class_cache.cfg"))

	# Unpack GDRE
	extract_all_from_zip(path_dependencies_temp_gdre.path_join("gdre.zip"), path_dependencies_temp_gdre.path_join("gdre"))

	# Copy GDRE
	var gdre_file_paths := get_flat_view_dict(path_dependencies_temp_gdre.path_join("gdre"))

	for path in gdre_file_paths:
		copy_file(path, path_exe_base_dir.path_join("GDPatch/mods/GodotModLoader/data/addons/mod_loader/vendor/gdre").path_join(path.trim_prefix(path_dependencies_temp_gdre.path_join("gdre"))))

	# Copy GDPatch Mod files
	copy_file(path_exe_base_dir.path_join("GDPatch/mods/GodotModLoader/data/addons/mod_loader/setup/gdpatch_mod.toml"), path_exe_base_dir.path_join("GDPatch/mods/GodotModLoader/gdpatch_mod.toml"))
	copy_file(path_exe_base_dir.path_join("GDPatch/mods/GodotModLoader/data/addons/mod_loader/setup/patcher.lua"), path_exe_base_dir.path_join("GDPatch/mods/GodotModLoader/patcher.lua"))

	# Delete override.cfg
	if FileAccess.file_exists(path_exe_base_dir.path_join("override.cfg")):
		DirAccess.remove_absolute(path_exe_base_dir.path_join("override.cfg"))


func extract_all_from_zip(path_to_zip: String, destination_path: String):
	var reader = ZIPReader.new()
	reader.open(path_to_zip)

	if not DirAccess.dir_exists_absolute(destination_path):
		DirAccess.make_dir_recursive_absolute(destination_path)

	var root_dir = DirAccess.open(destination_path)

	var files = reader.get_files()
	for file_path in files:
		# If the current entry is a directory.
		if file_path.ends_with("/"):
			root_dir.make_dir_recursive(file_path)
			continue

		root_dir.make_dir_recursive(root_dir.get_current_dir().path_join(file_path).get_base_dir())
		var file = FileAccess.open(root_dir.get_current_dir().path_join(file_path), FileAccess.WRITE)
		var buffer = reader.read_file(file_path)
		file.store_buffer(buffer)


func get_dependencies() -> void:
	get_gdre()
	get_gdpatch()
	get_modloader()


func get_dependency(url: String) -> HTTPRequest:
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	# http_request.request_completed.connect(self._http_request_completed)

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

	return http_request


func get_gdre() -> void:
	get_dependency(LINK_GDRE_LATEST_WIN).request_completed.connect(
	handle_completed_dependency_request.bind(DEPENDENCY_ID_GDRE)
	)


func get_gdpatch() -> void:
	get_dependency(LINK_GDPATCH_LATEST).request_completed.connect(
	handle_completed_dependency_request.bind(DEPENDENCY_ID_GDPATCH)
	)


func get_modloader() -> void:
	get_dependency(LINK_MODLOADER_LATEST).request_completed.connect(
	handle_completed_dependency_request.bind(DEPENDENCY_ID_MODLOADER)
	)


# Called when the HTTP request is completed.
func handle_completed_dependency_request(result, response_code, headers, body, dependency_id: String):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Dependency \"%s\" couldn't be downloaded." % dependency_id)
		return

	if not DirAccess.dir_exists_absolute(path_dependencies_temp):
		DirAccess.make_dir_absolute(path_dependencies_temp)

	if dependency_id == DEPENDENCY_ID_GDRE:
		if not DirAccess.dir_exists_absolute(path_dependencies_temp_gdre):
			DirAccess.make_dir_absolute(path_dependencies_temp_gdre)

		var file := FileAccess.open(path_dependencies_temp_gdre.path_join("gdre.zip"), FileAccess.WRITE)
		file.store_buffer(body)

	if dependency_id == DEPENDENCY_ID_GDPATCH:
		if not DirAccess.dir_exists_absolute(path_dependencies_temp_gdpatch):
			DirAccess.make_dir_absolute(path_dependencies_temp_gdpatch)

		var file := FileAccess.open(path_dependencies_temp_gdpatch.path_join("winmm.dll"), FileAccess.WRITE)
		file.store_buffer(body)

	if dependency_id == DEPENDENCY_ID_MODLOADER:
		if not DirAccess.dir_exists_absolute(path_dependencies_temp_modloader):
			DirAccess.make_dir_absolute(path_dependencies_temp_modloader)

		var file := FileAccess.open(path_dependencies_temp_modloader.path_join("modloader.zip"), FileAccess.WRITE)
		file.store_buffer(body)


# Slightly modified version of:
# https://gist.github.com/willnationsdev/00d97aa8339138fd7ef0d6bd42748f6e
# Removed .import from the extension filter.
# p_match is a string that filters the list of files.
# If p_match_is_regex is false, p_match is directly string-searched against the FILENAME.
# If it is true, a regex object compiles p_match and runs it against the FILEPATH.
static func get_flat_view_dict(
	p_dir := "res://",
 	p_match := "",
	p_match_file_extensions: Array[StringName] = [],
	p_match_is_regex := false,
	include_empty_dirs := false,
	ignored_dirs: Array[StringName] = []
) -> PackedStringArray:
	var data: PackedStringArray = []
	var regex: RegEx

	if p_match_is_regex:
		regex = RegEx.new()
		var _compile_error: int = regex.compile(p_match)
		if not regex.is_valid():
			return data

	var dirs := [p_dir]
	var first := true
	while not dirs.is_empty():
		var dir_name : String = dirs.back()
		var dir := DirAccess.open(dir_name)
		dirs.pop_back()

		if dir_name.lstrip("res://").get_slice("/", 0) in ignored_dirs:
			continue

		if dir:
			var _dirlist_error: int = dir.list_dir_begin()
			var file_name := dir.get_next()
			if include_empty_dirs and not dir_name == p_dir:
				data.append(dir_name)
			while file_name != "":
				if not dir_name == "res://":
					first = false
				# ignore hidden, temporary, or system content
				if not file_name.begins_with(".") and not file_name.get_extension() == "tmp":
					# If a directory, then add to list of directories to visit
					if dir.current_is_dir():
						dirs.push_back(dir.get_current_dir() + "/" + file_name)
					# If a file, check if we already have a record for the same name
					else:
						var path := dir.get_current_dir() + ("/" if not first else "") + file_name
						# grab all
						if not p_match and not p_match_file_extensions:
							data.append(path)
						# grab matching strings
						elif not p_match_is_regex and p_match and file_name.contains(p_match):
							data.append(path)
						# garb matching file extension
						elif p_match_file_extensions and file_name.get_extension() in p_match_file_extensions:
							data.append(path)
						# grab matching regex
						elif p_match_is_regex:
							var regex_match := regex.search(path)
							if regex_match != null:
								data.append(path)
				# Move on to the next file in this directory
				file_name = dir.get_next()
			# We've exhausted all files in this directory. Close the iterator.
			dir.list_dir_end()
	return data


static func copy_file(from: String, to: String) -> void:
	#ModLoaderSetupLog.debug("Copy file from: \"%s\" to: \"%s\"" % [from, to], LOG_NAME)
	var global_to_path := ProjectSettings.globalize_path(to.get_base_dir())

	if not DirAccess.dir_exists_absolute(global_to_path):
		#ModLoaderSetupLog.debug("Creating dir \"%s\"" % global_to_path, LOG_NAME)
		DirAccess.make_dir_recursive_absolute(global_to_path)

	var file_from := FileAccess.open(from, FileAccess.READ)
	var file_from_error := file_from.get_error()

	if not file_from_error == OK:
		#ModLoaderSetupLog.error("Error accessing file \"%s\": %s" % [from, error_string(file_from_error)], LOG_NAME)
		return

	var file_from_content := file_from.get_buffer(file_from.get_length())
	var file_to := FileAccess.open(to, FileAccess.WRITE)
	var file_to_error := file_to.get_error()

	if not file_to_error == OK:
		#ModLoaderSetupLog.error("Error writing file \"%s\": %s" % [to, error_string(file_to_error)], LOG_NAME)
		return

	file_to.store_buffer(file_from_content)
