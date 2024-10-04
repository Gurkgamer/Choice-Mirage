extends AnimatedSprite2D

@onready var player: CharacterBody2D = %Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func play_tercera_intro() -> void:
	player.get_node("AnimatedSprite2D").flip_h = false
	visible = true
	var tween  = create_tween()
	play("walk")
	await tween.tween_property(self,"global_position", player.global_position,2).finished
	player.get_node("AnimatedSprite2D").visible = true
	player.set_disable_control(false)	
	%FinaleCollision.disabled = false
	queue_free()
