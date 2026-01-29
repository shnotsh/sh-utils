@tool
extends EditorPlugin


func _enable_plugin() -> void:
	add_autoload_singleton("Utils", "res://addons/sh_utils/utils/utils.gd")
	add_autoload_singleton("Config", "res://addons/sh_utils/config/config.gd")
	add_autoload_singleton("Debug", "res://addons/sh_utils/debug/debug.tscn")


func _disable_plugin() -> void:
	remove_autoload_singleton("Config")
	remove_autoload_singleton("Utils")
	remove_autoload_singleton("Debug")
