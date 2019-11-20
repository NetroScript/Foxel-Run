tool
extends Area2D
class_name Collectable

var was_collected : bool = false
export var object_name : String = ""
export var probability : float = 1
var size : Vector2
onready var collider : CollisionPolygon2D = $CollisionPolygon2D as CollisionPolygon2D
export var gain_points : int = 500
export var gain_health : int = 0
export var gain_invinciblity : float = 0
export var spawn_inside_path : bool = true
export var set_player_material : Material
export var material_effect_speed : float = 1
export var material_reset_time : float = 0
export var sfx_name : String = "fox_rustle"

func _ready() -> void:
	add_to_group("collectable", true)

	for child in get_children():
		if child is Sprite:
			child.material = preload("res://shaders/used/collectable_glow.tres")

	size = get_size()


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

func _physics_process(delta : float) -> void:
	delta = delta * Controller.speed_modifier

	if get_global_transform_with_canvas().origin.x < -1000:

		get_parent().remove_child(self)
		queue_free()

		set_physics_process(false)
