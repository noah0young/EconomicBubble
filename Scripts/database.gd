class_name DataBase

var ecopromptDB = "res://Database/EcopromptDB.txt"
var names

func setNames():
	var file = FileAccess.open(ecopromptDB, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		var prompt = line.split("|")
		names.append(prompt[0])
	file.close()

func getRandom():
	return read_database(names.get(randi_range(0, names.size())))

#Reads the ecoprompt database and returns a new Ecoprompt for the specified name.  
func read_database(name: String):
	var file = FileAccess.open(ecopromptDB, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		var prompt = line.split("|")
		if prompt[0] == name:
			var replies
			for n in range(2,prompt.size(),1):
				replies.append(n)
			file.close()
			return EcoPrompt.new().setup(prompt[0], prompt[1], replies)
