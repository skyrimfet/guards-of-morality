Scriptname GOMMain extends Quest  

GOMConfig Property Config Auto
GOMUpdate Property Update Auto

; Return string version form mcm

String function getVersionString()

	return "1.1"

endFunction



; Return int version for mcm and update

Int function getVersion()

	return 3

endFunction



; Init or reinit mod

function startQuest()

	Config.modEnabled = true
	RegisterForSingleUpdate(Config.updateInterval)

endFunction



; Stop all related with this mod

function stopQuest()

	; Get count of spank quests
	int j = Config.spankQuest.length

	; Set stage 20 (end stage) for every spank quest to stop it
	while j > 0
		j -= 1
		Config.spankQuest[j].setStage(20)
	endWhile

	; Set stop flags and reset timeout array
	Config.modEnabled = false
	Config.timeoutActorList = new Actor[1]
	Config.timeoutActorList = new Actor[64]

endFunction



; Init procedure

Event OnInit()

	Config.lastVersion = 0
	Config.modEnabled = true
	
	Config.updateInterval = 10.0
	

	RegisterForSingleUpdate(Config.updateInterval)
	Log("onInit: Update start")
	Update.Update()
	Log("onInit: Update stop")

endEvent



; Period quest update 

Event onUpdate()

	if Config.modEnabled == true		
		RegisterForSingleUpdate(Config.updateInterval)

		; Reduce timeout for marked actors
		processTimeoutList()
		
		; Run process (search actors, etc)
		process()
	endIf

endEvent



; Main mod function

function process()

	; If armor is not detected, run search actors procedure
	if IsPlayerNaked() == true
		scanForActors()
	else
		;Log("process: stop (code 1)")
	endif

endfunction



; Check armor status for player

bool Function IsPlayerNaked()

	; Slot32 it is body slot - main armor slot
	Armor test = Config.PlayerRef.GetWornForm(Config.slotMask[32]) as Armor	
	if test == None
		return true
	endif
	return false

endFunction



; A loop to process founded actors (scan inside)

function scanForActors()

	; Init array
	Actor[] actors
	actors = getActors(Config.PlayerRef)
	
	int i = actors.length

	while i > 0
		i -= 1
		if actors[i]!=None

			initSpank(actors[i])
			; wait a while - to get time for init script on spank side quest 
			Utility.wait(1.0)

		endIf

	endWhile

endFunction



; Procedure to run one of span quest - add actor, setup and run

function initSpank(Actor akActor)

	int j = Config.spankQuest.length

	; search for free quest
	while j > 0

		j -= 1

		Quest q = config.spankQuest[j]

		; stage 0 means quest is ready 
		if q.getStage()==0


			; try to add to timeout list actor
 			if Utility.randomInt(0,100) > Config.actionChance
				addToTimeoutList(akActor,Utility.randomInt( ( Config.timeOutValue / 2 ) as Int , ( Config.timeOutValue * 1.5 ) as Int ) )
				return
			endIf

			if addToTimeoutList(akActor,Utility.randomInt( ( Config.timeOutValue / 2 ) as Int , ( Config.timeOutValue * 1.5 ) as Int ) ) == false
				; problem? list is full - nothing to do, break adding to scene
				Log("initSpank: "+ akActor.GetLeveledActorBase().GetName() + " rejected code 0")
				return
			endif

			; reset spank quest
			q.reset()
			q.setStage(0)
			
			; get alias ref.
			ReferenceAlias ref
			ref = q.getAliasByName("AgressorRef") as ReferenceAlias
			ref.ForceRefTo(akActor)

			; run quest (stage 10 include init script)
			q.setStage(10)

			; break loop - job is done
			return
		endif
		
	endWhile

endFunction



; Mark actor as busy + add additional time to cool down

Bool Function addToTimeoutList(Actor akActor,int rank)

	int i = Config.timeoutActorList.length

	; search for arrays free slot
	while i > 0
		i -= 1
		if Config.timeoutActorList[i] == none || Config.timeoutActorList[i] == akActor
			; Something is free
			; Add actor
			Config.timeoutActorList[i] = akActor

			;add to faction and set rank value
			akActor.addToFaction(Config.storageFactionGOMSpank)
			akActor.setFactionRank(Config.storageFactionGOMSpank,rank)

			; Return true = actor was added
			return true

		endif
	endWhile

	; Return false - actor is not placed - means list is full 
	return false

endFunction



; Deincrese some rank from wait faction (cool down effect)

