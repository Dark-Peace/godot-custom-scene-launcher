extends FileDialog


func _init():
	mode = FileDialog.FILE_MODE_OPEN_FILE
	access = FileDialog.ACCESS_RESOURCES
	set_filters(PackedStringArray(["*.tscn ; Godot Scenes"]))
