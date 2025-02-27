/obj/effect/proc_holder/spell
	var/gain_desc
	var/blood_used = 0
	var/vamp_req = FALSE

/obj/effect/proc_holder/spell/cast_check(skipcharge = 0, mob/user = usr)
	if(vamp_req)
		if(!is_vampire(user))
			return FALSE
		var/datum/antagonist/vampire/V = user.mind.has_antag_datum(/datum/antagonist/vampire)
		if(!V)
			return FALSE
		if(V.usable_blood < blood_used)
			to_chat(user, "<span class='warning'>You do not have enough blood to cast this!</span>")
			return FALSE
	. = ..(skipcharge, user)

/obj/effect/proc_holder/spell/Initialize()
	. = ..()
	if(vamp_req)
		clothes_req = FALSE
		range = 1
		human_req = FALSE //so we can cast stuff while a bat, too


/obj/effect/proc_holder/spell/before_cast(list/targets)
	. = ..()
	if(vamp_req)
		// sanity check before we cast
		if(!is_vampire(usr))
			targets.Cut()
			return

		if(!blood_used)
			return

		// enforce blood
		var/datum/antagonist/vampire/vampire = usr.mind.has_antag_datum(/datum/antagonist/vampire)

		if(blood_used <= vampire.usable_blood)
			vampire.usable_blood -= blood_used
		else
			// stop!!
			targets.Cut()

		if(LAZYLEN(targets))
			to_chat(usr, "<span class='notice'><b>You have [vampire.usable_blood] left to use.</b></span>")


/obj/effect/proc_holder/spell/can_target(mob/living/target)
	. = ..()
	if(!istype(target) || (vamp_req && is_vampire(target)))
		return FALSE
/datum/vampire_passive
	var/gain_desc

/datum/vampire_passive/New()
	..()
	if(!gain_desc)
		gain_desc = "You have gained \the [src] ability."


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/vampire_passive/nostealth
	gain_desc = "You are no longer able to conceal yourself while sucking blood."

/datum/vampire_passive/regen
	gain_desc = "Your rejuvenation abilities have improved and will now heal you over time when used."

/datum/vampire_passive/vision
	gain_desc = "Your vampiric vision has improved."

/datum/vampire_passive/full
	gain_desc = "You have reached your full potential and are no longer weak to the effects of anything holy and your vision has been improved greatly."

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/vampire_help
	name = "How to suck blood 101"
	desc = "Explains how the vampire blood sucking system works."
	action_icon_state = "bloodymaryglass"
	action_icon = 'icons/obj/drinks.dmi'
	action_background_icon_state = "bg_demon"
	charge_max = 0
	vamp_req = TRUE //YES YOU NEED TO BE A VAMPIRE TO KNOW HOW TO BE A VAMPIRE SHOCKING

/obj/effect/proc_holder/spell/self/vampire_help/cast(list/targets, mob/user = usr)
	to_chat(user, "<span class='notice'>Możesz spożywać krew żywych, humanoidalnych istot poprzez <b>uderzenie ich w głowę, mając włączoną intencje krzywdzenia/b>. To <i>ZAALARMUJE</i> każdego kto zdoła to zauważyć, oraz wyda dźwięk, który jest słyszalny w odległości <b>trzech metrów</b>. Pamiętaj, że <b>nie możesz</b> pobierać krwi z <b>katatonicznych osób ani zwłok</b>.\n\
            Twoja prędkość ssania zależy od siły chwytu. Możesz <i>potajemnie</i> wysysać krew, rozpoczynając ten proces bez chwytu, jednakże wysysasz więcej krwi na cykl ssania, <b>mając chwyt za szyje lub mocniejszy</b>. Obydwie te metody modyfikują ilość pobieranej krwi o 50%; zmniejszona przy metodzie dyskretnej, więcej przy siłowej.</span>")

/obj/effect/proc_holder/spell/self/rejuvenate
	name = "Rejuvenate"
	desc= "Flush your system with spare blood to repair minor damage to your body."
	action_icon_state = "rejuv"
	charge_max = 200
	stat_allowed = 1
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_background_icon_state = "bg_demon"
	vamp_req = TRUE

