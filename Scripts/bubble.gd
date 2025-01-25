extends Node2D

@export var gameModel : GameModel
var curEco
var curScale
var bubState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curEco = gameModel.getEconomy()
	curScale = curEco / gameModel.getEcoMAX()
	scale.x = curScale
	scale.y = curScale
	bubState =  gameModel. getEcoState()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curEco = gameModel.getEconomy()
	if curScale < (curEco / gameModel.getEcoMAX()):
		curScale += .05
	if curScale > (curEco / gameModel.getEcoMAX()):
		curScale -= .05
	scale.x = curScale + .2
	scale.y = curScale + .2
	bubState =  gameModel.getEcoState()
