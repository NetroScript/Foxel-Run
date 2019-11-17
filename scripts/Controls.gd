tool
extends Node


var player : Player 


var music_speed_modifier : float = 1 setget changed_music_speed

var obstacle_amount : int = 8

var locals : String = "en" setget _changed_language
var languages_available : Array = ["en", "de"]

var speed_modifier : float = 1 setget changed_speed
var previous_modifier : float = speed_modifier

var highest_score : int = 0

var screen_modulate : Color = Color(1,1,1) setget changed_modulate


signal speed_change
signal changed_language
signal music_speed_change
signal changed_modulate


func changed_modulate(new_modulate : Color):
	
	emit_signal("changed_modulate", new_modulate)
	
	screen_modulate = screen_modulate

func reset_values() -> void:
	
	speed_modifier = 1
	music_speed_modifier = 1
	obstacle_amount = 8
	
	pass

# Setter for current language, changes the language on change
func _changed_language(new_language : String) -> void:
		locals = new_language
		if TranslationServer.get_locale() != locals:
			TranslationServer.set_locale(locals)
			emit_signal("changed_language", locals)


func changed_music_speed(new_speed : float):
	
	emit_signal("music_speed_change", new_speed)
	
	music_speed_modifier = new_speed

func changed_speed(new_speed : float):
	
	emit_signal("speed_change", new_speed)
	
	speed_modifier = new_speed

func _ready():
	
	randomize()
	_changed_language("en")
	changed_speed(speed_modifier)
	pass
