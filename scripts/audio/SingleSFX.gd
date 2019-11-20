extends AudioStreamPlayer
class_name SingleSFX

export var maximal_amount : int = 3
export var minimal_millisecond_delay : int = 50
export var delay_random_spread : int = 50

var time_since_last_sound : int = 0

var currently_running : int = 0

var ready_state : Array = Array()

func _ready() -> void:

	for i in range(maximal_amount):
		var sfx : AudioStreamPlayer = AudioStreamPlayer.new()
		sfx.stream = stream
		sfx.pitch_scale = pitch_scale
		sfx.bus = bus


		self.add_child(sfx)
		ready_state.append(true)

		sfx.connect("finished", self, "enable", [i])


func play_sound() -> bool:


	if currently_running >= maximal_amount:
		return false


	var current_time : int = OS.get_ticks_msec()

	if current_time - time_since_last_sound > minimal_millisecond_delay:
		time_since_last_sound = current_time + (randi() % delay_random_spread)

		var number : int = ready_state.find(true)

		ready_state[number] = false

		get_child(number).play(0)

		currently_running += 1
		return true





	return false

func enable(number : int) -> void:
	ready_state[number] = true
	currently_running -= 1
