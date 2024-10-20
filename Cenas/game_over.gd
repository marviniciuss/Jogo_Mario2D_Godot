extends Control

@export var scene_to_restart: String
# Called when the node enters the scene tree for the first time.
func _ready():
	var button = $Button
	button.connect("pressed", Callable(self, "_on_button_pressed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	print("Reiniciando a cena...")
	get_tree().change_scene_to_file(scene_to_restart)


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Cenas/menu.tscn")
