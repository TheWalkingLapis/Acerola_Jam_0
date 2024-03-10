extends Control

@export var password = "Fistus"
var password_input: String

func _ready():
	password_input = ""

func _process(delta):
	if password_input == password:
		get_parent().log_in()
	
func reset():
	password_input = ""
	$LoginBG/pw_input.text = ""

func _on_pw_input_text_submitted(new_text):
	password_input = new_text
	$LoginBG/pw_input.text = ""

func _on_submit_button_down():
	password_input = $LoginBG/pw_input.text
	$LoginBG/pw_input.text = ""


func _on_leave_pressed():
	pass # Replace with function body.
