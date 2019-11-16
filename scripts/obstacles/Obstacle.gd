tool
extends Area2D
class_name Obstacle

var was_hit : bool = false
export var object_name : String = ""
export var probability : float = 1
var size : Vector2 
onready var collider : CollisionPolygon2D = $CollisionPolygon2D as CollisionPolygon2D

func _ready():
	add_to_group("obstacle", true)
	
	for child in get_children():
		if child is Sprite:
			child.material = preload("res://shaders/used/obstacle_glow.tres")
	
	size = get_size()
	

func get_name() -> String:
	return object_name
	
func get_probability() -> float:
	return probability
	
func get_size() -> Vector2:
	

	if collider != null:
		return utility.polygon_to_bounding(collider.polygon)
	
	return Vector2(0,0)

