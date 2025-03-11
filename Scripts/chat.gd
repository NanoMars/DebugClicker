extends Control

@export var chat_input: LineEdit
@export var chat_history_label: Label
@export var send_button: Button
@export var incoming_message_timer: Timer  
@export var message_sound_effect: AudioStreamPlayer
@export var message_send_sound_effect: AudioStreamPlayer 
@export var notification_icon: VBoxContainer

var potential_messages = [
	"hey you busy",  
	"wanna hang out later",  
	"what you up to",  
	"just woke up so tired",  
	"forgot to text back my bad",  
	"need to tell you something",  
	"guess what happened today",  
	"gonna call you in a bit",  
	"meet me at the usual spot",  
	"got some good news",  
	"come outside im here",  
	"what time you free",  
	"cant believe that just happened",  
	"send me the link",  
	"lets do something fun",  
	"you wont believe this",  
]

var target_input_message: String = ""
var updating_text: bool = false

func _ready() -> void:
	randomize()
	chat_input.editable = false
	send_button.disabled = true
	notification_icon.visible = false
	
	update_incoming_message_timer_interval()
	incoming_message_timer.connect("timeout", Callable(self, "_on_incoming_message_timer_timeout"))
	chat_input.connect("text_changed", Callable(self, "_on_chat_input_text_changed"))
	chat_input.connect("text_submitted", Callable(self, "_on_chat_input_entered"))
	send_button.connect("pressed", Callable(self, "_on_send_button_pressed"))

func update_incoming_message_timer_interval() -> void:
	var interval = randf_range(50.0, 70.0)
	incoming_message_timer.wait_time = interval
	incoming_message_timer.start()

func append_to_chat_history(new_line: String) -> void:
	var lines: Array = []
	if chat_history_label.text != "":
		lines = Array(chat_history_label.text.split("\n"))
	lines.append(new_line)
	chat_history_label.text = "\n".join(lines)

func _on_incoming_message_timer_timeout() -> void:
	message_sound_effect.play()
	var incoming_msg = potential_messages[randi() % potential_messages.size()]
	append_to_chat_history(incoming_msg)
	
	target_input_message = potential_messages[randi() % potential_messages.size()]
	chat_input.text = ""
	chat_input.editable = true
	send_button.disabled = true
	chat_input.grab_focus()
	notification_icon.visible = true  

func _on_chat_input_text_changed(new_text: String) -> void:
	if updating_text:
		return
	
	var length = new_text.length()
	if length > target_input_message.length():
		length = target_input_message.length()
	
	updating_text = true
	chat_input.text = target_input_message.substr(0, length)
	updating_text = false
	
	if target_input_message == "" or chat_input.text.length() < target_input_message.length():
		send_button.disabled = true
	else:
		send_button.disabled = false

func _on_chat_input_entered(_new_text: String) -> void:
	_on_send_button_pressed()

func _on_send_button_pressed() -> void:
	if chat_input.text == target_input_message and target_input_message != "":
		message_send_sound_effect.play()
		append_to_chat_history(chat_input.text)
		var chat_owned = Global.automations_owned.get("Chat", 1)
		var base_spawns = 150
		var num_spawns = base_spawns * chat_owned 
		
		var burst_duration = 1.0
		get_tree().get_root().get_node("BaseNode").get_node("ParticleManager").spawn_control_node(global_position + size / 2, num_spawns, burst_duration)
		
		chat_input.editable = false
		send_button.disabled = true
		target_input_message = ""
		chat_input.text = ""
		notification_icon.visible = false 
		
		update_incoming_message_timer_interval()
	else:
		print("Message not complete yet.")
