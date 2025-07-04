/* Teleportation devices.
 * Contains:
 *		Locator
 *		Hand-tele
 */

/*
 * Locator
 */
/obj/item/weapon/locator
	name = "locator"
	desc = "Used to track those with locater implants."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	var/temp = null
	var/frequency = 1451
	var/broadcasting = null
	var/listening = 1.0
	flags = CONDUCT
	w_class = SIZE_TINY
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	m_amt = 400
	origin_tech = "magnets=1"

/obj/item/weapon/locator/attack_self(mob/user)
	user.set_machine(src)
	var/dat
	if (src.temp)
		dat = "[src.temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else
		dat = {"
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(src.frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

<A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"}

	var/datum/browser/popup = new(user, "radio", "Persistent Signal Locator")
	popup.set_content(dat)
	popup.open()
	return

/obj/item/weapon/locator/Topic(href, href_list)
	..()
	if (usr.incapacitated())
		return
	var/turf/current_location = get_turf(usr)//What turf is the user on?
	if(!current_location || !SSmapping.has_level(current_location.z) || is_centcom_level(current_location.z) || is_junkyard_level(current_location.z))//If turf was not found or they're on centcom z level.
		to_chat(usr, "The [src] is malfunctioning.")
		return
	if (Adjacent(usr))
		usr.set_machine(src)
		if (href_list["refresh"])
			src.temp = "<B>Persistent Signal Locator</B><HR>"
			var/turf/sr = get_turf(src)

			if (sr)
				src.temp += "<B>Located Beacons:</B><BR>"

				for(var/obj/item/device/radio/beacon/W in radio_beacon_list)
					if (W.frequency == src.frequency)
						var/turf/tr = get_turf(W)
						if (tr.z == sr.z && tr)
							var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									if (direct < 20)
										direct = "weak"
									else
										direct = "very weak"
							src.temp += "[W.code]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>Extranneous Signals:</B><BR>"
				for (var/obj/item/weapon/implant/tracking/W in global.implant_list)
					if (!W.implanted_mob)
						continue

					var/mob/M = W.implanted_mob
					if (M.stat == DEAD)
						if (M.timeofdeath + 6000 < world.time)
							continue

					var/turf/tr = get_turf(W)
					if (tr.z == sr.z && tr)
						var/direct = max(abs(tr.x - sr.x), abs(tr.y - sr.y))
						if (direct < 20)
							if (direct < 5)
								direct = "very strong"
							else
								if (direct < 10)
									direct = "strong"
								else
									direct = "weak"
							src.temp += "[W.id]-[dir2text(get_dir(sr, tr))]-[direct]<BR>"

				src.temp += "<B>You are at \[[COORD(sr)]\]</B> in orbital coordinates.<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A><BR>"
			else
				src.temp += "<B><FONT color='red'>Processing Error:</FONT></B> Unable to locate orbital position.<BR>"
		else
			if (href_list["freq"])
				src.frequency += text2num(href_list["freq"])
				src.frequency = sanitize_frequency(src.frequency)
			else
				if (href_list["temp"])
					src.temp = null
		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					attack_self(M)
	return


/*
 * Hand-tele
 */
/obj/item/weapon/hand_tele
	name = "hand tele"
	desc = "A portable item using bluespace technology."
	icon = 'icons/obj/device.dmi'
	icon_state = "hand_tele"
	item_state = "hand_tele"
	throwforce = 5
	w_class = SIZE_TINY
	throw_speed = 3
	throw_range = 5
	m_amt = 10000
	origin_tech = "magnets=1;bluespace=3"

/obj/item/weapon/hand_tele/attack_self(mob/user)
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='red'>You don't have the dexterity to do this!</span>")
		return
	var/turf/current_location = get_turf(user)//What turf is the user on?
	if(!current_location || !SSmapping.has_level(current_location.z) || is_centcom_level(current_location.z) || is_junkyard_level(current_location.z))//If turf was not found or they're on z level 2 or >7 which does not currently exist.
		to_chat(user, "<span class='notice'>\The [src] is malfunctioning.</span>")
		return
	var/list/L = list(  )
	for(var/obj/machinery/computer/teleporter/com in teleporter_list)
		if(com.target)
			if(is_centcom_level(com.target.z))
				continue
			if(com.power_station && com.power_station.teleporter_hub && com.power_station.engaged)
				L["[com.id] (Active)"] = com.target
			else
				L["[com.id] (Inactive)"] = com.target
	var/list/turfs = list(	)
	for(var/turf/T in orange(10))
		if(T.x>world.maxx-8 || T.x<8)	continue	//putting them at the edge is dumb
		if(T.y>world.maxy-8 || T.y<8)	continue
		turfs += T
	if(turfs.len)
		L["None (Dangerous)"] = pick(turfs)
	var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
	if ((user.get_active_hand() != src || user.incapacitated()))
		return
	var/count = 0	//num of portals from this teleport in world
	for(var/obj/effect/portal/PO in portal_list)
		if(PO.creator == src)	count++
	if(count >= 3)
		to_chat(user, "<span class='notice'>\The [src] is recharging!</span>")
		return
	var/T = L[t1]

	user.audible_message("<span class='notice'>Locked In.</span>") //why not personal audible message?

	var/obj/effect/portal/P = new /obj/effect/portal( get_turf(src) )
	P.target = T
	P.creator = src
	add_fingerprint(user)
	return


