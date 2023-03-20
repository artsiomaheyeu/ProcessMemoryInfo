#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_AU3Check_Parameters=-w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Artsiom Ah(Ad)

 Script Function:
	A simple tool to visualize process memory usage: main loop

#ce ----------------------------------------------------------------------------

#include "module\GUI.au3"

Local $sListViewText = $sListTitle & @CRLF

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
			MsgBox($MB_ICONINFORMATION, "Info", "Data row copied to clipboard", 2)
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
		Case $aControlID[0][0] To $aControlID[9][0]
			MsgBox($MB_ICONINFORMATION, _Extract(_Extract($nMsg, "Title", $aControlID), "Title"), _Extract(_Extract($nMsg, "Title", $aControlID), "Description"))
		Case $ListView
			$sListViewText &= StringReplace(GUICtrlRead($PIDName), ":", "") & @CRLF
			For $i = 0 To 9
				$sListViewText &= StringReplace(GUICtrlRead(Execute("$idItem" & $i)), ":", "") & @CRLF
			Next
			ClipPut($sListViewText)
			MsgBox($MB_ICONINFORMATION, "Info", "Table copied to clipboard", 2)
			$sListViewText = $sListTitle & @CRLF
		Case Else
			Local $iDelta = Delay($iDelay)
			If Not $iCounter = $iDelta Then $iCounter = $iDelta
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
