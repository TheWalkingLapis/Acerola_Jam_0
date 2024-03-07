extends Node3D

@export var levels: Array[PackedScene]
var current_level
var current_level_idx: int = -1

func _ready():
	assert(levels.size() > 0)
	load_next_level()

func _process(delta):
	if Input.is_action_just_pressed("TEST_reset_level"):
		reload_current_level()

func reload_current_level():
	current_level.queue_free()
	current_level = levels[current_level_idx].instantiate()
	$Environment.add_child(current_level)
	current_level.position.y += 0.7
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
