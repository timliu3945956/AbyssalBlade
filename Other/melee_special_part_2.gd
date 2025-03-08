extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var inner_circle_lightning: AnimatedSprite2D = $InnerCircleVFX/InnerCircleLightning
@onready var inner_circle_wind: AnimatedSprite2D = $InnerCircleVFX/InnerCircleWind
@onready var middle_circle_lightning: AnimatedSprite2D = $MiddleCircleVFX/MiddleCircleLightning
@onready var middle_circle_wind: AnimatedSprite2D = $MiddleCircleVFX/MiddleCircleWind
@onready var outer_circle_lightning: AnimatedSprite2D = $OuterCircleVFX/OuterCircleLightning
@onready var outer_circle_wind: AnimatedSprite2D = $OuterCircleVFX/OuterCircleWind

@onready var lightning_3: AnimatedSprite2D = $InnerCircleVFX/Lightning3
@onready var lightning_ember_inner_1: AnimatedSprite2D = $InnerCircleVFX/Marker2D/LightningEmber1
@onready var lightning_ember_inner_2: AnimatedSprite2D = $InnerCircleVFX/Marker2D2/LightningEmber1
@onready var lightning_ember_inner_3: AnimatedSprite2D = $InnerCircleVFX/Marker2D3/LightningEmber1
@onready var lightning_ember_inner_4: AnimatedSprite2D = $InnerCircleVFX/Marker2D4/LightningEmber1
@onready var lightning_ember_inner_5: AnimatedSprite2D = $InnerCircleVFX/Marker2D5/LightningEmber1
@onready var lightning_ember_inner_6: AnimatedSprite2D = $InnerCircleVFX/Marker2D6/LightningEmber1

@onready var lightning_middle_1: AnimatedSprite2D = $MiddleCircleVFX/Marker2D/Lightning4
@onready var lightning_middle_2: AnimatedSprite2D = $MiddleCircleVFX/Marker2D2/Lightning4
@onready var lightning_middle_3: AnimatedSprite2D = $MiddleCircleVFX/Marker2D3/Lightning4
@onready var lightning_middle_4: AnimatedSprite2D = $MiddleCircleVFX/Marker2D4/Lightning4
@onready var lightning_middle_5: AnimatedSprite2D = $MiddleCircleVFX/Marker2D5/Lightning4
@onready var lightning_middle_6: AnimatedSprite2D = $MiddleCircleVFX/Marker2D6/Lightning4
@onready var lightning_ember_middle_1: AnimatedSprite2D = $MiddleCircleVFX/EmberMarker1/LightningEmber2
@onready var lightning_ember_middle_2: AnimatedSprite2D = $MiddleCircleVFX/EmberMarker2/LightningEmber2
@onready var lightning_ember_middle_3: AnimatedSprite2D = $MiddleCircleVFX/EmberMarker3/LightningEmber2
@onready var lightning_ember_middle_4: AnimatedSprite2D = $MiddleCircleVFX/EmberMarker4/LightningEmber2
@onready var lightning_ember_middle_5: AnimatedSprite2D = $MiddleCircleVFX/EmberMarker5/LightningEmber2
@onready var lightning_ember_middle_6: AnimatedSprite2D = $MiddleCircleVFX/EmberMarker6/LightningEmber2

@onready var middle_circle_lightning_2: AnimatedSprite2D = $MiddleCircleVFX2/MiddleCircleLightning
@onready var middle_circle_wind_2: AnimatedSprite2D = $MiddleCircleVFX2/MiddleCircleWind
@onready var lightning_second_middle_1: AnimatedSprite2D = $MiddleCircleVFX2/Marker2D/Lightning4
@onready var lightning_second_middle_2: AnimatedSprite2D = $MiddleCircleVFX2/Marker2D2/Lightning4
@onready var lightning_second_middle_3: AnimatedSprite2D = $MiddleCircleVFX2/Marker2D3/Lightning4
@onready var lightning_second_middle_4: AnimatedSprite2D = $MiddleCircleVFX2/Marker2D4/Lightning4
@onready var lightning_second_middle_5: AnimatedSprite2D = $MiddleCircleVFX2/Marker2D5/Lightning4
@onready var lightning_second_middle_6: AnimatedSprite2D = $MiddleCircleVFX2/Marker2D6/Lightning4
@onready var lightning_ember_middle_second_1: AnimatedSprite2D = $MiddleCircleVFX2/EmberMarker1/LightningEmber2
@onready var lightning_ember_middle_second_2: AnimatedSprite2D = $MiddleCircleVFX2/EmberMarker2/LightningEmber2
@onready var lightning_ember_middle_second_3: AnimatedSprite2D = $MiddleCircleVFX2/EmberMarker3/LightningEmber2
@onready var lightning_ember_middle_second_4: AnimatedSprite2D = $MiddleCircleVFX2/EmberMarker4/LightningEmber2
@onready var lightning_ember_middle_second_5: AnimatedSprite2D = $MiddleCircleVFX2/EmberMarker5/LightningEmber2
@onready var lightning_ember_middle_second_6: AnimatedSprite2D = $MiddleCircleVFX2/EmberMarker6/LightningEmber2


