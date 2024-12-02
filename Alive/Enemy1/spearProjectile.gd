extends Area2D

@onready var hitboxComponent: HitboxComponent = %HitboxComponent

# Define a velocity property to control movement direction and speed
var velocity: Vector2 = Vector2.ZERO
var speed = 300
var canHit: bool = true

var spawnPosition: Vector2

func _ready() -> void:
	#global_position = spawnPosition
	pass

func _physics_process(delta):
	position += velocity * speed * delta




func _on_hitbox_component_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() is Player:
		var hitbox: HitboxComponent = area
		hitbox.damage(25)
		queue_free()
	
	if  area.get_parent().get_parent() is Enemy and hitboxComponent.get_collision_layer_value(9):
		canHit = false
		var hitbox: HitboxComponent = area
		hitbox.damage(34)
		queue_free()
		
	
