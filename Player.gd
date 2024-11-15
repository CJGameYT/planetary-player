extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var camera_speed = 0.1

#mouse capture
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#looking around

func _process(delta):
	if Input.is_action_pressed("look left"):
		$Camera3D.rotate_y(camera_speed)
	if Input.is_action_pressed("look right"):
		$Camera3D.rotate_y(-camera_speed)
	if Input.is_action_pressed("look up"):
		$Camera3D.rotate_x(camera_speed)
	if Input.is_action_pressed("look down"):
		$Camera3D.rotate_x(-camera_speed)
		

#...
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "Forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
