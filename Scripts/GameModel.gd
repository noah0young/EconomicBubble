extends Node
class_name GameModel

var roundNum = 0

@export var uiManager : UI;
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
const REPLY_TOOLTIP_CHARS : int = 50

@export var economyBalance : float = 500;
const DEBT_START_AMOUNT = 1000000;
@export var debt : float = 0;
@export var promptTextBox : RichTextLabel;
const PROMPT_TEXT_BBCODE : String = "[font_size={50}][center]"
const TIME_BETWEEN_CHAR : float = 0.05
var effects : Array[AbstractEcoEffect];

func _ready():
	uiManager.setDebt(getDebt(), true);
	effects.append(EcoEffect.new(DEBT_START_AMOUNT, [0], ["Congratulations on your new job... but you're college degree has put you in debt... a lot of debt"]))
	effects.append(EcoEffect.new(0, [0], ["But at least your job puts you in charge of the Economic (bubble)"]))
	effects.append(EcoEffect.new(0, [0], ["... Would anyone notice if some money were to disappear ...?"]))
	await endRound(true)

func incrementEffectRound():
	for i in range(effects.size() - 1, -1, -1):
		print("incrementEffectRound" + str(i))
		var effect = effects[i]
		effect.nextTurn();
		if (effect.isDone()):
			effects.remove_at(i) # do you need to free a resource?

func isGoingPoorly() -> bool:
	return economyBalance < BAD_ECO_THRESHOLD or economyBalance > BURSTING_ECO_THRESHOLD

func allNews():
	var news : Array[String] = getRoundNotes()
	for i in range(0, news.size()):
		var note = news[i];
		if (i == 0):
			await animManager.showNews("Today's News", note);
		else:
			await animManager.contShowNews("Today's News", note);
		musicManager.playMoneySFX(effects[i].isPositive());
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

func showPrompt():
	await animManager.playShowUIPrompt()
	var toDisplay : String = currentPrompt.text;
	# Talk through prompt
	for i in range(0, toDisplay.length()):
		musicManager.playTalkSound("CheeseMan")
		promptTextBox.set_text(PROMPT_TEXT_BBCODE + toDisplay.substr(0, i))
		await get_tree().create_timer(TIME_BETWEEN_CHAR).timeout
	currentPrompt.genPrompt()
	await animManager.playShowUIReplies()

func clearPromptText():
	promptTextBox.set_text("")

func addEffect(effect : AbstractEcoEffect) -> void:
	effects.append(effect);

func getRoundNotes() -> Array[String]:
	var noteArray : Array[String] = []
	for effect in effects:
		var note = effect.getNote()
		if (note != ""):
			noteArray.append(note)
	return noteArray;

func endRound(initialTime : bool = false) -> void:
	if (not initialTime):
		await animManager.playHideUIPrompt()
		clearPromptText();
		clearReplies();
	await uiManager.setDebt(getDebt());
	for i in range(effects.size() - 1, -1, -1):
		var effect = effects[i]
		effect.apply(self);
	economyBalance = max(min(economyBalance, MAX_ECONOMY), MIN_ECONOMY)
	nextRound()

func nextRound():
	musicManager.setTargetVolFade(isGoingPoorly(), DAY_TRANS_VOL);
	roundNum += 1;
	# Show Day Count Here in screen animation
	await animManager.playDayStartAnim(roundNum)
	musicManager.startMusic(isGoingPoorly());
	# Show News in screen animation
	await allNews();
	
	# this line is just for the first round, when you see your initial debt appear
	await uiManager.setDebt(getDebt(), false);
	
	incrementEffectRound()
	if (!isGameOver()):
		# continue game
		getPrompt()
		showPrompt()
	else:
		# finish game
		showGameOver()

func addToDebt(val : float) -> void:
	debt += val;

func addToEconomy(val : float) -> void:
	economyBalance += val;

func isGameOver() -> bool:
	return debt <= 0 or economyBalance <= MIN_ECONOMY or economyBalance >= MAX_ECONOMY

func showGameOver() -> void:
	# Updates music
	musicManager.startMusic(isGoingPoorly());
	TypeDefs.playSFX(TypeDefs.bubblePopSFX, self)
	if (debt <= 0):
		animManager.playWinAnim();
	else:
		animManager.playLoseAnim();

func addReply(reply : Reply):
	var newReply : Button = replyButtonPrefab.instantiate()
	#uiManager.setReplyText(newReply.get_node("RichTextLabel"), reply.text);
	newReply.tooltip_text = TypeDefs.limitLinesTo(REPLY_TOOLTIP_CHARS, reply.text)
	curReplies.append(newReply);
	newReply.pressed.connect(
		func ():
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
