extends Node
class_name Main

@onready var Projectiles: Node = %Projectiles


func _ready():
	Globals.main = self
	
	
func get_projectiles_node() -> Node:
	return Projectiles
	
