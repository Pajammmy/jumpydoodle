extends CharacterBody2D
@onready var global = get_node("/root/Global")

const low_jump = Vector2(300,-1500)
const medium_jump = Vector2(400,-2000)
const high_jump = Vector2(500,-2500)

enum State {
	Idle,
	Jump,
	Fall,
}

var state
var hero 
var facing_left = false

func set_state(new_state):
	hero.stop()
	match new_state:
		State.Idle:
			hero.play("idle")
			velocity.x = 0
		State.Jump:
			hero.play("jump")
		State.Fall:
			hero.play("fall")
	state = new_state

func _ready():
	set_hero_type(global.hero_type)
	set_state(State.Idle)

func _physics_process(delta):
	process_input()
	hero.flip_h = facing_left
	velocity.y += global.gravity
	move_and_slide()
	if is_on_floor() and state != State.Idle:
		set_state(State.Idle)
	
func process_input():
	if Input.is_action_just_pressed("face_left"):
		facing_left = true
	elif Input.is_action_just_pressed("face_right"):
		facing_left = false
	
	if state == State.Idle:
		if Input.is_action_just_pressed("low_jump"):
			velocity = low_jump
			set_state(State.Jump)
		elif Input.is_action_just_pressed("medium_jump"):
			velocity = medium_jump
			set_state(State.Jump)
		elif Input.is_action_just_pressed("high_jump"):
			velocity = high_jump
			set_state(State.Jump)
		if facing_left and velocity.x > 0:
			velocity.x = -velocity.x
			
func _on_animation_finished():
	match state:
		State.Idle:
			pass
		State.Jump:
			pass
		State.Fall:
			pass

func set_hero_type(type):
	$Cat.visible = false
	$Dog.visible = false
	match type:
		"cat":
			hero = $Cat
		"dog":
			hero = $Dog
	hero.visible = true	