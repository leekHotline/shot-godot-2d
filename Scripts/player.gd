extends CharacterBody2D


@export var move_speed : float = 50.0

@export var animator : AnimatedSprite2D

@export var is_game_over : bool = false

	
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
	is_game_over = true
	animator.play('game_over')
	await get_tree().create_timer(3).timeout
	get_tree().reload_current_scene()


func _on_fire() -> void:
	print('fire')
