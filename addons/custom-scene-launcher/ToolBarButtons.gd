extends HBoxContainer

var scene_path_control := LineEdit.new()
var file_browser_button := Button.new()
var run_button := Button.new()
var remove_button := Button.new()
var open_root_dir_button := Button.new()
var pin_button := Button.new()
var scene_path: String : get = get_scene_path, set = set_scene_path
var more_button := Button.new()
var split_container := HBoxContainer.new()
var separator := VSeparator.new()

signal scene_path_changed(text)
signal file_browser_requested
signal open_root_dir_pressed
signal pin_button_toggled
signal run_button_pressed


func _init():
	scene_path_control.custom_minimum_size = Vector2(250, 20)
	pin_button.toggle_mode = true

	split_container.add_child(scene_path_control)
	split_container.add_child(file_browser_button)
	split_container.add_child(open_root_dir_button)
	split_container.add_child(remove_button)

	add_child(split_container)

	more_button.toggle_mode = true
	more_button.size_flags_vertical = SIZE_EXPAND_FILL
	more_button.connect("toggled",Callable(split_container,"set_visible"))
	split_container.visible = more_button.button_pressed

	add_child(more_button)
	add_child(pin_button)
	add_child(run_button)
	add_child(separator)

	scene_path_control.connect("text_changed",Callable(self,"_on_scene_path_text_changed"))
	file_browser_button.connect("pressed",Callable(self,"emit_signal").bind("file_browser_requested"))
	open_root_dir_button.connect("pressed",Callable(self,"emit_signal").bind("open_root_dir_pressed"))
	remove_button.connect("pressed",Callable(self,"_on_remove_button_pressed"))
	pin_button.connect("toggled",Callable(self,"_on_pin_button_toggled"))
	run_button.connect("pressed",Callable(self,"emit_signal").bind("run_button_pressed"))


func _on_scene_path_text_changed(new_text: String):
	emit_signal("scene_path_changed", new_text)


func _on_remove_button_pressed():
	scene_path_control.text = ""
	_on_scene_path_text_changed("")


func _on_pin_button_toggled(button_pressed: bool) -> void:
	emit_signal("pin_button_toggled", button_pressed)


func set_scene_path(new_path: String) -> void:
	scene_path_control.text = new_path


func get_scene_path() -> String:
	return scene_path_control.text

