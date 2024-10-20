extends Area2D

class_name Kamehameha
@onready var ray_cast_2d = $RayCast2D
@export var lifetime = 1.0

@export var horizontal_speed = 1
@export var vertical_speed = 50
var amplitude = 6
var is_moving_up = false

var direction
var vertical_movement_start_position

func _process(delta):
	lifetime -= delta  # Reduz o tempo de vida
	if lifetime <= 0:
		queue_free()  # Remove o Kamehameha da cena
	position.x += delta * horizontal_speed * direction
	if ray_cast_2d.is_colliding():
		is_moving_up = true
		vertical_movement_start_position = position
		
	if is_moving_up:
		position.y -= vertical_speed * delta
		if vertical_movement_start_position.y - amplitude >= position.y:
			is_moving_up = false
			
	if !is_moving_up:
		position.y += delta * vertical_speed

func _on_area_entered(area):
	if (area is Enemy):
		area.die_from_hit()
	await get_tree().create_timer(3).timeout
	queue_free()
	


#func _on_body_entered(body):
	#queue_free()
