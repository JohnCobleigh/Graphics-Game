extends Area2D

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var hitboxComponent: HitboxComponent = $HitboxComponent

@export var isEvil: bool = true

var velocity: Vector2 = Vector2.ZERO
var speed = 300
var canHit: bool = true
var lifetime: float = 2.0

func _ready() -> void:
	animatedSprite.play("Lightning Bolt")
		


func _process(delta: float) -> void:
	lifetime = lifetime - delta
	
	if lifetime < 1.3 and isEvil == true:
		set_collision_layer_value(8,true)
		hitboxComponent.set_collision_layer_value(8,true)
		hitboxComponent.set_collision_mask_value(8,true)

	if lifetime < 0:
		queue_free()

func _on_hitbox_component_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() is Player:
		var hitbox: HitboxComponent = area
		hitbox.damage(30)
	
	if area.get_parent().get_parent() is Enemy and hitboxComponent.get_collision_layer_value(9):
		canHit = false
		var hitbox: HitboxComponent = area
		hitbox.damage(50)
