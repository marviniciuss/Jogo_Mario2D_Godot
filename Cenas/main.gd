extends Node

@onready var player = get_node("Player")  # Ajuste o caminho conforme necessário
@onready var music_background = player.get_node("music_background")  # Substitua pelo nome correto do nó

func _ready():
	music_background.play()
