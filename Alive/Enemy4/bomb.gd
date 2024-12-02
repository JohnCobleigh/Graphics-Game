extends Area2D

@onready var hitboxComponent: HitboxComponent = $HitboxComponent
@onready var bomb1: Sprite2D = %Bomb1
@onready var explosion1: Sprite2D = %Explosion1

@export var lifetime: float = 1.0

var velocity: Vector2 = Vector2.ZERO
var canHit: bool = true
var speed: float = 200
var hasExpanded: bool = false

func _process(delta: float) -> void:
	position += velocity * speed * delta
	lifetime =lifetime - delta
	
	if lifetime < 0 and hasExpanded == false:
		hasExpanded = true
		bomb1.hide()
		explosion1.show()
		hitboxComponent.collisionShape.scale = hitboxComponent.collisionShape.scale * 6
		
	if lifetime < -.18:
		queue_free()
		
	if canHit == false and hasExpanded == false:
		hasExpanded = true
		speed = 0
		bomb1.hide()
		explosion1.show()
		hitboxComponent.collisionShape.scale = hitboxComponent.collisionShape.scale * 6
		hitboxComponent.set_collision_layer_value(8, false)
		hitboxComponent.set_collision_mask_value(8, false)
		lifetime = 0
		
func _on_hitbox_component_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() is Player:
		canHit = false
		var hitbox: HitboxComponent = area
		hitbox.damage(40)
	
	if  area.get_parent().get_parent() is Enemy and hitboxComponent.get_collision_layer_value(9):
		canHit = false
		var hitbox: HitboxComponent = area
		hitbox.damage(50)