/obj/effect/proc_holder/spell/self/rejuvenate/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/U = user
	U.stuttering = 0

	var/datum/antagonist/vampire/V = U.mind.has_antag_datum(/datum/antagonist/vampire)
	if(!V) //sanity check
		return
	for(var/i = 1 to 5)
		U.adjustStaminaLoss(-50)
		if(V.get_ability(/datum/vampire_passive/regen))
			U.adjustBruteLoss(-1)
			U.adjustOxyLoss(-2.5)
			U.adjustToxLoss(-1, TRUE, TRUE)
			U.adjustFireLoss(-1)
		sleep(7.5)


/obj/effect/proc_holder/spell/pointed/gaze
	name = "Vampiric Gaze"
	desc = "Paralyze your target with fear."
	charge_max = 300
	action_icon_state = "gaze"
	active_msg = "You prepare your vampiric gaze.</span>"
	deactive_msg = "You stop preparing your vampiric gaze.</span>"
	vamp_req = TRUE
	ranged_mousepointer = 'aquila/icons/effects/mouse_pointers/gaze_target.dmi'
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_background_icon_state = "bg_demon"

/obj/effect/proc_holder/spell/pointed/gaze/can_target(atom/target, mob/user, silent)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(target))
		to_chat(user, "<span class='warning'>Gaze will not work on this being.</span>")
		return FALSE
	var/mob/living/carbon/human/T = target

	if(T.stat == DEAD)
		to_chat(user,"<span class='warning'>You cannot gaze at corpses... \
			or maybe you could if you really wanted to.</span>")
		return FALSE

/obj/effect/proc_holder/spell/pointed/gaze/cast(list/targets, mob/user)
	var/mob/living/target = targets[1]
	var/mob/living/carbon/human/T = target
	user.visible_message("<span class='warning'>[user]'s eyes flash red.</span>",\
					"<span class='warning'>[user]'s eyes flash red.</span>")
	if(ishuman(target))
		var/obj/item/clothing/glasses/G = T.glasses
		if(G)
			if(G.flash_protect)
				to_chat(user,"<span class='warning'>[T] has protective sunglasses on!</span>")
				to_chat(target, "<span class='warning'>[user]'s paralyzing gaze is blocked by your [G]!</span>")
				return
		var/obj/item/clothing/mask/M = T.wear_mask
		if(M)
			if(M.flash_protect)
				to_chat(user,"<span class='warning'>[T]'s mask is covering their eyes!</span>")
				to_chat(target,"<span class='warning'>[user]'s paralyzing gaze is blocked by your [M]!</span>")
				return
		var/obj/item/clothing/head/H = T.head
		if(H)
			if(H.flash_protect)
				to_chat(user, "<span class='vampirewarning'>[T]'s helmet is covering their eyes!</span>")
				to_chat(target, "<span class='warning'>[user]'s paralyzing gaze is blocked by [H]!</span>")
				return
		to_chat(target,"<span class='warning'>You are paralyzed with fear!</span>")
		to_chat(user,"<span class='notice'>You paralyze [T].</span>")
		T.Stun(50)


/obj/effect/proc_holder/spell/pointed/hypno
	name = "Hypnotize"
	desc = "Knock out your target."
	charge_max = 300
	blood_used = 20
	action_icon_state = "hypnotize"
	active_msg = "<span class='warning'>You prepare your hypnosis technique.</span>"
	deactive_msg = "<span class='warning'>You stop preparing your hypnosis.</span>"
	vamp_req = TRUE
	ranged_mousepointer = 'aquila/icons/effects/mouse_pointers/hypnotize_target.dmi'
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_background_icon_state = "bg_demon"

/obj/effect/proc_holder/spell/pointed/hypno/Click()
	if(!active)
		usr.visible_message("<span class='warning'>[usr] twirls their finger in a circlular motion.</span>",\
				"<span class='warning'>You twirl your finger in a circular motion.</span>")
	..()

