extends CharacterBody2D

@onready var state_label: Label = $State_Label
@onready var flip: Node = $Flip

const SPEED = 1000.0
const JUMP_VELOCITY = -2000.0


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
var is_flipped = false

func _ready() -> void:
	movement_state = movement_states.STANDING_IDLE

func _physics_process(delta: float) -> void:
	Global.player_1_x = position.x
	state_label.text = movement_states.keys()[movement_state]
	
	if position.x > Global.player_2_x:
		flip.scale.x = -1
		is_flipped = true
	
	if position.x < Global.player_2_x:
		flip.scale.x = 1
		is_flipped = false
	
	movement(delta)

func movement(delta):
	#Input Logic
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("crouch", "jump")
	

	# Gravity logic
	if not is_on_floor():
		velocity += get_gravity() * delta * 4
	
	# Walking logic
	if direction_x > 0 and direction_y == 0 and is_on_floor():
		if is_flipped == false:
			movement_state = movement_states.WALKING_FORWARD
			print("walking forward")
		if is_flipped == true:
			movement_state = movement_states.WALKING_BACKWARD
			print("walking backward")
		velocity.x = direction_x * SPEED

	elif direction_x < 0 and direction_y == 0 and is_on_floor():
		if is_flipped == false:
			movement_state = movement_states.WALKING_BACKWARD
			print("walking backward")
		if is_flipped == true:
			movement_state = movement_states.WALKING_FORWARD
			print("walking forward")
		velocity.x = direction_x * SPEED

	elif is_on_floor() and direction_y == 0 and direction_x == 0:
		movement_state = movement_states.STANDING_IDLE
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Jumping logic
	if direction_x > 0 and direction_y > 0 and is_on_floor():
		if is_flipped == false:
			movement_state = movement_states.JUMPING_FORWARD
			print("jumping forward")
		if is_flipped == true:
			movement_state = movement_states.JUMPING_BACKWARD
			print("jumping backward")
		velocity.x = direction_x * SPEED * 2
		velocity.y = JUMP_VELOCITY
	
	if direction_x < 0 and direction_y > 0 and is_on_floor():
		if is_flipped == false:
			movement_state = movement_states.JUMPING_BACKWARD
			print("jumping backward")
		if is_flipped == true:
			movement_state = movement_states.JUMPING_FORWARD
			print("jumping forward")
		velocity.x = direction_x * SPEED * 2
		velocity.y = JUMP_VELOCITY
	
	if direction_x == 0 and direction_y > 0 and is_on_floor():
		movement_state = movement_states.JUMPING_UP
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = JUMP_VELOCITY
		print("jumping up")
	
	# Crouching logic
	if direction_x > 0 and direction_y < 0 and is_on_floor():
		if is_flipped == false:
			movement_state = movement_states.CROUCHING_FORWARD
			print("crouching forward")
		if is_flipped == true:
			movement_state = movement_states.CROUCHING_BACKWARD
			print("crouching backward")
	velocity.x = direction_x * SPEED / 2
	
	if direction_x < 0 and direction_y < 0 and Input.is_action_pressed("crouch") and is_on_floor():
		if is_flipped == false:
			movement_state = movement_states.CROUCHING_BACKWARD
			print("crouching backward")
		if is_flipped == true:
			movement_state = movement_states.CROUCHING_FORWARD
			print("crouching forward")
		velocity.x = direction_x * SPEED / 2
	if direction_x == 0 and direction_y < 0 and Input.is_action_pressed("crouch") and is_on_floor():
		movement_state = movement_states.CROUCHING_IDLE
		velocity.x = move_toward(velocity.x, 0, SPEED)
		print("crouching idle")
		
	
	move_and_slide()
