extends Sprite2D


@export var player: Player


func _ready() -> void:
	position.x = player.position.x
	position.y = player.position.y



func _process(_delta: float) -> void:
	if player.position.y < 900:
		hide()
	else:
		show()
	position.x = (player.position.x + 350) * .98
	position.y = (player.position.y + 200) * .98
