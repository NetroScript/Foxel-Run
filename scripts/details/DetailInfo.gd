extends Reference
class_name DetailInfo

var probability : float = 0
var scene_path : String = ""
var instance : Detail
var detail_loaded : PackedScene
var name : String = ""
var size : Vector2


func _init(scene_path : String) -> void:

	self.scene_path = scene_path
	self.detail_loaded = load(scene_path)
	self.instance = detail_loaded.instance() as Detail
	self.name = instance.get_name()
	self.probability = instance.get_probability()

	# Bounding box needs to be centered (-size/2) if drawn as rectangle
	self.size = instance.get_size()