/obj/effect/proc_holder/spell/pointed/hypno/can_target(atom/target, mob/user, silent)
	if(!..())
		return
	if(!ishuman(target))
		to_chat(user, "<span class='warning'>Hypnotize will not work on this being.</span>")
		return FALSE

	var/mob/living/carbon/human/T = target
	if(T.IsSleeping())
		to_chat(user, "<span class='warning'>[T] is already asleep!.</span>")
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/pointed/hypno/cast(list/targets, mob/user)
	var/mob/living/target = targets[1]
	var/mob/living/carbon/human/T = target
	user.visible_message("<span class='warning'>[user]'s eyes flash red.</span>",\
					"<span class='warning'>[user]'s eyes flash red.</span>")
	if(T)
		var/obj/item/clothing/glasses/G = T.glasses
		if(G)
			if(G.flash_protect)
				to_chat(user, "<span class='warning'>[T] has protective sunglasses on!</span>")
				to_chat(target, "<span class='warning'>[user]'s paralyzing gaze is blocked by [G]!</span>")
				return
		var/obj/item/clothing/mask/M = T.wear_mask
		if(M)
			if(M.flash_protect)
				to_chat(user, "<span class='vampirewarning'>[T]'s mask is covering their eyes!</span>")
				to_chat(target, "<span class='warning'>[user]'s paralyzing gaze is blocked by [M]!</span>")
				return
		var/obj/item/clothing/head/H = T.head
		if(H)
			if(H.flash_protect)
				to_chat(user, "<span class='vampirewarning'>[T]'s helmet is covering their eyes!</span>")
				to_chat(target, "<span class='warning'>[user]'s paralyzing gaze is blocked by [H]!</span>")
				return
	to_chat(target, "<span class='boldwarning'>Your knees suddenly feel heavy. Your body begins to sink to the floor.</span>")
	to_chat(user, "<span class='notice'>[target] is now under your spell. In four seconds they will be rendered unconscious as long as they are within close range.</span>")
	if(do_mob(user, target, 40, TRUE)) // 4 seconds...
		if(get_dist(user, T) <= 3) // 7 range
			flash_color(T, flash_color="#472040", flash_time=30) // it's the vampires color!
			T.SetSleeping(300)
			to_chat(user, "<span class='warning'>[T] has fallen asleep!</span>")
		else
			to_chat(T, "<span class='notice'>You feel a whole lot better now.</span>")

/obj/effect/proc_holder/spell/self/shapeshift
	name = "Shapeshift (50)"
	desc = "Changes your name and appearance at the cost of 50 blood and has a cooldown of 3 minutes."
	gain_desc = "You have gained the shapeshifting ability, at the cost of stored blood you can change your form permanently."
	action_icon_state = "genetic_poly"
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_background_icon_state = "bg_demon"
	blood_used = 50
	vamp_req = TRUE

/obj/effect/proc_holder/spell/self/shapeshift/cast(list/targets, mob/user = usr)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		user.visible_message("<span class='warning'>[H] transforms!</span>")
		randomize_human(H)
	user.regenerate_icons()

/obj/effect/proc_holder/spell/self/cloak
	name = "Cloak of Darkness"
	desc = "Toggles whether you are currently cloaking yourself in darkness."
	gain_desc = "You have gained the Cloak of Darkness ability which when toggled makes you near invisible in the shroud of darkness."
	action_icon_state = "cloak"
	charge_max = 10
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_background_icon_state = "bg_demon"
	vamp_req = TRUE

/obj/effect/proc_holder/spell/self/cloak/Initialize()
	. = ..()
	update_name()

/obj/effect/proc_holder/spell/self/cloak/update_name()
	. = ..()
	var/mob/living/user = loc
	if(!ishuman(user) || !is_vampire(user))
		return
	var/datum/antagonist/vampire/V = user.mind.has_antag_datum(/datum/antagonist/vampire)
	name = "[initial(name)] ([V.iscloaking ? "Deactivate" : "Activate"])"

