extends Control

var password
var password_input: String
var logged_in: bool = false

func _ready():
	password_input = ""

func _process(delta):
	if password_input == password:
		get_parent().log_in()
		logged_in = true

func set_password(pw):
	password = pw
	
func reset():
	password_input = ""
	$LoginBG/pw_input.text = ""
	if logged_in:
		$LoginBG/pw_input.text = password

func _on_pw_input_text_submitted(new_text):
	password_input = new_text
	$LoginBG/pw_input.text = ""

func _on_submit_button_down():
	password_input = $LoginBG/pw_input.text
	$LoginBG/pw_input.text = ""
