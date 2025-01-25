extends Node2D

@export var gameModel : GameModel
var curEco
var curScale
var bubState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curEco = gameModel.getEconomy()
	curScale = curEco / 100
	scale.x = curScale
	scale.y = curScale
	bubState =  gameModel. getEcoState()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curEco = gameModel.getEconomy()
	if curScale < (curEco / 100):
		curScale += .01
	if curScale > (curEco / 100):
		curScale -= .01
	scale.x = curScale
	scale.y = curScale
	bubState =  gameModel. getEcoState()
