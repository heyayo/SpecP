extends HBoxContainer
class_name SavePanelBuilder

@onready var template_panel : SavePanel = $"Template Panel"

func _ready() -> void:
	template_panel.visible = false;
func get_saves() -> Array[SaveData]:
	var files = DirAccess.get_files_at("user://saves");
	var saves : Array[SaveData];
	for save in files:
		var extension : String = save.get_extension();
		print("File Extension: %s" % extension);
		if (extension != "sav"): continue;
		var file_data : FileAccess = FileAccess.open("user://saves/%s"%save,FileAccess.READ);
		if (!file_data):
			print("Can't read file | %s" % save);
			continue;
		saves.push_back(SaveLoader.load_save(file_data));
	return saves;
func build_saves() -> void:
	var saves = get_saves();
	print("%s Saves Loaded" % saves.size());
	for s in saves:
		var dupe : SavePanel = template_panel.duplicate();
		add_child(dupe);
		dupe.build(s);
		dupe.visible = true;
