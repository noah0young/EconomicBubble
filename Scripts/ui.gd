extends Control
class_name UI

@export var musicManager : BackgroundMusicManager;
@export var model : GameModel;
const debtValueBBCode : String = "[font_size={70}][center][color=#570004]"
@export var debtValueLabel : RichTextLabel;

const MAX_TIME_TO_MOVE_DEBT = 10; # Max seconds to move debt
const BASE_DEBT_MOVE_SPEED = 10
const DEBT_MOVE_SPEED_ACC = 1
var curDebtMoveSpeed;

var debtCurVal : float;
var targetDebtValue : float;
var usingTargetDebtVal : bool;
signal finishedUpdatingDebtSignal;

const REPLY_BBCODE : String = "[color=black][dropcap color=white outline_color=black outline_size=20]"

@export var economyStatusLabel : RichTextLabel;
const ECONOMY_STATUS_BBCODE : String = "[center][outline_size=10][font_size=100]"
var prevEcoStatus = -1;

const BURSTING_STATUS_TEXT : String = "[color=#9c131a][pulse color=#eb1722]BURSTING"
const GOOD_STATUS_TEXT : String = "[color=#31a329][pulse color=#14ed05]GOOD"
const STABLE_STATUS_TEXT : String = "[color=#9fb832][pulse color=#81ff03]STABLE"
const BAD_STATUS_TEXT : String = "[color=#ad7417][pulse color=#fc9d00]BAD"
const POPPING_STATUS_TEXT : String = "[color=#9c131a][pulse color=#eb1722]POPPING"
const POPPED_STATUS_TEXT : String = "[color=#6b1419][pulse color=#000000]POPPED"

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
		curDebtMoveSpeed = max(BASE_DEBT_MOVE_SPEED, abs(debtCurVal - val) / MAX_TIME_TO_MOVE_DEBT)
		targetDebtValue = max(val, 0)
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
