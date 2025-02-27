/obj/effect/landmark
	name = "landmark"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/effect/landmark/singularity_act()
	return

// Please stop bombing the Observer-Start landmark.
/obj/effect/landmark/ex_act()
	return

/obj/effect/landmark/singularity_pull()
	return

INITIALIZE_IMMEDIATE(/obj/effect/landmark)

/obj/effect/landmark/Initialize(mapload)
	. = ..()
	GLOB.landmarks_list += src

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "x"
	anchored = TRUE
	layer = MOB_LAYER
	var/jobspawn_override = FALSE
	var/delete_after_roundstart = TRUE
	var/used = FALSE

/obj/effect/landmark/start/proc/after_round_start()
	if(delete_after_roundstart)
		qdel(src)

/obj/effect/landmark/start/Initialize(mapload)
	. = ..()
	GLOB.start_landmarks_list += src
	if(jobspawn_override)
		LAZYADDASSOCLIST(GLOB.jobspawn_overrides, name, src)
	if(name != "start")
		tag = "start*[name]"

/obj/effect/landmark/start/Destroy()
	GLOB.start_landmarks_list -= src
	if(jobspawn_override)
		LAZYREMOVEASSOC(GLOB.jobspawn_overrides, name, src)
	return ..()

// START LANDMARKS FOLLOW. Don't change the names unless
// you are refactoring shitty landmark code.
/obj/effect/landmark/start/assistant
	name = "Majtek" //Nsv13 - Crayon eaters
	icon_state = "Midshipman" //Nsv13 - Crayon eaters

/obj/effect/landmark/start/assistant/override
	jobspawn_override = TRUE
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/janitor
	name = "Woźny"
	icon_state = "Janitor"

/obj/effect/landmark/start/cargo_technician
	name = "Magazynier"
	icon_state = "Cargo Technician"

/obj/effect/landmark/start/bartender
	name = "Barman"
	icon_state = "Bartender"

/obj/effect/landmark/start/clown
	name = "Klaun"
	icon_state = "Clown"

/obj/effect/landmark/start/mime
	name = "Mim"
	icon_state = "Mime"

/obj/effect/landmark/start/quartermaster
	name = "Kwatermistrz"
	icon_state = "Quartermaster"

/obj/effect/landmark/start/atmospheric_technician
	name = "Inżynier Atmosferyki"
	icon_state = "Atmospheric Technician"

/obj/effect/landmark/start/cook
	name = "Kucharz"
	icon_state = "Cook"

/obj/effect/landmark/start/shaft_miner
	name = "Górnik"
	icon_state = "Shaft Miner"

/obj/effect/landmark/start/exploration
	name = "Odkrywca"
	icon_state = "Exploration Crew"

/obj/effect/landmark/start/security_officer
	name = "Żandarm" //Nsv13 - Crayon eaters & MPs
	icon_state = "Military Police" //Nsv13 - Crayon eaters & MPs

/obj/effect/landmark/start/botanist
	name = "Botanik"
	icon_state = "Botanist"

/obj/effect/landmark/start/head_of_security
	name = "Komendant"
	icon_state = "Head of Security"

/obj/effect/landmark/start/captain
	name = "Kapitan"
	icon_state = "Captain"

/obj/effect/landmark/start/detective
	name = "Detektyw"
	icon_state = "Detective"

/obj/effect/landmark/start/warden
	name = "Naczelnik"
	icon_state = "Warden"

/obj/effect/landmark/start/chief_engineer
	name = "Główny Inżynier"
	icon_state = "Chief Engineer"

/obj/effect/landmark/start/head_of_personnel
	name = "Starszy Oficer"
	icon_state = "Head of Personnel"

/obj/effect/landmark/start/librarian
	name = "Bibliotekarz"
	icon_state = "Curator"

/obj/effect/landmark/start/lawyer
	name = "Prawnik"
	icon_state = "Lawyer"

/obj/effect/landmark/start/station_engineer
	name = "Inżynier"
	icon_state = "Station Engineer"

/obj/effect/landmark/start/medical_doctor
	name = "Lekarz"
	icon_state = "Medical Doctor"

/obj/effect/landmark/start/paramedic
	name = "Ratownik Medyczny"
	icon_state = "Medical Doctor"

/obj/effect/landmark/start/scientist
	name = "Naukowiec"
	icon_state = "Scientist"

/obj/effect/landmark/start/chemist
	name = "Chemik"
	icon_state = "Chemist"

/obj/effect/landmark/start/roboticist
	name = "Robotyk"
	icon_state = "Roboticist"

/obj/effect/landmark/start/research_director
	name = "Dyrektor Naukowy"
	icon_state = "Research Director"

