extends Control

@onready var perf_label: Label = %"PerformanceLabel"
@onready var sys_info_label: Label = %"SysInfoLabel"
@onready var tab_container: TabContainer = $DebugPerformanceOverlay/TabContainer


func _ready() -> void:
	sys_info_label.text = "%s %s\nPlatform: %s\nCPU: %s\nCPU Cores: %d\nGPU: %s\nAPI: %s\nRendering Driver: %s\nMem Info: %.2f MB\nSystem Locale: %s\nWindow Size: %s\nScreen DPI: %s" % [
		ProjectSettings.get_setting("application/config/name", "Untitled"),
		ProjectSettings.get_setting("application/config/version", "0.0"),
		OS.get_name(),
		"Unknown" if OS.get_processor_name() == "" else OS.get_processor_name(),
		OS.get_processor_count(),
		RenderingServer.get_video_adapter_name(),
		RenderingServer.get_video_adapter_api_version(),
		RenderingServer.get_current_rendering_driver_name(),
		OS.get_memory_info()["physical"] / 1048576,
		OS.get_locale(),
		DisplayServer.window_get_size(),
		DisplayServer.screen_get_dpi(DisplayServer.window_get_current_screen()),
	]


func _process(_delta: float) -> void:
	perf_label.text = "FPS%s: %s\nCPU: %s\nObjects: %d\nNodes: %d\nPrimitives: %d\nDraw Calls: %d\nVRAM: %.2f MB\nRAM: %.2f MB" % [
		bool_to_string(DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED, " (VSync)", ""),
		Performance.get_monitor(Performance.TIME_FPS),
		Performance.get_monitor(Performance.TIME_PROCESS) * 1000,
		Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME),
		Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME),
		Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
		Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576,
		Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576,
	]


func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				tab_container.current_tab = 0
			KEY_2:
				tab_container.current_tab = 1
			KEY_3:
				tab_container.current_tab = 2
			KEY_4:
				tab_container.current_tab = 3
			KEY_5:
				tab_container.current_tab = 4


func bool_to_string(value: bool, true_value: String, false_value: String) -> String:
	return true_value if value else false_value
