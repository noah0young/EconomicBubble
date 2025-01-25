class_name Effect

var name
var text
var debtChange
var bubbleChange

func Effect(name, text, debtChange, bubbleChange):
	self.name = name
	self.text = text
	self.debtChange = debtChange
	self.bubbleChange = bubbleChange

func getName():
	return self.name

func getText():
	return self.text

func getDebtChange():
	return self.debtChange

func getBubbleChange():
	return self.bubbleChange

func setEffect():
	return
	# when setEffect is ran, activates the effect if effect.
