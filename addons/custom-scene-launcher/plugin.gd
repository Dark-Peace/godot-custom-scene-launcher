@tool
extends EditorPlugin

var container := preload("./ToolBarButtons.gd").new()
var file_dialog := preload("./ScenesFileDialog.gd").new()
var config := preload("./PluginConfig.gd").new(_get_root_dir())

func _enter_tree() -> void:
	connect("scene_changed",Callable(self,"_on_scene_changed"))
	connect("main_screen_changed",Callable(self,"_on_screen_changed"))
	config.load_settings()

	container.scene_path = config.scene_path
	container.file_browser_button.icon = _get_icon("File")
	container.remove_button.icon = _get_icon("Close")
	container.open_root_dir_button.icon = _get_icon("ActionPaste")
	container.pin_button.icon = _get_icon("Pin")
	container.run_button.icon = _get_icon("PlayStart")
	container.more_button.icon = _get_icon("MoveLeft")
	container.pin_button.button_pressed = config.was_manually_set


	container.run_button.shortcut = _get_shortcut()

	container.connect("scene_path_changed",Callable(self,"_on_scene_path_changed"))
	container.connect("file_browser_requested",Callable(file_dialog,"popup_centered_ratio"))
	container.connect("open_root_dir_pressed",Callable(OS,"shell_open").bind(_get_root_dir()))
	container.connect("run_button_pressed",Callable(self,"_on_run_button_pressed"))
	container.connect("pin_button_toggled",Callable(config,"set_was_manually_set"))

	add_control_to_container(CONTAINER_TOOLBAR, container)
	container.get_parent().move_child(container, container.get_index() - 2)

	file_dialog.connect("file_selected",Callable(self,"_on_file_dialog_file_selected"))
	get_editor_interface().get_base_control().add_child(file_dialog)


func _exit_tree() -> void:
	remove_control_from_container(CONTAINER_TOOLBAR, container)
	container.queue_free()
	file_dialog.queue_free()


func _on_file_dialog_file_selected(path: String) -> void:
	if path:
		container.scene_path = path
		config.scene_path = path
		config.was_manually_set = true
		container.pin_button.button_pressed = true
	else:
		container.scene_path = get_current_scene_path()
		config.was_manually_set = false
		container.pin_button.button_pressed = false


func get_current_scene_path() -> String:
	var current_scene: Node = get_editor_interface().get_edited_scene_root()
	if current_scene:
		return current_scene.filename
	return ""


func _on_scene_path_changed(new_text: String) -> void:
	config.was_manually_set = false
	container.pin_button.button_pressed = false
	config.scene_path = new_text


func _on_scene_changed(new_scene: Node):
	if config.was_manually_set:
		return
	if new_scene == null:
		return
	container.scene_path = new_scene.filename
	config.scene_path = new_scene.filename


func _on_screen_changed(new_screen: String) -> void:
	if new_screen == "2D" or new_screen == "3D":
		container.show()


func _on_run_button_pressed() -> void:
	config.load_settings()  # Godot bug forces us to reload config
	if config.scene_path == "":
		print(config.scene_path, "nope")
		return
	print(config.scene_path, "yep")
	get_editor_interface().play_custom_scene(config.scene_path)


func _show_feedback(title: String, text: String):
	var accept_dialog := AcceptDialog.new()
	accept_dialog.connect("popup_hide",Callable(accept_dialog,"queue_free"))
	accept_dialog.window_title = title
	accept_dialog.dialog_text = text
	get_editor_interface().get_base_control().add_child(accept_dialog)
	accept_dialog.popup_centered()


func _get_icon(icon_name: String) -> Texture2D:
	return get_editor_interface().get_base_control().theme.get_icon(icon_name, "EditorIcons")


func _get_root_dir() -> String:
	return EditorPaths.new().get_project_settings_dir()


func _get_shortcut() -> Shortcut:
	var key := InputEventKey.new()
	key.keycode = KEY_F7
	var shortcut := Shortcut.new()
	shortcut.events.append(key)
	return shortcut
