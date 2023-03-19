#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Artsiom Ah(Ad)

 Script Function:
	A simple tool to visualize process memory usage: main loop

#ce ----------------------------------------------------------------------------
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=meme.exe
#AutoIt3Wrapper_Res_Description=Simple tool for visualization memory usage
#AutoIt3Wrapper_Res_Fileversion=0.0.0.1
#AutoIt3Wrapper_Res_ProductName=ProcessMemoryInfo
#AutoIt3Wrapper_Res_CompanyName=Artsiom Ah(Ad)
#AutoIt3Wrapper_Res_LegalCopyright=Artsiom Aheyeu
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Run_Debug_Mode=n
#AutoIt3Wrapper_Icon="third-party\ico.ico"
#pragma compile(CompanyName, 'Artsiom Ah(Ad)')
#pragma compile(x64, false)
#pragma compile(UPX, False)
#AutoIt3Wrapper_AU3Check_Parameters=-w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "module\GUI.au3"

While 1
	Local $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button
			$bCFlag = True
		Case $InputPID
			$iPID = GUICtrlRead($InputPID)
		Case $SnapButton
			Snap()
		Case $idItem0 To $idItem9
			ClipPut(StringReplace(GUICtrlRead($nMsg), ":", ""))
			MsgBox($MB_ICONINFORMATION, "Info", "Data copied to clipboard", 2)
		Case $BeepCP
			If _IsChecked($BeepCP) Then
				$bBeep = False
			Else
				$bBeep = True
				ToolTip("")
			EndIf
		Case $InputTime
			Local $iNumber = Number(GUICtrlRead($InputTime))
			If IsNumber($iNumber) And $iNumber <> 0 Then $iDelay = $iNumber * 1000

		Case $aControlID[0][0] to $aControlID[9][0]
			MsgBox($MB_ICONINFORMATION, _Extract(_Extract($nMsg, "Title", $aControlID), "Title"), _Extract(_Extract($nMsg, "Title", $aControlID), "Description"))

		Case Else
			Local $iDelta = Delay($iDelay)
			If Not $iCounter = $iDelta Then
				$iCounter = $iDelta
			EndIf
			If Not $bBeep Then ToolTip($iDelta)
			If $bCFlag Then UpdateData($iPID)
	EndSwitch
WEnd

Func Delay($iTime)
	If $iTimeDiff >= $iTime Then
		$hStarttime = _Timer_Init()
		$iTimeDiff = 0
		$bCFlag = True
	Else
		$iTimeDiff = _Timer_Diff($hStarttime)
	EndIf
	Return Round(($iTime - $iTimeDiff) / 1000, 0)
EndFunc   ;==>Delay
