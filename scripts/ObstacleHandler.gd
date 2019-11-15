extends Node2D
class_name ObstacleHandler

func _ready():
	pass
	
func add_obstacles_in_area(area : Rect2):
	# To check if obstacles are valid, we use multiple rows
	# in each row we can place 1 to n obstacles
	# Then we have an array with the ranges of values where there are no obstacles (y ranges) f.e. [[0,100], [2,300]]
	# There needs to be at least 1 row which has enough space for the player height
	# Then for each row we combine the free spaces for the player (to max min values)
	
	print(area)
	pass
