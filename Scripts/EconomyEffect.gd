extends Resource
class_name EcoEffect

## What is added/removed from your debt
@export var addToDebt = 0;

## What is added/removed from the economy on each turn
## Where the 0th entry is applied immediately
## And the 1st is applied at the end of the next turn
## (Warning: addToEconomyByRound[0] and addToEconomy should not
## both be assigned to a non-zero value)
@export var addToEconomyByRound : Array[float] = [];

@export var noteForEachRound : Array[String] = [];

## How many turns have passed since this has been first applied
var turnsPassed = 0;

func _init(addToDebt : int, addToEconomyByRound : Array[float], 
		   noteForEachRound : Array[String] = []) -> void:
	self.addToDebt = addToDebt;
	self.addToEconomyByRound = addToEconomyByRound;
	self.noteForEachRound = noteForEachRound;

func apply(model : GameModel) -> void:
	if (turnsPassed == 0):
		model.addToDebt(addToDebt);
	model.addToEconomy(addToEconomyByRound[turnsPassed]);

## Gets the note for this round from this effect
## Returns an empty string if there is no note
func getNote() -> String:
	if (turnsPassed < noteForEachRound.size()):
		return noteForEachRound[turnsPassed];
	return "";

func nextTurn() -> void:
	turnsPassed += 1;

func isDone() -> bool:
	return turnsPassed >= addToEconomyByRound.size();
