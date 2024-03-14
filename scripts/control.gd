extends Node3D

@export var levels: Array[PackedScene]
@export var player_scene: PackedScene
@export var enivornment_scene: PackedScene
var current_level
var current_level_idx: int = -1

var fullscreen = false
var in_main_menu: bool = true
var in_pause_menu: bool = false
var game_over_test = false
var wait_time = 0.0
var removed_keycard = false

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
	
	if Input.is_action_just_pressed("pause_unpause"):
		pause_unpause()
			

func pause_unpause():
	var player = $Player
	if in_pause_menu:
		in_pause_menu = false
		$Pause_Menu.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
	else:
		in_pause_menu = true
		$Pause_Menu.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

func to_main_menu():
	if in_pause_menu:
		pause_unpause()
	in_main_menu = true
	$Main_Menu.get_node("Main_Menu").reset()
	$Main_Menu.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Audio_Manager.stop_all()
	
	$Environment.queue_free()
	await $Environment.tree_exited
	$Player.queue_free()
	await $Player.tree_exited
	
	current_level_idx -= 1

func reload_current_level():
	current_level.queue_free()
	current_level = levels[current_level_idx].instantiate()
	$Environment.add_child(current_level)
	
	$Player.position = current_level.get_node("PlayerSpawn").position
	$Player.rotation = current_level.get_node("PlayerSpawn").rotation
	removed_keycard = false
	if in_pause_menu:
		pause_unpause()
	$Audio_Manager.play_intro(current_level_idx)
	
func load_next_level():
	# no more levels (trigger win here?)
	if current_level_idx >= levels.size():
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
		
		$Player.position = current_level.get_node("PlayerSpawn").position
		$Player.rotation = current_level.get_node("PlayerSpawn").rotation
		$Audio_Manager.play_intro(0)
		return
		
	# load next level
	# instantiate environement and player
	if get_node_or_null("Environment") != null:
		$Environment.queue_free()
		await $Environment.tree_exited
	var environment = enivornment_scene.instantiate()
	environment.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(environment)
	if get_node_or_null("Player") != null:
		$Player.queue_free()
		await $Player.tree_exited
	var player = player_scene.instantiate()
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(player)
	
	# current_level freed when removing environment
	current_level_idx += 1
	current_level = levels[current_level_idx].instantiate()
	$Environment.add_child(current_level)
	
	$Player.position = current_level.get_node("PlayerSpawn").position
	$Player.rotation = current_level.get_node("PlayerSpawn").rotation
	removed_keycard = false
	$Audio_Manager.play_intro(current_level_idx)
	return
	
func start_game():
	in_main_menu = false
	$Main_Menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	load_next_level()
	
	$Audio_Manager.start_ingame_music()

# called by moon base
func pod_escaped():
	# won
	if current_level_idx == levels.size()-1:
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$Win.visible = true
		return
		
	$Player.get_node("Camera3D").get_node("negative").start_restart()
	$Audio_Manager.stop_ingame_music()
	get_tree().paused = true
	
	# wait for x seconds
	await get_tree().create_timer(7.0).timeout
	
	load_next_level()
	
	$Audio_Manager.start_ingame_music()
	get_tree().paused = false

func get_keycard() -> RigidBody3D:
	if removed_keycard: return null
	return current_level.get_node_or_null("Keycard")

func picked_up_keycard():
	current_level.get_node("Keycard").queue_free()
	removed_keycard = true

func get_all_children(querry: Node) -> Array[Node]:
	var res: Array[Node] = []
	for c in querry.get_children():
		res.append(c)
		res.append_array(get_all_children(c))
	return res
