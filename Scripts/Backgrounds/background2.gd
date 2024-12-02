extends Sprite2D

@export var player: Player


func _ready() -> void:
	position.x = player.position.x + 350
	position.y = player.position.y + 30
	


func _process(_delta: float) -> void:
	if player.position.y < 900:
		show()
	else:
		hide()
	position.x = (player.position.x + 350) * .93
	position.y = (player.position.y + 100) * .93
	pass
