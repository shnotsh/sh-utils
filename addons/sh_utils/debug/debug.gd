extends Node

@export var show_debug_overlays: bool = true
@onready var debug_overlays: Control = $DebugOverlays

func _init() -> void:
	if not InputMap.has_action("sh_force_quit"):
		InputMap.add_action("sh_force_quit")
		var event = InputEventKey.new()
		event.physical_keycode = KEY_ESCAPE
		InputMap.action_add_event("sh_force_quit", event)

	if not InputMap.has_action("sh_toggle_debug_overlays"):
		InputMap.add_action("sh_toggle_debug_overlays")
		var event = InputEventKey.new()
		event.physical_keycode = KEY_QUOTELEFT
		InputMap.action_add_event("sh_toggle_debug_overlays", event)

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
	

func _ready() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	debug_overlays.visible = show_debug_overlays


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("sh_toggle_debug_overlays"):
		show_debug_overlays = !show_debug_overlays
		debug_overlays.visible = show_debug_overlays

	if show_debug_overlays:
		if event.is_action_pressed("sh_force_quit"):
			get_tree().quit()

		if event.is_action_pressed("sh_toggle_vsync"):
			if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			else:
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
				
		if event.is_action_pressed("sh_toggle_fullscreen"):
			var screen: int = DisplayServer.window_get_mode()
			if screen == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
