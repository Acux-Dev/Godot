extends TabBar


# Called when the node enters the scene tree for the first time.
func _ready():
	%Mouse.value = Persistence.config.get_value("Control", 'Mouse_sensitivity')
	%Mouse_sense.text = str(%Mouse.value)


func _on_mouse_value_changed(value):
	Persistence.config.set_value("Control","Mouse_sensitivity",value)
	%Mouse_sense.text = str(value)
	Persistence.save_data()
