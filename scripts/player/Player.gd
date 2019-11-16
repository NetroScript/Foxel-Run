extends Node2D
class_name Player

export var speed : float = 100
var movement : float = 0
export var health : int = 3 setget set_health
var lastaction: int = 0
var downpressed: bool = false
var uppressed: bool = false

func _ready():
	
	set_health(health)
	
	pass
	
	
func set_health(value : int):
	var heart_container : HBoxContainer = $"PlayerGUI/HeartContainerMargin/HeartCon"
	for child in heart_container.get_children():
		heart_container.remove_child(child)
		child.queue_free()
	
	for i in range(value):
		var heart : TextureRect = TextureRect.new()
		
		heart.texture = preload("res://graphics/gui/Heart.png")
		
		heart_container.add_child(heart)
		
	health = value
	
func _physics_process(delta : float) -> void:
	delta = delta * Controller.speed_modifier
	
	position.x+=delta*150
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
		
