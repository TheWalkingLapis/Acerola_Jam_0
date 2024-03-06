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

#var areas: Array[Area3D]
var dict: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	#areas = [area_1, area_2, area_3, area_4, area_5 , area_6, area_7, area_8, area_9, area_ok, area_0, area_cancel, area_card]
	dict = {area_1: 1, area_2: 2, area_3: 3, area_4: 4, area_5: 5, area_6: 6, area_7: 7, area_7: 7, area_8: 8, area_9: 9, area_0: 0, area_ok: -1, area_cancel: -2, area_card: -3}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate_area(area: Area3D):
	if not dict.has(area):
		printerr("Error! Scanner has been called with a false Area3D!")
		return
	print(dict[area])
