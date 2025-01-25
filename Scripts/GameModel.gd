extends Node
class_name GameModel

const MAX_ECONOMY : float = 100; 
const MIN_ECONOMY : float = 0; 

const STABLE_ECO_THRESHOLD : float = 80;
const BAD_ECO_THRESHOLD : float = 40;

@export var economyBalance : float = 10;
@export var debt : float = 10;
var effects : Array[EcoEffect];

func debug_init():
	effects.append(EcoEffect.new(0, [10]))
	effects.append(EcoEffect.new(-5, [-5, 20]))
	print("Init")
	print("debt:")
	print(debt);
	print("economyBalance:")
	print(economyBalance);

func getEcoState() -> TypeDefs.EcoState:
	if (economyBalance >= STABLE_ECO_THRESHOLD):
		return TypeDefs.EcoState.STABLE
	elif (economyBalance >= BAD_ECO_THRESHOLD):
		return TypeDefs.EcoState.BAD
	else:
		return TypeDefs.EcoState.POPPED

func getDebt() -> float:
	return debt;

func addEffect(effect : EcoEffect) -> void:
	effects.append(effect);

func endRound() -> void:
	for i in range(effects.size() - 1, -1, -1):
		print("Applying Effect [" + str(i) + "]");
		var effect = effects[i]
		effect.apply(self);
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
