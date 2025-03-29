extends Control

@export var chat_input: LineEdit
@export var chat_message: PackedScene
@export var user_blue: Texture
@export var user_green: Texture
@export var send_button: Button
@export var message_container: VBoxContainer
@export var incoming_message_timer: Timer  
@export var message_sound_effect: AudioStreamPlayer
@export var message_send_sound_effect: AudioStreamPlayer

var potential_messages = [
	"hey you busy",
	"Hellooo",
	"what you up to",
	"YIPPEEEE",
	"Trans rights",
	"send me the link",
	"whats up",
	"how are you",
	"why are you chair",
	"lolol",
	"ok",
	"answer your phone",

]

var target_input_message: String = ""
var updating_text: bool = false

func _ready() -> void:
	randomize()
	chat_input.editable = false
	send_button.disabled = true

	update_incoming_message_timer_interval()
	
	incoming_message_timer.connect("timeout", _on_incoming_message_timer_timeout)
	chat_input.connect("text_changed", _on_chat_input_text_changed)
	chat_input.connect("text_submitted", _on_chat_input_entered)
	send_button.connect("pressed", _on_send_button_pressed)

func update_incoming_message_timer_interval() -> void:
	var interval: float
	if Global.game_behaviour_flags.get("chat_first_time", true):
		interval = randf_range(5.0, 7.0)
		Global.game_behaviour_flags["chat_first_time"] = false
	else:
		interval = randf_range(
			15.0 / (Global.flags.get("Chat_Upgrade", 0 ) + 1),
			30.0 / (Global.flags.get("Chat_Upgrade", 0 ) + 1)
		)

	incoming_message_timer.wait_time = interval
	incoming_message_timer.start()

func spawn_chat_message(text: String, is_sender: bool) -> void:
	var msg_instance = chat_message.instantiate()
	var hbox = msg_instance.get_node("HBoxContainer")
	var tex_rect = hbox.get_node("TextureRect")
	var label = hbox.get_node("Label")

	if is_sender:
		tex_rect.texture = user_blue
	else:
		tex_rect.texture = user_green
	
	label.text = text

	message_container.add_child(msg_instance)

func _on_incoming_message_timer_timeout() -> void:
	message_sound_effect.play()
	var incoming_msg = potential_messages[randi() % potential_messages.size()]

	spawn_chat_message(incoming_msg, false)

	target_input_message = potential_messages[randi() % potential_messages.size()]
	chat_input.text = ""
	chat_input.editable = true
	send_button.disabled = true
	chat_input.grab_focus()

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

		spawn_chat_message(chat_input.text, true)

		var chat_owned = Global.automations_owned.get("Chat", 1)
		var base_spawns = 150
		var num_spawns = base_spawns * chat_owned 
		var burst_duration = 1.0
		get_tree().get_root().get_node("BaseNode").get_node("ParticleManager") \
			.spawn_control_node(global_position + size / 2, num_spawns * (Global.flags.get("Chat_Upgrade_multiply", 0) + 1), burst_duration)
		
		chat_input.editable = false
		send_button.disabled = true
		target_input_message = ""
		chat_input.text = ""
		
		update_incoming_message_timer_interval()
	else:
		print("Message not complete yet.")
