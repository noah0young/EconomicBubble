extends AbstractEcoEffect
class_name GamblingEcoEffect

var won : bool;

## Odds between [0, 1] inclusive
@export var oddsOfWinning : float = 0.1;

# [Win]

## What is added/removed from your debt if you win
@export var addToDebtWin = 0;

## What is added/removed from your debt if you win
@export var addToEconomyWin = 0;

## Note if you win
@export var winNote : String;

# [Lose]

## What is added/removed from your debt if you lose
@export var addToDebtLose = 0;

## What is added/removed from your debt if you lose
@export var addToEconomyLose = 0;

## Note if you lose
@export var loseNote : String;

func _init(oddsOfWinning : float, addToDebtLose : int, addToEconomyLose : int, loseNote : String, addToDebtWin : int, addToEconomyWin : int, winNote : String) -> void:
	self.addToDebtLose = addToDebtLose;
	self.addToEconomyLose = addToEconomyLose;
	self.loseNote = loseNote;
	
	self.addToDebtWin = addToDebtWin;
	self.addToEconomyWin = addToEconomyWin;
	self.winNote = winNote;
	
	var rng = RandomNumberGenerator.new()
	won = rng.randf() < oddsOfWinning;

func apply(model : GameModel) -> void:
	if (won):
		model.addToDebt(addToDebtWin);
		model.addToEconomy(addToEconomyWin);
	else:
		model.addToDebt(addToDebtLose);
		model.addToEconomy(addToEconomyLose);

## Gets the note for this round from this effect
## Returns an empty string if there is no note
func getNote() -> String:
	if (won):
		return winNote
	else:
		return loseNote;

func isDone() -> bool:
	return true

func isPositive() -> bool:
	return won;
