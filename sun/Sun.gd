extends MeshInstance3D

@onready var sunlight: DirectionalLight3D = $"../SunLight"
@onready var noise: FastNoiseLite = load("res://sun/sun_noise_l1.tres").noise
@export var sun_speed: float = 1
var time: float

func _ready():
	time = 0


func _process(delta):
	time += delta
	position = 300.0 * Vector3(sin(sun_speed * time), 1, cos(sun_speed * time))
	var look_at_pos = -position
	#look_at_pos.y = -10
	sunlight.position = position
	sunlight.look_at(look_at_pos)
	look_at(Vector3.ZERO)

	noise.offset += delta*Vector3(10,10,10)
