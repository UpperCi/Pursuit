extends "res://scripts/entity.gd"

class_name Player

enum ACTIONS {
	ATTACK,
	MOVE,
	SPELL
}

var current_action = ACTIONS.MOVE setget set_action
var weapon = null
var spell = null

onready var ui = $UI
onready var anim = $AnimationPlayer

func set_action(v):
	current_action = v
	anim.play("RESET")
	match v:
		ACTIONS.MOVE:
			anim.play("Move")
		ACTIONS.ATTACK:
			anim.play("Attack", -1, 1.5)
		ACTIONS.SPELL:
			anim.play("Spell", -1, 0.8)

func _ready():
	self.map_pos = start_pos
	self.weapon = Universe.player_weapon
	self.spell = Universe.player_spell
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
		else:
			drop_item(map_pos, load(weapon.scene), weapon.img)
			weapon = weapon_node
			add_child(weapon_node)
		update_items()

func update_items():
	weapon.world = world
	spell.world = world
	weapon.player = self
	spell.player = self
	ui.get_node("Weapon").texture = weapon.img
	ui.get_node("Spell").texture = spell.img

func eval_action(dir: Vector2):
	match(current_action):
		ACTIONS.MOVE:
			return move_self(map_pos + dir)
		ACTIONS.ATTACK:
			self.current_action = ACTIONS.MOVE
			if weapon.use(map_pos, dir):
				return true
		ACTIONS.SPELL:
			self.current_action = ACTIONS.MOVE
			if spell.cool_left <= 0:
				if spell.use(map_pos, dir):
					spell.cool_left = spell.COOLDOWN
					return true
				
	return false

func update_ui():
	var state_node = ui.get_node("state")
	match current_action:
		ACTIONS.MOVE:
			state_node.text = "Move"
		ACTIONS.ATTACK:
			state_node.text = "Attack"
		ACTIONS.SPELL:
			state_node.text = "Spell"
	
	ui.get_node("hp").text = "hp: " + str(hp)

func start_turn():
	pass

func take_turn():
	if Input.is_action_just_pressed("player_cancel"):
		self.current_action = ACTIONS.MOVE
	elif Input.is_action_just_pressed("player_attack"):
		self.current_action = ACTIONS.ATTACK
	elif Input.is_action_just_pressed("player_spell") and spell.cool_left <= 0:
		self.current_action = ACTIONS.SPELL
	
	if Input.is_action_just_pressed("player_grab"):
		grab_item(map_pos)
		return true
	
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
	
	update_ui()
	
	return false

func end_turn():
	spell.cool_left = max(spell.cool_left - 1, 0)
	var cell = world.get_cell(map_pos)
	if cell.item:
		if cell.item.type == cell.item.ITEM_TYPES.EXIT:
			var room = Universe.get_random_room()
			get_tree().change_scene_to(room)
