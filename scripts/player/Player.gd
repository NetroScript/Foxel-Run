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



func _ready() -> void:

	set_health(health)

	$default/AnimationPlayer.play("Player_Running")

	collider.connect("area_entered", self, "area_entered")


	Controller.connect("speed_change", self, "on_speed_change")
	Controller.connect("drop_item", self, "drop_scene_item")

	Controller.connect("changed_language", self, "set_died_text")



func drop_scene_item(scene_path : String) -> void:
	var scene : PackedScene = load(scene_path) as PackedScene

	var obj : Node2D = scene.instance() as Node2D
	obj.position = position
	obj.rotation = rand_range(0, 2*PI)
	obj.position += Vector2(rand_range(-15,15), rand_range(-15,15))

	get_parent().add_child(obj)


func on_speed_change(speed : float) -> void:

	$default/AnimationPlayer.playback_speed = speed / 1.5

func area_entered(area : Area2D) -> void:

	if area is Collectable and !area.was_collected:
		SoundController.play_sound(area.sfx_name)
		if area.gain_health > 0:
			self.health += area.gain_health
		current_score += area.gain_points
		invinciblity_left += area.gain_invinciblity
		if area.set_player_material != null:

			$default.material = area.set_player_material
			material_reset_time = area.material_reset_time
			extra_speed_up = area.material_effect_speed
			Controller.music_speed_modifier = 1.2




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
				invinciblity_left = 1.5
				self.health -= 1


func set_score(value : int) -> void:

	if score_label != null:

		score_label.text = tr("CURRENT_SCORE") + str(value)

	current_score = value

func set_health(value : int) -> void:

	if value >= 5:
		value = 5
		health = 5


	var heart_container : HBoxContainer = $"PlayerGUI/HeartContainerMargin/HeartCon"
	for child in heart_container.get_children():
		heart_container.remove_child(child)
		child.queue_free()

	for i in range(value):
		var heart : TextureRect = TextureRect.new()

		heart.texture = preload("res://graphics/gui/Heart.png")

		heart_container.add_child(heart)

	if value < 1:
		die()

	health = value

func die() -> void:
	invinciblity_left = 0
	Controller.is_gameover = true
	$default.hide()
	$deadfox.show()
	Controller.speed_modifier = 0
	$"PlayerGUI2/ColorRect".show()
	set_died_text()
	$"PlayerGUI2/ColorRect/CenterContainer/Label".show()


func set_died_text(locas : String = "") -> void:
	$"PlayerGUI2/ColorRect/CenterContainer/Label".text = tr("YOU_LOST") + str(current_score) + "\n"

	if current_score > Controller.highest_score:
		$"PlayerGUI2/ColorRect/CenterContainer/Label".text += tr("BROKE_HIGHSCORE") + str(Controller.highest_score) + "\n\n" + tr("RETURN_MAIN")
		Controller.highest_score = current_score
	else:
		$"PlayerGUI2/ColorRect/CenterContainer/Label".text += tr("NO_HIGHSCORE")  + str(Controller.highest_score) + "\n\n" + tr("RETURN_MAIN")


func _process(delta : float) -> void:

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
		Controller.music_speed_modifier = 1

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
	# when both buttons are pressed, the most recent action should be done
	if uppressed==true && downpressed==true:
		movement=lastaction

	elif uppressed==true:
		movement=-1
	elif downpressed==true:
		movement=1


	# Declaring the different difficulties
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
		# set last action to up
		lastaction=-1

	elif event.is_action_released("up"):
		uppressed=false

	if event.is_action_pressed("down"):
		downpressed=true
		# set last action to down
		lastaction=1

	elif event.is_action_released("down"):
		downpressed=false

