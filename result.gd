extends Label
@onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Your time was %02d:%02d" % [global.time / 60, int(global.time) % 60]

