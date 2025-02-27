/*				CIVILIAN OBJECTIVES			*/

/datum/objective/crew/druglordbot //ported from old Hippie with adjustments
	var/targetchem = "none"
	var/datum/reagent/chempath
	explanation_text = "Have at least (somethin broke here) harvested plants containing (report this on GitHub) when the shift ends."
	jobs = "botanist"

/datum/objective/crew/druglordbot/New()
	. = ..()
	target_amount = rand(3,20)
	chempath = get_random_reagent_id(CHEMICAL_GOAL_BOTANIST_HARVEST)
	targetchem = chempath
	update_explanation_text()

/datum/objective/crew/druglordbot/update_explanation_text()
	. = ..()
	explanation_text = "Zbierz przynajmniej [target_amount] roślin zawierających [initial(chempath.name)] przed koncem zmiany."

/datum/objective/crew/druglordbot/check_completion()
	var/pillcount = target_amount
	if(owner?.current)
		if(owner.current.contents)
			for(var/obj/item/reagent_containers/food/snacks/grown/P in owner.current.get_contents())
				if(P.reagents.has_reagent(targetchem))
					pillcount--
	if(pillcount <= 0)
		return TRUE
	else
		return ..()

/datum/objective/crew/foodhoard
	var/datum/crafting_recipe/food/targetfood
	var/obj/item/reagent_containers/food/foodpath
	explanation_text = "Personally deliver at least (Something broke, yell on GitHub) to CentCom."
	jobs = "cook"

/datum/objective/crew/foodhoard/New()
	. = ..()
	target_amount = rand(2,10)
	var/blacklist = list(/datum/crafting_recipe/food, /datum/crafting_recipe/food/cak)
	var/possiblefoods = typesof(/datum/crafting_recipe/food) - blacklist
	targetfood = pick(possiblefoods)
	foodpath = initial(targetfood.result)
	update_explanation_text()

/datum/objective/crew/foodhoard/update_explanation_text()
	. = ..()
	explanation_text = "Osobiście dostarcz przynajmniej [target_amount] [initial(foodpath.name)] do Centrali."

/datum/objective/crew/foodhoard/check_completion()
	if(owner.current && owner.current.check_contents_for(foodpath) && SSshuttle.emergency.shuttle_areas[get_area(owner.current)])
		return TRUE
	else
		return ..()

/datum/objective/crew/cocktail
	explanation_text = "Have a bottle(any type) that contains 'something' when the shift ends. Each of them must be at least 'something'u."
	jobs = "bartender"
	var/targetchems = list()
	var/list/chemnames = list()
	var/chemsize
	var/datum/reagent/chempath

/datum/objective/crew/cocktail/New()
	. = ..()
	for(var/i in 1 to 5)
		chempath = get_random_reagent_id(CHEMICAL_GOAL_BARTENDER_SERVING)
		if(!(chempath in targetchems))
			targetchems += chempath
			chemnames += "[initial(chempath.name)]"
	// chems may reaction, but there's no reactionable recipe from CHEMICAL_GOAL_BARTENDER_SERVING. Just don't put basic chems there.
	chemsize = 4+(5-length(targetchems))
	update_explanation_text()

/datum/objective/crew/cocktail/update_explanation_text()
	. = ..()
	explanation_text = "Have a bottle(any type) that contains '[english_list(chemnames, and_text = ", and ")]' when the shift ends. Each of them must be at least [chemsize]u."

/datum/objective/crew/cocktail/check_completion()
	if(owner?.current)
		if(owner.current.contents)
			// check every bottle in your bag.
			for(var/obj/item/reagent_containers/B in owner.current.get_contents())
				var/count = length(targetchems) // a bottle should have the all desired chems. reset the count for every try.
				for(var/each in targetchems)
					if(B.reagents.has_reagent(each, chemsize))
						count--
						if(!count) // if it is legit, it completes.
							return TRUE
	return ..()

/datum/objective/crew/clean //ported from old Hippie
	var/list/areas = list()
	var/hardmode = FALSE
	explanation_text = "Ensure sure that (Yo, something broke. Yell about this on GitHub.) remain spotless at the end of the shift."
	jobs = "janitor"

/datum/objective/crew/clean/New()
	. = ..()
	if(prob(1))
		hardmode = TRUE
	var/list/blacklistnormal = list(typesof(/area/space) - typesof(/area/lavaland) - typesof(/area/mine) - typesof(/area/ai_monitored/turret_protected) - typesof(/area/tcommsat))
	var/list/blacklisthard = list(typesof(/area/lavaland) - typesof(/area/mine))
	var/list/possibleareas = list()
	if(hardmode)
		possibleareas = GLOB.teleportlocs - /area - blacklisthard
	else
		possibleareas = GLOB.teleportlocs - /area - blacklistnormal
	for(var/i in 1 to rand(1,6))
		areas |= pick_n_take(possibleareas)
	update_explanation_text()

