extends Node2D
class_name CollectableHandler

var collectable_dictionary : Dictionary
var weight_sum : float = 0


func _ready():
	
	# Get the collectables from the collectables folder
	var collectables : Array = utility.dir_contents("res://objects/collectables/")

	for collectable in collectables:
		# Get all scene objects (also when exportet)
		if collectable.ends_with(".tscn") or collectable.ends_with(".tscn.converted.res"):
			
			var collectable_path : String = "res://objects/collectables/"+collectable.split(".converted")[0]
			var collectable_info : CollectableInfo = CollectableInfo.new(collectable_path)
			

			collectable_dictionary[collectable_info.name] = collectable_info
			
			weight_sum += collectable_info.probability
			print("Loaded collectable: " + collectable_info.name)
			print("collectable size: " + str(collectable_info.size))
			

	

			
func get_random_weightened_collectable() -> CollectableInfo:
	
	var random_weight : float = rand_range(0.0001, weight_sum)
	
	
	
	for collectable in collectable_dictionary: 
		random_weight -= collectable_dictionary[collectable].probability
		if random_weight <= 0:
			return collectable_dictionary[collectable] as CollectableInfo

	
	return collectable_dictionary[collectable_dictionary.keys()[0]] as CollectableInfo
	
	
func add_collectables_in_area(area : Rect2, player_collision_line : PoolVector2Array, player_height : int) -> void:
	
	
	if randf() < 0.25:
	
		var current_collectable_info : CollectableInfo = get_random_weightened_collectable()
		
		var current_collectable : Collectable = current_collectable_info.collectable_loaded.instance() as Collectable
	
	
		if current_collectable != null:
			add_child(current_collectable)
			current_collectable.position.x = rand_range(area.position.x, area.position.x + area.size.x)
			current_collectable.position.y = rand_range(-90, 90)
	
		
	
		# Wait for the collisions to set up
		yield(get_tree(), "idle_frame")
			
		# Clear all but n collectables on the path
		
		if current_collectable.spawn_inside_path:
			
			var temp : Curve2D = Curve2D.new()
			
			for i in range(player_collision_line.size()/2):
				temp.add_point(player_collision_line[i] - Vector2(0, player_height/2))
			
			current_collectable.position = temp.get_closest_point(current_collectable.position)
			
			current_collectable.position.y += rand_range(-player_height/2, player_height/2)
			
			pass

