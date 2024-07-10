extends AudioStreamPlayer
class_name MenuAudio

const select_sfx : AudioStreamOggVorbis = preload("res://_audio/ogg/JDSherbert - Ultimate UI SFX Pack - Select - 2.ogg")
const select_sfx_two : AudioStreamOggVorbis = preload("res://_audio/ogg/JDSherbert - Ultimate UI SFX Pack - Cursor - 1.ogg")
const move_action_sfx = preload("res://_audio/ogg/JDSherbert - Ultimate UI SFX Pack - Cursor - 4.ogg")
const attack_action_sfx = preload("res://_audio/ogg/JDSherbert - Ultimate UI SFX Pack - Select - 1.ogg")

func play_audio(audio : AudioStreamOggVorbis) -> void:
	stream = audio;
	stop();
	play();

func button_pressed() -> void:
	play_audio(select_sfx);
func button_pressed_two() -> void:
	play_audio(select_sfx_two);
func move_action() -> void:
	play_audio(move_action_sfx);
func attack_action() -> void:
	play_audio(attack_action_sfx);
