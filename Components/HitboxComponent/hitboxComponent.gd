extends Area2D
class_name HitboxComponent


@export var healthComponent: HealthComponent
@export var collisionShape: CollisionShape2D
#@export var master: CharacterBody2D


func damage(damage):
	if healthComponent:
		healthComponent.takeDamage(damage)

#func followOwner():
	#master
