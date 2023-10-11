extends CharacterBody3D

const WALKING_SPEED = 4
const RUNNING_SPEED = 7
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.3
const VERTICAL_VIEW_LIMIT = 90
const LERP_SPEED = 10

@onready var head = $head
var speed
var direction = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	speed = WALKING_SPEED
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clampf(head.rotation.x, deg_to_rad(-VERTICAL_VIEW_LIMIT), deg_to_rad(VERTICAL_VIEW_LIMIT))

func _physics_process(delta):
	
	if Input.is_key_pressed(KEY_SHIFT):
		speed = RUNNING_SPEED
	else:
		speed = WALKING_SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * LERP_SPEED)
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
