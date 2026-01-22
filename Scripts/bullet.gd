extends Area2D

@export var bullet_speed : float = 100.0

# 注意释放内存的对象是子弹场景
# 随着游戏运行 子弹场景会逐渐增多 需要及时释放内存 可以在3s后子弹移除场景后释放
func _ready() -> void:
	await get_tree().create_timer(3).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	position += Vector2(bullet_speed, 0) * delta
