extends Node

const DEBUG_OVERLAY: PackedScene = preload("res://addons/sh_utils/debug/debug_overlay.tscn")

@export var show_debug_overlay: bool = true
@export var debug_shortcuts_without_overlay: bool = false

var debug_overlay: Control


func _init() -> void:
	if not InputMap.has_action("sh_force_quit"):
		InputMap.add_action("sh_force_quit")
		var event = InputEventKey.new()
		event.physical_keycode = KEY_ESCAPE
		InputMap.action_add_event("sh_force_quit", event)
	
	if not InputMap.has_action("sh_force_reload_scene"):
		InputMap.add_action("sh_force_reload_scene")
		var event = InputEventKey.new()
		event.physical_keycode = KEY_R
		InputMap.action_add_event("sh_force_reload_scene", event)

	if not InputMap.has_action("sh_toggle_debug_overlay"):
		InputMap.add_action("sh_toggle_debug_overlay")
		var event = InputEventKey.new()
		event.physical_keycode = KEY_QUOTELEFT
		InputMap.action_add_event("sh_toggle_debug_overlay", event)


	if not InputMap.has_action("sh_toggle_vsync"):
		InputMap.add_action("sh_toggle_vsync")
		var event = InputEventKey.new()
		event.physical_keycode = KEY_V
		InputMap.action_add_event("sh_toggle_vsync", event)

	if not InputMap.has_action("sh_toggle_fullscreen"):
		InputMap.add_action("sh_toggle_fullscreen")
		var event = InputEventKey.new()
		event.physical_keycode = KEY_F
		InputMap.action_add_event("sh_toggle_fullscreen", event)

	if not InputMap.has_action("sh_capture_screenshot"):
		InputMap.add_action("sh_capture_screenshot")
		var event = InputEventKey.new()
		event.physical_keycode = KEY_P
		InputMap.action_add_event("sh_capture_screenshot", event)
	

func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	debug_overlay = DEBUG_OVERLAY.instantiate()
	add_child(debug_overlay)
	debug_overlay.visible = show_debug_overlay


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("sh_toggle_debug_overlay"):
		show_debug_overlay = !show_debug_overlay
		debug_overlay.visible = show_debug_overlay

	if show_debug_overlay or debug_shortcuts_without_overlay:
		if event.is_action_pressed("sh_force_quit"):
			Config.save_config()
			get_tree().quit()
		
		if event.is_action_pressed("sh_force_reload_scene"):
			get_tree().reload_current_scene()

		if event.is_action_pressed("sh_toggle_vsync"):
			if Config.settings["vsync"]:
				Config.set_vsync(false)
			else:
				Config.set_vsync(true)
				
		if event.is_action_pressed("sh_toggle_fullscreen"):
			if Config.settings["fullscreen"]:
				Config.set_fullscreen(false)
			else:
				Config.set_fullscreen(true)
		
		if event.is_action_pressed("sh_capture_screenshot"):
			capture_screenshot()


func capture_screenshot() -> void:
	var screenshots_dir: String = "user://screenshots"
	var real_dir: String = ProjectSettings.globalize_path(screenshots_dir)
	if not DirAccess.dir_exists_absolute(screenshots_dir):
		DirAccess.open("user://").make_dir("screenshots")

	var timestamp: String = Time.get_datetime_string_from_system(false, true)
	timestamp = timestamp.replace(":", "-").replace(" ", "_")
	var filename: String = "Screenshot_%s.png" % timestamp
	var filepath: String = screenshots_dir.path_join(filename)

	var image: Image = get_viewport().get_texture().get_image()
	var error: Error = image.save_png(filepath)

	if error == OK:
		print("%s saved: %s" % [filename, real_dir])
	else:
		print("Failed to save screenshot: %s" % real_dir)
