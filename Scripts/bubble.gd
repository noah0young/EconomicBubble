extends Node2D

var gameModel
var curEco
var curScale
var bubState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curEco = gameModel.getEconomy()
	curScale = curEco / 100
	scale.x = curScale
	scale.y = curScale
	bubState = TypeDefs.EcoState.STABLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curEco = gameModel.getEconomy()
	if curScale < (curEco / 100):
		curScale += .01
	if curScale > (curEco / 100):
		curScale -= .01
	scale.x = curScale
	scale.y = curScale
	if curEco <= gameModel.getEcoMIN():
		bubState = TypeDefs.EcoState.POPPED
	elif curEco <= gameModel.getEcoBAD():
		bubState = TypeDefs.EcoState.BAD
	elif curEco <= gameModel.getEcoSTABLE():
		bubState = TypeDefs.EcoState.STABLE
	elif curEco <= gameModel.getEcoGOOD():
		bubState = TypeDefs.EcoState.GOOD
	elif curEco <= gameModel.getEcoBURST():
		bubState = TypeDefs.EcoState.BOOMING
	elif curEco >= gameModel.getEcoMAX():
		bubState = TypeDefs.EcoState.POPPED
