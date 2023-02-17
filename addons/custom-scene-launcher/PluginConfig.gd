extends RefCounted

const PLUGIN_NAME := "custom-scene-launcher"
const SETTINGS_KEY := PLUGIN_NAME + "/scene"
const DO_RUN_KEY := PLUGIN_NAME + "/run"
const PLUGIN_CONFIG_DIR := "addons"
const PLUGIN_CONFIG := "settings.cfg"

var _plugin_config = ConfigFile.new()

var scene_path: String : get = get_scene_path, set = set_scene_path
var was_manually_set: bool : get = get_was_manually_set, set = set_was_manually_set
var root_dir: String


func _init(dir: String):
	root_dir = dir


func load_settings() -> void:
	var path = get_config_path()
	var fs = FileAccess.open(path, FileAccess.READ_WRITE)
	if not fs:
		var config = ConfigFile.new()
		DirAccess.open("res://addons/"+PLUGIN_NAME).make_dir_recursive(path.get_base_dir())
		config.save(path)
	else:
		_plugin_config.load(path)
		var text = _plugin_config.get_value("general", "scene", "")
		if text != "": set_was_manually_set(true)


func get_config_path() -> String:
#	var home = root_dir.plus_file(PLUGIN_CONFIG_DIR).plus_file(PLUGIN_NAME)
#	var path = home.plus_file(PLUGIN_CONFIG)

	return "res://"+PLUGIN_CONFIG_DIR+"/"+PLUGIN_NAME+"/"+PLUGIN_CONFIG


func set_scene_path(new_path: String) -> void:
	_save_setting("scene_path", new_path)


func get_scene_path() -> String:
	return _load_setting("scene_path", "") as String


func set_was_manually_set(is_it: bool) -> void:
	_save_setting("was_manually_set", is_it)


func get_was_manually_set() -> bool:
	return _load_setting("was_manually_set", false)


# container.scene_path.text
func _save_setting(key: String, value) -> void:
	_plugin_config.set_value("general", key, value)
	_plugin_config.save(get_config_path())


func _load_setting(key: String, defaultValue):
	return _plugin_config.get_value("general", key, defaultValue)
