extends Control
@onready var global = get_node("/root/Global")

func _on_cat_pressed():
	global.hero_type = "cat"
	get_parent().next_scene()

func _on_dog_pressed():
	global.hero_type = "dog"
	get_parent().next_scene()
