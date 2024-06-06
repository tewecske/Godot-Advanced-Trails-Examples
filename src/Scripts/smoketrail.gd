extends Line2D
class_name Smoketrail

@export var limited_lifetime := false
@export var wildness := 3.0
@export var min_spawn_distance := 5.0
@export var gravity := Vector2.UP
@export var gradient_col : Gradient = Gradient.new()

var lifetime := [1.2, 1.6]
var tick_speed := 0.05
var tick := 0.0
var wild_speed := 0.1
var point_age := [0.0]
var stopped := false

@onready var curve := Curve2D.new()

func _ready():
	gradient = gradient_col
	set_as_top_level(true)
	clear_points()
	if limited_lifetime:
		stop()


func stop():
	stopped = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	var tween_duration = randf_range(lifetime[0], lifetime[1])
	var tweener = tween.tween_property(self, "modulate:a", 0.0, tween_duration)
	tweener.from(1.0)
	tween.tween_callback(queue_free)


func _process(delta):
	if tick > tick_speed:
		tick = 0
		for p in range(get_point_count()):
			point_age[p] += 5*delta
			var rand_vector := Vector2( randf_range(-wild_speed, wild_speed), randf_range(-wild_speed, wild_speed) )
			points[p] += gravity + ( rand_vector * wildness * point_age[p] )
		if stopped:
			# This part is optional and only servers visual polishing purposes.
			# If a trail is stopped, and a very intense gradient is used, this part can be left in to change the
			# gradient of the line slowly towards a softer end.
			# Performance wise it's slower than the variant without this part, but it looks much better for glowing
			# trails like rockets with a longer life time
			gradient.offsets[2] = clamp(gradient.offsets[2]+0.04, 0.0, 0.99)
			gradient.offsets[1] = clamp(gradient.offsets[1]+0.04, 0.0, 0.98)
			gradient.colors[2] = lerp(gradient.colors[2], gradient.colors[1], 0.1 )
			gradient.colors[3] = lerp(gradient.colors[3], gradient.colors[0], 0.2 )
			width += 3
	else:
		tick += delta

func add_point_to(point_pos:Vector2, at_pos := -1):
	if get_point_count() > 0 and point_pos.distance_to( points[get_point_count()-1] ) < min_spawn_distance:
		return
	
	point_age.append(0.0)
	super.add_point(point_pos, at_pos)

