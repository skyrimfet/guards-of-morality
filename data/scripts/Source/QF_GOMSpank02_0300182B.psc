;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname QF_GOMSpank02_0300182B Extends Quest Hidden

;BEGIN ALIAS PROPERTY AgressorRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_AgressorRef Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
debug.trace("Start Spank Quest!")

ReferenceAlias ref = thisQuest.getAliasByName("AgressorRef") as ReferenceAlias
ref.getActorRef().addItem(zbfWeaponCane,1)
;ref.getActorRef().AddToFaction(GOMSpank)
;ref.getActorRef().setFactionRank(GOMSpank,1)

ref.getActorRef().addSpell(GOMSpeed,false)

GOMSpank02Scene.Start()

int waitTime = Utility.randomInt(10,45)
while waitTime > 0
  
  waitTime -= 1
  Utility.wait(2.0)  

 
if ref.getActorRef().GetDistance(Game.getPlayer()) > 250
GOMSpank02Scene.Stop()
GOMSpank02Scene.Start()
  waitTime =   waitTime + 2
endif

  if Main.isOkAgressor(ref.getActorRef())==false
waitTime = 0
endif

endWhile



thisQuest.setStage(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
debug.trace("Spank quest is ready and wait for orders")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
GOMSpank02Scene.Stop()

ReferenceAlias ref = thisQuest.getAliasByName("AgressorRef") as ReferenceAlias
ref.getActorRef().RemoveItem(zbfWeaponCane,1)

ref.getActorRef().removeSpell(GOMSpeed)

;ref.getActorRef().RemoveFromFaction(GOMSpank)

thisQuest.reset()
thisQuest.setStage(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


Scene Property GOMSpank02Scene Auto
Weapon Property zbfWeaponCane Auto
Quest Property thisQuest Auto
Faction Property GOMSpank Auto
GOMMain Property Main Auto
Spell property GOMSpeed Auto
