extends CharacterBody2D


@export var move_speed : float = 50.0

@export var animator : AnimatedSprite2D

@export var is_game_over : bool = false

@export var bullet_scenes : PackedScene




# 向左和向下是正 positive是正
# 由于不同主机的帧率不同 推荐使用固定每秒60帧运行
# 判断速度 如果为0播放待机动画 如果被打击播放受机动画 如果不为零播放奔跑动画
func _physics_process(delta: float) -> void:
	
	if not is_game_over:
		velocity = Input.get_vector('left','right','up','down') * move_speed
		
		if velocity == Vector2.ZERO:
			animator.play('idle')
		elif velocity != Vector2.ZERO:
			animator.play('run')

		move_and_slide()

	
# 碰撞slime 游戏根节点所有元素刷新
func game_over() -> void:
	# 由于重启游戏会和显示字幕产生冲突 因此要先显示字幕
	get_tree().current_scene.show_go_label()
	if not is_game_over:
	
		is_game_over = true
		animator.play('game_over')
		await get_tree().create_timer(3).timeout
		get_tree().reload_current_scene()



# 创建子弹图纸 子弹由position出现
func _on_fire() -> void:
	# 当玩家静止或游戏结束时不能发射子弹
	if velocity != Vector2.ZERO or is_game_over:
		return
	
	var bullet_node = bullet_scenes.instantiate()
	bullet_node.position += position + Vector2(17,6)
	get_tree().current_scene.add_child(bullet_node)
	
	
	
