#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Artsiom Ah(Ad)

 Script Function:
	A simple tool to visualize process memory usage: GUI module

#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Timers.au3>

#include "WinApi.au3"

Local $iDelay = 5000
Local $iCounter
Local $iPID = @AutoItPID
Global $bCFlag = False

Global $iTimeDiff = $iDelay
Global $hStarttime = _Timer_Init()

Global $iColCount = 1
Global $bBeep = False

#Region ### START Koda GUI section ### Form= third-party\KodaForm.kxf
$Form = GUICreate("ProcessMemoryInfo " & $iPID, 488, 443, 192, 124)

$PrivateUsage = GUICtrlCreateDummy()

$WorkingSetSize = GUICtrlCreateLabel("WorkingSetSize", 24, 248, 70, 17, $SS_CENTER)

$WorkingSetSizeProgress = GUICtrlCreateProgress(24, 32, 73, 209, $PBS_VERTICAL)
$PeakWorkingSetSize = GUICtrlCreateLabel("PeakWorkingSetSize", 24, 12, 70, 17, $SS_CENTER)

$QuotaPagedPoolUsage = GUICtrlCreateLabel("QuotaPagedPoolUsage", 104, 248, 70, 17, $SS_CENTER)
$QuotaPagedPoolUsageProgress = GUICtrlCreateProgress(104, 32, 73, 209, $PBS_VERTICAL)
GUICtrlSetColor($QuotaPagedPoolUsageProgress, 32250)
$QuotaPeakPagedPoolUsage = GUICtrlCreateLabel("QuotaPeakPagedPoolUsage", 104, 12, 70, 17, $SS_CENTER)

$QuotaNonPagedPoolUsage = GUICtrlCreateLabel("QuotaNonPagedPoolUsage", 184, 248, 70, 17, $SS_CENTER)
$QuotaNonPagedPoolUsageProgress = GUICtrlCreateProgress(184, 32, 73, 209, $PBS_VERTICAL)
GUICtrlSetColor($QuotaNonPagedPoolUsageProgress, 0x808080)
$QuotaPeakNonPagedPoolUsage = GUICtrlCreateLabel("QuotaPeakNonPagedPoolUsage", 184, 12, 78, 17, $SS_CENTER)

$PagefileUsage = GUICtrlCreateLabel("PagefileUsage", 264, 248, 70, 17, $SS_CENTER)
$PagefileUsageProgress = GUICtrlCreateProgress(264, 32, 73, 209, $PBS_VERTICAL)
GUICtrlSetColor($PagefileUsageProgress, 0xB9D1EA)
$PeakPagefileUsage = GUICtrlCreateLabel("PeakPagefileUsage", 264, 12, 70, 17, $SS_CENTER)

$PageFaultCount = GUICtrlCreateLabel("PageFaultCount", 432, 12, 110, 17)
GUICtrlCreateLabel("Page Faults:", 352, 12, 80, 17)
$Button = GUICtrlCreateButton("Update", 352, 70, 105, 33)
$SnapButton = GUICtrlCreateButton("Snap", 352, 208, 105, 33)
GUICtrlCreateLabel("PID:", 354, 44, 50, 17)
$InputPID = GUICtrlCreateInput($iPID, 382, 41, 75, 21, $ES_NUMBER)
$InputTime = GUICtrlCreateInput($iDelay / 1000, 410, 112, 20, 21, $ES_NUMBER)
GUICtrlCreateLabel("Set delay:", 355, 115, 50, 17)
GUICtrlCreateLabel("Sec", 435, 115, 50, 17)

$Timer = GUICtrlCreateLabel("TIME", 376, 160, 56, 29)
GUICtrlSetFont(-1, 16, 800, 0, "MS Sans Serif")

$BeepCP = GUICtrlCreateCheckbox("Silent mode", 352, 245, 105, 17)
GUICtrlSetState($BeepCP, $GUI_CHECKED)

$ListView = GUICtrlCreateListView("Description|# SNAP 1 #|# SNAP 2 #|# SNAP 3 #|# SNAP 4 #", 24, 272, 441, 145)

$idItem0 = GUICtrlCreateListViewItem("Number of page faults:", $ListView)
$idItem1 = GUICtrlCreateListViewItem("Peak working set size:", $ListView)
$idItem2 = GUICtrlCreateListViewItem("Current working set size:", $ListView)
$idItem3 = GUICtrlCreateListViewItem("Peak paged pool usage:", $ListView)
$idItem4 = GUICtrlCreateListViewItem("Current paged pool usage:", $ListView)
$idItem5 = GUICtrlCreateListViewItem("Peak nonpaged pool usage:", $ListView)
$idItem6 = GUICtrlCreateListViewItem("Current nonpaged pool usage:", $ListView)
$idItem7 = GUICtrlCreateListViewItem("Current space allocated for the pagefile:", $ListView)
$idItem8 = GUICtrlCreateListViewItem("Peak space allocated for the pagefile:", $ListView)
$idItem9 = GUICtrlCreateListViewItem("Current private space:", $ListView)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Func UpdateData($iPID)
	Local $aMemStats = MEMSTAT($iPID, $bBeep)
	If $aMemStats = Null Then Return
	For $i = 0 To UBound($INFOHEADER) - 1
		GUICtrlSetData(Execute("$" & $INFOHEADER[$i][0]), $aMemStats[$i])
	Next

	GUICtrlSetData($WorkingSetSizeProgress, ProcessValue($aMemStats[1], $aMemStats[2]))
	GUICtrlSetData($QuotaPagedPoolUsageProgress, ProcessValue($aMemStats[3], $aMemStats[4]))
	GUICtrlSetData($QuotaNonPagedPoolUsageProgress, ProcessValue($aMemStats[5], $aMemStats[6]))
	GUICtrlSetData($PagefileUsageProgress, ProcessValue($aMemStats[8], $aMemStats[7]))
	$bCFlag = False
EndFunc   ;==>UpdateData

Func Snap()
	Local $sSep
	For $i = 1 To $iColCount
		$sSep &= "|"
	Next
	For $i = 0 To UBound($INFOHEADER) - 1
		GUICtrlSetData(Execute("$idItem" & $i), $sSep & GUICtrlRead(Execute("$" & $INFOHEADER[$i][0])))
	Next
	$iColCount += 1
	If $iColCount = 5 Then $iColCount = 1
EndFunc   ;==>Snap

Func _IsChecked($idControlID)
	Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func ProcessValue($iPeak, $iCurrent)
	Return $iCurrent / $iPeak * 100
EndFunc   ;==>ProcessValue