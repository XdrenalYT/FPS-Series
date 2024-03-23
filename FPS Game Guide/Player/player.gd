extends CharacterBody3D


var MOUSE_SENS := 0.005
var gravity := -3
var speed := 20.0

const DFLT_SPEED: float = 20.0

var angForCamToLearpTo := 0.0
var XangForCamToLearpTo := 0.0
var ySpeed := 0.0
var jumpStrength := 75
var jumpNum := 0
var maxJumpAmt := 1

var sprintSpeed = 20


@onready var neck = $Neck
@onready var camera_3d = $Neck/Camera3D



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENS)
		neck.rotate_x(-event.relative.y * MOUSE_SENS)
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-50), deg_to_rad(60))
		


func jump() -> void:
	jumpNum += 1
	ySpeed = jumpStrength



func _physics_process(delta: float) -> void:
	
	velocity = get_dir().rotated( Vector3.UP, rotation.y) * speed
	
	if not is_on_floor():
		ySpeed += gravity
	else:
		ySpeed = 0.0
		jumpNum = 0
	if Input.is_action_just_pressed("Jump") and (jumpNum < maxJumpAmt):
		jump()
	if Input.is_action_pressed("Sprint"):
		if is_on_floor():
			speed += sprintSpeed
		else:
			speed = DFLT_SPEED
	else:
		speed = DFLT_SPEED
	
	camera_3d.rotation_degrees.x = lerp(camera_3d.rotation_degrees.x, XangForCamToLearpTo, 0.1)
	velocity.y = ySpeed
	move_and_slide()


func get_dir() -> Vector3:
	var dir : Vector3
	
	dir.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	dir.z = Input.get_action_strength("Back") - Input.get_action_strength("Forward")
	angForCamToLearpTo = dir.x*-2.5
	XangForCamToLearpTo = dir.z*7.5
	return dir.normalized()

