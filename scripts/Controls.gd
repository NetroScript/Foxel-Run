extends Node


var player : Player 

var speed_modifier : float = 1 setget changed_speed

var obstacle_amount : int = 2

var locals : String = "en" setget _changed_language
var languages_available : Array = ["en", "de"]

signal speed_change
signal changed_language


# Setter for current language, changes the language on change
func _changed_language(new_language : String) -> void:
		locals = new_language
		if TranslationServer.get_locale() != locals:
			TranslationServer.set_locale(locals)
			emit_signal("changed_language", locals)

func changed_speed(new_speed : float):
	
	emit_signal("speed_change", new_speed)
	
	speed_modifier = new_speed

func _ready():
	
	randomize()
	_changed_language("en")
	changed_speed(speed_modifier)
	pass
