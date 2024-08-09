/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion
	name = "insectoid"
	desc = "Большой космический жук, исконный обитатель этого астероида."
	icon = 'icons/mob/monsters.dmi'
	icon_state = "Scorpion"
	icon_living = "Scorpion"
	icon_aggro = "Scorpion_alert"
	icon_dead = "Scorpion_dead"
	icon_gib = "syndicate_gib"
	move_to_delay = 20
	throw_message = "does nothing against the hard shell of"
	vision_range = 2
	speed = -1
	maxHealth = 200
	health = 200
	harm_intent_damage = 5
	melee_damage = 5
	attacktext = "gnaw"
	attack_sound = list('sound/weapons/bladeslice.ogg')
	aggro_vision_range = 9
	idle_vision_range = 2
	sight = SEE_MOBS
	see_in_dark = 6
	w_class = SIZE_LARGE
	pull_size_ratio = 1
	environment_smash = 1
	var/underground = FALSE
	var/last_trap = 0
	var/trap_cooldown = 20 SECONDS
	var/scarab_amount = 0
	var/worm_amount = 0

/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/atom_init()
	. = ..()
	set_lighting_alpha(LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)

	verbs.Add(/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/proc/dig,
		/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/proc/set_groundtrap,
		/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/proc/set_rocktrap,
		/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/proc/summon_scarabs)

	var/datum/action/dig = new /datum/action/innate/insectoid/dig_underground(src)
	var/datum/action/trap = new /datum/action/innate/insectoid/set_trap(src)
	dig.Grant(src)
	trap.Grant(src)

/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/ex_act(severity)
	switch(severity)
		if(EXPLODE_DEVASTATE) // Bombs won't help
			adjustBruteLoss(maxHealth * 0.5)
		if(EXPLODE_HEAVY)
			adjustBruteLoss(maxHealth * 0.2)

/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/proc/dig()
	set name = "Dig Underground"
	set desc = "Закопайтесь под землю."
	set category = "Insectoid"

	if(istype(get_turf(src), /turf/simulated/floor/plating/airless/asteroid))
		var/obj/effect/E = new /obj/effect/insectoid_dig(src.loc)
		if(do_after(src, 2 SECONDS, target = src))
			underground = !underground
			if(underground)
				alpha = 0
				speed = 1
				invisibility = INVISIBILITY_LEVEL_ONE
			else
				alpha = initial(alpha)
				speed = initial(speed)
				invisibility = initial(invisibility)
		qdel(E)

/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/proc/summon_scarabs()
	set name = "Summon Scarabs"
	set desc = "Призвать скарабеев."
	set category = "Insectoid"

	if(can_settrap() && scarab_amount <= 6)
		var/list/around = orange(src, 1)
		var/list/turfs = list()
		for(var/turf/simulated/floor/plating/airless/asteroid/T in around)
			turfs += T

		if(turfs.len)
			for(var/i in 1 to 3)
				var/turf/T = pick(turfs)
				var/obj/effect/E = new /obj/effect/insectoid_dig(T)
				if(do_after(src, 1 SECONDS, target = T))
					new /mob/living/simple_animal/hostile/asteroid/insectoid/minion/scarab(T, src)
				qdel(E)

/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/proc/set_groundtrap()
	set name = "Set Groundtrap"
	set desc = "Соорудите ловушку в земле."
	set category = "Insectoid"

	if(can_settrap())
		var/obj/effect/E = new /obj/effect/insectoid_dig(src.loc)
		if(do_after(src, 3 SECONDS, target = src))
			new /obj/item/mine/insectoid(src.loc)
			last_trap = world.time
		qdel(E)

