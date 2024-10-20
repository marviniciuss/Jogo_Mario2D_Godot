extends Area2D

@export var next_scene_path : String = "res://Cenas/win_scene.tscn"  # Caminho para a fase 2

@onready var win_game = $win_game2
@onready var background_fase_2 = $"../../background_fase2"
@onready var music_kamehameha = $"../../Player/music_kamehameha"


# Esta função é chamada quando o player colide com a área de colisão do castelo
func _on_body_entered(body):
	if body is Player2:  # Verifica se o corpo que entrou na área é o Player (Mario)
		print("Entroooouuuuuuuuuuuuuuuuuuuuuuu")

		if background_fase_2 and background_fase_2 is AudioStreamPlayer:
			if background_fase_2.playing:
				background_fase_2.stop()
				print("Música de fundo parada")
			else:
				print("Música de fundo não estava tocando")

		# Verifique se o music_kamehameha foi encontrado e se está tocando
		if music_kamehameha and music_kamehameha is AudioStreamPlayer:
			if music_kamehameha.playing:
				music_kamehameha.stop()
				print("Música Kamehameha parada")
			else:
				print("Música Kamehameha não estava tocando")
			
	
		win_game.play()
		body.set_physics_process(false)
		await get_tree().create_timer(7).timeout
		#background_music.stop()
		change_to_next_scene()


# Função para carregar a próxima cena
func change_to_next_scene():
	get_tree().change_scene_to_file(next_scene_path)  # Carrega a fase 2
