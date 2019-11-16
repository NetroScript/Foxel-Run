extends Reference
class_name ObstacleInfo

var probability : float = 0
var scene_path : String = ""
var instance : Obstacle 
var obstacle_loaded : PackedScene
var name : String = ""
var size : Vector2 


func _init(scene_path : String):

	self.scene_path = scene_path
	self.obstacle_loaded = load(scene_path)
	self.instance = obstacle_loaded.instance() as Obstacle
	self.name = instance.get_name()
	self.probability = instance.get_probability()

	# Bounding box needs to be centered (-size/2) if drawn as rectangle
	self.size = instance.get_size()
	

