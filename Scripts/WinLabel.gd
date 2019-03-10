extends Label

func _process(delta):
	match MatchStart.winner:
		0:
			set_text("PLAYER ONE WINS!")
		1:
			set_text("PLAYER TWO WINS!")