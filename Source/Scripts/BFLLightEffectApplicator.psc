Scriptname BFLLightEffectApplicator extends ActiveMagicEffect  
;===============  PROPERTIES  ==========================================;
GlobalVariable Property _BFLLightEffect0Enable Auto
GlobalVariable Property _BFLLightEffect1Enable Auto
GlobalVariable Property _BFLLightEffect2Enable Auto
GlobalVariable Property _BFLLightEffect3Enable Auto
GlobalVariable Property _BFLLightEffect4Enable Auto

Spell Property _BFLLightEffect0SPL Auto
Spell Property _BFLLightEffect1SPL Auto
Spell Property _BFLLightEffect2SPL Auto
Spell Property _BFLLightEffect3SPL Auto
Spell Property _BFLLightEffect4SPL Auto
;===============  UTILITIES   ==========================================;
;===============  VARIABLES   ==========================================;
Actor target
bool Light4
bool Light3
bool Light2
bool Light1
bool Light0
;===============    EVENTS    ==========================================;
Event OnEffectStart(Actor akTarget, Actor akCaster)
    target = akCaster
    Light4 = false
    Light3 = false
    Light2 = false
    Light1 = false
    Light0 = false
    Addremovelight(true)
endEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Addremovelight(false)
endEvent
;===============    STATES    ==========================================;
;===============    FUNCTIONS  ==========================================;
Function Addremovelight(bool add)
   If (add)

      If (_BFLLightEffect4Enable.GetValue() == 1.00)
         target.AddSpell(_BFLLightEffect4SPL,false)
         Light4 = true
      EndIf
      If (_BFLLightEffect3Enable.GetValue() == 1.00)
         target.AddSpell(_BFLLightEffect3SPL,false)
         Light3 = true
      EndIf
      If (_BFLLightEffect2Enable.GetValue() == 1.00)
         target.AddSpell(_BFLLightEffect2SPL,false)
         Light2 = true
      EndIf
      If (_BFLLightEffect1Enable.GetValue() == 1.00)
         target.AddSpell(_BFLLightEffect1SPL,false)
         Light1 = true
      EndIf
      If (_BFLLightEffect0Enable.GetValue() == 1.00)
         target.AddSpell(_BFLLightEffect0SPL,false)
         Light0 = true
      EndIf
   Else
      If Light4
         target.RemoveSpell(_BFLLightEffect4SPL)
      EndIf
      If Light3
         target.RemoveSpell(_BFLLightEffect3SPL)
      EndIf
      If Light2
         target.RemoveSpell(_BFLLightEffect2SPL)
      EndIf
      If Light1
         target.RemoveSpell(_BFLLightEffect1SPL)
      EndIf
      If Light0
         target.RemoveSpell(_BFLLightEffect0SPL)
      EndIf
   EndIf
EndFunction