class_name CustomSceneLauncher

const PluginConfig := preload("./PluginConfig.gd")


static func get_current_scene(project_dir: String) -> String:
	var dir = DirAccess.open(project_dir)
	if not dir.dir_exists(project_dir):
		push_error(
			(
				"the directory provided to `get_current_scene` isn't valid. Are you sure you're using the right one? Provided: `%s`"
				% [project_dir]
			)
		)
		return ""
	var config := PluginConfig.new(project_dir)
	config.load_settings()
	return config.scene_path
