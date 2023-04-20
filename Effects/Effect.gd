extends AnimatedSprite2D

func _ready():
	self.animation_finished.connect(_on_animation_finished)
	play("Animate")

#when the grass effect animation finishes the object will be destroyed
func _on_animation_finished():
	queue_free()
