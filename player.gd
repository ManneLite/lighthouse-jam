extends CharacterBody3D

## Player speed [m/s]
@export var speed: float = 14 

## Downward acceleration in air [m/s]
@export var fall_acceleration: float = 75

var target_velocity: Vector3 = Vector3.ZERO

func _physics_process(delta):
    var direction = Vector3.ZERO
    if Input.is_action_pressed("move_right"):
        direction.x += 1
    if Input.is_action_pressed("move_left"):
        direction.x -= 1
    if Input.is_action_pressed("move_back"):
        direction.z += 1
    if Input.is_action_pressed("move_forward"):
        direction.z -= 1

    if direction != Vector3.ZERO:
        direction = direction.normalized()
        $Pivot.basis = Basis.looking_at(direction)

    target_velocity.x = direction.x * speed
    target_velocity.z = direction.z * speed

    if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
        target_velocity.y = target_velocity.y - (fall_acceleration * delta)

    velocity = target_velocity
    move_and_slide()
