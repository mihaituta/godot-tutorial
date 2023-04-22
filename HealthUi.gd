extends Control

#still keeping the label example for future uses
#@onready var label = $Label
@onready var heartUIFull = $HeartUIFull 
@onready var heartUIEmpty = $HeartUIEmpty

var hearts = 4:
	set(value):
		hearts = clamp(value, 0, max_hearts)
		if heartUIFull != null:
			heartUIFull.set_size(Vector2(hearts * heartUIFull.texture.get_width(), heartUIFull.texture.get_height()))
#		if label != null:
#			label.text = "HP = " +str(hearts)

var max_hearts = 4:
	set(value): 
		max_hearts = max(value, 1)
		self.hearts = min(hearts, max_hearts)
		#max_hearts = clamp(hearts, 0, max_hearts)
		if heartUIEmpty != null:
			heartUIEmpty.set_size(Vector2(max_hearts * heartUIEmpty.texture.get_width(), heartUIEmpty.texture.get_height()))

func set_hearts(value):
	hearts = value;
	
func set_max_hearts(value):
	max_hearts = value

func _ready():
	self.max_hearts = PlayerStats.max_health 
	self.hearts = PlayerStats.health
	PlayerStats.health_changed.connect(set_hearts)
	PlayerStats.max_health_changed.connect(set_max_hearts)
