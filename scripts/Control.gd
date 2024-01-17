extends TabBar


# Called when the node enters the scene tree for the first time.
func _ready():
	%Mouse.value = Persistence.config.get_value("Mouse_sensitivity", '0')
	print(%Mouse.value)


func _on_mouse_value_changed(value):
	pass # Replace with function body.
