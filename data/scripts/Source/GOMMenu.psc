Scriptname GOMMenu extends SKI_ConfigBase

GOMMain Property Main Auto
GOMConfig Property Config Auto

Event OnGameReload()
	parent.OnGameReload()
	Return
EndEvent

Event OnVersionUpdate(Int ver)
	OnConfigInit()
	Return
EndEvent

Int Function GetVersion()
  OnConfigInit()
  Return (Main.getVersion()*100) as int
EndFunction

Event OnConfigClose()

EndEvent

Event OnConfigInit()

	ModName = "Guards Of Morality"

	Pages = new String[1]
	Pages[0] = "About "	
	;Pages[1] = "Settings "

	Return
EndEvent


Event OnPageReset(string page)
	OnConfigInit()
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0)
	
	
	SetTitleText("Guards of morality v:"+Main.getVersionString())		
	if (page == "About " || page == "")
		if Config.modEnabled == true
			static1 = AddTextOption("Mod status:", "ENABLED" ,OPTION_FLAG_DISABLED)
		else
			static1 = AddTextOption("Mod status:", "DISABLED" ,OPTION_FLAG_DISABLED)
		endif
		AddEmptyOption()
		modEnabled = AddToggleOption("Mod enabled", Config.modEnabled)
		AddEmptyOption()
		AddEmptyOption()
		actionChance = AddSliderOption("Attack chance",Config.actionChance,"{0}")
		AddEmptyOption()
		AddHeaderOption("Allow:")
		allowInPlayerHouse = AddToggleOption("in Player House", Config.allowInPlayerHouse)
		allowInInn = AddToggleOption("in Inn", Config.allowInInn)
	endif
	
	 
	
	
EndEvent



Event OnOptionSelect(Int Menu)
	if Menu == modEnabled
		if  Config.modEnabled == true
			Config.modEnabled = false			
			Main.stopQuest()
		else			
			Config.modEnabled = true			
			Main.startQuest()
		endIf
		SetToggleOptionValue(Menu,  Config.modEnabled)
		ForcePageReset()		
	endIf

	if Menu == allowInPlayerHouse
		if  Config.allowInPlayerHouse == true
			Config.allowInPlayerHouse = false			
		else			
			Config.allowInPlayerHouse = true			
		endIf
		SetToggleOptionValue(Menu,  Config.allowInPlayerHouse)
	endIf

	if Menu == allowInInn
		if  Config.allowInInn == true
			Config.allowInInn = false			
		else			
			Config.allowInInn = true			
		endIf
		SetToggleOptionValue(Menu,  Config.allowInInn)
	endIf
EndEvent

Event OnOptionSliderOpen(Int Menu)
	sliderSetupOpenInt(Menu,actionChance,Config.actionChance,1,100,1);	
EndEvent


Event OnOptionSliderAccept(Int Menu, Float Val)

	if Menu == actionChance
		SetSliderOptionValue(Menu,Val,"{0}")		
		Config.actionChance = Val as Int		
	endif		
EndEvent

function sliderSetupOpenInt(Int Menu, Int IntName,Int ConfValue, int rangeStart = 0, int rangeStop = 100, int interval = 1)
	if (Menu == IntName)
		SetSliderDialogStartValue(ConfValue)
		SetSliderDialogRange(rangeStart,rangeStop)
		SetSliderDialogInterval(interval)
	endIf
endFunction

function sliderSetupOpenFloat(Int Menu, Int IntName,Float ConfValue, float rangeStart = 0.0, float rangeStop = 100.0, float interval = 0.1)
	if (Menu == IntName)
		SetSliderDialogStartValue(ConfValue)
		SetSliderDialogRange(rangeStart,rangeStop)
		SetSliderDialogInterval(interval)
	endIf
endFunction

int static1
int modEnabled
int actionChance
int allowInPlayerHouse
int allowInInn