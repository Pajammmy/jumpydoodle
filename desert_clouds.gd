extends ParallaxLayer

func _process(delta):
	motion_offset.x += delta * -9
