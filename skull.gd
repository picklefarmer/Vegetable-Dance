extends RigidBody3D
var isDancing = true
var isFacing = false
@export var amount = 15
@export var hop = 0


func _on_timer_timeout() -> void:
	if isDancing:
		if isFacing:
			linear_velocity += Vector3(amount,hop,0)
			isFacing = false
		else:
			linear_velocity += Vector3(-amount,hop,0)
			isFacing = true
	
