tool
extends Node

func _ready():
	pass




# Adapted from https://docs.godotengine.org/en/3.1/classes/class_directory.html
# Returns all file names in a directory as an array
func dir_contents(path : String) -> Array:
	var dir : Directory = Directory.new()
	var out : Array = Array()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		while (file_name != ""):
			if not dir.current_is_dir():
				out.append(file_name)
			file_name = dir.get_next()
	return out


# Get the bounding size from a polygon
func polygon_to_bounding(polygon : PoolVector2Array) -> Vector2:
	var min_val : Vector2 = Vector2(10000, 100000)
	var max_val : Vector2 = Vector2(-10000, -100000)

	for vector in polygon:
		if vector.x < min_val.x:
			min_val.x = vector.x
		if vector.y < min_val.y:
			min_val.y = vector.y
		if vector.x > max_val.x:
			max_val.x = vector.x
		if vector.y > max_val.y:
			max_val.y = vector.y


	return max_val-min_val
