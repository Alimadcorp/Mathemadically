@tool
extends EditorPlugin

var exporter: EditorExportPlugin
var dock_instance: Control

func _enter_tree() -> void:
	exporter = preload("res://addons/versions/handler.gd").new()
	add_export_plugin(exporter)
	dock_instance = preload("res://addons/versions/version_inc.gd").new()
	add_control_to_bottom_panel(dock_instance, "Game Version Control")

func _exit_tree() -> void:
	remove_export_plugin(exporter)
	exporter = null
	
	remove_control_from_bottom_panel(dock_instance)
	dock_instance.queue_free()
