class_name Vegetable
extends RigidBody3D

var isFacing = false
var isDancing = true
@export var amount = 10	
@export var hop = 10
@export var type = "tomato"


@onready var audio_stream_player : AudioStreamPlayer = $"../AudioStreamPlayer"

var record_bus_index : int
#var record_effect: AudioEffectRecord
var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance
@export var MIN_DB: int = 68
@export var minimum = 0.25
@export var multiplier : float = 4
@export var deltav : float = 1.0
func _ready() -> void:
	
	#print(AudioServer.get_input_device_list())
	record_bus_index = AudioServer.get_bus_index("recording")
	#record_effect = AudioServer.get_bus_effect(record_bus_index,0)
	spectrum_analyzer = AudioServer.get_bus_effect_instance(record_bus_index,0)
	#record_effect.set_recording_active(true)
	

func _process(delta: float) -> void:
	

	if spectrum_analyzer:
		var volume_mag = spectrum_analyzer.get_magnitude_for_frequency_range(350.0,3000.0,AudioEffectSpectrumAnalyzerInstance.MAGNITUDE_AVERAGE).length()
		volume_mag = clamp((MIN_DB + linear_to_db(volume_mag))/MIN_DB,0,1)
		#print(volume_mag, "volume")
		#print( volume_mag)
		if volume_mag > minimum:
			#print(volume_mag,"Volume")
			#position.x = volume_mag * multiplier
		
			#rotation.z = -volume_mag * multiplier
			linear_velocity.y = volume_mag * multiplier
			#print(position.x , "position")
		else:
			#position.x = 0
			#rotation.z = 0
			linear_velocity = Vector3.ZERO
			position.y = 1 


func _on_body_entered(body: Node) -> void:
	
	if body is Blade:
		isDancing = false
		if scale.y > .25:
			scale -= Vector3.ONE/6
			var Knife = $"../knife"
			var knifeLoc = Knife.position
			
			Action.pushSlice.emit(type)
	
			look_at(knifeLoc,Vector3.UP)
			rotate(Vector3.UP,PI)
		
			linear_velocity += Vector3.FORWARD*10
			
		else:
			queue_free()
		

func _on_timer_timeout() -> void:
	if isDancing:
		if isFacing:
			linear_velocity += Vector3(amount,hop,0)
			isFacing = false
		else:
			linear_velocity += Vector3(-amount,hop,0)
			isFacing = true
	
