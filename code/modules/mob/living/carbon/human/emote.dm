/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "płacze"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/dap
	key = "dap"
	key_third_person = "daps"
	message = "Niestety nie ma z kim przybić żółwika i przybija żółwika sam ze sobą. Szkoda"
	message_param = "przybija żółwika z %t"
	restraint_check = TRUE

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "unosi brew"

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "marudzi"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "uściska własną dłoń"
	message_param = "ściska dłonie z %t"
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/hug
	key = "hug"
	key_third_person = "hugs"
	message = "przytula siebie"
	message_param = "przytula %t"
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "mamrocze"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/scream
	key = "scream"
	key_third_person = "screams"
	message = "krzyczy"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/carbon/human/scream/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.mind?.miming)
		return
	if(ishumanbasic(H) || iscatperson(H))
		if(user.gender == FEMALE)
			return pick('sound/voice/human/femalescream_1.ogg', 'sound/voice/human/femalescream_2.ogg', 'sound/voice/human/femalescream_3.ogg', 'sound/voice/human/femalescream_4.ogg')
		else
			return pick('sound/voice/human/malescream_1.ogg', 'sound/voice/human/malescream_2.ogg', 'sound/voice/human/malescream_3.ogg', 'sound/voice/human/malescream_4.ogg', 'sound/voice/human/malescream_5.ogg')
	else if(ismoth(H))
		return 'sound/voice/moth/scream_moth.ogg'
	else if(islizard(H))
		return pick('sound/voice/lizard/lizard_scream_1.ogg', 'sound/voice/lizard/lizard_scream_2.ogg', 'sound/voice/lizard/lizard_scream_3.ogg', 'sound/voice/lizard/lizard_scream_4.ogg')
	else if isethereal(H)
		return pick('aquila/sound/voice/ethereal/ethereal_scream_1.ogg', 'aquila/sound/voice/ethereal/ethereal_scream_2.ogg', 'aquila/sound/voice/ethereal/ethereal_scream_3.ogg') //AQ EDIT

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "blednie"

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	message = "podnosi dłoń"
	restraint_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "salutes"
	message_param = "salutuje do %t"
	restraint_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "wzrusza ramionami"

/datum/emote/living/carbon/human/wag
	key = "wag"
	key_third_person = "wags"
	message = "macha ogonem"

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/tail/tail = H?.getorganslot(ORGAN_SLOT_TAIL)
	if(!tail)
		return
	tail.toggle_wag(H)

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	return istype(H?.getorganslot(ORGAN_SLOT_TAIL), /obj/item/organ/tail)

/datum/emote/living/carbon/human/wag/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
	if(tail?.is_wagging(H))
		. = null

/datum/emote/living/carbon/human/wing
	key = "wing"
	key_third_person = "wings"
	message = "their wings"

/datum/emote/living/carbon/human/wing/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = user
		H.Togglewings()

/datum/emote/living/carbon/human/wing/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(("wings" in H.dna.species.mutant_bodyparts) || ("moth_wings" in H.dna.species.mutant_bodyparts))
		. = "opens " + message
	else
		. = "closes " + message

/datum/emote/living/carbon/human/wing/can_run_emote(mob/user, status_check = TRUE, intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.dna && H.dna.species)
		if(H.dna.features["wings"] != "None")
			return TRUE
		if(H.dna.features["moth_wings"] != "None")
			var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
			if(istype(wings))
				if(wings.flight_level >= WINGS_FLYING)
					return TRUE

/mob/living/carbon/human/proc/Togglewings()
	if(!dna || !dna.species)
		return FALSE
	var/obj/item/organ/wings/wings = getorganslot(ORGAN_SLOT_WINGS)
	if(istype(wings))
		if(wings.toggleopen(src))
			return TRUE
	return FALSE


/*/datum/emote/living/carbon/human/fart //AQUILA EDIT
	key = "fart"
	key_third_person = "farts"
	message = "farts"
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/carbon/human/fart/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	return 'sound/misc/fart1.ogg'
*/ //AQUILA EDIT
//Ayy lmao

// Robotic Tongue emotes. Beep!

/datum/emote/living/carbon/human/robot_tongue/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/obj/item/organ/tongue/T = user.getorganslot("tongue")
	if(T.status == ORGAN_ROBOTIC)
		return TRUE

/datum/emote/living/carbon/human/robot_tongue/beep
	key = "beep"
	key_third_person = "beeps"
	message = "beeps"
	message_param = "beeps at %t"

/datum/emote/living/carbon/human/robot_tongue/beep/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/machines/twobeep.ogg', 50)

/datum/emote/living/carbon/human/robot_tongue/buzz
	key = "buzz"
	key_third_person = "buzzes"
	message = "brzęczy"
	message_param = "brzęczy na %t"

/datum/emote/living/carbon/human/robot_tongue/buzz/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/machines/buzz-sigh.ogg', 50)

/datum/emote/living/carbon/human/robot_tongue/buzz2
	key = "buzz2"
	message = "brzęczy dwukrotnie"

/datum/emote/living/carbon/human/robot_tongue/buzz2/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/machines/buzz-two.ogg', 50)

/datum/emote/living/carbon/human/robot_tongue/chime
	key = "chime"
	key_third_person = "chimes"
	message = "dzwoni"

/datum/emote/living/carbon/human/robot_tongue/chime/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/machines/chime.ogg', 50)

/datum/emote/living/carbon/human/robot_tongue/ping
	key = "ping"
	key_third_person = "pings"
	message = "brzdęka"
	message_param = "brzdęka na %t"

/datum/emote/living/carbon/human/robot_tongue/ping/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/machines/ping.ogg', 50)

 // Clown Robotic Tongue ONLY. Henk.

/datum/emote/living/carbon/human/robot_tongue/clown/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	if(user.mind.assigned_role == JOB_NAME_CLOWN)
		return TRUE

/datum/emote/living/carbon/human/robot_tongue/clown/honk
	key = "honk"
	key_third_person = "honks"
	message = "trąbi"

/datum/emote/living/carbon/human/robot_tongue/clown/honk/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/items/bikehorn.ogg', 50)

/datum/emote/living/carbon/human/robot_tongue/clown/sad
	key = "sad"
	key_third_person = "plays a sad trombone"
	message = "wydaje z siebie dźwięk smutnego puzonu"

/datum/emote/living/carbon/human/robot_tongue/clown/sad/run_emote(mob/user, params)
	if(..())
		playsound(user.loc, 'sound/misc/sadtrombone.ogg', 50)
