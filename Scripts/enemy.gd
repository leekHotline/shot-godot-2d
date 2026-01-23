extends Area2D

#export导出的变量 可以在检查器中修改值
# 得声明类型和是否为变量
@export var slime_speed : float = -80.0



var is_dead: bool = false

func _physics_process(delta: float) -> void:
	if not is_dead:
		position += Vector2(slime_speed, 0) * delta
	if position.x < -260:
		queue_free()
	

# 添加信号 就是触发器 当slime碰撞玩家 执行函数中代码 
func _on_body_entered(body: Node2D) -> void:
	#如果碰撞到了 且史莱姆活着的时候才结束 防止0.6s的死亡动画也算
	if body is CharacterBody2D and not is_dead:
		print('hit player')
		body.game_over()
		Global.score_board = 0

	

# area是slime的信号 分组是bullet的 判断史莱姆是否碰撞上了子弹
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('bullet'):

		is_dead = true
		Global.score_board += 3
		print('bullet hit slime,score is now:',Global.score_board)
		$AnimatedSprite2D.play('death')
		$SlimeDeathSound.play()
		# 史莱姆和子弹也释放
		area.queue_free()
		
		get_tree().current_scene.score += 3
		await get_tree().create_timer(0.5).timeout
		# 0.6秒之后史莱姆和动画消失
		queue_free()
		
	
