class_name DataBase

var ecopromptDB = "res://Database/EcopromptDB.txt"
var replyDB = "res://Database/ReplyDB.txt"
var effectDB = "res://Database/EffectDB.txt"
var names
var gameModel

func setGameModel(gameModel: GameModel):
	self.gameModel = gameModel

func setNames():
	var file = FileAccess.open(ecopromptDB, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		var prompt = line.split("|")
		names.append(prompt[0])
	file.close()

func getRandom():
	return readDatabase(names.get(randi_range(0, names.size())))

#Reads the ecoprompt database and returns a new Ecoprompt for the specified name.  
func readDatabase(name: String):
	var file = FileAccess.open(ecopromptDB, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		var prompt = line.split("|")
		if prompt[0] == name:
			var replies
			for n in range(2, prompt):
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
			if (effect[1] == TypeDefs.EffectType.GAMBLE):
				file.close()
				return GamblingEcoEffect.new(effect[2], effect[3], effect[4], effect[5], effect[6], effect[7], effect[8])
			elif (effect[1] == TypeDefs.EffectType.ECOEFFECT):
				file.close()
				var addToEconomyByRound = effect[3].split(",")
				if (effect.size() == 4):
					var noteForEachRound = effect[3].split(",")
					return EcoEffect.new(effect[2], addToEconomyByRound, noteForEachRound)
				return EcoEffect.new(effect[2], addToEconomyByRound)
