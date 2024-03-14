extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Master_Vol/Val.text = str($Control/Master_Vol.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db($Control/Master_Vol.value/100.0))
	$Control/Music_Vol/Val.text = str($Control/Music_Vol.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db($Control/Music_Vol.value/100.0))
	$Control/Effect_Vol/Val.text = str($Control/Effect_Vol.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), linear_to_db($Control/Effect_Vol.value/100.0))
	$Control/Voice_Vol/Val.text = str($Control/Voice_Vol.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"), linear_to_db($Control/Voice_Vol.value/100.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_voice_vol_value_changed(value):
	$Control/Voice_Vol/Val.text = str(value)
	var vol = linear_to_db(value/100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"), vol)

func _on_effect_vol_value_changed(value):
	$Control/Effect_Vol/Val.text = str(value)
	var vol = linear_to_db(value/100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), vol)

func _on_music_vol_value_changed(value):
	$Control/Music_Vol/Val.text = str(value)
	var vol = linear_to_db(value/100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), vol)

func _on_master_vol_value_changed(value):
	$Control/Master_Vol/Val.text = str(value)
	var vol = linear_to_db(value/100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), vol)


func _on_restart_pressed():
	get_parent().reload_current_level()


func _on_unpause_pressed():
	get_parent().pause_unpause()


func _on_back_to_ment_pressed():
	get_parent().to_main_menu()
