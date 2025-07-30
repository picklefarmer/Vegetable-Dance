extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 14.5

@export var typed_key_value: Dictionary[int, String] = { 1: "first value", 2: "second value", 3: "etc" }

var knifeCollider
var throwingApple = preload("res://slice.tscn")

func dealBoss():
	pass
func _ready() -> void:
	knifeCollider = $Empty/Armature/Skeleton3D/Cube/KnifeBlade3d
	#Action.boss.connect(dealBoss) 
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_just_pressed("rotateL"):
		
		transform = transform.rotated(Vector3.UP,-25)
	
	if Input.is_action_just_pressed("rotateR"):
		transform = transform.rotated(Vector3.UP,25)
		
	move_and_slide()


func _on_potato_body_entered(body: Node) -> void:
	print(body)
	if body == knifeCollider :
		print("it works")
		throw()



func throw():
	var thrown = throwingApple.instantiate()
	var start = position
	var forward : Vector3 = -global_transform.basis.x
	start.y = position.y + 3
	thrown.position = start
	
	Action.boss.emit(self)
	
	get_tree().root.add_child(thrown)
	
	#print(forward*50, "thrown")
	thrown.apply_impulse(forward * 20.0)


func _on_broccoli_body_entered(body: Node) -> void:
	#print(body)
	if body == knifeCollider :
		print("it works")
		throw()


func _on_onion_body_entered(body: Node) -> void:
	if body == knifeCollider :
		print("it works")
		throw()


func _on_tomato_body_entered(body: Node) -> void:
	if body == knifeCollider :
		print("it works")
		throw()
	


func _on_cabbage_body_entered(body: Node) -> void:
	if body == knifeCollider :
		print("it works")
		throw()
