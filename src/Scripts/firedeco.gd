extends Node2D

@onready var smoketrail: SmoketrailStatic = $Smoketrail
@onready var fire = $Fire

var time := 0.0

func _process(delta):
	if time > 0.03:
		time = 0
		smoketrail.add_point_to(global_position)
	fire.scale = randf_range(0.2, 0.1) * Vector2.ONE
	time += delta
