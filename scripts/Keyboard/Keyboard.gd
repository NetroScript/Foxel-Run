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
	KEY_ASCIICIRCUM:"",
	KEY_SSHARP:"",
	KEY_BACKSPACE:"",
	KEY_DIRECTION_L:"",
	KEY_DIRECTION_R:"",
	KEY_STOP:"",
	KEY_SPACE:"_togglepause",
	KEY_ASTERISK:"",
	KEY_PLUS:"",
	KEY_COMMA :"",
	KEY_MINUS:"",
	KEY_PERIOD:"",
	KEY_SLASH:"",
	KEY_COLON:"",
	KEY_SEMICOLON:"",
	KEY_LESS:"",
	KEY_A:"",
	KEY_B:"",
	KEY_C:"",
	KEY_D:"_de",
	KEY_E :"_en",
	KEY_F:"",
	KEY_G:"",
	KEY_H:["methode", Color()],
	KEY_I:["_setsize",Vector2(200,200)],
	KEY_J:"",
	KEY_K:"",
	KEY_L:"",
	KEY_M:"",
	KEY_N:"",
	KEY_O:["_setsize",Vector2(500,500)],
	KEY_P:"_togglepause",
	KEY_UDIAERESIS:["_setsize",Vector2(1280,720)],
	KEY_Q:"_closegame",
	KEY_R:"_minimize",
	KEY_T:"_maximize",
	KEY_U:["_setsize",Vector2(1920,1080)],
	KEY_V:"",
	KEY_X:"",
	KEY_Y:"",
	KEY_Z:"_fullscreen",
	KEY_ODIAERESIS:""
}
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play_sound(scan_code : int) -> void:
	
	$Hit_Player.pitch_scale = 1 + float((scan_code+6)%11) / 5
	$Hit_Player.play()

func _unhandled_input(event:InputEvent) ->void:
	if event is InputEventKey:
		if event.pressed and !event.echo:
			if event.scancode in scancodedict:
				if scancodedict[event.scancode] is String:
					call(scancodedict[event.scancode], event.scancode)
				elif scancodedict[event.scancode] is Array:
					call(scancodedict[event.scancode][0], scancodedict[event.scancode][1], event.scancode)
					
					
				
				
func _de()->void:
	#changes language to german
	Controller.locals="de"
	
func _en()->void:
	#changes language to english
	Controller.locals="en"

func set_screen_color(color : Color, scancode : int)->void:
	pass

func _togglepause()->void:
	#pauses the game
	
	if Controller.speed_modifier > 0:
		Controller.previous_modifier = Controller.speed_modifier
		Controller.speed_modifier=0
	else:
		Controller.speed_modifier = Controller.previous_modifier
func _closegame()->void:
	get_tree().quit()
	
func _minimize()->void:
	OS.window_minimized=!OS.window_minimized

func _maximize()->void:
	OS.window_maximized=!OS.window_maximized
	
func _fullscreen()->void:
	OS.window_fullscreen=!OS.window_fullscreen
	
func _setsize(size:Vector2)->void:
	OS.window_size=size
