extends CharacterBody2D

class_name Player2
signal points_scored(points:int)

enum PlayerMode {
	small,
	big,
	shooting
}

const BIG_MARIO_COLLISION_SHAPE = preload("res://Resources/CollisionShapes/big_mario_collision_shape.tres")
const SMALL_MARIO_COLLISION_SHAPE = preload("res://Resources/CollisionShapes/small_mario.tres")

@onready var music_background = $"../background_fase2"
@onready var musica_shooting = $music_kamehameha
@onready var cogumelo = $Cogumelo

@onready var animated_sprite_2d = $AnimatedSprite2D as PlayerAnimatedSprite
@onready var area_collision_shape_2d = $Area2D/AreaCollisionShape2D
@onready var body_collision_shape_2d = $BodyCollisionShape2D
@onready var area_2d = $Area2D
const FIREBALL = preload("res://Cenas/fireball.tscn")
@onready var shooting_point = $Marker2D
const KAMEHAMEHA = preload("res://kamehameha.tscn")


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const points_label_scene = preload("res://Cenas/points_label.tscn")
var is_dead = false


@export_group("Camera sync")
@export var camera_sync: Camera2D
@export var should_camera_sync: bool = true
@export_group("")


@export_group("Locomotion")
@export var run_speed_damping = 2
@export var speed = 300
@export var jump_velocity = -350

@export_group("Stomping Enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -150



@export var player_mode = PlayerMode.small



func _process(delta):
	if global_position.x > camera_sync.global_position.x && should_camera_sync:
		camera_sync.global_position.x = global_position.x
		

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	if Input.is_action_just_released("jump") and velocity.y <0:
		velocity.y *= 0.5
		
		
	var direction = Input.get_axis("left","right")
	if direction:
		velocity.x = lerp(velocity.x,speed*direction, run_speed_damping*delta)
		#animated_sprite_2d.play("small_run")
	else:
		velocity.x = move_toward(velocity.x,0,speed*delta)
		#animated_sprite_2d.play("small_idle")
		animated_sprite_2d.trigger_animation(velocity, direction, player_mode)	

	if Input.is_action_just_pressed("shoot") && player_mode == PlayerMode.shooting:
		shoot()
	else:
		animated_sprite_2d.trigger_animation(velocity, direction, player_mode)
	
	
	var collision = get_last_slide_collision()
	if collision != null:
		handle_movement_collision(collision)
	
	
	move_and_slide()
	
	
func _on_area_2d_area_entered(area):
	if area is Enemy:
		handle_enemy_collision(area)
	if area is Shroom:
		handle_shroom_collision(area)
		area.queue_free()
	if area is ShootingFlower:
		handle_flower_collision()
		area.queue_free()

func handle_flower_collision():
	set_physics_process(false)

	var animation_name = "small_to_shooting" if player_mode == PlayerMode.small else "big_to_shooting"
	animated_sprite_2d.play(animation_name)
	#animated_sprite_2d.connect("animation_finished", _on_animation_finished)
	set_collision_shapes(false)

	if player_mode != PlayerMode.shooting:
		music_background.stop()
		musica_shooting.play()  # Toca a música de fundo
		print("Música de fundo tocando!")
	player_mode = PlayerMode.shooting  # Mudar para modo shooting



func handle_enemy_collision(enemy: Enemy):
	if enemy == null || is_dead:
		return


	if is_instance_of(enemy, Koopa) and (enemy as Koopa).in_a_shell:
		(enemy as Koopa).on_stomp(global_position)
	else:
		var angle_of_collision = rad_to_deg(position.angle_to_point(enemy.position))

		if angle_of_collision > min_stomp_degree && max_stomp_degree > angle_of_collision:
			enemy.die()
			on_enemy_stomped()
			spawn_points_label(enemy)
		else:
			die()


func handle_shroom_collision(area: Node2D):
	if player_mode == PlayerMode.small:
		set_physics_process(false)
		animated_sprite_2d.play("small_to_big")
		set_collision_shapes(false)
		cogumelo.play()





func on_enemy_stomped():
	velocity.y = stomp_y_velocity

func spawn_points_label(enemy):
	var points_label = points_label_scene.instantiate()
	points_label.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)
	points_scored.emit(100)
	
@onready var death_song = $DeathSong

func die():
	if player_mode == PlayerMode.small:
		is_dead = true
		music_background.stop()
		musica_shooting.stop()
		death_song.play()
		animated_sprite_2d.play("small_death")
		set_physics_process(false)
		await get_tree().create_timer(1.5).timeout #Dalay para poder tocar a música toda 

		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -45), .5)
		death_tween.chain().tween_property(self, "position", position + Vector2(0, 500), 1)
		death_tween.tween_callback(func(): get_tree().reload_current_scene())
	else:
		big_to_small()
		
		


func handle_movement_collision(collision: KinematicCollision2D):
	if collision.get_collider() is Block:
		var collision_angle = rad_to_deg(collision.get_angle())
		if roundf(collision_angle) == 180:
			(collision.get_collider() as Block).bump(player_mode)


func set_collision_shapes(is_small: bool):
	var collision_shape = SMALL_MARIO_COLLISION_SHAPE if is_small else BIG_MARIO_COLLISION_SHAPE
	area_collision_shape_2d.set_deferred("shape", collision_shape)
	body_collision_shape_2d.set_deferred("shape", collision_shape)


func big_to_small():
	set_collision_layer_value(1, false)
	set_physics_process(false)
	var animation_name = "small_to_big" if player_mode == PlayerMode.big else "small_to_shooting"
	animated_sprite_2d.play("small_to_big", 1.0, true)
	set_collision_shapes(true)
	if player_mode == PlayerMode.shooting:
		musica_shooting.stop()  # Parar a música de fundo
		print("Música de fundo parou!")
		music_background.play()
	player_mode = PlayerMode.big


#func _on_area_2d_body_entered(body):
#	if (body is Block):
#		print("block")
func shoot():
	animated_sprite_2d.play("shoot")
	set_physics_process(false)
	
	var kamehameha = KAMEHAMEHA.instantiate()
	kamehameha.direction = sign(animated_sprite_2d.scale.x)
	kamehameha.global_position = shooting_point.global_position
	get_tree().root.add_child(kamehameha)
	


func _on_area_2d_castelo_2_body_entered(body):
	
	pass # Replace with function body.
