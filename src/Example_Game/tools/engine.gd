extends Sprite2D

@onready var orig_scale = scale

func _process(delta):
	scale = orig_scale * randf_range(0.5, 1.0)
