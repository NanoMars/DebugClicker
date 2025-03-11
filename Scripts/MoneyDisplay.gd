extends VBoxContainer

@export var money_counter: Label
@export var cps_display: Label

var money_log: Array = []
var time_accum: float = 0.0

func _process(delta):
	money_counter.text = str(Global.money)
	time_accum += delta
	
	if time_accum >= 1.0:
		time_accum -= 1.0
		money_log.append(Global.money)
		
		if money_log.size() > 10:
			money_log.pop_front()
		
		if money_log.size() > 1:
			var total_increase = 0.0
			for i in range(money_log.size() - 1):
				var diff = money_log[i + 1] - money_log[i]
				if diff > 0:
					total_increase += diff
			var avg_increase = total_increase / (money_log.size() - 1)
			var avg_increase_rounded = round(avg_increase * 10) / 10.0
			cps_display.text = str(avg_increase_rounded) + "/s"
