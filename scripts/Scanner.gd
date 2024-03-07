extends Node3D

@onready var area_1: Area3D = $"Areas/One"
@onready var area_2: Area3D = $"Areas/Two"
@onready var area_3: Area3D = $"Areas/Three"
@onready var area_4: Area3D = $"Areas/Four"
@onready var area_5: Area3D = $"Areas/Five"
@onready var area_6: Area3D = $"Areas/Six"
@onready var area_7: Area3D = $"Areas/Seven"
@onready var area_8: Area3D = $"Areas/Eight"
@onready var area_9: Area3D = $"Areas/Nine"
@onready var area_0: Area3D = $"Areas/Zero"
@onready var area_ok: Area3D = $"Areas/Ok"
@onready var area_cancel: Area3D = $"Areas/Cancel"
@onready var area_card: Area3D = $"Areas/CardSlot"
@onready var display_label: Label3D = $"Display"

#var areas: Array[Area3D]
var dict: Dictionary

var open_func: Callable
var card_mode: bool
var opened: bool
var password: Array[int]
var current_attempt: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	card_mode = true
	opened = false
	current_attempt = [-1, -1, -1, -1]
	password = [1, 2, 3, 4]
	#areas = [area_1, area_2, area_3, area_4, area_5 , area_6, area_7, area_8, area_9, area_ok, area_0, area_cancel, area_card]
	dict = {area_1: 1, area_2: 2, area_3: 3, area_4: 4, area_5: 5, area_6: 6, area_7: 7, area_7: 7, area_8: 8, area_9: 9, area_0: 0, area_ok: -1, area_cancel: -2, area_card: -3}
	if card_mode:
		display_label.text = "CARD"
		for key in dict.keys():
			key.visible = false
		area_card.visible = true
	else:
		display_label.text = "____"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate_area(area: Area3D):
	if not dict.has(area):
		printerr("Error! Scanner has been called with a false Area3D!")
		return
	if opened:
		return
	
	var value: int = dict[area]
	
	if card_mode:
		if value == -3: # only accept inputs to card slot
			if true: # TODO check if player has keycard
				opened = true
				display_label.text = "OPEN"
				open_func.call(true)
		return
	
	if value == -3: # card
		pass
	elif value == -2: # cancel
		current_attempt = [-1, -1, -1, -1]
	elif value == -1: #ok
		if current_attempt == password:
			opened = true
			display_label.text = "OPEN"
			open_func.call(true)
			return
		current_attempt = [-1, -1, -1, -1]
	else: # insert value
		for i in range(4):
			if current_attempt[i] == -1:
				current_attempt[i] = value
				break
	# write to label
	var text = "    "
	for i in range(4):
		var next_char = ""
		if current_attempt[i] == -1:
			next_char = "_"
		else:
			next_char = str(current_attempt[i])
		text[i] = next_char
	display_label.text = text

func attach_to_door(f: Callable):
	open_func = f
