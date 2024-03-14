extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Controls_txt.visible = false
	$Credits_txt.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_parent().current_level_idx != -1:
		$"Start_Button".text = "Continue"

func reset():
	$Controls_txt.visible = false
	$Credits_txt.visible = false

func _on_start_button_button_down(): 
	# control/CanvasLayer/Main_Menu
	get_parent().get_parent().start_game()


func _on_quit_pressed():
	get_tree().quit()


func _on_controls_pressed():
	if $Controls_txt.visible:
		$Controls_txt.visible = false
	else:
		$Controls_txt.visible = true


func _on_credits_pressed():
	if $Credits_txt.visible:
		$Credits_txt.visible = false
	else:
		$Credits_txt.visible = true
