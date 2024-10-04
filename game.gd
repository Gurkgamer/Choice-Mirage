extends Node2D

@onready var shader_main: Control = %ShaderMain
@onready var player: CharacterBody2D = %Player
@onready var player_reflection: Node2D = %PlayerReflection

var material_shade : ShaderMaterial


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material_shade = shader_main.get_node("GrayScaleShader").get_material()
	material_shade.set_shader_parameter("enable_shader", false)

var intro_played = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if intro_played :
		play_intro()
		intro_played = false

func play_intro() -> void :
	%CroppedFloor3.visible = false
	%CroppedFloorSFX.play()
	await get_tree().create_timer(0.3).timeout
	%CroppedFloor2.visible = false
	%CroppedFloorSFX.play()
	await get_tree().create_timer(0.3).timeout
	%CroppedFloorSFX.play()
	%CroppedFloor.visible = false
	await get_tree().create_timer(0.3).timeout
	%IntroJugador.play_intro()
	await get_tree().create_timer(1).timeout
	%CroppedFloor.visible = true
	%CroppedFloorSFX.play()
	await get_tree().create_timer(0.3).timeout
	%CroppedFloor2.visible = true
	%CroppedFloorSFX.play()
	await get_tree().create_timer(0.3).timeout
	%CroppedFloor3.visible = true
	%CroppedFloorSFX.play()
	await get_tree().create_timer(0.3).timeout
	await get_tree().create_timer(0.3).timeout
	player.set_disable_control(false)
	player.get_node("AnimatedSprite2D").visible = true

#Animacion scena

func _on_scene_trigger_area_body_entered(body: Node2D) -> void:
	player.set_disable_control(true)
	player.velocity = Vector2.ZERO
	%AnimationPlayer.play("primera")
	
func set_player_dead_sprite() -> void:
	player.get_node("AnimatedSprite2D").play("dead1")
	player.velocity.y = 0
	player_reflection.get_node("AnimatedSprite2D").play("dead1")

func set_reflection_visible() -> void:
	player_reflection.visible = true

func set_reflection_invisible() -> void:
	player_reflection.visible = false


func _on_floor_touch_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	var tween = create_tween()
	tween.tween_property(%BlackFade,"modulate:a",1.0,4.0)
	tween.finished.connect(start_second_phase)

func start_second_phase() -> void:
	#%AnimationPlayer.stop()
	%MirrorTileset.visible = true
	%CollisionMirror.disabled = false
	await get_tree().create_timer(2.0).timeout
	var tween2 = create_tween()
	%primerascena.visible = false
	%SegundaFase.visible = true
	%primerascena.get_node("FloorTouch").queue_free()
	player.global_position = Vector2(280,320)
	player.get_node("AnimatedSprite2D").visible = false
	set_reflection_visible()
	player.set_disable_control(false)
	tween2.tween_property(%BlackFade,"modulate:a",0.0,4.0)
	%CollisionShape2D.disabled = true 
	%CollisionShape2D2.disabled = true
	player.set_animation_sprite("idle")
	player.reflect = true
	player_reflection.set_animation_sprite("idle")
	%AudioStreamPlayer2.play()
	%TerceraFaseArea.get_node("CollisionShape2D").disabled = false
	tercera_fase = true
	
var tercera_fase : bool = false

func _on_tercera_fase_area_body_entered(body: Node2D) -> void:
	if !tercera_fase :
		return
	if body.name != "Player":
		return
	player_reflection.set_idle_animation()
	player.disable_controls = true
	player.allow_crawl = false
	player.velocity = Vector2.ZERO
	%CroppedFloor3.visible = false
	%CroppedFloorSFX.play()
	await get_tree().create_timer(0.3).timeout
	%CroppedFloor2.visible = false
	%CroppedFloorSFX.play()
	await get_tree().create_timer(0.3).timeout
	%CroppedFloorSFX.play()
	%CroppedFloor.visible = false
	await get_tree().create_timer(0.3).timeout
	%TercerActoJugador.play_tercera_intro()
	await get_tree().create_timer(1).timeout
	%CroppedFloor.visible = true
	%CroppedFloorSFX.play()
	await get_tree().create_timer(0.3).timeout
	%CroppedFloor2.visible = true
	%CroppedFloorSFX.play()
	await get_tree().create_timer(0.3).timeout
	%CroppedFloor3.visible = true
	%CroppedFloorSFX.play()
	await get_tree().create_timer(0.3).timeout
	%TerceraFaseArea.queue_free()
	%SceneTriggerArea.queue_free()
	%CollisionShape2D.disabled = false
	%CollisionShape2D2.disabled = false
	%GreyScaleLevel1Collision.disabled = false
	%GreyScaleLevel2Collision.disabled = false
	%GreyScaleLevel3Collision.disabled = false
	%GreyScaleLevel4Collision.disabled = false
	%GreyScaleLevel5Collision.disabled = false
	%GreyScaleLevel6Collision.disabled = false
	%GreyScaleLevel7Collision.disabled = false
	%GreyScaleLevel8Collision.disabled = false
	%GreyScaleLevel9Collision.disabled = false
	%GreyScaleLevel10Collision.disabled = false
	%CreditsTigger.disabled = false


func _on_finale_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		player.set_finale_jump_state()
		player.set_disable_control(true)
		player.velocity = Vector2.ZERO
		player_reflection.just_dont()
	
func increase_gray_scale(value : float, value2 : float) -> void:
	material_shade.set_shader_parameter("enable_shader", true)
	material_shade.set_shader_parameter("brightness", value2)
	material_shade.set_shader_parameter("color_scale", value)

func _on_grey_scale_level_1_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		increase_gray_scale(0.1,0.5)
		%GreyScaleLevel1.queue_free()


func _on_grey_scale_level_2_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		increase_gray_scale(0.2,0.5)
		%GreyScaleLevel2.queue_free()


func _on_grey_scale_level_3_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		increase_gray_scale(0.3,0.4)
		%GreyScaleLevel3.queue_free()


func _on_grey_scale_level_4_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		increase_gray_scale(0.4,0.4)
		%GreyScaleLevel4.queue_free()


func _on_grey_scale_level_5_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		increase_gray_scale(0.5,0.4)
		%GreyScaleLevel5.queue_free()


func _on_grey_scale_level_6_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		increase_gray_scale(0.6,0.3)
		%GreyScaleLevel6.queue_free()


func _on_grey_scale_level_7_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		increase_gray_scale(0.7,0.3)
		%GreyScaleLevel7.queue_free()


func _on_grey_scale_level_8_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		increase_gray_scale(0.8,0.3)
		%GreyScaleLevel8.queue_free()


func _on_grey_scale_level_9_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		increase_gray_scale(0.9,0.3)
		%GreyScaleLevel9.queue_free()


func _on_grey_scale_level_10_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		increase_gray_scale(1.0,0.3)
		%GreyScaleLevel10.queue_free()

func _on_credits_launcher_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		%AudioStreamPlayer2.stop()
		Engine.time_scale = 0.03
		var tween = create_tween()
		player.show_surprise()
		await tween.tween_property(%Camera2D,"zoom",Vector2(4,4),0.1).finished
		%End.play()
		Engine.time_scale = 1
		await get_tree().create_timer(0.2).timeout
		increase_gray_scale(1,0)
		#visible = false
		var thx_instance = THX.instantiate()
		#material_shade.set_shader_parameter("enable_shader", false)
		get_parent().add_child(thx_instance)
		queue_free()
		
const THX = preload("res://Scenes/thx.tscn")
