extends ProgressBar

func update_health(amount: int):
	self.value -= amount
