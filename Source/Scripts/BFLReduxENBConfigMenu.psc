Scriptname BFLReduxENBConfigMenu extends nl_mcm_module
;===============  PROPERTIES  ==========================================;
Actor Property PlayerRef auto
GlobalVariable Property _BFLModEnable Auto
GlobalVariable Property _BFLPlayerEnable Auto
GlobalVariable Property _BFLTeammateEnable Auto
GlobalVariable Property _BFLAutoConvEnable Auto

GlobalVariable Property _BFLLightEffect0Enable Auto
GlobalVariable Property _BFLLightEffect1Enable Auto
GlobalVariable Property _BFLLightEffect2Enable Auto
GlobalVariable Property _BFLLightEffect3Enable Auto
GlobalVariable Property _BFLLightEffect4Enable Auto
GlobalVariable Property _BFLLightLevelLimit Auto

FormList Property _BFLExludedSupportActorList Auto
FormList Property _BFLForcedSupportActorList Auto

Faction Property BFLManualNPCSupportedFACT Auto
Faction Property BFLExcludedNPCFACT Auto

Spell Property _BFLLightEffect0SPL Auto
Spell Property _BFLLightEffect1SPL Auto
Spell Property _BFLLightEffect2SPL Auto
Spell Property _BFLLightEffect3SPL Auto
Spell Property _BFLLightEffect4SPL Auto

Spell Property _BFLLightApplicatorSPL Auto


;===============  UTILITIES   ==========================================;
;===============  VARIABLES   ==========================================;
Bool b_BFLModEnable
Bool b_BFLPlayerEnable
Bool b_BFLTeammateEnable
bool b_BFLAutoConvEnable
Bool b_BFLLightEffect0Enable
Bool b_BFLLightEffect1Enable
Bool b_BFLLightEffect2Enable
Bool b_BFLLightEffect3Enable
Bool b_BFLLightEffect4Enable
bool _use_standalone_mcm
Int LightLevelLimit
Int Forcedlistsize
Int Excludelistsize
;===============    EVENTS    ==========================================;
event OnInit()
    int nl_mcm_version = nl_mcm_globalinfo.CurrentVersion()
    if nl_mcm_version < 106
        Debug.messagebox("Your NL_MCM version ("+ nl_mcm_version + ") is outdated, Install last version !")
        return
    EndIf

    if Game.GetModByName("SMF.esp") == 255 && Game.GetModByName("SMF.esl") == 255
        _use_standalone_mcm = True
        RegisterModule("Better FaceLight Redux ENB")
    else
        RegisterModule("Better FaceLight Redux ENB", 1001, "_SMF_ConfigMenuInstance")
    endif
endevent


event OnGameReload()
    int nl_mcm_version = nl_mcm_globalinfo.CurrentVersion()
    if nl_mcm_version < 106
        Debug.messagebox("Your NL_MCM version ("+ nl_mcm_version + ") is outdated, Install last version !")
        return
    EndIf

    if Game.GetModByName("SMF.esp") == 255 && Game.GetModByName("SMF.esl") == 255
        if !_use_standalone_mcm
            UnregisterModule()
            _use_standalone_mcm = True
            RegisterModule("Better FaceLight Redux ENB")
        endif
    else
        if _use_standalone_mcm
            UnregisterModule()
            _use_standalone_mcm = False
            RegisterModule("Better FaceLight Redux ENB", 1001, "_SMF_ConfigMenuInstance")
        endif
    endif
endevent


event OnPageInit()
    if _use_standalone_mcm
        SetModName("Better FaceLight Redux ENB")
        SetLandingPage("Better FaceLight Redux ENB")
    endif
endevent

