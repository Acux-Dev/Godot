extends CharacterBody3D

@onready var head = $head
@onready var third_person_cam = $head/third_person_cam
@onready var first_person_cam = $head/first_person_cam

@export var current_speed = 5.0

const walking_speed = 5.0
const sprinting_speed = 9.0
const crouching_speed = 3.0

const jump_velocity = 4.5

var mouse_sensitivity := 0.1

var lerp_speed = 15.0

var direction = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	third_person_cam.current = true

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x) * mouse_sensitivity)
		head.rotate_x(deg_to_rad(-event.relative.y) * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-90),deg_to_rad(90))
	
	if Input.is_action_just_pressed("exit"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("click") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("scroll_up"):
		third_person_cam.current = false
	
	if event.is_action_pressed("scroll_down"):
		third_person_cam.current = true

func _physics_process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_pressed("crouch"):
			current_speed = crouching_speed
		else:
			if Input.is_action_pressed("sprint"):
				current_speed = sprinting_speed
			else:
				current_speed = walking_speed
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)
		if direction:
			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)

		move_and_slide()
