extends Node

signal config_changed

const CONFIG_PATH: String = "user://settings.cfg"
var verbose: bool = true

var settings: Dictionary = {}

var locales: Array[String] = []
var loaded_locales: PackedStringArray = TranslationServer.get_loaded_locales()
var locale: String


func _init() -> void:
	load_config()
	apply_config()
	save_config()


func get_config(cfg: ConfigFile) -> Dictionary:
	var _dict: Dictionary = {
		"locale": cfg.get_value("game", "locale", "en"),
		"fullscreen": cfg.get_value("video", "fullscreen", true),
		"vsync": cfg.get_value("video", "vsync", true),
	}
	return _dict


func set_config(dict: Dictionary) -> ConfigFile:
	var _cfg: ConfigFile = ConfigFile.new()
	_cfg.set_value("game", "locale", dict["locale"])
	_cfg.set_value("video", "fullscreen", dict["fullscreen"])
	_cfg.set_value("video", "vsync", dict["vsync"])
	return _cfg


func apply_config():
	var dict: Dictionary = settings
	set_locale(settings["locale"])
	set_fullscreen(settings["fullscreen"])
	set_vsync(settings["vsync"])


func load_config() -> void:
	var cfg: ConfigFile = ConfigFile.new()
	var err: int = cfg.load(CONFIG_PATH)

	if err == OK:
		settings = get_config(cfg)

	if OS.is_debug_build() and verbose:
		var real_dir: String = ProjectSettings.globalize_path(CONFIG_PATH)
		print("sh-utils: [Config] loaded from ", real_dir)


func save_config() -> void:
	var cfg: ConfigFile = set_config(settings)
	var save_result: int = cfg.save(CONFIG_PATH)
	if OS.is_debug_build() and verbose:
		var real_dir: String = ProjectSettings.globalize_path(CONFIG_PATH)
		if save_result == OK:
			print("sh-utils: [Config] saved to ", real_dir)
		else:
			printerr("sh-utils: [Config] ERROR: Failed to save config to ", real_dir, " (error code: ", save_result, ")")


func get_locales() -> Array[String]:
	locales.clear()
	if loaded_locales.is_empty():
		locales.append("en")
	for locale: String in loaded_locales:
		locales.append(String(locale))
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


func set_locale(locale: String) -> void:
	if locales.has(locale):
		settings["locale"] = locale
		TranslationServer.set_locale(locale)
	else:
		settings["locale"] = "en"
		TranslationServer.set_locale("en")
	config_changed.emit()


func set_fullscreen(val: bool) -> void:
	settings["fullscreen"] = val
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if val else DisplayServer.WINDOW_MODE_WINDOWED)
	config_changed.emit()


func set_vsync(val: bool) -> void:
	settings["vsync"] = val
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if val else DisplayServer.VSYNC_DISABLED)
	config_changed.emit()