event OnPageDraw()
    Check() ;Check global value
    SetCursorFillMode(TOP_TO_BOTTOM)
    ; Left side
    AddHeaderOption(FONT_PRIMARY("Main Options"))
    AddToggleOptionST("_BFLModEnableState", "Enable Mod", b_BFLModEnable)
    AddToggleOptionST("_BFLPlayerEnableState", "Enable for player", b_BFLPlayerEnable)
    AddToggleOptionST("_BFLTeammateEnableState", "Enable for Teammate", b_BFLTeammateEnable)
    AddToggleOptionST("_BFLAutoConvEnableState", "Enable auto-conversation", b_BFLAutoConvEnable)

    AddHeaderOption(FONT_PRIMARY("Manual Support List"))
    AddTextOptionST("bForceNPCState", "", FONT_INFO("Add aimed NPC"))
    
    Forcedlistsize = (_BFLForcedSupportActorList.GetSize() as Int)
    int i1 = 0
    While (i1 < Forcedlistsize)
        string actorname = (_BFLForcedSupportActorList.Getat(i1) As Actor).getLeveledActorbase().getName() as String
        if actorname
        AddTextOptionST("bRemoveForceNPCState___" + i1, "", FONT_INFO("NPC " + i1+ " : " + actorname))
        endif
        i1 += 1
    EndWhile    
;/
    AddHeaderOption(FONT_PRIMARY("Test"))
    AddTextOptionST("bAddNPCState", "", FONT_INFO("Add NPC"))
/;
    ; Right side
    SetCursorPosition(1)
    
    AddHeaderOption(FONT_PRIMARY("Light Level"))
    AddToggleOptionST("_BFLLightEffect0EnableState", "Intensity level 0.12", b_BFLLightEffect0Enable)
    AddToggleOptionST("_BFLLightEffect1EnableState", "Intensity level 0.24", b_BFLLightEffect1Enable)
    AddToggleOptionST("_BFLLightEffect2EnableState", "Intensity level 0.36", b_BFLLightEffect2Enable)
    AddToggleOptionST("_BFLLightEffect3EnableState", "Intensity level 0.48", b_BFLLightEffect3Enable)
    AddToggleOptionST("_BFLLightEffect4EnableState", "Intensity level 0.60", b_BFLLightEffect4Enable)
    AddParagraph("The effects are cumulative (intensity value)\nFor performance sake choose 0.48 + 0.24 instead of 0.36 + 0.24 + 0.12\nBe wise!")
    LightLevelLimit = _BFLLightLevelLimit.GetValue() as int
    AddSliderOptionST("_BFLLightLevelLimitState", "Max Light level", (LightLevelLimit))

    AddHeaderOption(FONT_PRIMARY("Excluded Support List"))
    AddTextOptionST("bExcludeNPCState", "", FONT_INFO("Exclude aimed NPC"))

    Excludelistsize = (_BFLExludedSupportActorList.GetSize() as Int)
    int i2 = 0
    While (i2 < Excludelistsize)
        string actorname = (_BFLExludedSupportActorList.Getat(i2) As Actor).getLeveledActorbase().getName() as String
        if actorname
        AddTextOptionST("bRemoveExcludeNPCState___" + i2, "", FONT_INFO("NPC " + i2 + " : " + actorname))
        endif
        i2 += 1
    EndWhile    

endevent

event OnConfigClose()
    ;forces the spell set to be updated according to the mcm option
    utility.wait(1)
    If b_BFLModEnable
        _BFLModEnable.SetValue(0.00)
    EndIf
    PlayerSpell(false)

    utility.wait(3)
    If b_BFLModEnable
        _BFLModEnable.SetValue(1.00)
    EndIf
    If b_BFLPlayerEnable
        PlayerSpell(true)
    Endif
endevent
;===============    STATES    ==========================================;
State _BFLModEnableState
    event OnHighlightST(string state_id)
        SetInfoText("Enable / Disable Better Face Ligth Redux ENB")
    endevent

    event OnSelectST(string state_id)
        b_BFLModEnable = !b_BFLModEnable
        SetToggleOptionValueST(b_BFLModEnable, false, "_BFLModEnableState")
        If b_BFLModEnable
            _BFLModEnable.SetValue(1.00)
         Else
            _BFLModEnable.SetValue(0.00)
         EndIf
    endevent
