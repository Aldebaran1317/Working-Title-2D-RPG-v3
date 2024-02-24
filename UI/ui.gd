extends CanvasLayer

func _ready():
	DialogueManager.show_UI_signal.connect(show_UI)
	
func show_UI():
	if visible:
		print_debug("UI hidden")
		visible = false
	else:
		print_debug("UI shown")
		visible = true
