extends Control

@export var progress_bar: ProgressBar
@export var cashout_button: Button
@export var animation_duration: float = 1.0
@export var money_timer_duration: float = 0.5

@export var base_payout: int = 2500
var progress: float = 0.0
var dummy_progress: float = 0.0
var last_money: int

var animating: bool = false
var animation_elapsed: float = 0.0
var animation_total: float = 0.0
var last_removed_amount: int = 0
var start_money: int = 0

var money_timer_active: bool = false
var money_timer_elapsed: float = 0.0
var progress_start: float = 0.0
var pending_money_diff: int = 0

func _ready() -> void:
	last_money = Global.money
	cashout_button.disabled = true
	cashout_button.connect("pressed", _on_cashout_button_pressed)

func _process(delta: float) -> void:
	var goal: float = 30
	progress_bar.max_value = goal
	
	if animating:
		money_timer_active = false
		animation_elapsed += delta
		var t = clamp(animation_elapsed / animation_duration, 0.0, 1.0)
		var new_dummy_progress = lerp(animation_total, 0.0, t)
		dummy_progress = new_dummy_progress
		progress_bar.value = dummy_progress
		cashout_button.disabled = true
		if animation_elapsed >= animation_duration:
			animating = false
			progress = 0
	elif money_timer_active:
		money_timer_elapsed += delta
		print("delta: " + str(delta) + " mte: " + str(money_timer_elapsed))
		if money_timer_elapsed >= money_timer_duration:
			money_timer_elapsed = money_timer_duration
			money_timer_active = false
		progress += delta * pow(2, Global.flags.get("Loading_Upgrade_1", 0))
		progress_bar.value = progress
		cashout_button.disabled = progress < goal
	else:
		if Global.money > last_money:
			pending_money_diff = Global.money - last_money
			money_timer_active = true
			money_timer_elapsed = 0.0
			progress_start = progress
		cashout_button.disabled = progress < goal
	last_money = Global.money

func _on_cashout_button_pressed() -> void:
	if not animating:
		animation_total = progress
		dummy_progress = progress
		progress = 0.0
		animating = true
		animation_elapsed = 0.0
		last_removed_amount = 0
		start_money = Global.money
		get_tree().get_root().get_node("BaseNode").get_node("ParticleManager").spawn_control_node(global_position + size / 2, (base_payout * Global.automations_owned.get("Loading", 0)) * pow(2, Global.flags.get("Loading_Upgrade_2", 0)), animation_duration)
