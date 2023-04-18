extends Node2D

var GrassEffect = preload("res://Effects/GrassEffect.tscn")

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var grassEffect = GrassEffect.instantiate()
		
		#the main world scene, attaching the effect to the world object
		#get_tree().current_scene.add_child(grassEffect)
		#grassEffect.global_position = global_position
		
		#attaching the effect to the grass parent
		get_parent().add_child(grassEffect)
		grassEffect.position = position
		
		queue_free()
