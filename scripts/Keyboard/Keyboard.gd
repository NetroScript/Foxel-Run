extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var scancodedict:Dictionary ={
	KEY_0:"play_sound",
	KEY_1:"play_sound",
	KEY_2:"play_sound",
	KEY_3:"play_sound",
	KEY_4:"play_sound",
	KEY_5:"play_sound",
	KEY_6:"play_sound",
	KEY_7:"play_sound",
	KEY_8:"play_sound",
	KEY_9:"play_sound",
	KEY_DIRECTION_L:"",
	KEY_DIRECTION_R:"",
	KEY_SPACE:"_togglepause",
	KEY_A:["set_screen_color", Color.blue],
	
	KEY_D:"_de",
	KEY_E :"_en",
	KEY_F:["set_screen_color", Color.white],
	KEY_G:["set_screen_color", Color.orange],
	KEY_H:["set_screen_color", Color.wheat],
	KEY_I:["_setsize",Vector2(200,200)],
	KEY_J:["set_screen_color", Color.brown],
	KEY_K:["set_screen_color", Color.rosybrown],
	KEY_L:["set_screen_color", Color.green],
	KEY_ODIAERESIS:["set_screen_color", Color.bisque],
	KEY_ADIAERESIS:["set_screen_color", Color.chartreuse],
	
	KEY_Z:"_fullscreen",
	KEY_O:["_setsize",Vector2(500,500)],
	KEY_P:"_togglepause",
	KEY_UDIAERESIS:["_setsize",Vector2(1280,720)],
	KEY_Q:"_closegame",
	KEY_R:"_minimize",
	KEY_T:"_maximize",
	KEY_U:["_setsize",Vector2(1920,1080)],
	
	KEY_Y:["spawn_object", "res://objects/details/Watch.tscn"],
	KEY_X:["spawn_object","res://objects/details/Coke.tscn"],
	KEY_C:["spawn_object","res://objects/details/Candy_1.tscn"],
	KEY_V:["spawn_object","res://objects/details/Candy_2.tscn"],
	KEY_B:["spawn_object","res://objects/details/can.tscn"],
	KEY_N:["spawn_object","res://objects/details/deadfish.tscn"],
	KEY_M:["spawn_object","res://objects/details/Bird Crap.tscn"],
}
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_sound(scan_code : int) -> void:
	
	$Hit_Player.pitch_scale = 1 + float((scan_code+6)%11) / 5
	$Hit_Player.play()
	
func train(scan_code:int)->void:
	SoundController.play_sound("train")
	pass

func _unhandled_input(event:InputEvent) ->void:
	if event is InputEventKey:
		if event.pressed and !event.echo:
			if event.scancode in scancodedict:
				if scancodedict[event.scancode] is String:
					call(scancodedict[event.scancode], event.scancode)
				elif scancodedict[event.scancode] is Array:
					call(scancodedict[event.scancode][0], scancodedict[event.scancode][1], event.scancode)
					
					

func spawn_object(path : String, scancode : int) -> void:
	
	Controller.drop_stuff(path)
				
func _de(scancode : int)->void:
	#changes language to german
	Controller.locals="de"
	
func _en(scancode : int)->void:
	#changes language to english
	Controller.locals="en"

func set_screen_color(color : Color, scancode : int)->void:
	Controller.screen_modulate = color
	pass

func _togglepause(scancode : int)->void:
	#pauses the game
	
	if !Controller.is_gameover:
	
		if Controller.speed_modifier > 0:
			Controller.previous_modifier = Controller.speed_modifier
			Controller.speed_modifier=0
		else:
			Controller.speed_modifier = Controller.previous_modifier
func _closegame(scancode : int)->void:
	get_tree().quit()
	
func _minimize(scancode : int)->void:
	OS.window_minimized=!OS.window_minimized

func _maximize(scancode : int)->void:
	OS.window_maximized=!OS.window_maximized
	
func _fullscreen(scancode : int)->void:
	OS.window_fullscreen=!OS.window_fullscreen
	
func _setsize(size:Vector2, scancode : int)->void:
	OS.window_size=size
