extends Block

class_name Brick 

func _ready():
	set_collision_layer_value(5, true)  # Por exemplo, Brick na camada 3
	set_collision_mask_value(4, true)   # Detecta a camada 2 (onde o Koopa pode estar)


func bump(player_mode: Player.PlayerMode):
	if player_mode == Player.PlayerMode.small:
		super.bump(player_mode)








