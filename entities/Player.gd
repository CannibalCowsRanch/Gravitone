extends Node
class_name Player

class Actions:
	var move_right: String
	var move_left: String
	var move_up: String
	var move_down: String
	var interact: String

var action: Actions = null
var number = Types.PlayerNumber.INVALID setget set_number

func _init(number) -> void:
	self.action = Actions.new()
	self.number = number

func set_number(new_number) -> void:
	number = new_number

	self.action.move_right = "move_right_%s" % self.number
	self.action.move_left = "move_left_%s" % self.number
	self.action.move_up = "move_up_%s" % self.number
	self.action.move_down = "move_down_%s" % self.number
	self.action.interact = "interact_%s" % self.number