@onready var lightning_outer_1: AnimatedSprite2D = $OuterCircleVFX/Marker2D/Lightning4
@onready var lightning_outer_2: AnimatedSprite2D = $OuterCircleVFX/Marker2D2/Lightning4
@onready var lightning_outer_3: AnimatedSprite2D = $OuterCircleVFX/Marker2D3/Lightning4
@onready var lightning_outer_4: AnimatedSprite2D = $OuterCircleVFX/Marker2D4/Lightning4
@onready var lightning_outer_5: AnimatedSprite2D = $OuterCircleVFX/Marker2D5/Lightning4
@onready var lightning_outer_6: AnimatedSprite2D = $OuterCircleVFX/Marker2D6/Lightning4
@onready var lightning_ember_outer_1: AnimatedSprite2D = $OuterCircleVFX/EmberMarker1/LightningEmber3
@onready var lightning_ember_outer_2: AnimatedSprite2D = $OuterCircleVFX/EmberMarker2/LightningEmber3
@onready var lightning_ember_outer_3: AnimatedSprite2D = $OuterCircleVFX/EmberMarker3/LightningEmber3
@onready var lightning_ember_outer_4: AnimatedSprite2D = $OuterCircleVFX/EmberMarker4/LightningEmber3
@onready var lightning_ember_outer_5: AnimatedSprite2D = $OuterCircleVFX/EmberMarker5/LightningEmber3
@onready var lightning_ember_outer_6: AnimatedSprite2D = $OuterCircleVFX/EmberMarker6/LightningEmber3

@onready var outer_collision: CollisionPolygon2D = $Area2D/OuterCollision


func _ready():
	animation_player.play("melee_special_part2")

func inner_melee_special_vfx():
	inner_circle_wind.play("default")
	inner_circle_lightning.play("default")
	lightning_3.play("default")
	lightning_ember_inner_1.play("default")
	lightning_ember_inner_2.play("default")
	lightning_ember_inner_3.play("default")
	lightning_ember_inner_4.play("default")
	lightning_ember_inner_5.play("default")
	lightning_ember_inner_6.play("default")
	
func middle_melee_special_vfx():
	middle_circle_wind.play("default")
	middle_circle_lightning.play("default")
	lightning_middle_1.play("default")
	lightning_middle_2.play("default")
	lightning_middle_3.play("default")
	lightning_middle_4.play("default")
	lightning_middle_5.play("default")
	lightning_middle_6.play("default")
	lightning_ember_middle_1.play("default")
	lightning_ember_middle_2.play("default")
	lightning_ember_middle_3.play("default")
	lightning_ember_middle_4.play("default")
	lightning_ember_middle_5.play("default")
	lightning_ember_middle_6.play("default")
	
func middle_melee_second_special_vfx():
	middle_circle_lightning_2.play("default")
	middle_circle_wind_2.play("default")
	lightning_second_middle_1.play("default")
	lightning_second_middle_2.play("default")
	lightning_second_middle_3.play("default")
	lightning_second_middle_4.play("default")
	lightning_second_middle_5.play("default")
	lightning_second_middle_6.play("default")
	lightning_ember_middle_second_1.play("default")
	lightning_ember_middle_second_2.play("default")
	lightning_ember_middle_second_3.play("default")
	lightning_ember_middle_second_4.play("default")
	lightning_ember_middle_second_5.play("default")
	lightning_ember_middle_second_6.play("default")
	
func outer_melee_special_vfx():
	outer_circle_wind.play("default")
	outer_circle_lightning.play("default")
	lightning_outer_1.play("default")
	lightning_outer_2.play("default")
	lightning_outer_3.play("default")
	lightning_outer_4.play("default")
	lightning_outer_5.play("default")
	lightning_outer_6.play("default")
	lightning_ember_outer_1.play("default")
	lightning_ember_outer_2.play("default")
	lightning_ember_outer_3.play("default")
	lightning_ember_outer_4.play("default")
	lightning_ember_outer_5.play("default")
	lightning_ember_outer_6.play("default")
	outer_collision.disabled = false
	await get_tree().create_timer(0.0833).timeout
	outer_collision.disabled = true


func _on_outer_circle_lightning_animation_finished() -> void:
	queue_free()
