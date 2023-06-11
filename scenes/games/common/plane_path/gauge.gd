extends Node2D

@onready var fuel_gauge = $GaugeFuel

var initial_fuel: float = 0.0

func set_initial_fuel(fuel: float):
	initial_fuel = fuel
	
func set_fuel(fuel: float):
	fuel = clampf(fuel, 0.0, initial_fuel)
	fuel_gauge.scale = Vector2(fuel / initial_fuel, 1.0)
	
