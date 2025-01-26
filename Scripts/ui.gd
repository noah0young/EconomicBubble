extends Control
class_name UI

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
		curDebtMoveSpeed = BASE_DEBT_MOVE_SPEED
		targetDebtValue = val
		usingTargetDebtVal = true;
		await finishedUpdatingDebtSignal
