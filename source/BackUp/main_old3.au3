#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         myName

 Script Function:
	Simple tool for visualization memory usage

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
#AutoIt3Wrapper_Res_Comment=By: Artsiom Ah(Ad)
;#AutoIt3Wrapper_Res_Icon_Add=BPlayer.ico
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

		Case $PageFaultCount  ;TODO: covert to list
			MsgBox($MB_ICONINFORMATION, _Extract("PageFaultCount", "Title"), _Extract("PageFaultCount", "Description"))

		Case Else
			Local $iDelta = Delay($iDelay)
			If Not $iCounter = $iDelta Then
				$iCounter = $iDelta
			EndIf
			If Not $bBeep Then ToolTip($iDelta)
			If $bCFlag Then UpdateData($iPID)
	EndSwitch
WEnd