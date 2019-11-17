tool
extends Node


var player : Player 


var music_speed_modifier : float = 1 setget changed_music_speed

var obstacle_amount : int = 8

var locals : String = "de" setget _changed_language
var languages_available : Array = ["en", "de"]

var speed_modifier : float = 1 setget changed_speed
var previous_modifier : float = speed_modifier

var highest_score : int = 0

var screen_modulate : Color = Color(1,1,1) setget changed_modulate

var game_volume : float = 50 setget _change_game_volume

# Settings which will be saved and loaded
var store_settings : Array = ["locals", "game_volume", "highest_score"]
var setting_save_file : File

var is_gameover : bool = false

signal speed_change
signal changed_language
signal music_speed_change
signal changed_modulate
signal drop_item


# Functions to save the current settings
func save_settings() -> void:
	# Settings which will be saved
	var to_save : Dictionary = {}
	# Iterate list with settings to be saved to store them in the Dictionary
	for setting in store_settings:
		to_save[setting] = get(setting)

	# If the setting file doesn't exist create it
	if setting_save_file == null:
		setting_save_file = File.new()

	# Open the file and then store settings in it
	setting_save_file.open("user://settings", File.WRITE)
	setting_save_file.store_var(to_save)
	setting_save_file.close()


func drop_stuff(scene_path : String):
	
	emit_signal("drop_item", scene_path)
	

# Load the settings from the settings file
func load_settings() -> void:
	# Create file object if it doesn't exist
	if setting_save_file == null:
		setting_save_file = File.new()

	# If no settingsfile exists don't load any settings
	if not setting_save_file.file_exists("user://settings"):
		return

	# Other wise get the data stored in the file
	setting_save_file.open("user://settings", File.READ)
	var data : Dictionary = setting_save_file.get_var()
	setting_save_file.close()

	# Load every key into the key of this object as long as it is in the settings which should be stored
	for key in data:
		if key in store_settings:
			set(key, data[key])

	# Update the settings menu
	get_tree().call_group("listens_to_settings_change", "update_settings")


# Setter for the game volume
func _change_game_volume(new_volume : float) -> void:
	game_volume = new_volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(new_volume/100))
	pass

func changed_modulate(new_modulate : Color):
	
	emit_signal("changed_modulate", new_modulate)
	
	screen_modulate = screen_modulate

func reset_values() -> void:
	
	self.speed_modifier = 1
	self.music_speed_modifier = 1
	self.obstacle_amount = 8
	
	save_settings()

# Setter for current language, changes the language on change
func _changed_language(new_language : String) -> void:
	locals = new_language
	if TranslationServer.get_locale() != locals:
		TranslationServer.set_locale(locals)
		emit_signal("changed_language", locals)
	save_settings()


func changed_music_speed(new_speed : float):
	
	emit_signal("music_speed_change", new_speed)
	
	music_speed_modifier = new_speed

func changed_speed(new_speed : float):
	
	emit_signal("speed_change", new_speed)
	
	speed_modifier = new_speed

func _ready():
	
	randomize()
	load_settings()
	reapply()
	
	
	
	pass

func reapply()->void:
	_changed_language(locals)
	_change_game_volume(game_volume)
