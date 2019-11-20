extends Area2D
class_name Obstacle

var was_hit : bool = false
export var object_name : String = ""
export var probability : float = 1
var size : Vector2
onready var collider : CollisionPolygon2D = $CollisionPolygon2D as CollisionPolygon2D
export var sfx_name : String = "fox_hit"
export var can_ignore_player_path : bool = false
export var movement : Vector2 = Vector2(0,0)
var is_moving : bool = false
var throw_away_state : bool = false
var tween : Tween = Tween.new()

export var allow_rotation : Vector2 = Vector2(-180, 180)



func _ready():

	add_to_group("obstacle", true)

	for child in get_children():
		if child is Sprite:
			child.material = preload("res://shaders/used/obstacle_glow.tres")

	add_child(tween)

	size = get_size()

	if movement != Vector2(0,0):
		is_moving = true


func get_name() -> String:
	return object_name

func get_probability() -> float:
	return probability

func get_size() -> Vector2:

	var get_size : Vector2 = Vector2(0, 0)

	if collider == null:
		collider = $CollisionPolygon2D as CollisionPolygon2D

	if collider != null:
		get_size = utility.polygon_to_bounding(collider.polygon)


	return get_size

func throw_away() -> void:
	if !throw_away_state:
		throw_away_state = true

		var time : float = rand_range(0.3, 0.8)

		tween.interpolate_property(self, "position", position, position + Vector2(rand_range(-100,20), sign(rand_range(-1, 1))*rand_range(50,130)), time, Tween.TRANS_EXPO, Tween.EASE_OUT)
		scale = Vector2(0.8, 0.8)
		tween.interpolate_property(self, "scale", scale, Vector2(1.5,1.5), time, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween.start()

func _physics_process(delta : float) -> void:

	var screen_x : float = get_global_transform_with_canvas().origin.x

	if Engine.is_editor_hint():
		return


	if is_moving and screen_x > -300 and screen_x < OS.window_size.x + 100 :
		position += movement.rotated(rotation) * delta

	delta = delta * Controller.speed_modifier




	if screen_x < -1000:

		get_parent().remove_child(self)
		queue_free()

		set_physics_process(false)

