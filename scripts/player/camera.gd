extends Camera2D
# Script to change the zoom when changing the window size


# The height of the game
var height : int = 180
var max_width_factor : float = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# On window resize also call size_changed
	get_tree().get_root().connect("size_changed", self, "_resize")
	_resize()

# Function to rescale the viewport to fit the window size
func set_map_size() -> void:

	# To make up for the changed size, we need to zoom our camera out / in
	zoom = Vector2(1,1) * (height / max(0.1, get_viewport_rect().size.y))
	offset.x = (get_viewport_rect().size.x * 0.3)*zoom.x

	if get_parent().has_node("PlayerGUI"):
		$"../PlayerGUI".scale = Vector2(1,1)/zoom/1.5



# Called on resize for full responsiveness
func _resize() -> void:

	# Our current method would prevent maximum size on maximize, so we allow every resolution on maximize
	if OS.window_maximized:
		OS.max_window_size = Vector2(0, 0)
		OS.window_maximized = false
		OS.window_maximized = true
	else:
		# Prevent the aspect ratio being too wide
		OS.max_window_size = Vector2(OS.window_size.y*max_width_factor, 1000000)

	set_map_size()

