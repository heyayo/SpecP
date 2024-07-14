extends Node
class_name AudioInstancer

func play_instance(audio : AudioStream) -> void:
	var player : AudioStreamPlayer = AudioStreamPlayer.new();
	player.finished.connect(report_end.bind(player));
	player.stream = audio;
	add_child(player);
	player.play();

func report_end(player : AudioStreamPlayer) -> void:
	player.queue_free();
