extends CharacterBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

@export var ACCELERATION = 600
@export var MAX_SPEED = 80
@export var ROLL_SPEED = 120
@export var FRICTION = 700

enum {MOVE, ROLL, ATTACK}

var state = MOVE
var roll_vector = Vector2.DOWN
var stats = PlayerStats

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitbox
@onready var hurtbox = $Hurtbox
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

#runs after everything is loaded
func _ready():
	stats.no_health.connect(queue_free)
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

#main loop
func _physics_process(delta): 
	match state:
		MOVE: 
			move_state(delta)
		ROLL: 
			roll_state()
		ATTACK: 
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down") 
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO: 
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	move_and_slide()
	animationState.travel("Roll")

func attack_state(delta):
	#velocity = Vector2.ZERO
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION/1.5 * delta)
	move_and_slide()
	animationState.travel("Attack")

func roll_animation_finished():
	#velocity = velocity * 0.5;
	velocity = roll_vector * MAX_SPEED
	state = MOVE

func attack_animation_finished():
	state = MOVE

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(1)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
