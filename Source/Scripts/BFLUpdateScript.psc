Scriptname BFLUpdateScript extends Quest Hidden
;===============  PROPERTIES  ==========================================;
Float Property fVersion auto hidden
Quest Property _BFLConfigMenuInstance auto
;===============  VARIABLES   ==========================================;
bool bMCMready = false
int iWaitSeconds
int iMCMregdelay = 10
int iMaxWait = 30
;===============  Utilities   ==========================================;
;===============    EVENTS    ==========================================;
Event OnInit()
  Maintenance()
EndEvent

;Needed code if MCM is updated
;Event OnConfigManagerReady(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
;	bMCMready = true
;endEvent
;===============    Functions  ==========================================;
Function Maintenance()
	If fVersion < 1.00 ; <--- Edit this value when updating
        Debug.Notification("Better Face lighting initializing")
		fVersion = 1.00 ; and this
		; Update Code
        ;/
		_BFLConfigMenuInstance.Stop()
        ;We must wait until the quest has stopped before restarting the quest. Using Stop() and immediately Start() may fail. 
        ;Continue after 5 seconds to prevent infinite loop.
        int i = 0
        while !_BFLConfigMenuInstance.IsStopped() && i < 50
            Utility.Wait(0.1)
            i += 1
        endWhile
 		_BFLConfigMenuInstance.Start()
        ;Needed code if MCM is updated
        int i2 = 0
        while !bMCMready && i2 < 50
            Utility.Wait(0.1)
            i2 += 1
        endWhile
        Quest qstMCM = Quest.GetQuest("SKI_ConfigManagerInstance") ;as SKI_ConfigManager
		qstMCM.SetStage(1)
        /;
        String VNumber = (fVersion as Int) + "." + (((fVersion - (fVersion as Int)) * 100 + 0.001) as Int)
		Debug.Notification("Now running Better Face lighting version: " + VNumber)
	EndIf
EndFunction

