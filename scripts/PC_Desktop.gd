extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Mail.visible = false
	$DoorControl.visible = false
	
	$Mail.set_items(get_parent().mails)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mail_button_pressed():
	$Mail.visible = true
	$Mail.layer = 10
	$DoorControl.layer = 9


func _on_mail_close_pressed():
	$Mail.visible = false
	$Mail.layer = 0
	$Mail.reset()

func _on_door_control_button_pressed():
	$DoorControl.update_doors()
	$DoorControl.visible = true
	$DoorControl.layer = 10
	$Mail.layer = 9

func _on_control_close_pressed():
	$DoorControl.visible = false
	$DoorControl.layer = 0
	$DoorControl.reset()

func reset():
	$Mail.visible = false
	$Mail.reset()
	$DoorControl.visible = false
	$DoorControl.reset()
