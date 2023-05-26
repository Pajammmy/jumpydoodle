extends Label
@onready var global = get_node("/root/Global")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "%02d:%02d" % [global.time / 60, int(global.time) % 60]
