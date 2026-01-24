extends "res://Scripts/bullet.gd"


#var bullet_speed = 200
# 覆盖父类普通子弹的速度
@export var water_bullet_speed = 200.0

# 水弹生效时间 3s
@export var water_duration : float= 2.0

var time_elapsed: float = 0.0  # 已经过的时间
var has_transformed: bool = false  # 是否已经变换过


# 注意释放内存的对象是子弹场景
# 随着游戏运行 子弹场景会逐渐增多 需要及时释放内存 可以在3s后子弹移除场景后释放
func _ready() -> void:
	# 赋值修改覆盖父类子弹的速度，如果是 null 就用默认值
	if water_bullet_speed != null:
		bullet_speed = water_bullet_speed
	else:
		bullet_speed = 200.0

	# 创建计时器，water_duration 秒后变成普通子弹
	var water_timer = get_tree().create_timer(water_duration)
	water_timer.timeout.connect(_on_transform_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	position += Vector2(bullet_speed, 0) * delta

	# 记录经过的时间
	time_elapsed += delta

func _on_transform_timeout() -> void:
	if has_transformed:
		return
		
	has_transformed = true
	
	var bullet_scene = preload("res://Scenes/Bullet.tscn")
	
	var new_bullet = bullet_scene.instantiate()
	new_bullet.global_position = global_position
	
	var parent_node = get_parent()
	parent_node.add_child(new_bullet)
	
	queue_free()
		
