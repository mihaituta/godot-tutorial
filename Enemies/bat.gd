extends CharacterBody2D

@onready var stats = $Stats

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200
@export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE
var knockback = Vector2.ZERO

@onready var playerDetectionArea = $PlayerDetectionArea
@onready var sprite = $AnimatedSprite
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	set_knockback_velocity(delta)
	
	match state: 
		IDLE: 
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER: 
			if wanderController.get_time_left() == 0:
				update_wander()

			accelerate_towards_point(wanderController.target_position, delta)

			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
		CHASE:
			var player = playerDetectionArea.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE 

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	move_and_slide()
	
func set_knockback_velocity(delta):
	var old_velocity = velocity
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = knockback
	move_and_slide()
	knockback = velocity
	velocity = old_velocity

func accelerate_towards_point(point, delta):
	var direction = position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta) 
	sprite.flip_h = velocity.x < 0

func seek_player():
	print(playerDetectionArea)
	if playerDetectionArea.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE,WANDER])
	wanderController.start_wander_timer(randf_range(1,3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	
func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.position = position

func _on_hurtbox_invincibility_started():
	animationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
