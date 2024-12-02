extends Sprite2D


@export var player: Player


func _ready() -> void:
	position.x = player.position.x + 6000
	position.y = player.position.y + 20000


func _process(_delta: float) -> void:
	if player.position.y < 900:
		hide()
	else:
		show()
	position.x = (player.position.x + 400) * .93
	position.y = (player.position.y + 300) * .93
	
