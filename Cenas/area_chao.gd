extends Area2D


func _on_body_entered(body):
	if body is Player:  # Verifica se o corpo que entrou é o Mario
		body.die()  # Chama a função de morte do Mario
		#get_tree().reload_current_scene()  # Reinicia a cena atual
