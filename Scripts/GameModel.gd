extends Node
class_name GameModel

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

func getEcoBalance() -> float:
	return economyBalance;

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
			effects.remove_at(i)
	print("Round End")
	print("debt:")
	print(debt);
	print("economyBalance:")
	print(economyBalance);

func addToDebt(val : float) -> void:
	debt += val;
	
func addToEconomy(val : float) -> void:
	economyBalance += val;
