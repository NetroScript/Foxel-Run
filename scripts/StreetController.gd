extends Node2D
class_name Background

export var amount : int = 5
export var texture : Texture
onready var texture_width : int = texture.get_width()
onready var despawn_border : int = texture_width*(amount/2)

var texture_array : Array = Array()

#onready var player : Player = $"../Player"

onready var obstacle_handler : ObstacleHandler = $"../ObstacleHandler" as ObstacleHandler

func _ready():
	
	yield($"../ObstacleHandler", "ready")
	
	var middle_object : int = amount/2
	
	for i in range(-middle_object, -middle_object+amount):
		var sprite : Sprite = Sprite.new()
		sprite.texture  = texture
		sprite.position = Vector2(i*texture_width, 0)
		add_child(sprite)
		texture_array.push_back(sprite)
		if i > 0:
			obstacle_handler.add_obstacles_in_area(Rect2(sprite.position-sprite.texture.get_size()/2, sprite.texture.get_size()))

func _physics_process(delta : float) -> void:
	delta = delta * Controller.speed_modifier
	
	if delta > 0:
		
		var current_sprite : Sprite = texture_array[0] as Sprite
		
		if current_sprite.get_global_transform_with_canvas().origin.x < -despawn_border:
			
			texture_array.pop_front()
			
			remove_child(current_sprite)
			current_sprite.queue_free()
			#print("Removed old street object")
			
			var new_sprite : Sprite = Sprite.new()
			new_sprite.texture = texture
			new_sprite.position = texture_array.back().position + Vector2(texture_width, 0)
			
			obstacle_handler.add_obstacles_in_area(Rect2(new_sprite.position-new_sprite.texture.get_size()/2, new_sprite.texture.get_size()))
			
			
			
			add_child(new_sprite)
			texture_array.push_back(new_sprite)
			
			#print("added new street object")
			
			

	
		var screen_position : Vector2 = get_global_transform_with_canvas().origin
	
	
	pass
