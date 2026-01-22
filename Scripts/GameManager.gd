extends Node2D

@export var slime_scene: PackedScene

@export var wait_timer : Timer

# 可以在node2d根节点获取变量值并修改 也可以从全局变量里读取并修改
# 以全局变量score_board为主 score变量只为演示
@export var score : int = 0

@export var game_over_label = Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$BGM.play()
	pass # Replace with function body.


# 目前的生成速率是每3秒生成一个怪物 增加难度 每过一秒速率 单怪/-0.2s 难度钳制1-3s
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	wait_timer.wait_time -= 0.2 * delta
	wait_timer.wait_time = clamp(wait_timer.wait_time, 1.2, 3)

# 生成实例 位置范围 节点加入主场景
func _generate_slime() -> void:
	var slime_node = slime_scene.instantiate()
	slime_node.position = Vector2(253, randf_range(46,112))
	get_tree().current_scene.add_child(slime_node)	

func show_go_label():
	game_over_label.visible = true
	
	
