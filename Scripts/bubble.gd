extends Node2D

@export var ui : UI;
@export var gameModel : GameModel
var curEco : float;
var curScale : float;
var bubState
const SPEED = 0.05

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
	var newScale = (curEco / gameModel.getEcoMAX())
	if curScale < newScale:
		curScale += SPEED * delta
	if curScale > newScale:
		curScale -= SPEED * delta
	scale.x = curScale + .2
	scale.y = curScale + .2
	scale *= 5; # DEBUG
	print(scale)
	bubState =  gameModel.getEcoState()
	ui.setEcoBubbleStatus(bubState)