/obj/effect/landmark/start/geneticist
	name = "Genetyk"
	icon_state = "Geneticist"

/obj/effect/landmark/start/chief_medical_officer
	name = "Ordynator"
	icon_state = "Chief Medical Officer"

/obj/effect/landmark/start/virologist
	name = "Wirolog"
	icon_state = "Virologist"

/obj/effect/landmark/start/chaplain
	name = "Kapłan"
	icon_state = "Chaplain"

/obj/effect/landmark/start/cyborg
	name = "Cyborg"
	icon_state = "Cyborg"

/obj/effect/landmark/start/ai
	name = "SI Statku"
	icon_state = "AI"
	delete_after_roundstart = FALSE
	var/primary_ai = TRUE
	var/latejoin_active = TRUE

/obj/effect/landmark/start/ai/after_round_start()
	if(latejoin_active && !used)
		new /obj/structure/AIcore/latejoin_inactive(loc)
	return ..()

/obj/effect/landmark/start/ai/secondary
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "ai_spawn"
	primary_ai = FALSE
	latejoin_active = FALSE

/obj/effect/landmark/start/brig_physician
	name = "Medyk Więzienny"

/obj/effect/landmark/start/randommaint
	name = "maintjobstart"
	icon_state = "x3"
	var/job = "Gimmick" //put the title of the job here.

/obj/effect/landmark/start/randommaint/New() //automatically opens up a job slot when the job's spawner loads in
	..()
	var/datum/job/J = SSjob.GetJob(job)
	J.total_positions += 1
	J.spawn_positions += 1

/obj/effect/landmark/start/randommaint/backalley_doc
	name = "Fryzjer"
	job = JOB_NAME_BARBER

/obj/effect/landmark/start/randommaint/magician
	name = "Magik"
	job = JOB_NAME_STAGEMAGICIAN

/obj/effect/landmark/start/randommaint/psychiatrist
	name = "Psychiatra"
	job = JOB_NAME_PSYCHIATRIST

/obj/effect/landmark/start/randommaint/vip
	name = "VIP"
	job = JOB_NAME_VIP

/obj/effect/landmark/start/randommaint/experiment
	name = "Experiment"
	job = "Experiment"

//Department Security spawns

/obj/effect/landmark/start/depsec
	name = "department_sec"
	icon_state = "Military Police" //Nsv13 - Crayon eaters & MPs

/obj/effect/landmark/start/depsec/Initialize(mapload)
	. = ..()
	GLOB.department_security_spawns += src

/obj/effect/landmark/start/depsec/Destroy()
	GLOB.department_security_spawns -= src
	return ..()

/obj/effect/landmark/start/depsec/supply
	name = "supply_sec"

/obj/effect/landmark/start/depsec/medical
	name = "medical_sec"

/obj/effect/landmark/start/depsec/engineering
	name = "engineering_sec"

/obj/effect/landmark/start/depsec/science
	name = "science_sec"

//Antagonist spawns

/obj/effect/landmark/start/wizard
	name = "wizard"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "wiznerd_spawn"

/obj/effect/landmark/start/wizard/Initialize(mapload)
	..()
	GLOB.wizardstart += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/nukeop
	name = "nukeop"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_spawn"

/obj/effect/landmark/start/nukeop/Initialize(mapload)
	..()
	GLOB.nukeop_start += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/nukeop_leader
	name = "nukeop leader"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_leader_spawn"

/obj/effect/landmark/start/nukeop_leader/Initialize(mapload)
	..()
	GLOB.nukeop_leader_start += loc
	return INITIALIZE_HINT_QDEL

// Must be immediate because players will
// join before SSatom initializes everything.
INITIALIZE_IMMEDIATE(/obj/effect/landmark/start/new_player)

/obj/effect/landmark/start/new_player
	name = "New Player"

/obj/effect/landmark/start/new_player/Initialize(mapload)
	..()
	GLOB.newplayer_start += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/latejoin
	name = "JoinLate"

/obj/effect/landmark/latejoin/Initialize(mapload)
	..()
	SSjob.latejoin_trackers += loc
	return INITIALIZE_HINT_QDEL

//space carps, magicarps, lone ops, slaughter demons, possibly revenants spawn here
/obj/effect/landmark/carpspawn
	name = "carpspawn"
	icon_state = "carp_spawn"

//observer start
/obj/effect/landmark/observer_start
	name = "Observer-Start"
	icon_state = "observer_start"

//xenos, morphs and nightmares spawn here
/obj/effect/landmark/xeno_spawn
	name = "xeno_spawn"
	icon_state = "xeno_spawn"

/obj/effect/landmark/xeno_spawn/Initialize(mapload)
	..()
	GLOB.xeno_spawn += loc
	return INITIALIZE_HINT_QDEL