EndState

State _BFLPlayerEnableState
    event OnHighlightST(string state_id)
        SetInfoText("Enable Permanent Light on player")
    endevent

    event OnSelectST(string state_id)
        b_BFLPlayerEnable = !b_BFLPlayerEnable
        SetToggleOptionValueST(b_BFLPlayerEnable, false, "_BFLPlayerEnableState")
        If b_BFLPlayerEnable
            _BFLPlayerEnable.SetValue(1.00)
         Else
            _BFLPlayerEnable.SetValue(0.00)
         EndIf
    endevent
EndState

State _BFLTeammateEnableState
    event OnHighlightST(string state_id)
        SetInfoText("Enable permanent Light on teammate")
    endevent

    event OnSelectST(string state_id)
        b_BFLTeammateEnable = !b_BFLTeammateEnable
        SetToggleOptionValueST(b_BFLTeammateEnable, false, "_BFLTeammateEnableState")
        If b_BFLTeammateEnable
            _BFLTeammateEnable.SetValue(1.00)
        Else
            _BFLTeammateEnable.SetValue(0.00)
        EndIf
    endevent
EndState

State _BFLAutoConvEnableState
    event OnHighlightST(string state_id)
        SetInfoText("Enable automatic conversation light")
    endevent

    event OnSelectST(string state_id)
        b_BFLAutoConvEnable = !b_BFLAutoConvEnable
        SetToggleOptionValueST(b_BFLAutoConvEnable, false, "_BFLAutoConvEnableState")
        If b_BFLAutoConvEnable
            _BFLAutoConvEnable.SetValue(1.00)
            PlayerSpell(true)
        Else
            _BFLAutoConvEnable.SetValue(0.00)
            PlayerSpell(false)
        EndIf
    endevent
EndState

State _BFLLightEffect0EnableState
    event OnHighlightST(string state_id)
        SetInfoText("Enable Light effect level 0.12")
    endevent

    event OnSelectST(string state_id)
        b_BFLLightEffect0Enable = !b_BFLLightEffect0Enable
        SetToggleOptionValueST(b_BFLLightEffect0Enable, false, "_BFLLightEffect0EnableState")
        If b_BFLLightEffect0Enable
            _BFLLightEffect0Enable.SetValue(1.00)
        Else
            _BFLLightEffect0Enable.SetValue(0.00)
        EndIf
    endevent
EndState

State _BFLLightEffect1EnableState
    event OnHighlightST(string state_id)
        SetInfoText("Enable Light effect level 0.24")
    endevent

    event OnSelectST(string state_id)
        b_BFLLightEffect1Enable = !b_BFLLightEffect1Enable
        SetToggleOptionValueST(b_BFLLightEffect1Enable, false, "_BFLLightEffect1EnableState")
        If b_BFLLightEffect1Enable
            _BFLLightEffect1Enable.SetValue(1.00)
        Else
            _BFLLightEffect1Enable.SetValue(0.00)
        EndIf
    endevent
EndState

State _BFLLightEffect2EnableState
    event OnHighlightST(string state_id)
        SetInfoText("Enable Light effect level 0.36")
    endevent

    event OnSelectST(string state_id)
        b_BFLLightEffect2Enable = !b_BFLLightEffect2Enable
        SetToggleOptionValueST(b_BFLLightEffect2Enable, false, "_BFLLightEffect2EnableState")
        If b_BFLLightEffect2Enable
            _BFLLightEffect2Enable.SetValue(1.00)
        Else
            _BFLLightEffect2Enable.SetValue(0.00)
        EndIf
    endevent
EndState

