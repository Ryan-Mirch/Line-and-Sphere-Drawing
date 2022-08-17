extends Node

var points:Array
var lines:Array

var mouse_line: MeshInstance3D

func _ready() -> void:
	call_deferred("_init_mouse_line")
	
	
func _process(_delta: float) -> void:
	_update_mouse_line()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Left Click"):
		_draw_point_and_line()
	
	if event.is_action_pressed("Right Click"):
		_clear_points_and_lines()

#Returns the position in 3d that the mouse is hovering, or null if it isnt hovering anything
func get_mouse_pos():
	var space_state = get_parent().get_world_3d().get_direct_space_state()
	var mouse_position = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera_3d()
	
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 1000
		
	var params = PhysicsRayQueryParameters3D.new()
	params.from = ray_origin
	params.to = ray_end
	params.collision_mask = 1
	params.exclude = []
	
	var rayDic = space_state.intersect_ray(params)	
	
	if rayDic.has("position"):
		return rayDic["position"]
	return null

func _init_mouse_line():
	mouse_line = Draw3D.line(Vector3.ZERO, Vector3.ZERO, Color.BLACK)
		
func _update_mouse_line():
	var mouse_pos = get_mouse_pos()
	var mouse_line_immediate_mesh = mouse_line.mesh as ImmediateMesh
	if mouse_pos != null:
		var mouse_pos_V3:Vector3 = mouse_pos
		mouse_line_immediate_mesh.clear_surfaces()
		mouse_line_immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
		mouse_line_immediate_mesh.surface_add_vertex(Vector3.ZERO)
		mouse_line_immediate_mesh.surface_add_vertex(mouse_pos_V3)
		mouse_line_immediate_mesh.surface_end()	
		
func _draw_point_and_line()->void:
	var mouse_pos = get_mouse_pos()
	if mouse_pos != null:
		var mouse_pos_V3:Vector3 = mouse_pos
		points.append(Draw3D.point(mouse_pos_V3,0.05))
		
		#If there are at least 2 points...
		if points.size() > 1:
			#Draw a line from the position of the last point placed to the position of the second to last point placed
			var point1 = points[points.size()-1]
			var point2 = points[points.size()-2]
			var line = Draw3D.line(point1.position, point2.position)
			lines.append(line)

func _clear_points_and_lines()->void:
	for p in points:
		p.queue_free()
	points.clear()
		
	for l in lines:
		l.queue_free()
	lines.clear()
