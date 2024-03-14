extends CanvasLayer

@onready var login_screen: Control = $Login
@onready var desktop_screen: Control = $Desktop

@export var mails: Array[Resource]
@export var pc_active: bool = true
@export var pc_password: String = ""
@export var always_logged_in: bool = false

@export var control_sleeping_room_door: bool = true
@export var control_pod_room_door: bool = true
@export var control_pod_door: bool = true

func _ready():
	login_screen.set_password(pc_password)
	if always_logged_in:
		login_screen.visible = false
	else:
		login_screen.visible = true
		
func _process(delta):
	pass

func log_in():
	if !pc_active:
		return
	login_screen.visible = false
	login_screen.reset()

func _on_log_out_button_button_down():
	if always_logged_in:
		desktop_screen.reset()
		get_parent().get_node("Interior").get_node("LivingRoom").leave_pc_interaction()
		return
	login_screen.visible = true
	login_screen.reset()
	desktop_screen.reset()


func _on_leave_pressed():
	login_screen.reset()
	get_parent().get_node("Interior").get_node("LivingRoom").leave_pc_interaction()
