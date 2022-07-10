extends "res://scripts/entity.gd"

class_name Player

enum ACTIONS {
	ATTACK,
	MOVE,
	SPELL,
	CONFIRM_ITEM
}

var current_action = ACTIONS.MOVE setget set_action
var weapon = null
var spell = null

onready var ui = $UI
onready var anim = $AnimationPlayer
onready var pause_scene = preload("res://scenes/PauseMenu.tscn")

func set_action(v):
	if v != current_action:
		anim.play("RESET")
		match v:
			ACTIONS.MOVE:
				anim.play("Move")
			ACTIONS.ATTACK:
				anim.play("Attack", -1, 1.5)
				SFX.play_random("knife", 4)
			ACTIONS.SPELL:
				anim.play("Spell", -1, 0.8)
				SFX.play_random("spell_prepare", 4)
	current_action = v

func _ready():
	self.map_pos = start_pos
	weapon = Universe.player_weapon.instance()
	spell = Universe.player_spell.instance()
	hp = Universe.player_hp
	max_hp = 6
	anim.play("Move")
	world.player = self
	update_items()

func grab_item(pos: Vector2):
	var cell = world.get_cell(pos)
	if cell.item:
		if cell.item.type != cell.item.ITEM_TYPES.PICKUP:
			return
		world.delete_item(cell.item)
		var weapon_node = cell.item.target_weapon.instance()
		if 'is_spell' in weapon_node:
			drop_item(map_pos, load(spell.scene), spell.img)
			spell = weapon_node
			SFX.play_random("pickUp_spell", 4)
			Universe.player_spell = cell.item.target_weapon
			if not spell.item_name in Universe.seen_items:
				init_desc(spell)
		else:
			drop_item(map_pos, load(weapon.scene), weapon.img)
			weapon = weapon_node
			SFX.play_random("pickUp_weapon", 4)
			Universe.player_weapon = cell.item.target_weapon
			add_child(weapon_node)
			if not weapon.item_name in Universe.seen_items:
				init_desc(weapon)
		update_items()
		return true
	return false

func init_desc(item):
	current_action = ACTIONS.CONFIRM_ITEM
	ui.get_node("ItemDesc/Name").text = item.item_name
	ui.get_node("ItemDesc/Desc").text = item.item_desc
	ui.get_node("ItemDesc/ItemContainer/Item").texture = item.img
	ui.get_node("ItemDesc").visible = true
	current_action = ACTIONS.CONFIRM_ITEM
	Universe.seen_items.push_back(item.item_name)

func _on_MenuButton_pressed():
	current_action = ACTIONS.MOVE
	ui.get_node("ItemDesc").visible = false

func damage():
	SFX.play_random("player_gets_damage", 4)

func die():
	SceneSwitcher.switch(load("res://scenes/DeathMenu.tscn"))

func update_items():
	weapon.world = world
	spell.world = world
	weapon.start()
	spell.start()
	weapon.player = self
	spell.player = self
	ui.get_node("Weapon").texture = weapon.img
	ui.get_node("Spell").texture = spell.img

func eval_action(dir: Vector2):
	match(current_action):
		ACTIONS.MOVE:
			if move_self(map_pos + dir):
				SFX.play_random("footstep_single", 6)
				return true
		ACTIONS.ATTACK:
			self.current_action = ACTIONS.MOVE
			if weapon.use(map_pos, dir):
				SFX.play_random("knife_hit", 4)
				return true
		ACTIONS.SPELL:
			self.current_action = ACTIONS.MOVE
			if spell.cool_left <= 0:
				if spell.use(map_pos, dir):
					spell.cool_left = spell.COOLDOWN
					return true
				
	return false

func update_ui():
	ui.get_node("Weapon/FG").visible = (current_action == ACTIONS.ATTACK)
	ui.get_node("Spell/FG").visible = (current_action == ACTIONS.SPELL)
	
	ui.get_node("HP_Even").value = floor(hp / 2.0)
	ui.get_node("HP_Odd").value = ceil(hp / 2.0)
	ui.get_node("room_num").text = str(Universe.room_num + 1)
	
	ui.get_node("Mana").max_value = spell.COOLDOWN - 1
	ui.get_node("Mana").value = (spell.COOLDOWN - spell.cool_left) - 1
	
	if spell.cool_left > 0:
		ui.get_node("Spell").self_modulate = Color(1,1,1,0.5)
	else:
		ui.get_node("Spell").self_modulate = Color(1,1,1,1)

func start_turn():
	pass

func take_turn():
	if current_action == ACTIONS.CONFIRM_ITEM:
		update_ui()
		if Input.is_action_just_pressed("player_attack"):
			_on_MenuButton_pressed()
			pass
		return
	if Input.is_action_just_pressed("player_cancel"):
		current_action = ACTIONS.MOVE
	elif Input.is_action_just_pressed("player_attack"):
		current_action = ACTIONS.ATTACK
	elif Input.is_action_just_pressed("player_spell") and spell.cool_left <= 0:
		current_action = ACTIONS.SPELL
	
	if Input.is_action_just_pressed("player_grab"):
		return grab_item(map_pos)
	
	if Input.is_action_just_pressed("player_right"):
		$Sprite.flip_h = false
		return eval_action(Vector2.RIGHT)
	elif Input.is_action_just_pressed("player_left"):
		$Sprite.flip_h = true
		return eval_action(Vector2.LEFT)
	elif Input.is_action_just_pressed("player_up"):
		return eval_action(Vector2.UP)
	elif Input.is_action_just_pressed("player_down"):
		return eval_action(Vector2.DOWN)
	
	if Input.is_action_just_pressed("ui_pause"):
		var pause_node = pause_scene.instance()
		get_tree().root.add_child(pause_node)
		get_tree().paused = true
	
	update_ui()
	
	return false

func end_turn():
	spell.cool_left = max(spell.cool_left - 1, 0)
	var cell = world.get_cell(map_pos)
	if cell.item:
		if cell.item.type == cell.item.ITEM_TYPES.EXIT:
			var room = Universe.get_random_room()
			SFX.play_random("footstep_multi", 3)
			Universe.room_num += 1
			Universe.player_hp = hp
			SceneSwitcher.switch(room)
