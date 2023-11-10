extends RefCounted
class_name Task

var supertask:String = ""
var option:String = ""
var interactable:Interactable = null
var required_item:Item = null
var being_done_by:Employee = null
var wait_time:float = 0.0

#Task.new(supertask,item_location,task.required_item))
# supertask, option, interactable, required item, wait
func _init(i_supertask:String,i_option:String,i_interactable:Interactable,i_required_item:Item = null,wait:float = 0.0):
	supertask = i_supertask
	option = i_option
	interactable = i_interactable
	required_item = i_required_item
	wait_time = wait
	if wait_time > 0:
		pass

func _to_string():
	var intr:String = "invalid interactable"
	if interactable != null:
		intr = interactable.a_name()
	var rq:String = ""
	if required_item != null:
		rq = required_item.a_name() + " at "
	var db:String = "not currently being done by anyone"
	if being_done_by != null:
		db = being_done_by.a_name()
	return option + " " + rq + intr + ", " + db
