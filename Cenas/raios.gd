extends AnimatedSprite2D

@export var visible_duration = 2.0  # Tempo que o sprite fica visível (em segundos)
@export var invisible_duration = 3.0  # Tempo que o sprite fica invisível (em segundos)

func _ready():
	# Começa o ciclo de visibilidade assim que o nó entra na cena
	start_visibility_cycle()

func start_visibility_cycle() -> void:
	while true:
		# Mostra o sprite e toca a animação
		visible = true
		play()  # Se houver animação
		await get_tree().create_timer(visible_duration).timeout
		
		# Esconde o sprite e para a animação
		visible = false
		stop()  # Se houver animação
		await get_tree().create_timer(invisible_duration).timeout

