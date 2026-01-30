extends Node

signal setting_changed(key: String, value: Variant)

const CONFIG_PATH: String = "user://settings.cfg"
const DEFAULT_SETTINGS: Dictionary = {
	"locale": "en",
	"fullscreen": true,
	"vsync": false,
}

var verbose: bool
var locales: Array[String]
var loaded_locales: PackedStringArray = TranslationServer.get_loaded_locales()
var locale: String

var _config_global_path: StringName
var _settings: Dictionary


func _init() -> void:
	if OS.is_debug_build():
		verbose = Debug.verbose
		Debug.debug_force_quit.connect(_on_debug_force_quit)
		Debug.debug_toggle_fullscreen.connect(_on_debug_toggle_fullscreen)
		Debug.debug_toggle_vsync.connect(_on_debug_toggle_vsync)

	_config_global_path = ProjectSettings.globalize_path(CONFIG_PATH)
	_settings = DEFAULT_SETTINGS.duplicate()

	
	load_config()
	set_config(_settings)


func load_config() -> void:
	var cfg: ConfigFile = ConfigFile.new()
	var err: int = cfg.load(CONFIG_PATH)
	if err != OK:
		printerr("sh-utils: [Config] ERROR: Failed to load config file (Error code: %d). Using defaults." % err)
		return

	if verbose: print("sh-utils: [Config] loaded from ", _config_global_path)

	_settings["locale"] = cfg.get_value("game", "locale", DEFAULT_SETTINGS["locale"])
	_settings["fullscreen"] = cfg.get_value("video", "fullscreen", DEFAULT_SETTINGS["fullscreen"])
	_settings["vsync"] = cfg.get_value("video", "vsync", DEFAULT_SETTINGS["vsync"])

	apply_config()


func apply_config() -> void:
	set_locale(get_setting("locale"))
	set_fullscreen(get_setting("fullscreen"))
	set_vsync(get_setting("vsync"))


func get_setting(key: String, default: Variant = null) -> Variant:
	return _settings.get(key, default)


func get_all_settings() -> Dictionary:
	return _settings.duplicate()


func set_config(dict: Dictionary) -> ConfigFile:
	var _cfg: ConfigFile = ConfigFile.new()
	_cfg.set_value("game", "locale", dict.get("locale", DEFAULT_SETTINGS["locale"]))
	_cfg.set_value("video", "fullscreen", dict.get("fullscreen", DEFAULT_SETTINGS["fullscreen"]))
	_cfg.set_value("video", "vsync", dict.get("vsync", DEFAULT_SETTINGS["vsync"]))
	return _cfg


func save_config() -> void:
	var cfg: ConfigFile = set_config(_settings)
	var save_result: int = cfg.save(CONFIG_PATH)
	if save_result != OK:
		printerr("sh-utils: [Config] ERROR: Failed to save config to ", _config_global_path, " (error code: ", save_result, ")")
		return
	if verbose: print("sh-utils: [Config] saved to ", _config_global_path)


func get_locales() -> Array[String]:
	locales.clear()
	if loaded_locales.is_empty():
		locales.append("en")
	for _locale: String in loaded_locales:
		locales.append(_locale)
	return locales


func get_system_locale() -> String:
	var system_locale: String = OS.get_locale()
	if locales.has(system_locale):
		return system_locale
	var lang_part: String = system_locale.split("_")[0]
	if locales.has(lang_part):
		return lang_part
	if locales.has("en"):
		return "en"
	return locales[0] if not locales.is_empty() else "en"


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_EXIT_TREE:
		save_config()


func _on_debug_force_quit() -> void:
	save_config()
	get_tree().quit()


func _on_debug_toggle_vsync() -> void:
	set_vsync(not get_setting("vsync", true))


func _on_debug_toggle_fullscreen() -> void:
	set_fullscreen(not get_setting("fullscreen", true))


func set_locale(new_locale: String) -> void:
	if not locales.has(new_locale):
		new_locale = "en"
	
	_settings["locale"] = new_locale
	TranslationServer.set_locale(new_locale)
	setting_changed.emit("locale", new_locale)


func set_fullscreen(val: bool) -> void:
	_settings["fullscreen"] = val
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if val else DisplayServer.WINDOW_MODE_WINDOWED)
	setting_changed.emit("fullscreen", val)


func set_vsync(val: bool) -> void:
	_settings["vsync"] = val
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if val else DisplayServer.VSYNC_DISABLED)
	setting_changed.emit("vsync", val)