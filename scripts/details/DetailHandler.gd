extends Node2D
class_name DetailHandler

var detail_dictionary : Dictionary
var weight_sum : float = 0


func _ready():
	
	# Get the details from the details folder
	var details : Array = utility.dir_contents("res://objects/details/")

	for detail in details:
		# Get all scene objects (also when exportet)
		if detail.ends_with(".tscn") or detail.ends_with(".tscn.converted.res"):
			
			var detail_path : String = "res://objects/details/"+detail.split(".converted")[0]
			var detail_info : DetailInfo = DetailInfo.new(detail_path)
			

			detail_dictionary[detail_info.name] = detail_info
			
			weight_sum += detail_info.probability
			print("Loaded detail: " + detail_info.name)

			
func get_random_weightened_detail() -> DetailInfo:
	
	var random_weight : float = rand_range(0.0001, weight_sum)

	for detail in detail_dictionary: 
		random_weight -= detail_dictionary[detail].probability
		if random_weight <= 0:
			return detail_dictionary[detail] as DetailInfo

	
	return detail_dictionary[detail_dictionary.keys()[0]] as DetailInfo
	
	
func add_details_in_area(area : Rect2) -> void:
	
	var amount : int = 2+randi()%7

	# Add our objects
	for i in range(amount):
		var current_detail_info : DetailInfo = get_random_weightened_detail()
		var current_detail : Detail = current_detail_info.detail_loaded.instance() as Detail
		if current_detail != null:
			current_detail.rotation = rand_range(0, 2*PI)
			add_child(current_detail)
			
			current_detail.position.x = rand_range(area.position.x, area.position.x + area.size.x)
			current_detail.position.y = rand_range(area.position.y, area.position.y + area.size.y)


