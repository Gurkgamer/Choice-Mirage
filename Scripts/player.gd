extends CharacterBody2D

var disable_controls = false
const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var reflect = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var coyote_available : bool
@onready var coyote_timer: Timer = %CoyoteTimer
var jump_buffered : bool
@onready var buffered_jump_timer: Timer = %BufferedJumpTimer


var reflection
var finale_jump = false

func set_finale_jump_state() -> void :
	finale_jump = true

func _ready() -> void:	
	reflection = get_tree().get_first_node_in_group("Reflection")
	disable_controls = true
	animated_sprite_2d.visible = false
	allow_crawl = false
	sprite_2d.visible = false

func _physics_process(delta: float) -> void:

	var direction := Input.get_axis("ui_left", "ui_right")
	
	if is_on_floor():
		coyote_available = true
		if jump_buffered:
			audio_stream_player_2d.play()
			velocity.y = JUMP_VELOCITY
			coyote_available = false
			run(direction,SPEED)
			move_and_slide()
			return
			
	
	if disable_controls :
		velocity += get_gravity() * delta
		if allow_crawl :
			if direction < 0 or direction == 0 :
				direction = 0
				animated_sprite_2d.play("dead1")
			else :
				if is_on_floor():
					animated_sprite_2d.play("dead2")
				else:
					animated_sprite_2d.play("dead1")
				animated_sprite_2d.flip_h = false
			run( direction , 20)
		move_and_slide()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		coyote_available = false
	
	#Character leaves platform without jumping
	if !is_on_floor() and coyote_available and coyote_timer.is_stopped():
		coyote_timer.start()
		
	#Coyote jump
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor() and coyote_available :
		velocity.y = JUMP_VELOCITY
		audio_stream_player_2d.play()
		coyote_available = false
		
	#Start jump buffering
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor() and !jump_buffered:
		jump_buffered = true
		buffered_jump_timer.start()
		
	#Enough jump
	if Input.is_action_just_released("ui_accept") and !is_on_floor() and velocity.y < 0:
		velocity.y = 0

	if direction > 0 :
		animated_sprite_2d.flip_h = false if !reflect else true
	elif direction < 0 :
		animated_sprite_2d.flip_h = true if !reflect else false
		
	if direction == 0:
		animated_sprite_2d.play("idle")
		reflection.set_idle_animation()
	else:
		animated_sprite_2d.play("run")
		reflection.set_run_animation()
		
	if is_on_floor() :
		if direction == 0:
			animated_sprite_2d.play("idle")
			reflection.set_idle_animation()
		else:
			animated_sprite_2d.play("run")
			reflection.set_run_animation()
	else:
		animated_sprite_2d.play("jump")
		reflection.set_jump_animation()
	
	if reflect :
		direction = direction * -1
	
	run(direction,SPEED)

	move_and_slide()

func run(direction, speed) -> void:
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and is_on_floor() and !disable_controls: 
		audio_stream_player_2d.play()
	
	if finale_jump and event.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func set_disable_control(value : bool):
	disable_controls = value

# Animacion primera

func set_animation_sprite(animation_name : String) -> void:
	animated_sprite_2d.play(animation_name)

var allow_crawl : bool = false

func set_allow_crawling() -> void :
	allow_crawl = true

func show_surprise() -> void:
	audio_stream_player.play()
	sprite_2d.visible = true
	var tween = create_tween()
	tween.tween_property(sprite_2d,"modulate",Color.RED,1)

func _on_coyote_timer_timeout() -> void:
	coyote_available = false

func _on_buffered_jump_timer_timeout() -> void:
	jump_buffered = false
