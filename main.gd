extends Control
@onready var global = get_node("/root/Global")
@onready var fade = get_node("Fade/AnimationPlayer")

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
var count_time = false

func set_scene(new_scene):
	if is_instance_valid(scene_instance):
		remove_child(scene_instance)
		scene_instance.queue_free()
	scene = new_scene
	count_time = false
	fade.play("fade_out")
	

func _on_animation_player_animation_finished(name):
	if name == "fade_out":
		$Hud.visible = true
		$AudioStreamPlayer.stop()
		match scene:
			Scene.None:
				return
			Scene.Title:
				scene_instance = load("res://title.tscn").instantiate()
				$Hud.visible = false
			Scene.Forest:
				scene_instance = load("res://forest_level.tscn").instantiate()
			Scene.Desert:
				scene_instance = load("res://desert_level.tscn").instantiate()
			Scene.Snow:
				scene_instance = load("res://snow_level.tscn").instantiate()
			Scene.End:
				scene_instance = load("res://end.tscn").instantiate()
				$Hud.visible = false
		add_child(scene_instance)
		fade.play("fade_in")
	else:
		if scene > Scene.Title and scene < Scene.End:
			count_time = true
			$AudioStreamPlayer.play(0)

func next_scene():
	if scene == Scene.End:
		scene = Scene.None
		global.time = 0.0
	set_scene(scene + 1)
	
func _ready():
	next_scene()
	
func _process(delta):
	if Input.is_action_just_pressed("skip"):
		next_scene()
	if count_time:
		global.time += delta




