extends Area2D


@onready var wispProjectileAnimation: AnimatedSprite2D = $wispProjectileAnimation

var velocity: Vector2 = Vector2.ZERO
var speed = 300 # Adjust this speed as needed
var canHit: bool = true
#var spawnPosition: Vector2


func _ready() -> void:
	pass
		


func _physics_process(delta: float) -> void:
	position += velocity * speed * delta
	



func _on_hitbox_component_area_entered(area: Area2D) -> void:
	
	#print("QQQQ")  
	if area.get_parent().get_parent() is Enemy and canHit:
		canHit = false
		var hitbox: HitboxComponent = area
		hitbox.damage(10)
		queue_free()
