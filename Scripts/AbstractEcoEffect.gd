extends Resource
class_name AbstractEcoEffect

## How many turns have passed since this has been first applied
var turnsPassed = 0;

func _init(addToDebt : int, addToEconomyByRound : Array[float], 
		   noteForEachRound : Array[String] = []) -> void:
	self.addToDebt = addToDebt;
	self.addToEconomyByRound = addToEconomyByRound;
	self.noteForEachRound = noteForEachRound;

func apply(model : GameModel) -> void:
	pass

## Gets the note for this round from this effect
## Returns an empty string if there is no note
func getNote() -> String:
	return "";

func nextTurn() -> void:
	turnsPassed += 1;

func isDone() -> bool:
	return true