/datum/objective/crew/clean/update_explanation_text()
	. = ..()
	explanation_text = "Upewnij się, że"
	for(var/i in 1 to areas.len)
		var/area/A = areas[i]
		explanation_text += " [A]"
		if(i != areas.len && areas.len >= 3)
			explanation_text += ","
		if(i == areas.len - 1)
			explanation_text += "and"
	explanation_text += " [(areas.len ==1) ? "jest całkowicie" : "są [(areas.len == 2) ? "całkowicie" : "wszystkie"]"] czyste do pod koniec zmiany."
	if(hardmode)
		explanation_text += " Chop-chop."

/datum/objective/crew/clean/check_completion()
	for(var/area/A in areas)
		for(var/obj/effect/decal/cleanable/C in A.contents)
			return ..()
	return TRUE

/datum/objective/crew/exterminator
	explanation_text = "Ensure that there are no more than (Yell on github, this objective broke) living mice on the station when the round ends."
	jobs = "janitor"

/datum/objective/crew/exterminator/New()
	. = ..()
	target_amount = rand(2, 5)
	update_explanation_text()

/datum/objective/crew/exterminator/update_explanation_text()
	. = ..()
	explanation_text = "Upewnij się, że nie więcej niż [target_amount] żywych myszy biega po stacji pod koniec zmiany."

/datum/objective/crew/exterminator/check_completion()
	var/num_mice = 0
	for(var/mob/living/simple_animal/mouse/M in GLOB.alive_mob_list)
		if((M.z in SSmapping.levels_by_trait(ZTRAIT_STATION)))
			num_mice++
	if(num_mice <= target_amount)
		return TRUE
	return ..()

/datum/objective/crew/lostkeys
	explanation_text = "Nie zgub kluczyków do swojego wózka. Miej je do końca zmiany."
	jobs = "janitor"

/datum/objective/crew/lostkeys/check_completion()
	if(owner && owner.current && owner.current.check_contents_for(/obj/item/key/janitor))
		return TRUE
	return ..()

/datum/objective/crew/slipster //ported from old Hippie with adjustments
	explanation_text = "Slip at least (Yell on GitHub if you see this) different people with your PDA, and have it on you at the end of the shift."
	jobs = "clown"

/datum/objective/crew/slipster/New()
	. = ..()
	target_amount = rand(5, 20)
	update_explanation_text()

/datum/objective/crew/slipster/update_explanation_text()
	. = ..()
	explanation_text = "Poślizgnij przynajmniej [target_amount] różnych osób za pomocą twojego PDA i zachowaj je do końca zmiany."

/datum/objective/crew/slipster/check_completion()
	var/list/uniqueslips = list()
	if(owner?.current)
		for(var/obj/item/modular_computer/tablet/pda/clown/PDA in owner.current.get_contents())
			for(var/H in PDA.slip_victims)
				uniqueslips |= H
	if(uniqueslips.len >= target_amount)
		return TRUE
	else
		return ..()

/datum/objective/crew/shoethief
	explanation_text = "Steal at least (Yell on github, this objective broke) pairs of shoes, and have them in your bag at the end of the shift. Bonus points if they are stolen from crewmembers instead of ClothesMates."
	jobs = "clown"

/datum/objective/crew/shoethief/New()
	. = ..()
	target_amount = rand(3, 5)
	update_explanation_text()

/datum/objective/crew/shoethief/update_explanation_text()
	. = ..()
	explanation_text = "Ukradnij przynajmniej [target_amount] par butów i miej je w plecaku do końca zmiany. Bonusowe punkty jeśli zostały ukradzione załodze, a nie z automatów na ubrania."

/datum/objective/crew/shoethief/check_completion()
	var/list/shoes = list()
	if(owner?.current)
		for(var/obj/item/clothing/shoes/S in owner.current.get_contents())
			if(!istype(S, /obj/item/clothing/shoes/clown_shoes))
				shoes |= S
	if(shoes.len >= target_amount)
		return TRUE
	return ..()

/datum/objective/crew/vow //ported from old Hippie
	explanation_text = "Nigdy nie złam przysięgi milczenia."
	jobs = "mime"

/datum/objective/crew/vow/check_completion()
	if(owner?.current)
		var/list/say_log = owner.current.logging[INDIVIDUAL_SAY_LOG]
		if(say_log.len > 0)
			return ..()
	return TRUE