Function processTimeoutList()

	int i = Config.timeoutActorList.length

	while i > 0

		i -= 1

		if Config.timeoutActorList[i] != none

			int fRank = Config.timeoutActorList[i].getFactionRank(Config.storageFactionGOMSpank)

			if fRank >= 0
				fRank = fRank - 1
				Config.timeoutActorList[i].setFactionRank(Config.storageFactionGOMSpank, fRank)
			else
				Config.timeoutActorList[i].RemoveFromFaction(Config.storageFactionGOMSpank)
				Config.timeoutActorList[i] = none
			endif

		endif

	endWhile

endFunction



; Search area for actors

Actor[] function getActors(Actor acAktor)

	Actor[] actors
	actors = new Actor[32]

	;TODO maybe
	;if CurrentLocationHasKeyword(Config.PlayerRef, Config.LocTypeCity) == false && CurrentLocationHasKeyword(Config.PlayerRef, Config.LocTypeTown) == false
	;	return actors
	;endIf

	Actor acActor = acAktor

	float rad = Config.triggerDistance
	float posx = acActor.GetPositionX()
	float posy = acActor.GetPositionY()
	float posz = acActor.GetPositionZ()


	int i = 0
	int index = 0
	while i < 30
		
		actor npctoadd = Game.FindRandomActor(posx, posy, posz, rad)

		if actors.find(npctoadd)==-1 && isOkAgressor(npctoadd,true) == true && npctoadd.HasLOS(Config.PlayerRef) == true

			int factionScore = 0
			int j = 0

				; Compare actor faction with allowed factions
				while j < Config.allowedFactions.length 
					if npctoadd.getFactionRank(Config.allowedFactions[j]) >= 0
						j = Config.allowedFactions.length
						factionScore = factionScore + 1
					endIf
					j = j + 1
				endWhile
			
				if factionScore > 0
					Log("getActors: "+ npctoadd.GetLeveledActorBase().GetName() + " added")
					actors[index] = npctoadd
					index+=1
				endif
				
				;just for save CPU
				if index > 3
					return actors
				endif
			
		endif
		
		i+=1
	endWhile

	return actors
	
endFunction



; Check conditions - used in initial validation and spank quests!

bool function isOkAgressor(Actor akActor, bool checkFaction = false)

	
	log("Package: " + akActor.GetLeveledActorBase().GetName() + " - " + akActor.GetCurrentPackage() )

	if checkFaction == true
		if akActor.getFactionRank(Config.storageFactionGOMSpank)>=0 
			log("isOkAgressor: " + akActor.GetLeveledActorBase().GetName() + " rejected: code 0" )
			return false
		endif
	endif

	if akActor == Config.PlayerRef || akActor.isDead()==true || akActor.isInCombat()==true
		log("isOkAgressor: " + akActor.GetLeveledActorBase().GetName() + " rejected: code 1" )
		return false
	endif
	
	if Config.PlayerRef.isInCombat()==true
		log("isOkAgressor: " + akActor.GetLeveledActorBase().GetName() + " rejected: code 2" )
		return false
	endif
	
	if akActor.GetDistance(Config.PlayerRef) > (Config.triggerDistance * 4.0)
		log("isOkAgressor: " + akActor.GetLeveledActorBase().GetName() + " rejected: code 3" )
		return false
	endif

	if Config.modEnabled == false
		log("isOkAgressor: " + akActor.GetLeveledActorBase().GetName() + " rejected: code 4" )
		return false
	endif

	Armor test = Config.PlayerRef.GetWornForm(Config.slotMask[32]) as Armor	
	if test != None
		log("isOkAgressor: " + akActor.GetLeveledActorBase().GetName() + " rejected: code 5" )
		return false
	endif

	if Config.allowInInn == false
		if CurrentLocationHasKeyword(Config.PlayerRef, Config.LocTypeInn)
			log("isOkAgressor: " + akActor.GetLeveledActorBase().GetName() + " rejected: code 6 (Inn)" )
			return false
		endif
	endif

	if Config.allowInPlayerHouse == false
		if CurrentLocationHasKeyword(Config.PlayerRef, Config.LocTypePlayerHouse)
			log("isOkAgressor: " + akActor.GetLeveledActorBase().GetName() + " rejected: code 6 (PlayerHouse)" )
			return false
		endif
	endif

	log("isOkAgressor: " + akActor.GetLeveledActorBase().GetName() + " is accepted" )

	return true

endFunction




Bool Function CurrentLocationHasKeyword(ObjectReference akRef, Keyword akKeyword)

	Location kCurrentLoc = akRef.GetCurrentLocation()

	if (kCurrentLoc == none)
		return false
	endif
 
	if kCurrentLoc.HasKeyword(akKeyword)
		return true
	else
		return false
	endif

EndFunction

import MiscUtil
import MfgConsoleFunc

function log(String txt)
	;debug.trace("GOM: "+ txt)
	;PrintConsole("GOM: "+ txt)
endFunction