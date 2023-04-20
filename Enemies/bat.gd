extends CharacterBody2D

 

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, delta * 200)
	move_and_slide()

func _on_hurtbox_area_entered(area):
	velocity = area.knockback_vector * 120

