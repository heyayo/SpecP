extends AudioStreamPlayer
class_name MenuAudio

const select_sfx : AudioStreamOggVorbis = preload("res://_audio/ogg/JDSherbert - Ultimate UI SFX Pack - Select - 2.ogg")

func play_audio(audio : AudioStreamOggVorbis) -> void:
	stream = audio;
	stop();
	play();

func button_pressed() -> void:
	play_audio(select_sfx);
