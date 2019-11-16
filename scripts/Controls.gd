extends Node


var player : Player 

var speed_modifier : float = 1 setget changed_speed

var obstacle_amount : int = 2

signal speed_change

func changed_speed(new_speed : float):
	
	emit_signal("speed_change", new_speed)
	
	speed_modifier = new_speed

func _ready():
	changed_speed(speed_modifier)
	pass
