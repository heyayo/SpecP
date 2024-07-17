extends Resource
class_name SaveData

@export var version_major : int = 1;
@export var version_minor : int = 0;
@export var name : String = "default";
@export var date : String;
@export var environmental_resources : Array = [];
@export var units : Array = [];
@export var structures : Array = [];
@export var wood : int;
@export var food : int;
@export var stone : int;
@export var metal : int;

func as_json_string() -> String:
	var data : Dictionary = {
		"version_major":version_major,
		"version_minor":version_minor,
		"name":name,
		"date":date,
		"environmental_resources":[],
		"units":[],
		"structures":[],
		"wood":wood,
		"food":food,
		"stone":stone,
		"metal":metal
	};
	var environ_arr = data["environmental_resources"];
	for e in environmental_resources:
		environ_arr.append(e);
	var unit_arr = data["units"];
	for u in units:
		unit_arr.append(u);
	var structure_arr = data["structures"];
	for s in structures:
		structure_arr.append(s);
	return JSON.stringify(data);

static func from_json(json : Dictionary) -> SaveData:
	var data := SaveData.new();
	data.name = json["name"];
	data.date = json["date"];
	data.version_major = json["version_major"];
	data.version_minor = json["version_minor"];
	data.environmental_resources = json["environmental_resources"].duplicate();
	data.units = json["units"].duplicate();
	data.structures = json["structures"].duplicate();
	data.wood = json["wood"];
	data.food = json["food"];
	data.stone = json["stone"];
	data.metal = json["metal"];
	return data;
