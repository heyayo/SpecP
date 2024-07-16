extends Node
class_name SaveLoader

static func load_save(file : FileAccess) -> SaveData:
	var json = JSON.new();
	var error = json.parse(file.get_as_text());
	var file_data = json.data;
	return SaveData.from_json(file_data);

static func save_game(persist : Array) -> SaveData:
	var data : SaveData = SaveData.new();
	var date_values = Time.get_date_dict_from_system();
	data.date = "%s|%s|%s" % [date_values["day"],date_values["month"],date_values["year"]];
	for p in persist:
		if (p is Unit):
			data.units.append(p.save());
			continue;
		if (p is WorldResource):
			data.environmental_resources.append(p.save());
			continue;
		if (p is Structure):
			data.structures.append(p.save());
			continue;
	return data;

static func save_file(data : SaveData) -> bool:
	var save_folder_exists : bool = DirAccess.dir_exists_absolute("user://saves")
	if (!save_folder_exists):
		DirAccess.make_dir_recursive_absolute("user://saves");
	var file = FileAccess.open("user://saves/%s.%s" % [data.name,"sav"], FileAccess.WRITE);
	if (!file):
		print("Unable to Write Save File | %s" % FileAccess.get_open_error());
		return false;
	var json = JSON.new();
	file.store_line(data.as_json_string());
	return true;
