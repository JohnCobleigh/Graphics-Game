extends Node
class_name Main





func _ready():
	Globals.main = self
	




func _process(_delta):
	pass



func _input(event: InputEvent):
	#if event.is_action_pressed("switch"):
		#if Globals.isSelf == true:
			#Globals.isSelf = false
			#Globals.emeny1.player = true
		#else:
			#Globals.isSelf = true
			#Globals.enemy1.player = false
	pass
