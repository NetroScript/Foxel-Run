extends Node
class_name MultiSFX

export var minimal_millisecond_delay : int = 50
export var delay_random_spread : int = 50

var time_since_last_sound : int = 0

var child_count : int
var child_index_array : Array = Array()


func _ready() -> void:
	child_count = get_child_count()
	for i in range(child_count):
		child_index_array.append(i)



func play_sound() -> bool:


	var current_time : int = OS.get_ticks_msec()
	if current_time - time_since_last_sound > minimal_millisecond_delay:

		time_since_last_sound = current_time + (randi() % delay_random_spread)
		child_index_array.shuffle()

		for i in child_index_array:

			if get_child(i).play_sound():
				return true

	return false
