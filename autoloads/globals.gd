extends Node

enum Masks {
	NONE,
	RED,
	BLUE,
	GREEN,
}

var current_mask: int

var enemy_normal_speed: float
var enemy_slow_speed: float

var can_enemy_chase: bool = true
var can_damage_player: bool = true
