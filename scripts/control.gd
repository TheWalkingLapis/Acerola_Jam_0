extends Node3D

@export var levels: Array[PackedScene]
@export var player_scene: PackedScene
@export var enivornment_scene: PackedScene
var current_level
var current_level_idx: int = -1

var in_main_menu: bool = true
var game_over_test = false

#TODO remove
var chaos_stage = 0.0
var start_chaos = false
var chaos_time = 0.0

func _ready():
	assert(levels.size() > 0)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	if in_main_menu:
		return
		
	if game_over_test:
		if Input.is_action_just_pressed("TEST_win_back_to_menu"):
			current_level_idx = -1
			game_over_test = false
			in_main_menu = true
			$Main_Menu.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$TEST_win.visible = false
			$TEST_loose.visible = false
		return
	
	#TODO remove
	if start_chaos:
		chaos_time += delta
		if chaos_stage > 2.0:
			game_over_test = true
			get_node("Player").queue_free()
			get_node("Environment").queue_free()
			$TEST_loose.visible = true
		if chaos_time > 1.0:
			chaos_stage += 0.1
			chaos_time -= 1.0
			progress_chaos()
	
	if Input.is_action_just_pressed("TEST_reset_level"):
		reload_current_level()

func reload_current_level():
	current_level.queue_free()
	current_level = levels[current_level_idx].instantiate()
	$Environment.add_child(current_level)
	current_level.position.y += 0.7
	
	$Player.position = current_level.get_node("PlayerSpawn").position
	$Player.rotation = current_level.get_node("PlayerSpawn").rotation
	
	#TODO remove
	start_chaos = false
	chaos_stage = 0.0
	chaos_time = 0.0
	
func load_next_level():
	# no more levels (trigger win here?)
	if current_level_idx >= levels.size():
		printerr("No more levels to be loaded!")
		return
	# load first level
	if current_level_idx == -1:
		current_level_idx += 1
		current_level = levels[0].instantiate()
		$Environment.add_child(current_level)
		current_level.position.y += 0.7
		return
	# load next level
	current_level.queue_free()
	current_level_idx += 1
	current_level = levels[current_level_idx].instantiate()
	$Environment.add_child(current_level)
	current_level.position.y += 0.7
	
func start_game():
	in_main_menu = false
	$Main_Menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var enivornment = enivornment_scene.instantiate()
	add_child(enivornment)
	var player = player_scene.instantiate()
	add_child(player)
	
	load_next_level()
	$Player.position = current_level.get_node("PlayerSpawn").position
	$Player.rotation = current_level.get_node("PlayerSpawn").rotation

# called by moon base
func pod_reached():
	#TODO remove
	if start_chaos:
		return
	game_over_test = true
	get_node("Player").queue_free()
	get_node("Environment").queue_free()
	
	$TEST_win.visible = true


#TODO remove
func test_loose():
	start_chaos = true
func progress_chaos():
	chaos_stage += 0.1
	var chaos_mat: ShaderMaterial = load("res://materials/chaos_mat.tres")
	var children = get_all_children($Environment)
	for c in children:
		if "material_override" in c and randf() <= chaos_stage:
			c.material_override = chaos_mat
func get_all_children(querry: Node) -> Array[Node]:
	var res: Array[Node] = []
	for c in querry.get_children():
		res.append(c)
		res.append_array(get_all_children(c))
	return res
