extends Label

@export var timer: Timer   
@export var lines_remembered: int = 14  

var lines: Array = []  

var random_yap = [
	"⣜⢵⠷⡯⣺⠗⡻⣄⠝⡧⡿⠞⣍⢲⣽⠋⢤⡺⠧⣹⡇⠾⣡⢣⠎",
	"FTRAXX//9XΩ::UJGNRL#11.4 ",
	"V9X-ζχψ₧₧₧₧₧₧₧₧₧₧₧⟰⟰⟰",
	"𐎘𐎚𐎜𐎠𐎦𐎺𐏁𐏂𐏃𐏉𐏔𐏕𐏖",
	"𐑑𐑖𐑳𐑛𐑒𐑢𐑧𐑑𐑣𐑦𐑙𐑒𐑢𐑦𐑚𐑒𐑻",
	"⨁⩤⩫⨟⩹𝔤𝕵⟆𝟟𝟜𝟘𝟙 ",
	"⨅⨉⩹⫌⫎⫏⩿⨋⩮⩱ ",
	"jKx9-a1Z.37C zfQ0 [qu?] &= !",
	"2341:9bn0-lnx@u ~^ /u0r xLsh 4xy9",
	"[dsFf-l0x] - rTcv(00x07f9d)",
	"?? => __y9b4-$pQ",
	"[98xf] : gH9-Z",
	"sQm-LN64 [f_4+r^vx]",
	"GHZ> aCkZ(02,00 - gF3#)",
	"[04x-l1g] cX.aZ - r?9 - kK6_z",
	"f93l-xx1 - snpQ(13.0)",
	"zXd7: RvQ-7cx => yz99|~",
	"10S7-p64 LqTx? [27fxe2]",
	"rRy4-lCd jH9n^ (?7v)",
	"cNv9-λ9X aTμ$ -> 1.2.0.β",
	"[wo0k] iFz(1398a) qZ9-hSy",
	"_-! &= 74x0 ⟿ ^kS4",
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
