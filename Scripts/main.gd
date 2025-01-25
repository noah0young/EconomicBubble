extends Node2D

var gameModel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameModel = GameModel.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_debug_button_button_down() -> void:
	gameModel.debugMakeReply();
