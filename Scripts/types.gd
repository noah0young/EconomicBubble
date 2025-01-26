extends Node
class_name TypeDefs
enum EcoState {BURSTING, GOOD, STABLE, BAD, POPPING, POPPED}
enum EffectType{GAMBLE, ECOEFFECT}

static func strOfEffectType(val : TypeDefs.EffectType) -> String:
	match val:
		TypeDefs.EffectType.GAMBLE:
			print("Got Gamble")
			return "GAMBLE";
		TypeDefs.EffectType.ECOEFFECT:
			print("Got eco effect")
			return "ECOEFFECT";
	return "NULL"
