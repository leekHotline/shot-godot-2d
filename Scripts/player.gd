extends CharacterBody2D


@export var move_speed : float = 50.0

@export var animator : AnimatedSprite2D

@export var is_game_over : bool = false

#@export var bullet_scenes : PackedScene
@export var normal_bullet_scene  : PackedScene
@export var water_bullet_scene : PackedScene
# 添加两个场景


# 水弹能力的持续时间（秒）
var water_bullet_duration : float = 3.0
# 子弹场景默认是普通的 需要延迟赋值
@onready var current_bullet_scenes : PackedScene = normal_bullet_scene

# 翻滚相关变量
var is_rolling : bool = false
var roll_direction : Vector2 = Vector2.RIGHT
var roll_speed : float = 200.0
var roll_time : float = 1.0

# 静止 游戏中 不应该播放 只有 wsad移动即速度不为零且游戏中时才播放音乐否则暂停
func _process(delta: float) -> void:
	# 水弹能力倒计时
	if water_bullet_duration > 0:
		water_bullet_duration -= delta
		if water_bullet_duration <= 0:
			print("水弹能力结束，变回普通子弹")
			current_bullet_scenes = normal_bullet_scene

	# 当速度不为0或者游戏没有结束时 播放音乐
	if velocity == Vector2.ZERO or is_game_over:
		$RunSound.stop()
	# 如果跑步音效没有播放的话需要播放音乐
	elif not $RunSound.playing:
		$RunSound.play()
		

# 翻滚时间为roll_time
# 向左和向下是正 positive是正
# 由于不同主机的帧率不同 推荐使用固定每秒60帧运行
# 判断速度 如果为0播放待机动画 如果被打击播放受机动画 如果不为零播放奔跑动画
func _physics_process(delta: float) -> void:
	if is_game_over:
		return
	
	# 这是第二步 翻滚位移 并结束
	if is_rolling:
		# 速度需要有方向
		velocity = roll_direction * roll_speed 
		move_and_slide()
		return

	# 这是第一步 按键触发动画
	# 如果按下空格键就翻滚动画 播放动画直接返回 防止动画被覆盖只执行了一帧
	if Input.is_action_just_pressed('roll'):
		is_rolling = true
		animator.play('roll')
		return
	
	# 如果速度不为零 获取方向并修改 normalized就是吧二维向量归一化为长度为一的单位向量只反应方向 velocity(50,0)就是右移50像素
	if velocity != Vector2.ZERO:
		roll_direction = velocity.normalized()

	
	if not is_game_over:
		velocity = Input.get_vector('left','right','up','down') * move_speed
		
			
		#if Input.is_action_just_pressed('roll'):
			#is_rolling = true
			#animator.play('roll')
			

				
		if velocity == Vector2.ZERO:
			animator.play('idle')
		elif velocity != Vector2.ZERO:
			animator.play('run')

		# 这个是实时的移动 如上下左右
		move_and_slide()

# 翻滚就是 位移+方向+动画  速度=位移+方向

	
# 碰撞slime 游戏根节点所有元素刷新
func game_over() -> void:
	if is_game_over:
		# position是位置(0,0) velocity是速度和方向(0,0)
		#velocity = Vector2(0,0)
		return

	# 由于重启游戏会和显示字幕产生冲突 因此要先显示字幕
	get_tree().current_scene.show_go_label()

	if not is_game_over:
	
		is_game_over = true
		animator.play('game_over')
		# 游戏结束的音效只显示一次 不应该先播放再检查 应该先检查游戏是否结束
		$GameOverSound.play()
		# 游戏结束不需要根节点的scenetimer而是普通的timer即可 不然背景图都刷新了
		# 开始倒计时 等待3秒
		$RestartTimer.start()
		#await get_tree().create_timer(3).timeout
		#get_tree().reload_current_scene()
	
# 子弹能力切换到水弹
func switch_bullet_mode() -> void:
	current_bullet_scenes = water_bullet_scene
	water_bullet_duration = 3.0  # 水弹能力持续10秒
	print("获得水弹能力！持续10秒")

# 创建子弹图纸 子弹由position出现
func _on_fire() -> void:
	# 当玩家静止或游戏结束时不能发射子弹
	if velocity != Vector2.ZERO or is_game_over:
		return
	
	$FireSound.play()
	# 将子弹场景替换
	#var bullet_node = bullet_scenes.instantiate()
	var bullet_node = current_bullet_scenes.instantiate()
	bullet_node.position += position + Vector2(17,6)
	get_tree().current_scene.add_child(bullet_node)
	

func _reload_scene() -> void:
	get_tree().reload_current_scene()

# move_and_slide用于控制玩家想着速度velocity方向移动
# get_vector是持续按下有速度 is_action_finished是按下的一瞬间返回true 适合开枪 翻滚 跳跃
func _roll_finished() -> void:
	if animator.animation == 'roll':
		# 播放动画完毕
		is_rolling = false
