@tool
extends Camera2D

@onready var player: CharacterBody2D = %Player
@onready var middle_point: Node2D = %MiddlePoint
var randomStrength = 30.0
var shake= 5.0
var rng = RandomNumberGenerator.new()
var shake_strength = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position.x = 41 * 16 / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y = player.global_position.y
	
	if shake_strength > 0 :
		shake_strength = lerpf(shake_strength, 0, shake * delta)
		
		offset = random_offset()
		
func apply_shake() -> void:
	shake_strength = randomStrength
	
func random_offset() -> Vector2 :
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
	
func shake_camera() -> void:
	apply_shake()
	
