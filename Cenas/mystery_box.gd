extends Block

class_name MysteryBox

enum BonusType{
	COIN,
	SHROOM,
	FLOWER
}

const COIN_SCENE = preload("res://Cenas/coin.tscn")
const SHROOM_SCENE = preload("res://Cenas/shroom.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var bonus_Type: BonusType = BonusType.COIN
@export var invisible: bool = false
const SHOOTING_FLOWER = preload("res://Cenas/shooting_flower.tscn")

var is_empty = false
func _ready():
	animated_sprite_2d.visible = !invisible

func bump(player_mode: Player.PlayerMode):
	if is_empty:
		return
		
	if invisible:
		animated_sprite_2d.visible = true
		invisible = !invisible
		
	super.bump(player_mode)
	make_empty()
	
	match bonus_Type:
		BonusType.COIN:
			spawn_coin()
		BonusType.SHROOM:
			spawn_shroom()
		BonusType.FLOWER:
			spawn_flower()
			

func make_empty():
	is_empty = true
	animated_sprite_2d.play("empty")
	
func spawn_shroom():
	var shroom = SHROOM_SCENE.instantiate()
	shroom.global_position = global_position
	get_tree().root.add_child(shroom)

func spawn_coin():
	var coin = COIN_SCENE.instantiate()
	coin.global_position = global_position+Vector2(0, -16)
	get_tree().root.add_child(coin)
	var level_manager = get_tree().get_first_node_in_group("level_manager")
	if level_manager:
		level_manager.on_coin_collected()
	else:
		print("Level manager não encontrado. Ignorando coleta de moedas.")
	

func spawn_flower():
	var flower = SHOOTING_FLOWER.instantiate()
	flower.global_position = global_position
	get_tree().root.add_child(flower)
			
			

		
		





