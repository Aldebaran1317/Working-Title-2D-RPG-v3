extends Node

signal show_UI_signal

func show_UI():
	emit_signal("show_UI_signal")
	print_debug("It's working!")
