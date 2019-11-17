tool
extends Sprite
class_name Detail

export var object_name : String = ""
export var probability : float = 1
export(float, 0, 1) var transparency : float = 1 setget set_transparency
var size : Vector2 


func _ready():
	add_to_group("detail", true)
	size = get_size()
	modulate.a = transparency
	
func set_transparency(value : float) -> void:
	
	modulate.a = value
	
	transparency = value

func get_name() -> String:
	return object_name
	
func get_probability() -> float:
	return probability
	
func get_size() -> Vector2:
	size = texture.get_size()
	return size
	
func _physics_process(delta : float) -> void:
	delta = delta * Controller.speed_modifier

	if get_global_transform_with_canvas().origin.x < -1000:
		
		get_parent().remove_child(self)
		queue_free()
		
		set_physics_process(false)

