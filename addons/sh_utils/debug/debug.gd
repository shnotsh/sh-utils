extends Node

signal debug_force_quit
signal debug_toggle_fullscreen
signal debug_toggle_vsync

const DEBUG_OVERLAY: PackedScene = preload("res://addons/sh_utils/debug/debug_overlay.tscn")

@export var show_debug_overlay: bool = true
@export var debug_shortcuts_without_overlay: bool = true
@export var verbose: bool = true

var project_name: String = ProjectSettings.get_setting("application/config/name", "Untitled")
var project_ver: String = ProjectSettings.get_setting("application/config/version", "0.0")

var debug_overlay: Control


func _ready() -> void:
	if OS.is_debug_build():
		set_debug_keyboard_actions()

		debug_overlay = DEBUG_OVERLAY.instantiate()
		debug_overlay.visible = show_debug_overlay
		add_child(debug_overlay)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("sh_toggle_debug_overlay"):
		show_debug_overlay = !show_debug_overlay
		debug_overlay.visible = show_debug_overlay

	if show_debug_overlay or debug_shortcuts_without_overlay:
		if event.is_action_pressed("sh_force_quit"):
			debug_force_quit.emit()
		if event.is_action_pressed("sh_force_reload_scene"):
			get_tree().reload_current_scene()
		if event.is_action_pressed("sh_toggle_vsync"):
			debug_toggle_vsync.emit()
		if event.is_action_pressed("sh_toggle_fullscreen"):
			debug_toggle_fullscreen.emit()
		if event.is_action_pressed("sh_capture_screenshot"):
			capture_screenshot()


func get_hardware_info() -> Dictionary:
	var _gpu_type: String
	match RenderingServer.get_video_adapter_type():
		RenderingDevice.DEVICE_TYPE_OTHER: _gpu_type = "Unknown"
		RenderingDevice.DEVICE_TYPE_INTEGRATED_GPU: _gpu_type = "Integrated"
		RenderingDevice.DEVICE_TYPE_DISCRETE_GPU: _gpu_type = "Discrete"
		RenderingDevice.DEVICE_TYPE_VIRTUAL_GPU: _gpu_type = "Virtual"
		RenderingDevice.DEVICE_TYPE_CPU: _gpu_type = "CPU"
	return {
		"Platform": "%s %s" % [OS.get_name(), OS.get_version()],
		"CPU": "%s (%s)" % [OS.get_processor_name(), OS.get_processor_count()],
		"GPU": "%s (%s)" % [RenderingServer.get_video_adapter_name(), _gpu_type],
		"API version": "%s" % RenderingServer.get_video_adapter_api_version(),
		"Rendering Driver": "%s" % [RenderingServer.get_current_rendering_driver_name()],
		"RAM": "%.0f MB" % (OS.get_memory_info()["physical"] / 1048576),
		"System Locale": "%s" % OS.get_locale_language(),
		"Display": "%s (%s)" % [Utils.str_from_vec(DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())), DisplayServer.window_get_current_screen()],
	}


func get_performance_info() -> Dictionary:
	return {
		"FPS": "%.0f %s" % [Performance.get_monitor(Performance.TIME_FPS), "(VSync)" if DisplayServer.window_get_vsync_mode() else ""],
		"CPU Time": "%.3f" % (Performance.get_monitor(Performance.TIME_PROCESS) * 1000),
		"Objects Drawn": "%d" % Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME),
		"Nodes": "%d" % Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		"Primitives": "%d" % Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME),
		"Draw Calls": "%d" % Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
		"VRAM Usage": "%.2f MB" % (Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576),
		"RAM Usage": "%.2f MB" % (Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576),
		"Window Size": "%s" % Utils.str_from_vec(DisplayServer.window_get_size())
	}


func set_debug_keyboard_actions() -> void:
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
