extends StaticBody2D
var animation 

enum State {
	Up,
	Down,
	Launch,
}

var state = State.Up

func set_state(new_state: State):
	match new_state:
		State.Up:
			animation.play("up")
		State.Down:
			animation.play("down")
		State.Launch:
			animation.play("launch")

func _ready():
	animation = $Area2D.get_node("AnimationPlayer")
	set_state(State.Up)

func _on_area_2d_body_entered(body):
	if state == State.Up:
		set_state(State.Down)

func _on_area_2d_body_exited(body):
	if state == State.Down:
		set_state(State.Up)

func _on_animation_finished(name):
	match name:
		"down":
			set_state(State.Launch)
		"launch":
			set_state(State.Up)

func launch_target():
	var bodies = $Area2D.get_overlapping_bodies()
	if bodies.size() > 0 and bodies[0].has_method("launch"):
		bodies[0].launch()

