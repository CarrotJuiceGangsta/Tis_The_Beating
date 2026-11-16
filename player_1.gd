extends CharacterBody2D

@onready var state_label: Label = $State_Label

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#var airborn = false
#var walking = false
#var idle = false
enum movement_states {
	STANDING_IDLE,
	CROUCHING_IDLE,
	JUMPING_UP,
	WALKING_FORWARD,
	WALKING_BACKWARD,
	CROUCHING_FORWARD,
	CROUCHING_BACKWARD,
	JUMPING_FORWARD,
	JUMPING_BACKWARD,
}

var movement_state : movement_states

func _ready() -> void:
	movement_state = movement_states.STANDING_IDLE



func _process(delta: float) -> void:
	state_label.text = movement_states.keys()[movement_state]
	movement(delta)



func movement(delta):
	#Input Logic
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("crouch", "jump")
	
	# Gravity logic
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Walking logic
	if direction_x > 0 and direction_y == 0 and is_on_floor():
		movement_state = movement_states.WALKING_FORWARD
		velocity.x = direction_x * SPEED
		print("walking forward")
	elif direction_x < 0 and direction_y == 0 and is_on_floor():
		movement_state = movement_states.WALKING_BACKWARD
		velocity.x = direction_x * SPEED
		print("walking backward")
	elif is_on_floor() and direction_y == 0 and direction_x == 0:
		movement_state = movement_states.STANDING_IDLE
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Jumping logic
	if direction_x > 0 and direction_y > 0 and is_on_floor():
		movement_state = movement_states.JUMPING_FORWARD
		velocity.x = direction_x * SPEED
		velocity.y = JUMP_VELOCITY
		print("jumping forward")
	if direction_x < 0 and direction_y > 0 and is_on_floor():
		movement_state = movement_states.JUMPING_BACKWARD
		velocity.x = direction_x * SPEED
		velocity.y = JUMP_VELOCITY
		print("jumping backward")
	if direction_x == 0 and direction_y > 0 and is_on_floor():
		movement_state = movement_states.JUMPING_UP
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = JUMP_VELOCITY
		print("jumping up")
	
	# Crouching logic
	if direction_x > 0 and direction_y < 0 and is_on_floor():
		movement_state = movement_states.CROUCHING_FORWARD
		velocity.x = direction_x * SPEED / 2
		print("crouching forward")
		
	if direction_x < 0 and direction_y < 0 and Input.is_action_pressed("crouch") and is_on_floor():
		movement_state = movement_states.CROUCHING_BACKWARD
		velocity.x = direction_x * SPEED / 2
		print("crouching backward")
		
	if direction_x == 0 and direction_y < 0 and Input.is_action_pressed("crouch") and is_on_floor():
		movement_state = movement_states.CROUCHING_IDLE
		velocity.x = move_toward(velocity.x, 0, SPEED)
		print("crouching idle")
		
	
	move_and_slide()
