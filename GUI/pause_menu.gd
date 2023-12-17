extends ColorRect

@onready var animation_player = $AnimationPlayer
@onready var resume_button : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Resume_Button
@onready var settings_button : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Settings_Button
@onready var restart_button : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Restart_Button
@onready var exit_button : Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Exit_Button

# Called when the node enters the scene tree for the first time.
func _ready():
	resume_button.pressed.connect(unpause)
	#settings_button.pressed.connect()
	#restart_button.pressed.connect()
	#exit_button.pressed.connect()

func unpause():
	animation_player.play("Unpause")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	await get_tree().create_timer(0.01).timeout
	get_tree().paused = false

func pause():
	animation_player.play("Pause")
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
