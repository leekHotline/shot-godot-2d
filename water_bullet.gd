extends "res://Scripts/bullet.gd"

# 水弹速度（覆盖父类的速度）
@export var water_bullet_speed = 200.0

# 注意释放内存的对象是子弹场景
# 随着游戏运行 子弹场景会逐渐增多 需要及时释放内存 可以在3s后子弹移除场景后释放
func _ready() -> void:
	# 赋值修改覆盖父类子弹的速度
	if water_bullet_speed != null:
		bullet_speed = water_bullet_speed
	else:
		bullet_speed = 200.0

	print("水弹创建！速度:", bullet_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(bullet_speed, 0) * delta
