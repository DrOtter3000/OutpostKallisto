extends KinematicBody2D


const GRAVITY = 4
const UP = Vector2(0,1)
var velocity = Vector2.ZERO
export var damage = 10


func _ready():
	pass


func _physics_process(delta):
	apply_gravity()
	velocity = move_and_slide(velocity, UP)


func apply_gravity():
	velocity.y += GRAVITY

func _on_HurtArea_body_entered(body):
	if body.is_in_group("Players"):
		body.hurt(damage)
		$HurtTimer.start()


func _on_HurtArea_body_exited(body):
	if body.is_in_group("Players"):
		$HurtTimer.stop()
		$HurtTimer.wait_time = 1


func _on_HurtTimer_timeout():
	get_tree().call_group("Players", "hurt", damage)
	$HurtTimer.start()
