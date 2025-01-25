class_name Reply

var name
var text
var effect
var gameModel
var mouseOn: bool = false

func Reply(name, text, effect, gameModel):
	self.name = name
	self.text = text
	self.replies = effect
	self.gameModel = gameModel

func getName():
	return self.name

func getText():
	return self.text

func getEffect():
	return self.effect

func getGameModel():
	return self.gameModel

func _on_mouse_entered():
	mouseOn = true

func _on_mouse_exited():
	mouseOn = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and Input.is_mouse_button_pressed(1) and mouseOn:
			selectReply(effect)
			print("dick")

func selectReply(effect : EcoEffect) -> void:
	gameModel.addEffect(effect)
