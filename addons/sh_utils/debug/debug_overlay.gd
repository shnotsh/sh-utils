extends Control

@onready var perf_label: Label = %"PerformanceLabel"
@onready var sys_info_label: Label = %"SysInfoLabel"
@onready var config_label: Label = %"ConfigLabel"
@onready var tab_container: TabContainer = $DebugPerformanceOverlay/TabContainer

var project_name: String
var project_ver: String

func _ready() -> void:
	Config.config_changed.connect(_on_config_changed)

	project_name = ProjectSettings.get_setting("application/config/name", "Untitled")
	project_ver = ProjectSettings.get_setting("application/config/version", "0.0")

	sys_info_label.text = "%s\nPlatform: %s\nCPU: %s\nCPU Cores: %d\nGPU: %s\nAPI version: %s\nRendering Driver: %s\nRAM: %.2f MB\nSystem Locale: %s\nDisplays Count: %d\nPrimary Display ID: %d\nCurrent Display ID: %d\nCurrent Display Size: %s\nCurrent Display DPI: %d\n" % [
		"%s %s \n[%s]" % [project_name, project_ver, "Hardware"],
		OS.get_name(),
		"Unknown" if OS.get_processor_name() == "" else OS.get_processor_name(),
		OS.get_processor_count(),
		RenderingServer.get_video_adapter_name(),
		RenderingServer.get_video_adapter_api_version(),
		RenderingServer.get_current_rendering_driver_name(),
		OS.get_memory_info()["physical"] / 1048576,
		OS.get_locale(),
		DisplayServer.get_screen_count(),
		DisplayServer.get_primary_screen(),
		DisplayServer.window_get_current_screen(),
		Utils.vector2i_to_string(DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())),
		DisplayServer.screen_get_dpi(DisplayServer.window_get_current_screen()),
		
	]

	var a: RayCast3D
	config_label.text = "%s\n%s" % [
		"%s %s \n[%s]" % [project_name, project_ver, "Config"],
		Utils.dictionary_to_string(Config.settings),
	]

func _process(_delta: float) -> void:
	perf_label.text = "%s\nFPS%s: %.0f\nCPU: %.3f\nObjects Drawn: %d\nNodes: %d\nPrimitives: %d\nDraw Calls: %d\nVRAM Usage: %.2f MB\nRAM Usage: %.2f MB\nWindow Size: %s\n" % [
		"%s %s \n[%s]" % [project_name, project_ver, "Performance"],
		Utils.bool_to_string(DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED, " (VSync)", ""),
		Performance.get_monitor(Performance.TIME_FPS),
		Performance.get_monitor(Performance.TIME_PROCESS) * 1000,
		Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME),
		Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME),
		Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
		Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576,
		Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576,
		Utils.vector2i_to_string(DisplayServer.window_get_size()),
	]


func _on_config_changed() -> void:
	config_label.text = "%s\n%s" % [
		"%s %s \n[%s]" % [project_name, project_ver, "Config"],
		Utils.dictionary_to_string(Config.settings),
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