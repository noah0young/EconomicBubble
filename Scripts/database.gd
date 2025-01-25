class_name DataBase

var promptList : Array[EcoPrompt];

func addPrompt():
	promptList.append(self.EcoPrompt)

func getPrompts():
	return promptList

func getProm(x):
	return promptList
