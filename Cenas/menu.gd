extends Control

@onready var button = $Button

func _ready():
	# Conectando o botão ao método correto usando Callable
	button.connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Cenas/main.tscn")
	print("O botão foi pressionado!")
