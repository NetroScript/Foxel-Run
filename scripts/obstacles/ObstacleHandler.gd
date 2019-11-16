extends Node2D
class_name ObstacleHandler

var obstacle_dictionary : Dictionary
var weight_sum : float = 0

func _ready():
	
	# Get the obstacles from the obstacles folder
	var obstacles : Array = utility.dir_contents("res://objects/obstacles/")

	for obstacle in obstacles:
		# Get all scene objects (also when exportet)
		if obstacle.ends_with(".tscn") or obstacle.ends_with(".tscn.converted.res"):
			
			var obstacle_path : String = "res://objects/obstacles/"+obstacle.split(".converted")[0]
			var obstacle_info : ObstacleInfo = ObstacleInfo.new(obstacle_path)
			
			
			
			obstacle_dictionary[obstacle_info.name] = obstacle_info
			
			weight_sum += obstacle_info.probability
			print("Loaded Obstacle: " + obstacle_info.name)
			print("Obstacle size: " + str(obstacle_info.size))

			
func get_random_weightened_obstacle() -> ObstacleInfo:
	
	var random_weight : float = rand_range(0.0001, weight_sum)
	
	
	
	for obstacle in obstacle_dictionary: 
		random_weight -= obstacle_dictionary[obstacle].probability
		if random_weight <= 0:
			return obstacle_dictionary[obstacle] as ObstacleInfo

	
	return obstacle_dictionary[obstacle_dictionary.keys()[0]] as ObstacleInfo
	
	
func add_obstacles_in_area(area : Rect2):
	# To check if obstacles are valid, we use multiple rows
	# in each row we can place 1 to n obstacles
	# Then we have an array with the ranges of values where there are no obstacles (y ranges) f.e. [[0,100], [2,300]]
	# There needs to be at least 1 row which has enough space for the player height
	# Then for each row we combine the free spaces for the player (to max min values) 
	# If f.e. [[0,100], [200,300]] and [[50,150]] then it is [[50,100]]
	# for both the row ahead and the row behind there needs to be at least x times the height of the player available
	# Also the max distance of the previous empty position and the next empty position can be set to n
	
	#print(area)
	pass