/datum/objective/crew/nothingreallymatterstome
	explanation_text = "Zachowaj Buletkę Niczego (Bottle of Nothing) do końca zmiany."
	jobs = "mime"

/datum/objective/crew/nothingreallymatterstome/check_completion()
	if(owner && owner.current && owner.current.check_contents_for(/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing))
		return TRUE
	return ..()

/datum/objective/crew/nullrod
	explanation_text = "Nie zgub swojego atrybutu - nullroda. Możesz dalej przetransformować ją w inny przedmiot."
	jobs = "chaplain"

/datum/objective/crew/nullrod/check_completion()
	if(owner?.current)
		for(var/nullrodtypes in typesof(/obj/item/nullrod))
			if(owner.current.check_contents_for(nullrodtypes))
				return TRUE
	return ..()

/datum/objective/crew/reporter //ported from old hippie
	var/charcount = 100
	explanation_text = "Publish at least (Yo something broke) articles containing at least (Report this on GitHub) characters."
	jobs = "curator"

/datum/objective/crew/reporter/New()
	. = ..()
	target_amount = rand(2,10)
	charcount = rand(20,250)
	update_explanation_text()

/datum/objective/crew/reporter/update_explanation_text()
	. = ..()
	explanation_text = "Opublikuj przynajmniej [target_amount] artukułów z [charcount]. znakami."

/datum/objective/crew/reporter/check_completion()
	if(owner?.current)
		var/ownername = "[ckey(owner.current.real_name)][ckey(owner.assigned_role)]"
		for(var/datum/newscaster/feed_channel/chan in GLOB.news_network.network_channels)
			for(var/datum/newscaster/feed_message/msg in chan.messages)
				if(ckey(msg.returnAuthor()) == ckey(ownername))
					if(length(msg.returnBody()) >= charcount)
						target_amount--
	if(target_amount <= 0)
		return TRUE
	else
		return ..()

/datum/objective/crew/pwrgame //ported from Goon with adjustments
	var/obj/item/clothing/targettidegarb
	explanation_text = "Get your grubby hands on a (Dear god something broke. Report this on GitHub)."
	jobs = "assistant"

/datum/objective/crew/pwrgame/New()
	. = ..()
	var/list/muhvalids = list(/obj/item/clothing/mask/gas, /obj/item/clothing/head/welding, /obj/item/clothing/head/ushanka, /obj/item/clothing/gloves/color/yellow, /obj/item/clothing/mask/gas/owl_mask)
	if(prob(10))
		muhvalids += list(/obj/item/clothing/suit/space)
	targettidegarb = pick(muhvalids)
	update_explanation_text()

/datum/objective/crew/pwrgame/update_explanation_text()
	. = ..()
	explanation_text = "Połóż swoje chytre rączki na [initial(targettidegarb.name)]."

/datum/objective/crew/pwrgame/check_completion()
	if(owner?.current)
		for(var/tidegarbtypes in typesof(targettidegarb))
			if(owner.current.check_contents_for(tidegarbtypes))
				return TRUE
	return ..()

/datum/objective/crew/promotion //ported from Goon
	explanation_text = "Miej ID zarejestrowane na inną profesję niż asystent pod koniec zmiany."
	jobs = "assistant"

/datum/objective/crew/promotion/check_completion()
	if(owner?.current)
		var/mob/living/carbon/human/H = owner.current
		var/obj/item/card/id/theID = H.get_idcard()
		if(istype(theID))
			if(!(H.get_assignment() == JOB_NAME_ASSISTANT) && !(H.get_assignment() == "No id") && !(H.get_assignment() == "No job"))
				return TRUE
			if(theID.hud_state != JOB_HUD_ASSISTANT) // non-assistant HUD counts too
				return TRUE
	return ..()

/datum/objective/crew/justicecrew
	explanation_text = "Upewnij się, że pod koniec zmiany w skrzydle więziennym nie ma żadnych członków Ochrony."
	jobs = "lawyer"

/datum/objective/crew/justicecrew/check_completion()
	if(owner?.current)
		for(var/datum/mind/M in SSticker.minds)
			if(M.current && isliving(M.current))
				if(!M.special_role && !(M.assigned_role == JOB_NAME_SECURITYOFFICER) && !(M.assigned_role == JOB_NAME_DETECTIVE) && !(M.assigned_role == JOB_NAME_HEADOFSECURITY) && !(M.assigned_role == "Internal Affairs Agent") && !(M.assigned_role == JOB_NAME_WARDEN) && get_area(M.current) != typesof(/area/security/prison))
					return ..()
		return TRUE