State _BFLLightEffect3EnableState
    event OnHighlightST(string state_id)
        SetInfoText("Enable Light effect level 0.48")
    endevent

    event OnSelectST(string state_id)
        b_BFLLightEffect3Enable = !b_BFLLightEffect3Enable
        SetToggleOptionValueST(b_BFLLightEffect3Enable, false, "_BFLLightEffect3EnableState")
        If b_BFLLightEffect3Enable
            _BFLLightEffect3Enable.SetValue(1.00)
        Else
            _BFLLightEffect3Enable.SetValue(0.00)
        EndIf
    endevent
EndState

State _BFLLightEffect4EnableState
    event OnHighlightST(string state_id)
        SetInfoText("Enable Light effect level 0.60")
    endevent

    event OnSelectST(string state_id)
        b_BFLLightEffect4Enable = !b_BFLLightEffect4Enable
        SetToggleOptionValueST(b_BFLLightEffect4Enable, false, "_BFLLightEffect4EnableState")
        If b_BFLLightEffect4Enable
            _BFLLightEffect4Enable.SetValue(1.00)
        Else
            _BFLLightEffect4Enable.SetValue(0.00)
        EndIf
    endevent
EndState

state _BFLLightLevelLimitState

	event OnDefaultST(string state_id)
		LightLevelLimit = 90
	endevent

	event OnHighlightST(string state_id)
		SetInfoText("Above this limit, NPCs are not enlightened. 90 is clear weather daylight")
	endevent
	
	event OnSliderOpenST(string state_id)
        SetSliderDialog(LightLevelLimit, 0.0, 200.0, 1.0, 90)
	endevent
	
	event OnSliderAcceptST(string state_id, float f)
		LightLevelLimit = f as int
        _BFLLightLevelLimit.SetValue(f as float)
		SetSliderOptionValueST(f)
	endevent
endstate


state bExcludeNPCState
    event OnSelectST(string state_id)
        Actor AimedActor = Game.GetCurrentCrosshairRef() as Actor
        String AimedActorName = AimedActor.getLeveledActorbase().getName() as String
        If !_BFLForcedSupportActorList.HasForm(AimedActor)
            If !_BFLExludedSupportActorList.HasForm(AimedActor)
                If (_BFLExludedSupportActorList.GetSize() as Int) < 10
                    _BFLExludedSupportActorList.AddForm(AimedActor)
                    AimedActor.AddToFaction(BFLExcludedNPCFACT)
                    Debug.Notification(AimedActorName + " added to list")
                EndIf
            Endif
            ForcePageListReset()
        Else
            Debug.Notification("Warning: Aimed Actor is already in support list")
        EndIf
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("The aimed NPCs will be ignored")
    endEvent
endstate

state bForceNPCState
    event OnSelectST(string state_id)
        Actor AimedActor = Game.GetCurrentCrosshairRef() as Actor
        String AimedActorName = AimedActor.getLeveledActorbase().getName() as String
        If !_BFLExludedSupportActorList.HasForm(AimedActor)
            If !_BFLForcedSupportActorList.HasForm(AimedActor)
                If (_BFLForcedSupportActorList.GetSize() as Int) < 10
                    _BFLForcedSupportActorList.AddForm(AimedActor)
                    AimedActor.AddToFaction(BFLManualNPCSupportedFACT)
                    Debug.Notification(AimedActorName + " added to list")
                EndIf
            Endif
            ForcePageListReset()
        Else
            Debug.Notification("Warning: Aimed Actor is already in exclusion list")
        EndIf
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("The aimed NPCs will be treated as same as a teammate")
    endEvent
endstate

state bRemoveForceNPCState
    event OnSelectST(string state_id)
        actor selectedactor = _BFLForcedSupportActorList.GetAt(state_id as Int) as actor
        _BFLForcedSupportActorList.RemoveAddedForm(selectedactor)
        selectedactor.RemoveFromFaction(BFLManualNPCSupportedFACT)
        ForcePageListReset()
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Select NPCs will be remove from list")
    endEvent
endstate


