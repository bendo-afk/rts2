extends Node2D

class_name Unit

#components
@onready var hp_comp := $HPComp
@onready var attack_comp := $AttackComp
@onready var move_comp := $MoveComp
@onready var change_height_comp := $ChangeHeightComp


var height: float
