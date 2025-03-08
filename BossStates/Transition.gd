extends State

func transition():
	match owner.timeline:
		0:
			get_parent().change_state("Follow")
		1:
			get_parent().change_state("InOutAttack")
		2:
			get_parent().change_state("Follow")
		3:
			get_parent().change_state("MoveToCenter")
		4:
			get_parent().change_state("Follow")
		5:
			get_parent().change_state("MoveToCenter")
		6:
			get_parent().change_state("Follow")
		7:
			get_parent().change_state("InOutAttack")
		8: 
			get_parent().change_state("Follow")
		9: # Mini-enrage here combo knockback now
			get_parent().change_state("MoveToCenter")
		10:
			get_parent().change_state("Follow")
		11: # Wave of Hatred followed by Enrage
			get_parent().change_state("MoveToCenter")
		12:
			if owner.slash_count % 2 != 0:
				get_parent().change_state("Follow")
			else:
				get_parent().change_state("TopDownCharge")
		13:
			get_parent().change_state("MoveToCenter")
		14:
			if owner.slash_count % 2 != 0:
				get_parent().change_state("Follow")
			else:
				get_parent().change_state("TopDownCharge")
		#11:
			#get_parent().change_state("ComboInOut")
		15:
			get_parent().change_state("MoveToCenter")
		16:
			if owner.slash_count % 2 != 0:
				get_parent().change_state("Follow")
			else:
				get_parent().change_state("TopDownCharge")
		17:
			get_parent().change_state("MoveToCenter")
		#14: #removed enrage and combo inout so these two are removed from timeline
			#get_parent().change_state("Follow")
		#15:
			#get_parent().change_state("MoveToCenter")
