extends Area2D

@export var next_scene_path : String = "res://Cenas/fase_2.tscn"  # Caminho para a fase 2

@onready var win_game = $win_game


# Esta função é chamada quando o player colide com a área de colisão do castelo
func _on_body_entered(body):
	if body is Player:  # Verifica se o corpo que entrou na área é o Player (Mario)
		var background_music = body.get_node("music_background")  # Substitua pelo caminho correto da música de fundo
		if background_music:
			background_music.stop()
		win_game.play()
		
		body.set_physics_process(false)
		await get_tree().create_timer(7).timeout
		background_music.stop()
		change_to_next_scene()


# Função para carregar a próxima cena
func change_to_next_scene():
	get_tree().change_scene_to_file(next_scene_path)  # Carrega a fase 2





