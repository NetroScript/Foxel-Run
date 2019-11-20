extends Node2D
class_name ObstacleHandler

var obstacle_dictionary : Dictionary
var weight_sum : float = 0

var last_player_y : float = 0
const player_height : int = 50

onready var player_collision_helper_polygon : CollisionPolygon2D = $PlayerPathHelper/CollisionPolygon2D as CollisionPolygon2D
onready var player_collision_helper : Area2D = $PlayerPathHelper as Area2D

onready var collectable_handler : CollectableHandler
onready var detail_handler : DetailHandler = $"../DetailHandler" as DetailHandler

func _ready():


	if get_parent().has_node("CollectableHandler"):
		collectable_handler = get_parent().get_node("CollectableHandler") as CollectableHandler

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

	if collectable_handler != null:

		yield(collectable_handler, "ready")




func get_random_weightened_obstacle() -> ObstacleInfo:

	var random_weight : float = rand_range(0.0001, weight_sum)



	for obstacle in obstacle_dictionary:
		random_weight -= obstacle_dictionary[obstacle].probability
		if random_weight <= 0:
			return obstacle_dictionary[obstacle] as ObstacleInfo


	return obstacle_dictionary[obstacle_dictionary.keys()[0]] as ObstacleInfo


func add_obstacles_in_area(area : Rect2):


	var collision_polygon : PoolVector2Array = generate_player_path(area.size.x, area.position.x)



	# Checking for player path collision so we need to add the player path as collision object

	player_collision_helper_polygon.polygon = collision_polygon


	var reached_path_collisions : int = 1

	var amount : int = Controller.obstacle_amount

	var added_obstacles : Array = Array()

	# Add our objects
	for i in range(amount):
		var current_obstacle_info : ObstacleInfo = get_random_weightened_obstacle()

		var current_obstacle : Obstacle = current_obstacle_info.obstacle_loaded.instance() as Obstacle


		if current_obstacle != null:
			current_obstacle.rotation = rand_range(deg2rad(current_obstacle.allow_rotation.x), deg2rad(current_obstacle.allow_rotation.y))
			add_child(current_obstacle)
			current_obstacle.position.x = rand_range(area.position.x, area.position.x + area.size.x)
			current_obstacle.position.y = rand_range(-90, 90)
			added_obstacles.append(current_obstacle)


	# Wait for the collisions to set up
	yield(get_tree(), "idle_frame")

	# Clear all but n obstacles on the path

	#print(player_collision_helper.get_overlapping_areas())

	for areas in player_collision_helper.get_overlapping_areas():

		#areas.modulate = Color.green
		if areas is Obstacle:
			if reached_path_collisions > 0 or areas.can_ignore_player_path:
				reached_path_collisions-=1
			else:
				if areas.get_parent() == self:
					remove_child(areas)
				areas.queue_free()
		#print("Removing")

		#print(areas)

	if collectable_handler != null:
		collectable_handler.add_collectables_in_area(area, collision_polygon, player_height)
	detail_handler.add_details_in_area(area)





func generate_player_path(width : int, x_offset : float, max_in_direction : float = 90, max_offset : float = 45, max_collission_occurrances : int = 1) -> PoolVector2Array:


	var point_amount : int = width/140

	point_amount += randi()%4

	var section_offset : float = width / float(point_amount)

	var resulting_points : PoolVector2Array = PoolVector2Array()

	var previous_y = last_player_y

	for i in range(point_amount+1):
		var point : Vector2 = Vector2(i*section_offset+x_offset, rand_range(-max_in_direction, max_in_direction))

		if abs(point.y - previous_y) > max_offset:
			if point.y > previous_y:
				point.y = previous_y + max_offset
			else:
				point.y = previous_y - max_offset

		resulting_points.append(point)
		previous_y = point.y


	resulting_points[0].y = last_player_y
	last_player_y = resulting_points[resulting_points.size()-1].y

	var polygon_list : PoolVector2Array = PoolVector2Array()

	for i in range(point_amount+1):
		polygon_list.append(resulting_points[i] + Vector2(0, player_height/2))
	for i in range(point_amount, -1, -1):
		polygon_list.append(resulting_points[i] + Vector2(0, -player_height/2))

	return polygon_list

