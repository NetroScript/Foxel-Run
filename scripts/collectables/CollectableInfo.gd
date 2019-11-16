extends Reference
class_name CollectableInfo

var probability : float = 0
var scene_path : String = ""
var instance : Collectable
var collectable_loaded : PackedScene
var name : String = ""
var size : Vector2 


func _init(scene_path : String):

	self.scene_path = scene_path
	self.collectable_loaded = load(scene_path)
	self.instance = collectable_loaded.instance() as Collectable
	self.name = instance.get_name()
	self.probability = instance.get_probability()

	# Bounding box needs to be centered (-size/2) if drawn as rectangle
	self.size = instance.get_size()
	

