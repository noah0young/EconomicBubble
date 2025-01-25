extends Node
class_name GameModel

const MAX_ECONOMY : float = 100; 
const MIN_ECONOMY : float = 0; 

const BURSTING_ECO_THRESHOLD : float = 80;
const GOOD_ECO_THRESHOLD : float = 60;
const STABLE_ECO_THRESHOLD : float = 40;
const BAD_ECO_THRESHOLD : float = 20;

@export var economyBalance : float = 10;
@export var debt : float = 10;
var effects : Array[EcoEffect];

func getEcoState() -> TypeDefs.EcoState:
	if (economyBalance >= MAX_ECONOMY):
		return TypeDefs.EcoState.POPPED
	elif (economyBalance >= BURSTING_ECO_THRESHOLD):
		return TypeDefs.EcoState.BURSTING
	elif (economyBalance >= GOOD_ECO_THRESHOLD):
		return TypeDefs.EcoState.GOOD
	elif (economyBalance >= STABLE_ECO_THRESHOLD):
		return TypeDefs.EcoState.STABLE
	elif (economyBalance >= BAD_ECO_THRESHOLD):
		return TypeDefs.EcoState.BAD
	elif (economyBalance >= MIN_ECONOMY):
		return TypeDefs.EcoState.POPPING
	else:
		return TypeDefs.EcoState.POPPED

func getDebt() -> float:
	return debt;

func getEconomy() -> float:
	return economyBalance;

func getEcoMIN() -> float:
	return MIN_ECONOMY;

func getEcoMAX() -> float:
	return MAX_ECONOMY;

func getEcoBAD() -> float:
	return BAD_ECO_THRESHOLD;

func getEcoSTABLE() -> float:
	return STABLE_ECO_THRESHOLD;

func getEcoGOOD() -> float:
	return GOOD_ECO_THRESHOLD;

func getEcoBURST() -> float:
	return BURSTING_ECO_THRESHOLD;



func addEffect(effect : EcoEffect) -> void:
	effects.append(effect);

func getRoundNotes() -> Array[String]:
	var noteArray : Array[String] = []
	for effect in effects:
		noteArray.append(effect.getNote())
	return noteArray;

func endRound() -> void:
	for i in range(effects.size() - 1, -1, -1):
		print("Applying Effect [" + str(i) + "]");
		var effect = effects[i]
		effect.apply(self);
		effect.nextTurn();
		if (effect.isDone()):
			effects.remove_at(i) # do you need to free a resource?
	economyBalance = max(min(economyBalance, MAX_ECONOMY), MIN_ECONOMY)
	print("Round End")
	print("debt:")
	print(debt);
	print("economyBalance:")
	print(economyBalance);

func addToDebt(val : float) -> void:
	debt += val;

func addToEconomy(val : float) -> void:
	economyBalance += val;

func isGameOver() -> bool:
	return debt <= 0 or economyBalance
