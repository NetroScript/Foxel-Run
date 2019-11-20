tool
extends Sprite
class_name Detail

export var object_name : String = ""
export var probability : float = 1
export var transparency_range : Vector2 = Vector2(1,1) setget set_transparency
export var scale_range : Vector2 = Vector2(1,1) setget set_scale_range
var size : Vector2


func _ready() -> void:
	add_to_group("detail", true)
	size = get_size()
	modulate.a = rand_range(transparency_range.x, transparency_range.y)

func set_transparency(value : Vector2) -> void:

	modulate.a = rand_range(value.x, value.y)

	transparency_range = value

func set_scale_range(value : Vector2) -> void:

	var tmp : float = rand_range(value.x, value.y)

	scale = Vector2(tmp, tmp)

	scale_range = value

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

