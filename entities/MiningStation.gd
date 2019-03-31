extends Node

# Cooldown is the number of seconds
# needed to mine an amount of resource
export var cooldown = 1;

# The amount of resource mined each period
export var quantity = 100;


func _ready():
	$Timer.wait_time = cooldown