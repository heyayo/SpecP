extends Node2D

class_name Tasker

#region Build Tasks
var build_requests : Array[Structure] = [];
func get_closest_build() -> Structure:
	if (build_requests.is_empty()): return null;
	return build_requests.front();
func request_build(s : Structure) -> void:
	build_requests.push_back(s);
	sort_by_distance(build_requests);
func remove_build_request(s : Structure) -> void:
	var index : int = build_requests.find(s);
	if (index >= 0):
		build_requests.remove_at(index);
#endregion

#region Harvest Tasks
var harvest_requests : Array[Harvestable] = [];
func get_closest_harvest() -> Harvestable:
	if (harvest_requests.is_empty()): return null;
	var h = harvest_requests.front();
	if (!h): return null;
	return harvest_requests.front();
func request_harvest(h : Harvestable) -> void:
	if (harvest_requests.find(h) >= 0): return;
	harvest_requests.push_back(h);
	sort_by_distance(harvest_requests);
func remove_harvest_request(h : Harvestable) -> void:
	var index : int = harvest_requests.find(h);
	if (index >= 0):
		harvest_requests.remove_at(index);
#endregion

## Sorts Requests Arrays by distance
func sort_by_distance(requests : Array) -> void:
	var shortest : float = 999999999;
	var index : int = 0;
	var parent : Node2D = get_parent();
	for i in range(0,requests.size()):
		var s : Node2D = requests[i];
		var dist : float = parent.global_position.distance_to(s.global_position);
		if (shortest > dist):
			shortest = dist;
			index = i;
