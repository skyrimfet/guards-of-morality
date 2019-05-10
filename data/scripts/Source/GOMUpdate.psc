Scriptname GOMUpdate extends Quest  

GOMConfig Property Config Auto
GOMMain Property Main Auto



; Standard update procedure

function update()

	; Check updates mini functions for current version (config.lastVersion)

	if Config.lastVersion < 1

		updateTo01()

	endif

	if Config.lastVersion < 2

		updateTo02()

	endif

	if Config.lastVersion < 3

		updateTo03()

	endif


	; Run update function with constant infos
	updateAlways()

	Config.lastVersion = Main.getVersion()

endfunction 


function updateTo03()
	Config.allowInPlayerHouse = false
	Config.allowInInn = false
endfunction

function updateTo02()

	;empty testu update

endfunction

function updateTo01()

	Main.log("Update 01 Start")

	Config.triggerDistance = 1024.0
	Config.timeOutValue = 6
	Config.updateInterval = 10.0
	Config.actionChance = 90

	Config.timeoutActorList = new Actor[64]

	int i = Config.timeoutActorList.length
	while i > 0
		i -= 1
		Config.timeoutActorList[i] = none;
	endWhile

	Main.log("Update 01 Stop")
	
endfunction

function updateAlways()

	Main.log("Update always start")

	; Not using, locations where mod can find actors
	Config.allowedLocations = new Keyword[6]
	Config.allowedLocations[0] = Config.LocTypeCity
	Config.allowedLocations[1] = Config.LocTypeTown
	Config.allowedLocations[2] = Config.LocTypeBarracks
	Config.allowedLocations[3] = Config.LocSetMilitaryCamp
	Config.allowedLocations[4] = Config.LocTypeMilitaryFort
	Config.allowedLocations[5] = Config.LocTypeTemple

	; Just to skip Game.getPlayer()
	Config.PlayerRef = Game.getPlayer()

	; Declare quest array
	Config.spankQuest = new Quest[3]
	Config.spankQuest[0] = Config.storageQuestSpank001
	Config.spankQuest[1] = Config.storageQuestSpank002
	Config.spankQuest[2] = Config.storageQuestSpank003

	; List of agresive factions like quards, soldiers and ??
	Config.allowedFactions = new Faction[1]
	Config.allowedFactions[0] = Config.storageFactionIsGuard

	; Array to translate slot number to slot "adress"
	Config.slotMask = new Int[65]
	Config.slotMask[30] = 0x00000001
	Config.slotMask[31] = 0x00000002
	Config.slotMask[32] = 0x00000004 ; Im using only this slot, body
	Config.slotMask[33] = 0x00000008
	Config.slotMask[34] = 0x00000010
	Config.slotMask[35] = 0x00000020
	Config.slotMask[36] = 0x00000040
	Config.slotMask[37] = 0x00000080
	Config.slotMask[38] = 0x00000100
	Config.slotMask[39] = 0x00000200
	Config.slotMask[40] = 0x00000400
	Config.slotMask[41] = 0x00000800
	Config.slotMask[42] = 0x00001000
	Config.slotMask[43] = 0x00002000
	Config.slotMask[44] = 0x00004000
	Config.slotMask[45] = 0x00008000
	Config.slotMask[46] = 0x00010000
	Config.slotMask[47] = 0x00020000
	Config.slotMask[48] = 0x00040000
	Config.slotMask[49] = 0x00080000
	Config.slotMask[50] = 0x00100000
	Config.slotMask[51] = 0x00200000
	Config.slotMask[52] = 0x00400000
	Config.slotMask[53] = 0x00800000
	Config.slotMask[54] = 0x01000000
	Config.slotMask[55] = 0x02000000
	Config.slotMask[56] = 0x04000000
	Config.slotMask[57] = 0x08000000
	Config.slotMask[58] = 0x10000000
	Config.slotMask[59] = 0x20000000
	Config.slotMask[60] = 0x40000000
	Config.slotMask[61] = 0x80000000

	Main.log("Update always stop")
	
endfunction