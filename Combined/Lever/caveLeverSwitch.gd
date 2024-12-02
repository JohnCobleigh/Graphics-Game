extends CollisionShape2D

@onready var leverPull: AnimatedSprite2D = %leverPull

@export var door_path: NodePath
var secretDoor: Node2D
var secretDoorCollision: Node2D

var isSwitched: bool = false

func _ready() -> void:
	var main: Node2D = get_tree().root.get_node("main")
	secretDoor = main.get_node("World").get_node("SecretDoor")
	secretDoorCollision = main.get_node("WorldCollision").get_node("WorldBorder").get_node("SecretDoorCollision")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is HitboxComponent and isSwitched == false:
		isSwitched = true
		leverPull.play("Lever Pull")
		secretDoor.translate(Vector2(0, -1450))
		secretDoorCollision.translate(Vector2(0, -1350))
		#print("ALALALAALAL")
		
		
