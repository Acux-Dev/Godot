extends ColorRect

@onready var animation_player = $AnimationPlayer
@onready var resume_button : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Resume_Button
@onready var settings_button : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Settings_Button
@onready var restart_button : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Restart_Button
@onready var exit_button : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Exit_Button
@onready var canvas_settings = %CanvasSettings

# Called when the node enters the scene tree for the first time.
func _ready():
	resume_button.pressed.connect(unpause)
	settings_button.pressed.connect(settings)
	#restart_button.pressed.connect()
	#exit_button.pressed.connect()

func _input(event):
	if get_tree().paused == true:
		if event.is_action_pressed("exit"):
			unpause()

func unpause():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func pause():
	show()
	animation_player.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func settings():
	hide()
	canvas_settings.show()
