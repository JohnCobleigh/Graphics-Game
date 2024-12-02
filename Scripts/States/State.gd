extends Node
class_name State

#@warning_ignore("unused_signal")
#signal Transitioned

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func processInput(_event: InputEvent) -> State:
	return null
	
func _process(_delta: float) -> void:
	return
	
func _physics_process(_delta: float) -> void:
	return
