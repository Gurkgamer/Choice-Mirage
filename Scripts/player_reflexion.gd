extends Node2D

var player : CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
var i_wont_jump = false

var screen_size = 42 * 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if i_wont_jump :
		return
	global_position.y = player.global_position.y
	global_position.x = screen_size - player.global_position.x - 16
	animated_sprite_2d.flip_h = !player.get_node("AnimatedSprite2D").flip_h

func set_run_animation() :
	animated_sprite_2d.play("run")
	
func set_idle_animation():
	animated_sprite_2d.play("idle")
	
func set_jump_animation():
	animated_sprite_2d.play("jump")
	
#Animacion primera
func set_animation_sprite(animation_name: String) -> void :
	animated_sprite_2d.play(animation_name)

func just_dont() -> void:
	i_wont_jump = true
