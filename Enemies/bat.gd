extends CharacterBody2D

@onready var stats = $Stats

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200

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

func _physics_process(delta):
	set_knockback_velocity(delta)
	
	match state: 
		IDLE: 
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER: 
			pass
		CHASE:
			var player = playerDetectionArea.player
			if player != null:
				#var direction = (player.global_position - global_position).normalized()
				var direction = position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta) 
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	move_and_slide()
	
func set_knockback_velocity(delta):
	var old_velocity = velocity
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = knockback
	move_and_slide()
	knockback = velocity
	velocity = old_velocity

func seek_player():
	print(playerDetectionArea)
	if playerDetectionArea.can_see_player():
		state = CHASE

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150
	hurtbox.create_hit_effect()
	
func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.position = position
