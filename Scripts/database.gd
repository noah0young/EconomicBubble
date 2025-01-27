class_name DataBase

var ecopromptDB = "res://Database/EcopromptDB.txt"
var replyDB = "res://Database/ReplyDB.txt"
var effectDB = "res://Database/EffectDB.txt"
var names: Array
var gameModel

func _init(gameModel: GameModel) -> void:
	self.gameModel = gameModel
	setNames()

func setNames():
	var file = FileAccess.open(ecopromptDB, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		var prompt = line.split("|")
		names.append(prompt[0])
	file.close()

func getRandom():
	return readDatabase(names[randi_range(0, names.size() - 2)])

#Reads the ecoprompt database and returns a new Ecoprompt for the specified name.  
func readDatabase(name: String):
	var file = FileAccess.open(ecopromptDB, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		var prompt = line.split("|")
		if prompt[0] == name:
			var replies: Array
			for n in range(2, prompt.size()):
				replies.append(readReplyDB(prompt[n]))
			file.close()
			return EcoPrompt.new(prompt[0], prompt[1], replies)

func readReplyDB(name: String):
	var file = FileAccess.open(replyDB, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		var reply = line.split("|")
		if reply[0] == name:
			var effects = readEffectDB(reply[2])
			file.close()
			return Reply.new(reply[0], reply[1], effects, gameModel)

func readEffectDB(name: String):
	var file = FileAccess.open(effectDB, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		var effect = line.split("|")
		if effect[0] == name:
			if (effect[1] == TypeDefs.strOfEffectType(TypeDefs.EffectType.GAMBLE)):
				file.close()
				return GamblingEcoEffect.new(float(effect[2]), int(effect[3]), int(effect[4]), str(effect[5]), int(effect[6]), int(effect[7]), str(effect[8]))
			elif (effect[1] == TypeDefs.strOfEffectType(TypeDefs.EffectType.ECOEFFECT)):
				file.close()
				var addToEconomyByRoundAsStr = effect[3].split(",")
				var addToEconomyByRound : Array[float] = [];
				for i in range(0, addToEconomyByRoundAsStr.size()):
					addToEconomyByRound.append(float(addToEconomyByRoundAsStr[i]))
				if (effect.size() >= 4):
					var noteForEachRound = effect[4].split(",")
					return EcoEffect.new(int(effect[2]), addToEconomyByRound, noteForEachRound)
				return EcoEffect.new(int(effect[2]), addToEconomyByRound)
