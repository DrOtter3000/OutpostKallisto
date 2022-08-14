extends CanvasLayer


func _ready():
	pass


func update_jetpack(act, maximum):
	$Control/GridContainer/JetpackBar.value = act
	$Control/GridContainer/JetpackBar.max_value = maximum 


func update_oxygen(act, maximum):
	$Control/GridContainer/OxygenBar.value = act
	$Control/GridContainer/OxygenBar.max_value = maximum


func update_health(act, maximum):
	$Control/GridContainer/HealthBar.value = act
	$Control/GridContainer/HealthBar.max_value = maximum
