extends Node2D
class_name Player


var health : int = 3

func _ready():
	
	pass
	
func _physics_process(delta : float) -> void:
	delta = delta * Controller.speed_modifier
	
	position.x+=delta*200
