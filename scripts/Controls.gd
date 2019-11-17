tool
extends Node


var player : Player 


var music_speed_modifier : float = 1 setget changed_music_speed

var obstacle_amount : int = 8

var locals : String = "en" setget _changed_language
var languages_available : Array = ["en", "de"]

var speed_modifier : float = prevspeed_modifier
var prevspeed_modifier: float = 1 setget changed_speed



signal speed_change
signal changed_language
signal music_speed_change



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
