extends Node
class_name GameModel

var roundNum = 0

@export var musicManager : BackgroundMusicManager;
const DAY_TRANS_VOL = -10

@export var animManager : AnimManager;
@export var newsContButton : Button;

const MAX_ECONOMY : float = 1000; 
const MIN_ECONOMY : float = 0; 

const BURSTING_ECO_THRESHOLD : float = 800;
const GOOD_ECO_THRESHOLD : float = 600;
const STABLE_ECO_THRESHOLD : float = 400;
const BAD_ECO_THRESHOLD : float = 200;

@onready var database: DataBase = DataBase.new(self)

var currentPrompt: EcoPrompt

@export var replyHolder : HBoxContainer;
var replyButtonPrefab = preload("res://Scenes/reply_prefab.tscn")
var curReplies : Array[Button] = [];

@export var economyBalance : float = 500;
@export var debt : float = 100;
@export var promptTextBox : RichTextLabel;
var effects : Array[AbstractEcoEffect];

func nextRound():
	musicManager.setTargetVolFade(economyBalance < 50, DAY_TRANS_VOL);
	roundNum += 1;
	# Show Day Count Here in screen animation
	await animManager.playDayStartAnim(roundNum)
	musicManager.startMusic(economyBalance < 50);
	# Show News in screen animation
	await allNews();
	getPrompt()
	currentPrompt.genPrompt()
	changeTextRich()

func allNews():
	var news : Array[String] = ["Hello", "Good"]#getRoundNotes():
	for i in range(0, news.size()):
		var note = news[i];
		if (i == 0):
			await animManager.showNews("Today's News", note);
		else:
			await animManager.contShowNews("Today's News", note);
		await newsContButton.pressed
		if (i == news.size() - 1):
			await animManager.hideNews()
		else:
			await animManager.contHideNews();

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

func changeTextRich():
	promptTextBox.set_text(currentPrompt.text)

func addEffect(effect : AbstractEcoEffect) -> void:
	effects.append(effect);

func getRoundNotes() -> Array[String]:
	var noteArray : Array[String] = []
	for effect in effects:
		noteArray.append(effect.getNote())
	return noteArray;

func endRound() -> void:
	clearReplies();
	for i in range(effects.size() - 1, -1, -1):
		print("Applying Effect [" + str(i) + "]");
		var effect = effects[i]
		print("effect:")
		print(effect)
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
	nextRound()

func addToDebt(val : float) -> void:
	debt += val;

func addToEconomy(val : float) -> void:
	economyBalance += val;

func isGameOver() -> bool:
	return debt <= 0 or economyBalance

func addReply(reply : Reply):
	var newReply : Button = replyButtonPrefab.instantiate()
	newReply.text = reply.text;
	curReplies.append(newReply);
	newReply.pressed.connect(
		func ():
		print("Press")
		addEffect(reply.getEffect())
		endRound()
		)
	replyHolder.add_child(newReply);

func clearReplies():
	for reply in curReplies:
		reply.queue_free()
	curReplies = []

func getPrompt():
	currentPrompt = database.getRandom()
