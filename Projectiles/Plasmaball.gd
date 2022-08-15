extends Area2D


var speed = 1500


func _ready():
	pass


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_Plasmaball_body_entered(body):
	if body.is_in_group("foes"):
		body.queue_free()
	queue_free()
