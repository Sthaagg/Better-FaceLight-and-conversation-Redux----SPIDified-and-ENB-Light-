Scriptname BFLMaintenanceScript extends ReferenceAlias  
;===============  PROPERTIES  ==========================================;
BFLUpdateScript Property QuestScript Auto
;===============    EVENTS    ==========================================;
Event OnPlayerLoadGame()
	QuestScript.Maintenance()
EndEvent