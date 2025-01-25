class_name Reply

var name
var text
var effect

func Reply(name, text, effect):
	self.name = name
	self.text = text
	self.replies = effect

func getName():
	return self.name

func getText():
	return self.text

func getEffect():
	return self.effect

func playReply():
	return
	# when a reply is selected, run this and it will run the effect of the reply