//objects with the stationloving component (nuke disk) respawn here.
//also blobs that have their spawn forcemoved (running out of time when picking their spawn spot), santa and respawning devils
/obj/effect/landmark/blobstart
	name = "blobstart"
	icon_state = "blob_start"

/obj/effect/landmark/blobstart/Initialize(mapload)
	..()
	GLOB.blobstart += loc
	return INITIALIZE_HINT_QDEL

//spawns sec equipment lockers depending on the number of sec officers
/obj/effect/landmark/secequipment
	name = "secequipment"
	icon_state = "secequipment"

/obj/effect/landmark/secequipment/Initialize(mapload)
	..()
	GLOB.secequipment += loc
	return INITIALIZE_HINT_QDEL

//players that get put in admin jail show up here
/obj/effect/landmark/prisonwarp
	name = "prisonwarp"
	icon_state = "prisonwarp"

/obj/effect/landmark/prisonwarp/Initialize(mapload)
	..()
	GLOB.prisonwarp += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/ert_spawn
	name = "Emergencyresponseteam"
	icon_state = "ert_spawn"

/obj/effect/landmark/ert_spawn/Initialize(mapload)
	..()
	GLOB.emergencyresponseteamspawn += loc
	return INITIALIZE_HINT_QDEL

//ninja energy nets teleport victims here
/obj/effect/landmark/holding_facility
	name = "Holding Facility"
	icon_state = "holding_facility"

/obj/effect/landmark/holding_facility/Initialize(mapload)
	..()
	GLOB.holdingfacility += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/observe
	name = "tdomeobserve"
	icon_state = "tdome_observer"

/obj/effect/landmark/thunderdome/observe/Initialize(mapload)
	..()
	GLOB.tdomeobserve += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/one
	name = "tdome1"
	icon_state = "tdome_t1"

/obj/effect/landmark/thunderdome/one/Initialize(mapload)
	..()
	GLOB.tdome1	+= loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/two
	name = "tdome2"
	icon_state = "tdome_t2"

/obj/effect/landmark/thunderdome/two/Initialize(mapload)
	..()
	GLOB.tdome2 += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome/admin
	name = "tdomeadmin"
	icon_state = "tdome_admin"

/obj/effect/landmark/thunderdome/admin/Initialize(mapload)
	..()
	GLOB.tdomeadmin += loc
	return INITIALIZE_HINT_QDEL

//Servant spawn locations
/obj/effect/landmark/servant_of_ratvar
	name = "servant of ratvar spawn"
	icon_state = "clockwork_orange"
	layer = MOB_LAYER

/obj/effect/landmark/servant_of_ratvar/Initialize(mapload)
	..()
	GLOB.servant_spawns += loc
	return INITIALIZE_HINT_QDEL

//City of Cogs entrances
/obj/effect/landmark/city_of_cogs
	name = "city of cogs entrance"
	icon_state = "city_of_cogs"

/obj/effect/landmark/city_of_cogs/Initialize(mapload)
	..()
	GLOB.city_of_cogs_spawns += loc
	return INITIALIZE_HINT_QDEL

//handles clockwork portal+eminence teleport destinations
/obj/effect/landmark/event_spawn
	name = "generic event spawn"
	icon_state = "generic_event"
	layer = HIGH_LANDMARK_LAYER


/obj/effect/landmark/event_spawn/Initialize(mapload)
	. = ..()
	GLOB.generic_event_spawns += src

/obj/effect/landmark/event_spawn/Destroy()
	GLOB.generic_event_spawns -= src
	return ..()

/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/Initialize(mapload, my_ruin_template)
	. = ..()
	name = "ruin_[GLOB.ruin_landmarks.len + 1]"
	ruin_template = my_ruin_template
	GLOB.ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
	GLOB.ruin_landmarks -= src
	ruin_template = null
	. = ..()

/// Marks the bottom left of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_bottom_left
	name = "unit test zone bottom left"

/// Marks the top right of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_top_right
	name = "unit test zone top right"

/obj/effect/spawner/hangover_spawn
	name = "hangover spawner"

/obj/effect/spawner/hangover_spawn/Initialize(mapload)
	..()
	if(prob(60))
		new /obj/effect/decal/cleanable/vomit(get_turf(src))
	if(prob(70))
		var/bottle_count = pick(10;1, 5;2, 2;3)
		for(var/index in 1 to bottle_count)
			var/obj/item/reagent_containers/food/drinks/beer/almost_empty/B = new(get_turf(src))
			B.pixel_x += rand(-6, 6)
			B.pixel_y += rand(-6, 6)
	return INITIALIZE_HINT_QDEL
