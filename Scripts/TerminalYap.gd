extends Label

@export var timer: Timer   
@export var lines_remembered: int = 14  

var lines: Array = []  

var random_yap = [
	"AFSAFKLAJSFLKJALSFJ",
	"fjdfuhjbfgvdfbjshdbfns",
	"fhsdjfnad afdjansd kadfadsf",
	"adsfad",
	"ewsxcvbnm oiuytg",
	"wazxdf yghjkmn bvcx"
]

func print_to_terminal(text_to_print: String) -> void:
	var time = Time.get_time_dict_from_system()
	var current_time = "%02d:%02d:%02d" % [time.hour, time.minute, time.second]
	var line = "[%s] %s" % [current_time, text_to_print]
	
	lines.append(line)
	
	if lines.size() > lines_remembered:
		lines.remove_at(0)
	
	text = "\n".join(lines)

func _ready() -> void:
	if timer:
		timer.timeout.connect(_on_Timer_timeout)
		timer.start()  
	else:
		push_error("Timer node not assigned in the Inspector!")

func _on_Timer_timeout() -> void:
	var index = randi() % random_yap.size()
	print_to_terminal(random_yap[index])
