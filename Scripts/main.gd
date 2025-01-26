extends Node2D

@export var gameModel : GameModel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameModel.nextRound();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
