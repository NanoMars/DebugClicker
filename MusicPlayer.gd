extends Control


@export var audio_player: AudioStreamPlayer

@export var song_name_label: Label
@export var progress_bar: ProgressBar
@export var progress_slider: HSlider
@export var play_pause_button: Button

@export var play_icon: Texture
@export var pause_icon: Texture

@export var next_button: Button
@export var previous_button: Button

@export var song_list: Array[AudioStream] = []
@export var first_song: int = 0

var original_playing: bool

var songs_played: Array[AudioStream] = []

var update_progress_slider: bool = true
var progress = 0.0

func _on_play_pause_button_pressed() -> void:
	if audio_player.playing:
		audio_player.stop()
	else:
		audio_player.play((progress / 100 ) * audio_player.stream.get_length())
	
func play_next_song(song_to_play: int = -1) -> void:
	var song_list_without_current_song = song_list.filter(func(song): return song != audio_player.stream)

	if song_list_without_current_song.size() > 0:
		audio_player.stop()
		audio_player.stream = (song_list_without_current_song[randi() % song_list_without_current_song.size()] if song_to_play == -1 else song_list[song_to_play])
		audio_player.play()
	else:
		audio_player.stop()
		audio_player.play()

	song_name_label.text = audio_player.stream.resource_path.get_file()
	
	songs_played.push_back(audio_player.stream)

func _on_previous_button_pressed() -> void:
	if songs_played.size() > 1:
		audio_player.stop()
		songs_played.pop_back()
		audio_player.stream = songs_played[songs_played.size() - 1]
		audio_player.play()
	else:
		audio_player.stop()
		audio_player.play()

	song_name_label.text = audio_player.stream.resource_path.get_file()

func _on_progress_slider_drag_started() -> void:
	original_playing = audio_player.playing
	audio_player.playing = false
	update_progress_slider = false

func _on_progress_slider_drag_ended(_value: bool) -> void:
	update_progress_slider = true
	if original_playing:
		audio_player.play((progress / 100 ) * audio_player.stream.get_length())

func _ready() -> void:
	play_pause_button.connect("pressed", _on_play_pause_button_pressed)
	next_button.connect("pressed", play_next_song)
	previous_button.connect("pressed", _on_previous_button_pressed)
	progress_slider.connect("drag_started", _on_progress_slider_drag_started)
	progress_slider.connect("drag_ended", _on_progress_slider_drag_ended)

	play_next_song(first_song)
	audio_player.playing = false

func _process(_delta: float) -> void:
	play_pause_button.icon = pause_icon if audio_player.playing else play_icon

	if update_progress_slider and audio_player.playing:
		progress = (audio_player.get_playback_position() / audio_player.stream.get_length()) * 100
		progress_slider.value = progress
	else:
		progress = progress_slider.value
	progress_bar.value = progress - 0.1

	if progress >= 99.5:
		play_next_song()
