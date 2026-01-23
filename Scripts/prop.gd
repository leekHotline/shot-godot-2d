extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# slime由于需要和玩家交互用body_enter,slime和子弹交互用area_enter,但是这个prop只需要和玩家交互，就是body_entered
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _prop_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D :
		# 玩家body碰撞物体 播放音效 并获得buffer增益
		print("hit prop")
		$PropSound.play()
		$AnimatedSprite2D.visible = false
		Global.score_board += 10
		#释放道具
		
