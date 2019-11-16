tool
extends Area2D
class_name Obstacle

var was_hit : bool = false
export var object_name : String = ""
export var probability : float = 1
var size : Vector2 

func _ready():
	size = get_size()

func get_name() -> String:
	return object_name
	
func get_probability() -> float:
	return probability
	
func get_size() -> Vector2:
	
	var collider : CollisionPolygon2D = $CollisionPolygon2D as CollisionPolygon2D
	
	if collider != null:
		return utility.polygon_to_bounding(collider.polygon)
	
	return Vector2(0,0)

