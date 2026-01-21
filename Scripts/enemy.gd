extends Area2D

# 得声明类型和是否为变量
@export var slime_speed : float = -100.0

func _physics_process(delta: float) -> void:
	
	position += Vector2(slime_speed, 0) * delta
	

# 添加信号 就是触发器 当slime碰撞玩家 执行函数中代码
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print('hit player')
		body.game_over()
	
