extends CharacterBody3D

# nodos
@onready var head = $head
@onready var third_person_cam = $head/third_person_cam
@onready var first_person_cam = $head/first_person_cam
@onready var standing_collision_shape_3d = $standing_CollisionShape3D
@onready var crouching_collision_shape_3d_2 = $crouching_CollisionShape3D2
@onready var ray_cast_3d = $RayCast3D

@export var current_speed = 5.0

# velocidades
const walking_speed = 5.0
const sprinting_speed = 9.0
const crouching_speed = 3.0

const jump_velocity = 4.5

# sensibilidad del mouse
var mouse_sensitivity = 0.1

# velocidad de ajuste de movimiento (mientras mayor se mueve menos)
var lerp_speed = 15.0

var direction = Vector3.ZERO

# profundidad de agacharse
var crouching_depth = -0.6

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	third_person_cam.current = true
	
	#agarra la sensibilidad del archivo de configuracion
	mouse_sensitivity = Persistence.config.get_value("Control","Mouse_sensitivity")


func _input(event):
	# movimiento de camara
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x) * mouse_sensitivity)
		head.rotate_x(deg_to_rad(-event.relative.y) * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-90),deg_to_rad(90))
	
	# sacar mouse de pantalla
	if event.is_action_pressed("exit"):
		$"../Pause_Menu".pause()
	
	# cambiar entre primera y tercera persona
	if event.is_action_pressed("scroll_up"):
		third_person_cam.current = false
	
	if event.is_action_pressed("scroll_down"):
		third_person_cam.current = true

func _physics_process(delta):
	if Input.is_action_pressed("crouch"):
		current_speed = crouching_speed
		standing_collision_shape_3d.disabled = true
		crouching_collision_shape_3d_2.disabled = false
		
	# crouching logic
	elif !ray_cast_3d.is_colliding():
		standing_collision_shape_3d.disabled = false
		crouching_collision_shape_3d_2.disabled = true
		if Input.is_action_pressed("sprint"):
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed
	
	if first_person_cam.current == true:
		if Input.is_action_pressed("crouch"):
			head.position.y = lerp(head.position.y, 1.8 + crouching_depth, delta * lerp_speed)
		elif !ray_cast_3d.is_colliding():
			head.position.y = lerp(head.position.y, 1.8, delta * lerp_speed)
	
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

func new_mouse_sense(value):
	mouse_sensitivity = value
