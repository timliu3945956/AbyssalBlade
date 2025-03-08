extends Node2D

@onready var lightning_laser: AnimatedSprite2D = $LightningLaser
@onready var lightning_ball: AnimatedSprite2D = $LightningBall
@onready var lightning_ball_inside: AnimatedSprite2D = $LightningBallInside
@onready var lightning_ember: AnimatedSprite2D = $LightningEmber
@onready var lightning_ember_2: AnimatedSprite2D = $LightningEmber2
@onready var lightning_bolts: AnimatedSprite2D = $LightningBolts
@onready var inner_circle_lightning: AnimatedSprite2D = $InnerCircleLightning



#@onready var lightning_ball_collision: CollisionShape2D = $Area2D/LightningBallCollision
@onready var lightning_laser_collision: CollisionShape2D = $Area2D/LightningLaserCollision


func _ready():
	lightning_laser.play("default")
	lightning_ball.play("default")
	lightning_ball_inside.play("default")
	lightning_ember.play("default")
	lightning_ember_2.play("default")
	lightning_bolts.play("default")
	inner_circle_lightning.play("default")
	
	#lightning_ball_collision.disabled = false
	lightning_laser_collision.disabled = false


func _on_lightning_laser_animation_finished() -> void:
	#lightning_ball_collision.disabled = true
	lightning_laser_collision.disabled = true
	self.queue_free()
