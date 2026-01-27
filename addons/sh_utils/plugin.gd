@tool
extends EditorPlugin


func _enable_plugin() -> void:
	add_autoload_singleton("Debug", "res://addons/sh_utils/debug/debug.tscn")
	add_autoload_singleton("Utils", "res://addons/sh_utils/utils/utils.gd")


func _disable_plugin() -> void:
	remove_autoload_singleton("Debug")
	remove_autoload_singleton("Utils")
