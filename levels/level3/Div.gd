extends Node

var containerSizeX = 1536
var containerSizeY = 900
var halfContainerX = containerSizeX/2
var halfContainerY = containerSizeY/2

onready var ray = get_node("RayCast2D")
onready var boxQuantidade = get_child_count() - 1

var offSetX
var offSetY

var boxSizeX = 57
var boxSizeY = 80

onready var boxSpaceX = boxSizeX * boxQuantidade
onready var boxSpaceY = boxSizeY * boxQuantidade
var boxList = []

var flexDirection = "row"
var functions = [
	"class",
	"justify-content","FILL",
	"align-items","FILL"
]


func _ready():
	get_container_size()
	add_boxes()
	set_up_boxes()
	sort_boxes()
	process_class(functions)


func get_container_size():
	$RayCast2D.cast_to = Vector2(-1536,0)
	ray.force_raycast_update()
	offSetX = $RayCast2D.global_transform.origin.distance_to($RayCast2D.get_collision_point())

	$RayCast2D.cast_to = Vector2(0,-1536)
	ray.force_raycast_update()
	offSetY = $RayCast2D.global_transform.origin.distance_to($RayCast2D.get_collision_point())

	$RayCast2D.cast_to = Vector2(1536,0)
	ray.force_raycast_update()
	var rigth = $RayCast2D.global_transform.origin.distance_to($RayCast2D.get_collision_point())
	
	$RayCast2D.cast_to = Vector2(0,1536)
	ray.force_raycast_update()
	var bottom = $RayCast2D.global_transform.origin.distance_to($RayCast2D.get_collision_point())
	
	containerSizeX = offSetX + rigth
	containerSizeY = offSetY + bottom
	halfContainerX = containerSizeX/2
	halfContainerY = containerSizeY/2
	
	offSetX -= boxSizeX/2
	offSetY -= boxSizeY/2
	
	remove_child(ray)
	ray.queue_free()


func process_class(a):
	print(a)
	var tempFunctions = ["class"]
	var count = 0
	
	for  i in (a.size() - 1)/2:
		count+=1
		i+=count
		
		match a[i]:
			"justify-content":
				tempFunctions.append_array([a[i],a[i+1]])
				justify_content(a[i+1])
				
			
			"align-items":
				tempFunctions.append_array([a[i],a[i+1]])
				
			
			"flex-direction":
				flexDirection = a[i+1]
				reload()
			
			_:
				break
		
		if not a[0] == "reset":
			functions = tempFunctions


func justify_content(parament):
	var local = 0
	var increment = 0
	
	match parament:
		"center":
			match flexDirection:
				"column":
					local = halfContainerY - boxSpaceY/2
					increment = boxSizeY
					basic_placement_X(local, increment, offSetY)
				#alteração louca kk
				"row-revese":
					local = halfContainerX - boxSpaceX/2
					for box in boxList:
						box.position.x = local - offSetX
						local += boxSizeX
				
				_:
					local = halfContainerX - boxSpaceX/2
					for box in boxList:
						box.position.x = local - offSetX
						local += boxSizeX
		
		"flex-end":
			local = containerSizeX - boxSpaceX
			for box in boxList:
				box.position.x = local - offSetX
				local += boxSizeX
		
		"space-between":
			increment = containerSizeX - boxSizeX
			increment /= boxQuantidade - 1
			for box in boxList:
				box.position.x = local - offSetX
				local += increment
		
		"space-around":
			increment = containerSizeX - boxSpaceX
			increment = increment/(boxQuantidade * 2)
			increment += boxSizeX/2
			for box in boxList:
				local += increment
				box.position.x = local - (offSetX + boxSizeX/2)
				local += increment
		
		"space-evenly":
			increment = containerSizeX - boxSpaceX
			increment = increment/(boxQuantidade + 1)
			local += increment + boxSizeX/2
			for box in boxList:
				box.position.x = local - (offSetX + boxSizeX/2)
				local += increment + boxSizeX
		
		_:
			match flexDirection:
				"column":
					for box in boxList:
						box.position.y = local - offSetY
						local += boxSizeY
				
				_:
					for box in boxList:
						box.position.x = local - offSetX
						local += boxSizeX


func align_items(parament):
	var local = 0
	var increment = 0
	
	match parament:
		"center":
			match flexDirection:
				"column":
					local = halfContainerX - boxSizeX/2
					for box in boxQuantidade:
						get_child(box).position.x = local - offSetX
				
				_:
					local = halfContainerY - boxSizeY/2
					for box in boxQuantidade:
						get_child(box).position.y = local - offSetY
		
		"flex-end":
			local = containerSizeY - boxSizeY
			for box in boxList:
				box.position.y = local - offSetY
		
		_:
			match flexDirection:
				"column":
					for box in boxQuantidade:
						get_child(box).position.x = local - offSetX
				
				_:
					for box in boxQuantidade:
						get_child(box).position.y = local - offSetY


func add_boxes():
	for box in boxQuantidade:
		boxList.append(get_child(box))


func set_up_boxes():
	for box in boxList:
		box.containerSizeX = containerSizeX
		box.containerSizeY = containerSizeY
		box.offSetX = offSetX
		box.offSetY = offSetY


func sort_boxes():
	for i in boxQuantidade:
		for j in boxQuantidade - 1:
			if boxList[i].ordem < boxList[j].ordem:
				var temp = boxList[i]
				boxList[i] = boxList[j]
				boxList[j] = temp


func basic_placement_X(local, increment, offSet):
	for box in boxList:
		boxList[box].position.y = local - offSet
		local += increment


func basic_placement_X_reverse(local, increment, offSet):
	for box in range(len(boxList) - 1, -1, -1):
		boxList[box].position.y = local - offSet
		local += increment


func reload():
	process_class([
	"reset",
	"justify-content","FILL",
	"align-items","FILL"
	])
	process_class(functions)




