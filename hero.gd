extends CharacterBody2D
@onready var global = get_node("/root/Global")

const low_jump = Vector2(200,-1250)
const medium_jump = Vector2(450,-1300)
const high_jump = Vector2(600,-2000)
const extrahigh_jump = Vector2(1000,-2200)
const fly_y = -3000.0
const fly_x = 500.0
const teleport_x = 20.0

enum State {
	Idle,
	Jump,
	Fall,
	Fly,
	Teleport,
}

var state
var hero 
var facing_left = false
var portal

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
		State.Fly:
			hero.play("fall")
			velocity.y = fly_y
		State.Teleport:
			hero.play("fall")
			motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
			$AnimationPlayer.play("teleport")
			$AudioStreamPlayer5.play()
	state = new_state

func _ready():
	set_hero_type(global.hero_type)
	velocity = Vector2(100, 0)
	set_state(State.Fall)

func _physics_process(delta):
	process_input()
	hero.flip_h = facing_left
	if state == State.Teleport:
		position.x = lerp(position.x, portal.position.x, .5)
		velocity.y = 0
	else:
		velocity.y += global.gravity
	move_and_slide()
	if is_on_floor() and state != State.Idle and state != State.Teleport:
		set_state(State.Idle)
	
func process_input():
	if Input.is_action_just_pressed("face_left"):
		facing_left = true
	elif Input.is_action_just_pressed("face_right"):
		facing_left = false
	
	if state == State.Fly:
		if Input.is_action_pressed("face_left"):
			velocity.x = lerp(velocity.x, -fly_x, .5)
		elif Input.is_action_pressed("face_right"):
			velocity.x = lerp(velocity.x, fly_x, .5)
	
	if state == State.Idle:
		if !is_on_floor():
			set_state(State.Fall)
		elif Input.is_action_just_pressed("low_jump"):
			velocity = low_jump
			set_state(State.Jump)
			$AudioStreamPlayer4.play()
		elif Input.is_action_just_pressed("medium_jump"):
			velocity = medium_jump
			set_state(State.Jump)
			$AudioStreamPlayer.play()
		elif Input.is_action_just_pressed("high_jump"):
			velocity = high_jump
			set_state(State.Jump)
			$AudioStreamPlayer2.play()
		elif Input.is_action_just_pressed("extrahigh_jump"):
			velocity = extrahigh_jump
			set_state(State.Jump)
			$AudioStreamPlayer3.play()
		if facing_left and velocity.x > 0:
			velocity.x = -velocity.x
			

func set_hero_type(type):
	$Cat.visible = false
	$Dog.visible = false
	match type:
		"cat":
			hero = $Cat
		"dog":
			hero = $Dog
	hero.visible = true	

func launch():
	if state == State.Idle:
		set_state(State.Fly)
	
func teleport(port):
	if state != State.Teleport:
		portal = port
		set_state(State.Teleport)


func _on_animation_player_animation_finished(_name):
	get_node("/root/Main").next_scene()