/obj/effect/proc_holder/spell/self/cloak/cast(list/targets, mob/user = usr)
	var/datum/antagonist/vampire/V = user.mind.has_antag_datum(/datum/antagonist/vampire)
	if(!V)
		return
	V.iscloaking = !V.iscloaking
	update_name()
	to_chat(user, "<span class='notice'>You will now be [V.iscloaking ? "hidden" : "seen"] in darkness.</span>")

/obj/effect/proc_holder/spell/targeted/disease
	name = "Diseased Touch (50)"
	desc = "Touches your victim with infected blood giving them Grave Fever, which will, left untreated, causes toxic building and frequent collapsing."
	gain_desc = "You have gained the Diseased Touch ability which causes those you touch to become weak unless treated medically."
	action_icon_state = "disease"
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_background_icon_state = "bg_demon"
	blood_used = 50
	vamp_req = TRUE

/obj/effect/proc_holder/spell/targeted/disease/cast(list/targets, mob/user = usr)
	for(var/mob/living/carbon/target in targets)
		to_chat(user, "<span class='warning'>You stealthily infect [target] with your diseased touch.</span>")
		target.help_shake_act(user)
		if(is_vampire(target))
			to_chat(user, "<span class='warning'>They seem to be unaffected.</span>")
			continue
		var/datum/disease/D = new /datum/disease/vampire
		target.ForceContractDisease(D)

/obj/effect/proc_holder/spell/self/screech
	name = "Chiropteran Screech (20)"
	desc = "An extremely loud shriek that stuns nearby humans and breaks windows as well."
	gain_desc = "You have gained the Chiropteran Screech ability which stuns anything with ears in a large radius and shatters glass in the process."
	action_icon_state = "reeee"
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_background_icon_state = "bg_demon"
	blood_used = 20
	vamp_req = TRUE

/obj/effect/proc_holder/spell/self/screech/cast(list/targets, mob/user = usr)
	user.visible_message("<span class='warning'>[user] lets out an ear piercing shriek!</span>", "<span class='warning'>You let out a loud shriek.</span>", "<span class='warning'>You hear a loud painful shriek!</span>")
	for(var/mob/living/carbon/C in hearers(4))
		if(C == user || (ishuman(C) && C.get_ear_protection()) || is_vampire(C))
			continue
		to_chat(C, "<span class='warning'><font size='3'><b>You hear a ear piercing shriek and your senses dull!</font></b></span>")
		C.Knockdown(40)
		C.adjustEarDamage(0, 30)
		C.stuttering = 250
		C.Stun(40)
		C.Jitter(150)
	for(var/obj/structure/window/W in view(4))
		W.take_damage(75)
	playsound(user.loc, 'sound/effects/screech.ogg', 100, 1)

/obj/effect/proc_holder/spell/self/bats
	name = "Summon Bats (30)"
	desc = "You summon a pair of space bats who attack nearby targets until they or their target is dead."
	gain_desc = "You have gained the Summon Bats ability."
	action_icon_state = "bats"
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_background_icon_state = "bg_demon"
	charge_max = 1200
	vamp_req = TRUE
	blood_used = 30
	var/num_bats = 2


/obj/effect/proc_holder/spell/self/bats/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/turf/spawns = get_adjacent_open_turfs(user.loc)
	for(var/i = 1 to num_bats)
		var/T = pick(spawns)
		new /mob/living/simple_animal/hostile/vampire_bat(T)
		spawns -= T


/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/mistform
	name = "Mist Form (30)"
	gain_desc = "You have gained the Mist Form ability which allows you to take on the form of mist for a short period and pass over any obstacle in your path."
	blood_used = 30
	action_background_icon_state = "bg_demon"
	vamp_req = TRUE

/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/mistform/Initialize()
	. = ..()
	range = -1
	addtimer(VARSET_CALLBACK(src, range, -1), 10) //Avoid fuckery

