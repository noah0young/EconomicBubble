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
	for n in range(0, replies.size()):
		replies[n].genReply()
