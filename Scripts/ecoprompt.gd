class_name EcoPrompt

var name
var text
var replies

func _init(name, text, replies) -> void: #constructs object
	self.name = name
	self.text = text
	self.replies = replies

func getName(): # returns object name
	return self.name

func getText(): # returns object text
	return self.text

func getReplies(): # returns object replies
	return self.replies

func genPrompt(): # generates prompt
	return
	# I am very sick rn due to my own making, so i cant write this out
	# But basically, it makes the game play the prompt onto the screen
