extends CharacterBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 600

enum {MOVE, ROLL, ATTACK}

var state = MOVE

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

#runs after everything is loaded
func _ready():
	animationTree.active = true

#main loop
func _physics_process(delta): 
	match state:
		MOVE: 
			move_state(delta)
		ROLL: 
			pass
		ATTACK: 
			attack_state(delta)
	

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO: 
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	#velocity = Vector2.ZERO
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION/1.5 * delta)
	move_and_slide()
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE
