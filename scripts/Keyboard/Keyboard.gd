extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var scancodedict:Dictionary ={
	KEY_0:"",
	KEY_1:"",
	KEY_2:"",
	KEY_3:"",
	KEY_4:"",
	KEY_5:"",
	KEY_6:"",
	KEY_7:"",
	KEY_8:"",
	KEY_9:"",
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
	KEY_H:"",
	KEY_I:"",
	KEY_J:"",
	KEY_K:"",
	KEY_L:"",
	KEY_M:"",
	KEY_N:"",
	KEY_O:"",
	KEY_P:"_togglepause",
	KEY_Q:"",
	KEY_R:"",
	KEY_T:"",
	KEY_U:"",
	KEY_V:"",
	KEY_X:"",
	KEY_Y:"",
	KEY_Z:"",
	KEY_ODIAERESIS:""
}
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _unhandled_input(event:InputEvent) ->void:
	if event is InputEventKey:
		if event.pressed and !event.echo:
			if event.scancode in scancodedict:
				call(scancodedict[event.scancode])
func _de()->void:
	#changes language to german
	Controller.locals="de"
	
func _en()->void:
	#changes language to english
	Controller.locals="en"
	
func _togglepause()->void:
	#pauses the game
	Controller.speed_modifier=0
	pass
	
