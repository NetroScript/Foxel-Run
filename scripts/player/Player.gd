extends Node2D
class_name Player

export var speed : float = 60
var movement : float = 0
export var health : int = 3 setget set_health
export var max_health : int = 5
var lastaction: int = 0
var downpressed: bool = false
var uppressed: bool = false
var life_time : float = 0
var invinciblity_left : float = 0

var time_till_next_score : float = 0

var current_score : int = 0 setget set_score

var difficulty : int = 0
var extra_speed_up : float = 1

onready var collider : Area2D = $Area2D
onready var tween : Tween = $Tween
onready var score_label : Label = $"PlayerGUI2/Label"

var blinking_state : float = 0
var material_reset_time : float = 0


func _ready():
	
	set_health(health)
	
	$default/AnimationPlayer.play("Player_Running")
	
	collider.connect("area_entered", self, "area_entered")
	
	
	Controller.connect("speed_change", self, "on_speed_change")
	
	
func on_speed_change(speed : float) -> void:
	
	$default/AnimationPlayer.playback_speed = speed / 1.5

func area_entered(area : Area2D) -> void:
	
	if area is Collectable and !area.was_collected:
		if area.gain_health > 0:
			self.health += area.gain_health
		current_score += area.gain_points
		invinciblity_left += area.gain_invinciblity
		if area.set_player_material != null:
			
			$default.material = area.set_player_material
			material_reset_time = area.material_reset_time
			extra_speed_up = area.material_effect_speed

		
		area.was_collected = true
		
		area.get_parent().remove_child(area)
		
		area.queue_free()
		
		
	elif area is Obstacle:
		
		if area.was_hit != true and extra_speed_up > 1:
			area.was_hit = true
			area.throw_away()
		
		if area.was_hit != true and extra_speed_up <= 1:
			SoundController.play_sound(area.sfx_name)
		
		if invinciblity_left <= 0:
			if area.was_hit != true:
				area.was_hit = true
				self.health -= 1
				invinciblity_left = 1.5
				
func set_score(value : int):
	
	if score_label != null:
	
		score_label.text = tr("CURRENT_SCORE") + str(value)
	
	current_score = value
	
func set_health(value : int):
	
	if value >= 5:
		value = 5
		health = 5
	if value < 0:
		die()
	
	var heart_container : HBoxContainer = $"PlayerGUI/HeartContainerMargin/HeartCon"
	for child in heart_container.get_children():
		heart_container.remove_child(child)
		child.queue_free()
	
	for i in range(value):
		var heart : TextureRect = TextureRect.new()
		
		heart.texture = preload("res://graphics/gui/Heart.png")
		
		heart_container.add_child(heart)
		
	health = value
	
func die() -> void:
	pass
	
func _process(delta : float):
	
	delta = delta * Controller.speed_modifier
	
	if invinciblity_left <= 0:
		invinciblity_left = 0
		modulate.a = 1
	else:
		
		modulate.a = lerp(0.3, 0.6, (cos(invinciblity_left*9)+2)/2)
	
	
func _physics_process(delta : float) -> void:
	invinciblity_left-=delta
	
	
	
	if $default.material != null and material_reset_time <= 0:
		$default.material = null
		extra_speed_up = 1
	
	if $default.material != null and material_reset_time > 0:
		material_reset_time -= delta
		
	delta *= extra_speed_up
	
	if Controller.speed_modifier > 0:
		life_time += delta
		time_till_next_score += delta
	
	while time_till_next_score > 0.1:
		time_till_next_score -= 0.1
		self.current_score += 1
	
	
	
	delta = delta * Controller.speed_modifier
	
	

	
	position.x+=delta*80
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
		
	if life_time > 300  and difficulty == 9:
		Controller.speed_modifier = 3.5
		Controller.obstacle_amount += 6
		difficulty = 10
		return
		
	if life_time > 270  and difficulty == 8:
		Controller.speed_modifier = 3
		Controller.obstacle_amount += 5
		difficulty = 9
		return
		
	if life_time > 240  and difficulty == 7:
		Controller.obstacle_amount += 6
		difficulty = 8
		return
		
	if life_time > 200  and difficulty == 6:
		Controller.speed_modifier = 2.75
		Controller.obstacle_amount += 2
		difficulty = 7
		return
		
	if life_time > 175  and difficulty == 5:
		Controller.speed_modifier = 2.5
		difficulty = 6
		return
		
	if life_time > 140  and difficulty == 4:
		Controller.obstacle_amount += 4
		Controller.speed_modifier = 2.5
		difficulty = 5
		return
		
	if life_time > 110  and difficulty == 3:
		Controller.obstacle_amount += 4
		Controller.speed_modifier = 2.5
		difficulty = 4
		return
		
	if life_time > 75  and difficulty == 2:
		Controller.obstacle_amount += 4
		Controller.speed_modifier = 2.2
		difficulty = 3
		return
		
	if life_time > 45 and difficulty == 1:
		Controller.obstacle_amount += 2
		Controller.speed_modifier = 1.75
		difficulty = 2
		return
	
	if life_time > 15 and difficulty == 0:
		Controller.obstacle_amount += 1
		Controller.speed_modifier = 1.4
		difficulty = 1
	
		
		
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
		
