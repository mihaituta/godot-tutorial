extends CharacterBody2D

@onready var stats = $Stats

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, delta * 200)
	move_and_slide()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * 120

func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.position = position
