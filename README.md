# Godot Custom Scene Launcher

Add a button to run any custom scene, next to the buttons to run the current and main scene. Original plugin for Godot 3 by Xananax.

![a view of the plugin, showing the path and the different buttons](https://gitlab.com/godot-addons/custom-scene-launcher/-/raw/main/example.png)

1. Path of the scene that will run
2. File browser to set a specific scene
3. Open settings directory in OS file browser
4. Clear current scene
5. Hide/Show everything to the left (they are hidden by default)
6. Pin current scene
7. Play current scene (or press <kbd>F7</kbd>)

## Basic Usage

At first, using this plugin isn't different from `Play Scene` button (<kbd>F6</kbd>)</kbd>).

However, by pressing the "pin" icon, you will prevent the scene from changing as you navigate to new tabs.

You can also use the "file browser" icon to navigate to a specific path.

## Advanced Usage

Say you wanted to load a specific scene, but you have a custom bootstrap sequence, as many games do.

The current scene is saved into the plugin settings; you can therefore retrieve it at runtime.

- Step 1: Click the "Open Settings Directory" button to retrieve the current directory. In my case, it looks like: `"/home/xananax/.config/godot/projects/scene-runner-4b012470566bfbcf0efd40f68ef71164"`
- Step 2: Use the example below:

```gdscript
func _ready():
	var project_path := "<the long directory you got in step 1>"
	var scene_path := CustomSceneLauncher.get_current_scene(project_path)
	print(scene_path)
```
