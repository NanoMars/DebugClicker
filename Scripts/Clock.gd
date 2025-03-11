extends Label

func _ready():
	update_time()
	$"..".get_tree().create_timer(1.0).timeout.connect(update_time)

func update_time():
	var current_time = Time.get_time_dict_from_system()
	var hour = current_time.hour
	var minute = current_time.minute
	
	var am_pm = "AM"
	if hour >= 12:
		am_pm = "PM"
	if hour > 12:
		hour -= 12
	elif hour == 0:
		hour = 12
	
	var formatted_time = "%02d:%02d %s" % [hour, minute, am_pm]
	text = formatted_time
	
	$"..".get_tree().create_timer(1.0).timeout.connect(update_time)
