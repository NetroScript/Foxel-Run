extends Node

var available_sounds : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_sound_list()
	print("Loaded following SFX:")
	print(available_sounds.keys())



#
#func _input(event : InputEvent):
#	if event is InputEventMouseButton:
#		play_sound("ice_tower_attack")

func play_sound(title : String) -> void:

	if title in available_sounds:
		available_sounds[title].play_sound()



func build_sound_list() -> void:
	for c in get_children():
		var child : Node = c as Node

		if child != null:
			available_sounds[child.get_name()] = child
