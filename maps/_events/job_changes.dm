#define JOB_MODIFICATION_MAP_NAME "Nostromo (Alien)"

/datum/job/captain/New()
	..()
	MAP_JOB_CHECK
	access = list(access_maint_tunnels, access_captain)
	minimal_player_ingame_minutes = 1200
	skillsets = list("Captain" = /datum/skillset/falcon/captain)
	outfit = /datum/outfit/nostromo

/datum/job/doctor/New()
	..()
	MAP_JOB_CHECK
	access = list(access_maint_tunnels, access_medical)
	total_positions = 2
	spawn_positions = 2
	alt_titles = list()
	minimal_player_ingame_minutes = 300
	supervisors = "the captain"
	skillsets = list("Medical Doctor" = /datum/skillset/falcon/doctor)
	outfit = /datum/outfit/nostromo

/datum/job/engineer/New()
	..()
	MAP_JOB_CHECK
	title = "Engineer"
	access = list(access_maint_tunnels, access_engine)
	total_positions = 2
	spawn_positions = 2
	alt_titles = list()
	minimal_player_ingame_minutes = 300
	supervisors = "the captain"
	skillsets = list("Engineer" = /datum/skillset/falcon/engineer)
	outfit = /datum/outfit/nostromo

/datum/job/blueshield/New()
	..()
	MAP_JOB_CHECK
	title = "Pilot"
	access = list(access_maint_tunnels, access_blueshield)
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()
	supervisors = "the captain"
	skillsets = list("Pilot" = /datum/skillset/falcon/officer)
	outfit = /datum/outfit/nostromo

/datum/job/cargo_tech/New()
	..()
	MAP_JOB_CHECK
	access = list(access_maint_tunnels, access_cargo)
	total_positions = 1
	spawn_positions = 1
	minimal_player_ingame_minutes = 300
	supervisors = "the captain"
	skillsets = list("Cargo Technician" = /datum/skillset/falcon/quartermaster)
	outfit = /datum/outfit/nostromo

// ONLY HUMAN CAN PLAY THIS IVENT XENOSI SOSAAAAT
/datum/job/special_species_check(datum/species/S)
	return S.name == HUMAN

MAP_REMOVE_JOB(chief_engineer)

MAP_REMOVE_JOB(atmos)

MAP_REMOVE_JOB(technical_assistant)

MAP_REMOVE_JOB(cyborg)

MAP_REMOVE_JOB(clown)

MAP_REMOVE_JOB(bartender)

MAP_REMOVE_JOB(ai)

MAP_REMOVE_JOB(rd)

MAP_REMOVE_JOB(scientist)

MAP_REMOVE_JOB(research_assistant)

MAP_REMOVE_JOB(mining)

MAP_REMOVE_JOB(qm)

MAP_REMOVE_JOB(chaplain)

MAP_REMOVE_JOB(chef)

MAP_REMOVE_JOB(intern)

MAP_REMOVE_JOB(cmo)

MAP_REMOVE_JOB(cadet)

MAP_REMOVE_JOB(officer)

MAP_REMOVE_JOB(detective)

MAP_REMOVE_JOB(hos)

MAP_REMOVE_JOB(hop)

MAP_REMOVE_JOB(recycler)

MAP_REMOVE_JOB(barber)

MAP_REMOVE_JOB(hydro)

MAP_REMOVE_JOB(janitor)

MAP_REMOVE_JOB(librarian)

MAP_REMOVE_JOB(lawyer)

MAP_REMOVE_JOB(mime)

MAP_REMOVE_JOB(paramedic)

MAP_REMOVE_JOB(chemist)

MAP_REMOVE_JOB(geneticist)

MAP_REMOVE_JOB(virologist)

MAP_REMOVE_JOB(psychiatrist)

MAP_REMOVE_JOB(xenoarchaeologist)

MAP_REMOVE_JOB(xenobiologist)

MAP_REMOVE_JOB(roboticist)

MAP_REMOVE_JOB(warden)

MAP_REMOVE_JOB(forensic)

MAP_REMOVE_JOB(assistant)

#undef JOB_MODIFICATION_MAP_NAME
