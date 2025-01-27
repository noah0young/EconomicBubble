extends AnimationPlayer

@export var animName : String;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play(animName)
