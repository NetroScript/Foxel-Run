extends Node2D
class_name Player

export var speed : float = 50
var movement : float = 0
export var health : int = 3 setget set_health
export var max_health : int = 6
var lastaction: int = 0
var downpressed: bool = false
var uppressed: bool = false
var life_time : float = 0
var invinciblity_left : float = 0

onready var collider : Area2D = $Area2D
onready var tween : Tween = $Tween

var blinking_state : float = 0

func _ready():
	
	set_health(health)
	
	
	collider.connect("area_entered", self, "area_entered")
	


func area_entered(area : Area2D) -> void:
	
	if invinciblity_left <= 0:
		
		if area is Obstacle:
			if area.was_hit != true:
				area.was_hit = true
				self.health -= 1
				invinciblity_left = 1
				
	
	
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
	invinciblity_left-=delta
	life_time += delta
	
	delta = delta * Controller.speed_modifier
	
	

	
	position.x+=delta*50
	position.y+=delta*speed*movement
	position.y=clamp(position.y,-90,90)
	
	$"PlayerGUI/Polutedsmoke".position.y = - 180 - position.y
	
	
	movement=0
	#wenn beide gedrückt soll die letzte action gemacht werden
	if uppressed==true && downpressed==true: 
		movement=lastaction

	elif uppressed==true:
		movement=-1
	elif downpressed==true:
		movement=1
		
		
	if life_time > 20:
		Controller.obstacle_amount + 1
		Controller.speed_modifier = 1.4
	
		
		
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
		
