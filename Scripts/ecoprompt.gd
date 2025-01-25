class_name EcoPrompt

var name
var text
var replies

func EcoPrompt(name, text, replies):
	self.name = name
	self.text = text
	self.replies = replies

func getName():
	return self.name

func getText():
	return self.text

func getReplies():
	return self.replies

func playPrompt():
	return
	# I am very sick rn due to my own making, so i cant write this out
	# But basically, it makes the game play the prompt onto the screen
