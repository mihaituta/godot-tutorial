extends Node2D

var GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
		var grassEffect = GrassEffect.instantiate()
		
		#the main world scene, attaching the effect to the world object
		#get_tree().current_scene.add_child(grassEffect)
		#grassEffect.global_position = global_position
		
		#attaching the effect to the grass parent
		get_parent().add_child(grassEffect)
		grassEffect.position = position

func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
