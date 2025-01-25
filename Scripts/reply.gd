class_name Reply

var name
var text
var effect
var gameModel
var mouseOn: bool = false

func _init(name, text, effect, gameModel) -> void:
	self.name = name
	self.text = text
	self.replies = effect
	self.gameModel = gameModel

func getName(): # returns object name
	return self.name

func getText(): # returns object text
	return self.text

func getEffect(): # returns object effect
	return self.effect

func getGameModel(): # returns the gamemodel
	return self.gameModel

func _on_mouse_entered(): # turns onMouse to true
	mouseOn = true

func _on_mouse_exited(): # turns onMouse to false
	mouseOn = false

func _unhandled_input(event): # when a m1 click, checks if its on the reply and
	# runs selectReply
	if event is InputEventKey:
		if event.pressed and Input.is_mouse_button_pressed(1) and mouseOn:
			selectReply(effect)
			print("dick")

func selectReply(effect : EcoEffect) -> void: # adds reply effect to the gamemodel
	# effect lsit
	gameModel.addEffect(effect)

func genReply(): # generates a reply onto the table
	return
