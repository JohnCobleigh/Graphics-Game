extends Node2D

@onready var player: Player = %Player
@onready var hearts: Array = []

var previousHealth: float
var hasStarted: bool = false
var increaseMaxHealth: bool = false

func _ready() -> void:
	z_index = 10    

func _process(delta: float) -> void:
	if player != null and hasStarted == false:
		hasStarted = true
		enter()
	
	if player == null:
		return
		
	if previousHealth != player.healthComponent.health:
		updateHealthAmount(player.healthComponent.health)
		
	if player.healthComponent.maxHealth == 200 and increaseMaxHealth == false:
		showLaterChildren()
		
func updateHealthAmount(health: float) -> void:
	for i in range(hearts.size()):
		var heart_health = health - i * 10 
		if heart_health >= 10:
			hearts[i].get_node("HeartUi1").show()
			hearts[i].get_node("HeartUi2").hide()
			hearts[i].get_node("HeartUi3").hide()
		elif heart_health >= 5:
			hearts[i].get_node("HeartUi1").hide()
			hearts[i].get_node("HeartUi2").show()
			hearts[i].get_node("HeartUi3").hide()
		else:
			hearts[i].get_node("HeartUi1").hide()
			hearts[i].get_node("HeartUi2").hide()
			hearts[i].get_node("HeartUi3").show()
	
	previousHealth = player.healthComponent.health


func showLaterChildren() -> void:
	for i in range(10, hearts.size()):
		hearts[i].show()


func enter() -> void:
	previousHealth = player.healthComponent.health
	for i in range(1, 21):
		hearts.append(get_node("Heart" + str(i)))
