extends Sprite2D

@export var player: Player


func _ready() -> void:
	position.x = player.position.x + 200
	position.y = player.position.y + 200
	


func _process(_delta: float) -> void:
	if player.position.y < 900:
		show()
	else:
		hide()
	position.x = (player.position.x + 600) * .95
	position.y = (player.position.y - 100) * .95
	pass
