extends Control

var next_scene: PackedScene
export var time = -1.0
var transitioning = false

func switch(scene: PackedScene):
	get_tree().paused = true
	$AnimationPlayer.play("Switch", -1.0, 0.8)
	next_scene = scene
	transitioning = true

func _process(delta):
	if transitioning:
		Gfx.set_trans(time)

func fully_switch():
	get_tree().change_scene_to(next_scene)

func finish():
	get_tree().paused = false
	transitioning = false
