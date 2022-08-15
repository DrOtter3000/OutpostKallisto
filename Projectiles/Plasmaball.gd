extends Area2D


var speed = 2000


func _ready():
	pass


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_Plasmaball_body_entered(body):
	if body.is_in_group("Foes"):
		body.queue_free()
	elif body.is_in_group("Players"):
		pass
	else:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	$SelfDestructionTimer.start()


func _on_SelfDestructionTimer_timeout():
	queue_free()