/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/proc/set_rocktrap(O in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Set Rocktrap"
	set desc = "Соорудите ловушку в каменной породе."
	set category = "Insectoid"

	if(can_settrap())
		if(O in oview(1))
			if(istype(O, /turf/simulated/mineral))
				var/turf/simulated/mineral/M = O
				var/obj/effect/E = new /obj/effect/insectoid_dig(M.loc)
				if(do_after(src, 3 SECONDS, target = src))
					M.set_trap()
					last_trap = world.time
				qdel(E)

/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/proc/can_settrap()
	if(underground)
		to_chat(src, "<span class='notice'>Вы не можете делать это, находясь под землёй.</span>")
		return FALSE
	if(!istype(get_turf(src), /turf/simulated/floor/plating/airless/asteroid))
		to_chat(src, "<span class='notice'>Вы не можете делать это не на родной земле астероида.</span>")
		return FALSE
	if(world.time < last_trap + trap_cooldown)
		to_chat(src, "<span class='notice'>Время ещё не пришло.</span>")
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/Bump(atom/A)
	. = ..()
	if(A == loc)
		return
	if(underground && istype(A, /turf/simulated/mineral))
		forceMove(A)

/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/Move(NewLoc) // can crawl under the ground and rocks
	if(underground && !(istype(NewLoc, /turf/simulated/floor/plating/airless/asteroid) || istype(NewLoc, /turf/simulated/mineral)))
		return FALSE
	else
		var/turf/T = NewLoc
		for(var/atom/A in T.contents)
			if(A.density)
				return FALSE
	. = ..()

/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/start_pulling(atom/movable/AM)
	if(underground)
		return
	. = ..()

/obj/effect/insectoid_dig
	name = "Insectoid Dig"

/obj/item/mine/insectoid
	anchored = TRUE

/obj/item/mine/insectoid/try_trigger(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.visible_message("<span class='danger'>[H] steps on [src]!</span>")
		trigger_act(H)
		qdel(src)
	if(istype(AM, /obj/mecha))
		qdel(src)

/obj/item/mine/insectoid/trigger_act(mob/living/carbon/human/H)
	H.flash_eyes()
	H.adjustBruteLoss(50)

/obj/item/mine/insectoid/bullet_act(obj/item/projectile/Proj, def_zone)
	return

/obj/item/mine/insectoid/try_disarm(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/shovel))
		user.visible_message("<span class='notice'>[user] starts disarming [src].</span>", "<span class='notice'>You start disarming [src].</span>")
		if(I.use_tool(src, user, 40, volume = 50))
			user.visible_message("<span class='notice'>[user] finishes disarming [src].</span>", "<span class='notice'>You finish disarming [src].</span>")
			qdel(src)


/datum/action/innate/insectoid
	check_flags = AB_CHECK_ALIVE

/datum/action/innate/insectoid/Grant(mob/T)
	if(!istype(T, /mob/living/simple_animal/hostile/asteroid/insectoid/scorpion))
		qdel(src)
		return
	. = ..()

/datum/action/innate/insectoid/dig_underground
	name = "Закопаться под землю"
	button_icon = 'icons/turf/asteroid.dmi'
	button_icon_state = "asteroid_dug"

/datum/action/innate/insectoid/dig_underground/Activate()
	if(istype(owner, /mob/living/simple_animal/hostile/asteroid/insectoid/scorpion))
		var/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/I = owner
		I.dig()

/datum/action/innate/insectoid/summon_scarabs
	name = "Закопаться под землю"
	button_icon = 'icons/turf/asteroid.dmi'
	button_icon_state = "asteroid_dug"

/datum/action/innate/insectoid/dig_underground/Activate()
	if(istype(owner, /mob/living/simple_animal/hostile/asteroid/insectoid/scorpion))
		var/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/I = owner
		I.dig()

/datum/action/innate/insectoid/set_trap
	name = "Соорудить ловушку"
	button_icon = 'icons/obj/items.dmi'
	button_icon_state = "beartrap1"

/datum/action/innate/insectoid/set_trap/Activate()
	if(istype(owner, /mob/living/simple_animal/hostile/asteroid/insectoid/scorpion))
		var/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/I = owner
		I.set_groundtrap()

/mob/living/simple_animal/hostile/asteroid/insectoid/minion
	var/mob/living/simple_animal/hostile/asteroid/insectoid/scorpion/parent = null

/mob/living/simple_animal/hostile/asteroid/insectoid/minion/atom_init(mapload, var/mob/M)
	. = ..()
	parent = M

/mob/living/simple_animal/hostile/asteroid/insectoid/minion/scarab
	name = "scarab"
	desc = "Маленький и очень агрессивный космический скарабей."
	icon = 'icons/mob/monsters.dmi'
	icon_state = "Hivelordbrood"
	icon_living = "Hivelordbrood"
	icon_aggro = "Hivelordbrood"
	icon_dead = "Hivelordbrood"
	icon_gib = "syndicate_gib"
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	move_to_delay = 0
	friendly = "buzzes near"
	vision_range = 10
	speed = 1
	maxHealth = 1
	health = 1
	harm_intent_damage = 5
	melee_damage = 4
	attacktext = "slash"
	throw_message = "falls right through the strange body of the"
	environment_smash = 0
	pass_flags = PASSTABLE
