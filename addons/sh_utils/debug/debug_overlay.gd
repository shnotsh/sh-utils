extends Control

@onready var perf_label: Label = %"PerformanceLabel"
@onready var sys_info_label: Label = %"SysInfoLabel"
@onready var config_label: Label = %"ConfigLabel"
@onready var tab_container: TabContainer = $DebugPerformanceOverlay/TabContainer


func _ready() -> void:
	sys_info_label.text = "[Hardware]\n%s" % Utils.str_from_dict(Debug.get_hardware_info())
	config_label.text = "[Config]\n%s" % Utils.str_from_dict(Config.get_all_settings())


func _physics_process(_delta: float) -> void:
	perf_label.text = "[Performance]\n%s" % Utils.str_from_dict(Debug.get_performance_info())


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
