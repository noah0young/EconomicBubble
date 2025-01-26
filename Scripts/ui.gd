extends Control
class_name UI

@export var musicManager : BackgroundMusicManager;
@export var model : GameModel;
const debtValueBBCode : String = "[font_size={70}][center][color=#570004]"
@export var debtValueLabel : RichTextLabel;

const BASE_DEBT_MOVE_SPEED = 10
const DEBT_MOVE_SPEED_ACC = 1
var curDebtMoveSpeed;

var debtCurVal : float;
var targetDebtValue : float;
var usingTargetDebtVal : bool;
signal finishedUpdatingDebtSignal;

const REPLY_BBCODE : String = "[color=black][dropcap color=white outline_color=black outline_size=20]"

@export var economyStatusLabel : RichTextLabel;
const ECONOMY_STATUS_BBCODE : String = "[center][outline_size=10][font_size=50]"
var prevEcoStatus = -1;

const BURSTING_STATUS_TEXT : String = "[color=#ffa408]BURSTING"
const GOOD_STATUS_TEXT : String = "[color=#5ff04f]GOOD"
const STABLE_STATUS_TEXT : String = "[color=#7bed09]STABLE"
const BAD_STATUS_TEXT : String = "[color=#ffa408]BAD"
const POPPING_STATUS_TEXT : String = "[color=#ff0011]POPPING"
const POPPED_STATUS_TEXT : String = "[color=#6b0007]POPPED"

func _ready() -> void:
	debtCurVal = model.getDebt();

func _process(delta : float):
	updateDebt(delta)

func updateDebt(delta : float):
	# pos dir or neg dir based on if debt is increasing or decreasing
	if (usingTargetDebtVal):
		curDebtMoveSpeed += DEBT_MOVE_SPEED_ACC
		var dir = 1;
		if (debtCurVal > targetDebtValue):
			dir = -1;
		debtCurVal += dir * delta * curDebtMoveSpeed;
		if (debtCurVal * dir > targetDebtValue * dir):
			debtCurVal = targetDebtValue
			usingTargetDebtVal = false
			finishedUpdatingDebtSignal.emit()
		_setDebtText(debtCurVal)
	

func _setDebtText(val):
	var isNeg = val < 0
	var absVal = abs(val)
	var startOfDebtText = "$";
	var absValAsStr = "%.2f" % absVal
	debtValueLabel.set_text(debtValueBBCode + startOfDebtText + absValAsStr)

func setDebt(val : float, immediate : bool = false):
	if (immediate):
		_setDebtText(val)
		usingTargetDebtVal = false;
	else:
		if (debtCurVal == val):
			return
		musicManager.playMoneySFX(val < debtCurVal);
		curDebtMoveSpeed = BASE_DEBT_MOVE_SPEED
		targetDebtValue = val
		usingTargetDebtVal = true;
		await finishedUpdatingDebtSignal

func setReplyText(textLabel : RichTextLabel, text : String):
		textLabel.set_text(REPLY_BBCODE + text)

func setEcoBubbleStatus(status : TypeDefs.EcoState):
	if (status == prevEcoStatus):
		return
	prevEcoStatus = status
	var newText : String = "";
	match status:
		TypeDefs.EcoState.BURSTING:
			newText = BURSTING_STATUS_TEXT;
		TypeDefs.EcoState.GOOD:
			newText = GOOD_STATUS_TEXT;
		TypeDefs.EcoState.STABLE:
			newText = STABLE_STATUS_TEXT;
		TypeDefs.EcoState.BAD:
			newText = BAD_STATUS_TEXT;
		TypeDefs.EcoState.POPPING:
			newText = POPPING_STATUS_TEXT;
		TypeDefs.EcoState.POPPED:
			newText = POPPED_STATUS_TEXT;
	economyStatusLabel.set_text(ECONOMY_STATUS_BBCODE + newText)