state bRemoveExcludeNPCState
    event OnSelectST(string state_id)
        actor selectedactor = _BFLExludedSupportActorList.GetAt(state_id as Int) as actor
        _BFLExludedSupportActorList.RemoveAddedForm(selectedactor)
        selectedactor.RemoveFromFaction(BFLExcludedNPCFACT)
        ForcePageListReset()
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Select NPCs will be remove from list")
    endEvent
endstate

;/
;=============      TESTING    ==========================================;
state bAddNPCState
    event OnSelectST(string state_id)
        Actor AimedActor = Game.GetCurrentCrosshairRef() as Actor
        String AimedActorName = AimedActor.getLeveledActorbase().getName() as String
        Debug.Notification("BFL Applicator added to " + AimedActorName)
        AimedActor.AddSpell(_BFLLightApplicatorSPL,false)
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("Add distributor to the aimed NPC.")
    endEvent
endstate
/;
;===============    FUNCTIONS  ==========================================;
Function Check()
    If _BFLPlayerEnable.GetValue() < 1.00
        b_BFLPlayerEnable = false
    Else
        b_BFLPlayerEnable = true
    EndIf
    If _BFLTeammateEnable.GetValue() < 1.00
        b_BFLTeammateEnable = false
    Else
        b_BFLTeammateEnable = true
    EndIf
    If _BFLAutoConvEnable.GetValue() < 1.00
        b_BFLAutoConvEnable = false
    Else
        b_BFLAutoConvEnable = true
    EndIf

    If _BFLLightEffect0Enable.GetValue() < 1.00
        b_BFLLightEffect0Enable = false
    Else
        b_BFLLightEffect0Enable = true
    EndIf
    If _BFLLightEffect1Enable.GetValue() < 1.00
        b_BFLLightEffect1Enable = false
    Else
        b_BFLLightEffect1Enable = true
    EndIf
    If _BFLLightEffect2Enable.GetValue() < 1.00
        b_BFLLightEffect2Enable = false
    Else
        b_BFLLightEffect2Enable = true
    EndIf
    If _BFLLightEffect3Enable.GetValue() < 1.00
        b_BFLLightEffect3Enable = false
    Else
        b_BFLLightEffect3Enable = true
    EndIf
EndFunction

Function PlayerSpell(bool add)
    If (add) == true
        If (_BFLLightEffect0Enable.GetValue() == 1.0)
            PlayerRef.AddSpell(_BFLLightEffect0SPL,false)
        EndIf
        If (_BFLLightEffect1Enable.GetValue() == 1.0)
            PlayerRef.AddSpell(_BFLLightEffect1SPL,false)
        EndIf
        If (_BFLLightEffect2Enable.GetValue() == 1.0)
            PlayerRef.AddSpell(_BFLLightEffect2SPL,false)
        EndIf
        If (_BFLLightEffect3Enable.GetValue() == 1.0)
            PlayerRef.AddSpell(_BFLLightEffect3SPL,false)
        EndIf
        If (_BFLLightEffect4Enable.GetValue() == 1.0)
            PlayerRef.AddSpell(_BFLLightEffect4SPL,false)
        EndIf
    else
        If (_BFLLightEffect0Enable.GetValue() == 0.0)
            PlayerRef.RemoveSpell(_BFLLightEffect0SPL)
        EndIf
        If (_BFLLightEffect1Enable.GetValue() == 0.0)
            PlayerRef.RemoveSpell(_BFLLightEffect1SPL)
        EndIf
        If (_BFLLightEffect2Enable.GetValue() == 0.0)
            PlayerRef.RemoveSpell(_BFLLightEffect2SPL)
        EndIf
        If (_BFLLightEffect3Enable.GetValue() == 0.0)
            PlayerRef.RemoveSpell(_BFLLightEffect3SPL)
        EndIf
        If (_BFLLightEffect4Enable.GetValue() == 0.0)
            PlayerRef.RemoveSpell(_BFLLightEffect4SPL)
        EndIf
    EndIf
EndFunction