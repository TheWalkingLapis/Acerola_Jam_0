extends Node3D

@export var levels: Array[PackedScene]
@export var player_scene: PackedScene
@export var enivornment_scene: PackedScene
var current_level
var current_level_idx: int = -1

var fullscreen = false
var in_main_menu: bool = true
var game_over_test = false

func _ready():
	assert(levels.size() > 0)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen = !fullscreen
		
	if in_main_menu:
		return
	
	if Input.is_action_just_pressed("TEST_reset_level"):
		reload_current_level()

func reload_current_level():
	current_level.queue_free()
	current_level = levels[current_level_idx].instantiate()
	$Environment.add_child(current_level)
	current_level.position.y += 0.7
	
	$Player.position = current_level.get_node("PlayerSpawn").position
	$Player.rotation = current_level.get_node("PlayerSpawn").rotation
	
func load_next_level():
	# no more levels (trigger win here?)
	if current_level_idx >= levels.size():
		print("Won, TODO")
		return
	
	# load first level
	if current_level_idx == -1:
		# instantiate environement and player
		var environment = enivornment_scene.instantiate()
		environment.process_mode = Node.PROCESS_MODE_PAUSABLE
		add_child(environment)
		var player = player_scene.instantiate()
		player.process_mode = Node.PROCESS_MODE_PAUSABLE
		add_child(player)
		
		current_level_idx += 1
		current_level = levels[0].instantiate()
		$Environment.add_child(current_level)
		current_level.position.y += 0.7
		
		$Player.position = current_level.get_node("PlayerSpawn").position
		$Player.rotation = current_level.get_node("PlayerSpawn").rotation
		return
		
	# load next level
	# instantiate environement and player
	$Environment.queue_free()
	await $Environment.tree_exited
	var environment = enivornment_scene.instantiate()
	environment.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(environment)
	$Player.queue_free()
	await $Player.tree_exited
	var player = player_scene.instantiate()
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(player)
	
	# current_level freed when removing environment
	current_level_idx += 1
	current_level = levels[current_level_idx].instantiate()
	$Environment.add_child(current_level)
	current_level.position.y += 0.7
	
	$Player.position = current_level.get_node("PlayerSpawn").position
	$Player.rotation = current_level.get_node("PlayerSpawn").rotation
	
func start_game():
	in_main_menu = false
	$Main_Menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	load_next_level()
	
	$Audio_Manager.start_ingame_music()

# called by moon base
func pod_escaped():
	print("escaped")
	$Player.get_node("Camera3D").get_node("negative").visible = true
	$Audio_Manager.stop_ingame_music()
	get_tree().paused = true
	
	# wait for x seconds
	await get_tree().create_timer(4.0).timeout
	load_next_level()
	print("Next level!")
	$Audio_Manager.start_ingame_music()
	get_tree().paused = false

var removed_keycard = false
func get_keycard() -> RigidBody3D:
	if removed_keycard: return null
	return current_level.get_node("Keycard")

func picked_up_keycard():
	current_level.get_node("Keycard").queue_free()
	removed_keycard = true

func get_all_children(querry: Node) -> Array[Node]:
	var res: Array[Node] = []
	for c in querry.get_children():
		res.append(c)
		res.append_array(get_all_children(c))
	return res