/obj/effect/proc_holder/spell/targeted/vampirize
	name = "Lilith's Pact (300)"
	desc = "You drain a victim's blood, and fill them with new blood, blessed by Lilith, turning them into a new vampire."
	gain_desc = "You have gained the ability to force someone, given time, to become a vampire."
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_background_icon_state = "bg_demon"
	action_icon_state = "oath"
	blood_used = 300
	vamp_req = TRUE

/obj/effect/proc_holder/spell/targeted/vampirize/cast(list/targets, mob/user = usr)
	var/datum/antagonist/vampire/vamp = user.mind.has_antag_datum(/datum/antagonist/vampire)
	for(var/mob/living/carbon/target in targets)
		if(is_vampire(target))
			to_chat(user, "<span class='warning'>They're already a vampire!</span>")
			vamp.usable_blood += blood_used // Refund cost
			continue
		user.visible_message("<span class='warning'>[user] latches onto [target]'s neck, pure dread eminating from them.</span>", "<span class='warning'>You latch onto [target]'s neck, preparing to transfer your unholy blood to them.</span>", "<span class='warning'>A dreadful feeling overcomes you</span>")
		target.reagents.add_reagent("salbutamol", 10) //incase you're choking the victim
		for(var/progress = 0, progress <= 3, progress++)
			switch(progress)
				if(1)
					to_chat(target, "<span class='danger'>Wicked shadows invade your sight, beckoning to you.</span>")
					to_chat(user, "<span class='notice'>We begin to drain [target]'s blood in, so Lilith can bless it.</span>")
				if(2)
					to_chat(target, "<span class='danger'>Demonic whispers fill your mind, and they become irressistible...</span>")
				if(3)
					to_chat(target, "<span class='danger'>The world blanks out, and you see a demo- no ange- demon- lil- glory- blessing... Lilith.</span>")
					to_chat(user, "<span class='notice'>Excitement builds up in you as [target] sees the blessing of Lilith.</span>")
			if(!do_mob(user, target, 70))
				to_chat(user, "<span class='danger'>The pact has failed! [target] has not became a vampire.</span>")
				to_chat(target, "<span class='notice'>The visions stop, and you relax.</span>")
				vamp.usable_blood += blood_used / 2 // Refund half the cost
				return
		if(!QDELETED(user) && !QDELETED(target))
			to_chat(user, "<span class='notice'>. . .</span>")
			to_chat(target, "<span class='italics'>Come to me, child.</span>")
			sleep(10)
			to_chat(target, "<span class='italics'>The world hasn't treated you well, has it?</span>")
			sleep(15)
			to_chat(target, "<span class='italics'>Strike fear into their hearts...</span>")
			to_chat(user, "<span class='notice italics bold'>They have signed the pact!</span>")
			to_chat(target, "<span class='userdanger'>You sign Lilith's Pact.</span>")
			target.mind.store_memory("<B>[user] showed you the glory of Lilith. <I>You are not required to obey [user], however, you have gained a respect for them.</I></B>")
			target.Sleeping(600)
			target.blood_volume = 560
			add_vampire(target, FALSE)
			vamp.converted ++
			add_vampire(target)



/obj/effect/proc_holder/spell/self/revive
	name = "Revive"
	gain_desc = "You have gained the ability to revive after death... However you can still be cremated/gibbed, and you will disintergrate if you're in the chapel!"
	desc = "Revives you, provided you are not in the chapel!"
	blood_used = 0
	stat_allowed = TRUE
	charge_max = 1000
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_icon_state = "coffin"
	action_background_icon_state = "bg_demon"
	vamp_req = TRUE

