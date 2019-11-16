tool
extends Node2D
class_name ObstacleHandler

var obstacle_dictionary : Dictionary
var weight_sum : float = 0

var last_player_y : float = 0
const player_height : int = 40
var poly : PoolVector2Array = PoolVector2Array()
onready var player_collision_helper_polygon : CollisionPolygon2D = $PlayerPathHelper/CollisionPolygon2D
onready var player_collision_helper : Area2D = $PlayerPathHelper

var past_polygons : Array = Array()

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
	
	
	var collision_polygon : PoolVector2Array = generate_player_path(area.size.x, area.position.x)
	
	# Checking for player path collision so we need to add the player path as collision object
	
	var base_area : RID = Physics2DServer.area_create()
	
	var triangle_point_array : PoolIntArray = Geometry.triangulate_polygon(collision_polygon)
	var triangle_shape_array : Array = Array()
	
	for i in range(0, triangle_point_array.size(), 3):
		var coll_polygon : ConvexPolygonShape2D = ConvexPolygonShape2D.new()
		coll_polygon.points.push_back(collision_polygon[triangle_point_array[i]])
		coll_polygon.points.push_back(collision_polygon[triangle_point_array[i+1]])
		coll_polygon.points.push_back(collision_polygon[triangle_point_array[i+2]])
		triangle_shape_array.append(coll_polygon.get_rid())
		Physics2DServer.area_add_shape(base_area, coll_polygon.get_rid())
	
	Physics2DServer.area_set_space(base_area,  get_world_2d().space)
	
	player_collision_helper_polygon.polygon = collision_polygon
	
	
	var reached_path_collisions : int = 0
	
	var amount : int =20
	
	
	for i in range(amount):
		var current_obstacle_info : ObstacleInfo = get_random_weightened_obstacle()
		
		var current_obstacle : Obstacle = current_obstacle_info.obstacle_loaded.instance() as Obstacle

		
		
		var fitting_position : bool = false
		
		if current_obstacle == null:
			fitting_position = true
		else:
			current_obstacle.rotation = rand_range(0, 2*PI)
			add_child(current_obstacle)


		var check_query : Physics2DShapeQueryParameters = Physics2DShapeQueryParameters.new()
		var obstacle_shape : ConvexPolygonShape2D = ConvexPolygonShape2D.new()
		obstacle_shape.set_point_cloud(current_obstacle.collider.polygon)
		
		check_query.set_shape(obstacle_shape)
			
			
		var tries : int = 0
		
		while(not fitting_position):
			
			
			current_obstacle.position.x = rand_range(area.position.x, area.position.x + area.size.x)
			
			current_obstacle.position.y = rand_range(-90, 90)

			check_query.transform = Transform2D(current_obstacle.rotation, current_obstacle.position)
			
			var is_valid : bool = true
			
			var collisions : Array = get_world_2d().direct_space_state.collide_shape(check_query)
			
			if collisions.size() > 0:
				print(collisions)
				is_valid = false
			
			
			var is_colliding_with_path : bool = false

			
			
			
			if not is_colliding_with_path or reached_path_collisions < 2:
				
#				for col_area in current_obstacle.get_overlapping_areas():
#					print(col_area)
#					if col_area is Obstacle:
#						is_valid = false
						
				if is_valid and is_colliding_with_path:
					print("Collided with path but was allowed")
					reached_path_collisions+=1
					
				if is_valid:
					fitting_position = true
				
			
			tries+=1
						
			if tries > 15:
				print("Stopped trying, too many tries")
				fitting_position = true
				remove_child(current_obstacle)
				current_obstacle.queue_free()
			
		yield(get_tree(), "idle_frame")
		
		pass
	
	
	
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
	
	
func generate_player_path(width : int, x_offset : float, max_in_direction : float = 90, max_offset : float = 45, max_collission_occurrances : int = 1) -> PoolVector2Array:
	
	
	
	var point_amount : int = width/140
	
	point_amount += randi()%4
	
	var section_offset : float = width / float(point_amount)
	
	var resulting_points : PoolVector2Array = PoolVector2Array()
	
	var previous_y = last_player_y
	
	for i in range(point_amount):
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
	
	for i in range(point_amount):
		polygon_list.append(resulting_points[i] + Vector2(0, player_height/2))
	for i in range(point_amount-1, -1, -1):
		polygon_list.append(resulting_points[i] + Vector2(0, -player_height/2))
		
		
	return polygon_list
	
