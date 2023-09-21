@tool
extends EditorPlugin

const ps_message = preload("res://addons/jesus_in_control/JIC_Message.tscn")
var message_popup : Window

func _enter_tree() -> void:
	message_popup = ps_message.instantiate()
	add_child(message_popup)
	pass


func _exit_tree() -> void:
	remove_child(message_popup)
	pass
