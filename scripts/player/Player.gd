extends Node2D
class_name Player

export var speed : float = 50
var movement : float = 0
var health : int = 3
var lastaction: int = 0
var downpressed: bool = false
var uppressed: bool = false

func _ready():
	
	pass
	
func _physics_process(delta : float) -> void:
	delta = delta * Controller.speed_modifier
	
	position.x+=delta*200
	position.y+=delta*speed*movement
	position.y=clamp(position.y,-90,90)
	
	movement=0
	#wenn beide gedrückt soll die letzte action gemacht werden
	if uppressed==true && downpressed==true: 
		movement=lastaction

	elif uppressed==true:
		movement=-1
	elif downpressed==true:
		movement=1
	
		
		
func _unhandled_input(event:InputEvent) ->void:
	if event.is_action_pressed("up"):
		uppressed=true
		#setze die letzte Bewegung auf up
		lastaction=-1	
		
	elif event.is_action_released("up"):
		uppressed=false
		
	if event.is_action_pressed("down"):
		downpressed=true
		#setze die letzte Bewegung auf down
		lastaction=1  
		
	elif event.is_action_released("down"):
		downpressed=false
		
