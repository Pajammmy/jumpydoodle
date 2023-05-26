extends Control
@onready var global = get_node("/root/Global")

enum Scene {
	None,
	Title,
	Forest,
	Desert,
	Snow,
	End
}

var scene_instance
var scene = Scene.None

func set_scene(new_scene):
	if is_instance_valid(scene_instance):
		remove_child(scene_instance)
		scene_instance.queue_free()
	scene = new_scene
	match new_scene:
		Scene.None:
			return
		Scene.Title:
			scene_instance = load("res://title.tscn").instantiate()
		Scene.Forest:
			scene_instance = load("res://forest_level.tscn").instantiate()
		Scene.Desert:
			scene_instance = load("res://desert_level.tscn").instantiate()
		Scene.Snow:
			scene_instance = load("res://snow_level.tscn").instantiate()
		Scene.End:
			print("End")
	add_child(scene_instance)

func next_scene():
	if scene == Scene.End:
		scene = Scene.None
	set_scene(scene + 1)
	
func _ready():
	next_scene()
	
func _process(delta):
	if scene > Scene.Title and scene < Scene.End:
		$Hud.visible = true
		global.time += delta
	else:
		$Hud.visible = false

