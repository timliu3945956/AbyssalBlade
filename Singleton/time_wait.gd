extends Node

const USEC_PER_MSEC := 1_000
const USEC_PER_SEC := 1_000_000

func wait_usec(us: int) -> void:
	var deadline := Time.get_ticks_usec() + us
	while Time.get_ticks_usec() < deadline:
		await get_tree().physics_frame
		
func wait_msec(ms: int) -> void:
	await wait_usec(ms * USEC_PER_MSEC)
	
func wait_sec(sec: float) -> void:
	await wait_usec(int(sec * USEC_PER_SEC))
