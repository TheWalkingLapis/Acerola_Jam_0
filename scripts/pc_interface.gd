extends CanvasLayer

@onready var login_screen: Control = $Login
@onready var desktop_screen: Control = $Desktop

@export var mails: Array[Resource]
@export var pc_active: bool = true
@export var pc_password: String = ""

func _ready():
	login_screen.visible = true
	login_screen.set_password(pc_password)

func _process(delta):
	pass

func log_in():
	if !pc_active:
		return
	login_screen.visible = false
	login_screen.reset()

func _on_log_out_button_button_down():
	login_screen.visible = true
	login_screen.reset()
	desktop_screen.reset()


func _on_leave_pressed():
	login_screen.reset()
	get_parent().get_node("Interior").get_node("LivingRoom").leave_pc_interaction()
