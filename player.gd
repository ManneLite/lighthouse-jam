extends CharacterBody3D

## Player speed [m/s]
@export var speed: float = 14 

## Downward acceleration in air [m/s]
@export var fall_acceleration: float = 75

## Mouse rotation sensitivity for x axis
@export var yaw: float = 0.01

## Mouse rotation sensitivity for y axis
@export var pitch: float = 0.01

@onready var pivot : Node3D= $Pivot
@onready var camera := $Pivot/Camera3D

var target_velocity: Vector3 = Vector3.ZERO

func _unhandled_input(event: InputEvent)-> void:
    if event is InputEventMouseButton:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    elif event.is_action_pressed("escape"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        if event is InputEventMouseMotion:
            pivot.rotate_y(-event.relative.x * yaw)
            camera.rotate_x(-event.relative.y * pitch)
            camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-40),deg_to_rad(60))
            
        

func _physics_process(delta: float) -> void:
    var input_dir := Input.get_vector("move_left","move_right","move_forward","move_back")
    var direction := (pivot.transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = move_toward(velocity.x,0,speed)
        velocity.z = move_toward(velocity.z,0,speed)


    if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
        target_velocity.y = target_velocity.y - (fall_acceleration * delta)

    move_and_slide()