/obj/effect/proc_holder/spell/self/revive/cast(list/targets, mob/user = usr)
	if(!is_vampire(user) || !isliving(user))
		revert_cast()
		return
	if(user.stat != DEAD)
		to_chat(user, "<span class='notice'>We aren't dead enough to do that yet!</span>")
		revert_cast()
		return
	if(user.reagents.has_reagent("holywater"))
		to_chat(user, "<span class='danger'>We cannot revive, holy water is in our system!</span>")
		return
	var/mob/living/L = user
	if(istype(get_area(L.loc), /area/chapel))
		L.visible_message("<span class='warning'>[L] disintergrates into dust!</span>", "<span class='userdanger'>Holy energy seeps into our very being, disintergrating us instantly!</span>", "You hear sizzling.")
		new /obj/effect/decal/remains/human(L.loc)
		L.dust()
	to_chat(L, "<span class='notice'>We begin to reanimate... this will take 1 minute.</span>")
	addtimer(CALLBACK(src, /obj/effect/proc_holder/spell/self/revive.proc/revive, L), 600)

/obj/effect/proc_holder/spell/self/revive/proc/revive(mob/living/user)
	var/list/missing = user.get_missing_limbs()
	if(missing.len)
		playsound(user, 'sound/magic/demon_consume.ogg', 50, 1)
		user.visible_message("<span class='warning'>Shadowy matter takes the place of [user]'s missing limbs as they reform!</span>")
		user.regenerate_limbs()
		user.regenerate_organs()
	user.revive(full_heal = TRUE)
	user.visible_message("<span class='warning'>[user] reanimates from death!</span>", "<span class='notice'>We get back up.</span>")

/obj/effect/proc_holder/spell/self/summon_coat
	name = "Summon Dracula Coat (100)"
	desc = "Allows you to summon a Vampire Coat providing passive usable blood restoration when your usable blood is very low."
	gain_desc = "Now that you have reached full power, you can now pull a vampiric coat out of thin air!"
	blood_used = 100
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_icon_state = "coat"
	action_background_icon_state = "bg_demon"
	vamp_req = TRUE

/obj/effect/proc_holder/spell/self/summon_coat/cast(list/targets, mob/user = usr)
	if(!is_vampire(user) || !isliving(user))
		revert_cast()
		return
	var/datum/antagonist/vampire/V = user.mind.has_antag_datum(/datum/antagonist/vampire)
	if(!V)
		return
	if(QDELETED(V.coat) || !V.coat)
		V.coat = new /obj/item/clothing/suit/draculacoat(user.loc)
	else if(get_dist(V.coat, user) > 1 || !(V.coat in user.GetAllContents()))
		V.coat.forceMove(user.loc)
	user.put_in_hands(V.coat)
	to_chat(user, "<span class='notice'>You summon your dracula coat.</span>")


/obj/effect/proc_holder/spell/self/batform
	name = "Bat Form (15)"
	gain_desc = "You now have the Bat Form ability, which allows you to turn into a bat (and back!)"
	desc = "Transform into a bat!"
	action_icon_state = "bat"
	charge_max = 200
	blood_used = 0 //this is only 0 so we can do our own custom checks
	action_icon = 'aquila/icons/mob/vampire.dmi'
	action_background_icon_state = "bg_demon"
	vamp_req = TRUE
	var/mob/living/simple_animal/hostile/vampire_bat/bat

/obj/effect/proc_holder/spell/self/batform/cast(list/targets, mob/user = usr)
	var/datum/antagonist/vampire/V = user.mind.has_antag_datum(/datum/antagonist/vampire)
	if(!V)
		return FALSE
	if(!bat || bat.stat == DEAD)
		if(V.usable_blood < 15)
			to_chat(user, "<span class='warning'>You do not have enough blood to cast this!</span>")
			return FALSE
		bat = new /mob/living/simple_animal/hostile/vampire_bat(user.loc)
		user.forceMove(bat)
		bat.controller = user
		user.status_flags |= GODMODE
		user.mind.transfer_to(bat)
		charge_counter = charge_max //so you don't need to wait 20 seconds to turn BACK.
		recharging = FALSE
		action.UpdateButtonIcon()
	else
		bat.controller.forceMove(bat.loc)
		bat.controller.status_flags &= ~GODMODE
		bat.mind.transfer_to(bat.controller)
		bat.controller = null //just so we don't accidently trigger the death() thing
		QDEL_NULL(bat)
