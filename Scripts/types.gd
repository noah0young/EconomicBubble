extends Node
class_name TypeDefs
enum EcoState {BURSTING, GOOD, STABLE, BAD, POPPING, POPPED}
enum EffectType{GAMBLE, ECOEFFECT}

static var rng = RandomNumberGenerator.new()

static func strOfEffectType(val : TypeDefs.EffectType) -> String:
	match val:
		TypeDefs.EffectType.GAMBLE:
			return "GAMBLE";
		TypeDefs.EffectType.ECOEFFECT:
			return "ECOEFFECT";
	return "NULL"

static var possibleClickDownSFX : Array[AudioStream] = [
	preload("res://SFX/Button Click 1.wav"),
	preload("res://SFX/Button Click 2.wav")
]

static var possibleClickUpSFX : Array[AudioStream] = [
	preload("res://SFX/Button Click 3.wav"),
	preload("res://SFX/Button Click 4.wav"),
	preload("res://SFX/Button Click 5.wav")
]

static var possibleCheeseManSFX : Array[AudioStream] = [
	preload("res://SFX/Cheese Man 1.wav"),
	preload("res://SFX/Cheese Man 2.wav"),
	preload("res://SFX/Cheese Man 3.wav")
]

static var bubblePopSFX = preload("res://SFX/Bubble Pop.wav")
static var moneyUpSFX = preload("res://SFX/Money Up.wav")
static var moneyDownSFX = preload("res://SFX/Money Down.wav")

static func getRandClickDownSFX() -> AudioStream:
	var randSelected : int = rng.randi_range(0, possibleClickDownSFX.size() - 1);
	return possibleClickDownSFX[randSelected]

static func getRandClickUpSFX() -> AudioStream:
	var randSelected : int = rng.randi_range(0, possibleClickUpSFX.size() - 1);
	return possibleClickUpSFX[randSelected]

static func getRandCheeseManSFX() -> AudioStream:
	var randSelected : int = rng.randi_range(0, possibleCheeseManSFX.size() - 1);
	return possibleCheeseManSFX[randSelected]

static func playSFX(sfx : AudioStream, referenceObj : Node):
	var player : AudioStreamPlayer2D = AudioStreamPlayer2D.new();
	referenceObj.get_tree().get_root().add_child(player)
	player.stream = sfx;
	player.play();
	await player.finished
	player.queue_free()

static func limitLinesTo(charLimit : int, text : String):
	var res = ""
	while (text.length() > 0):
		var taken : int = min(charLimit, text.length());
		res += text.substr(0, taken) + "\n"
		text = text.substr(taken)
	return res
