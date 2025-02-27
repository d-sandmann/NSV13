/datum/antagonist/blob
	name = "Blob"
	roundend_category = "blobs"
	antagpanel_category = "Blob"
	show_to_ghosts = TRUE
	banning_key = ROLE_BLOB

	var/datum/action/innate/blobpop/pop_action
	var/starting_points_human_blob = 60
	var/point_rate_human_blob = 2

/datum/antagonist/blob/roundend_report()
	var/basic_report = ..()
	//Display max blobpoints for blebs that lost
	if(isovermind(owner.current)) //embarrasing if not
		var/mob/camera/blob/overmind = owner.current
		if(!overmind.victory_in_progress) //if it won this doesn't really matter
			var/point_report = "<br><b>[owner.name]</b> rozrósł się na [overmind.max_count] kafelków w jego szczytowym punkcie."
			return basic_report+point_report
	return basic_report

/datum/antagonist/blob/greet()
	if(!isovermind(owner.current))
		to_chat(owner,"<span class='userdanger'>You feel bloated.</span>")
	else
		owner.current.client?.tgui_panel?.give_antagonist_popup("Blob",
			"Place your core by using the place core button.\n\
			Expand and manage your resources carefully, the crew will know about your existence soon \
			and will work together to destroy you.")

/datum/antagonist/blob/on_gain()
	create_objectives()
	. = ..()

/datum/antagonist/blob/proc/create_objectives()
	if(!give_objectives)
		return
	var/datum/objective/blob_takeover/main = new
	main.owner = owner
	objectives += main
	log_objective(owner, main.explanation_text)

/datum/antagonist/blob/apply_innate_effects(mob/living/mob_override)
	if(!isovermind(owner.current))
		if(!pop_action)
			pop_action = new
		pop_action.Grant(owner.current)

/datum/objective/blob_takeover
	explanation_text = "Reach critical mass!"

//Non-overminds get this on blob antag assignment
/datum/action/innate/blobpop
	name = "Pop"
	desc = "Unleash the blob"
	icon_icon = 'icons/mob/blob.dmi'
	button_icon_state = "blob"

/datum/action/innate/blobpop/Activate()
	var/mob/old_body = owner
	var/datum/antagonist/blob/blobtag = owner.mind.has_antag_datum(/datum/antagonist/blob)
	if(!blobtag)
		Remove()
		return
	var/mob/camera/blob/B = new /mob/camera/blob(get_turf(old_body), blobtag.starting_points_human_blob)
	owner.mind.transfer_to(B)
	old_body.gib()
	B.place_blob_core(blobtag.point_rate_human_blob, pop_override = TRUE)

/datum/antagonist/blob/antag_listing_status()
	. = ..()
	if(owner?.current)
		var/mob/camera/blob/B = owner.current
		if(istype(B))
			. += "(Progress: [B.blobs_legit.len]/[B.blobwincount])"
