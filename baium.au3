#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.jpg
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_Language=1036
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ L2R Assitance
;~ This helper can optimise your farming time to be free to PVP

; What we need :
#include <Date.au3>
#include <ColorConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <ScreenCapture.au3>
#Include <Array.au3>
#Include <String.au3>

; We need to focus on our Nox player window
Global $hwnd = WinGetHandle("NoxPlayer")
;~ Get coordinate from our handler
Opt("MouseCoordMode", 2)
Opt("GUIOnEventMode", 1)
;WinMove("[CLASS:SpotifyMainWindow]", "", Default, Default, 1280, 720)
WinMove($hwnd, "", Default, Default, 960, 540)

Global $mode_test = false

; Todays actions
; Allows the script to carry on from where it stopped
$Tc = 0

Global $Interrupt = 1
$EventCheck = 0

Global $hGUI = GUICreate("Baium", 560, 250)
$hPic_background = GUICtrlCreatePic(@WorkingDir & "\background.jpg", 0, 0, 0, 0)
;; create more controls here
GUICtrlSetState($hPic_background, $GUI_DISABLE)

GUISetOnEvent($GUI_EVENT_CLOSE, "ThatExit")

$RunBtn = GUICtrlCreateButton("Lancer", 10, 10, 80, 30)
$StopBtn = GUICtrlCreateButton("Arrêter", 10, 10, 80, 30)
;~ GUICtrlSetLimit(-1, 200) ; to limit horizontal scrolling
Global $idListview = GUICtrlCreateListView("Heure|Message", 10, 50, 540, 190,$LVS_SORTDESCENDING)
_GUICtrlListView_SetColumnWidth($idListview,0,50)
_GUICtrlListView_SetColumnWidth($idListview,1,276)
;GUICtrlSetOnEvent($RunBtn, "RunnerFunc")
GUICtrlSetState($StopBtn, $GUI_HIDE)
GUISetState()
GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")

Func _WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	If BitAND($wParam, 0x0000FFFF) =  $StopBtn Then
	  $Interrupt = 1
	EndIf
  Return $GUI_RUNDEFMSG
EndFunc

Func ThatExit()
   Exit
EndFunc

Func LogInGame()
	_ScreenCapture_CaptureWnd(@WorkingDir & "\cache\login", $hwnd, 20, 22, 166, 52)
EndFunc

ConsoleWrite("test" & @CRLF)

While 1
	If $Interrupt <> 0 Then
		$EventCheck = 0
	Else
		$EventCheck = 1
		;_startPlaying()
	EndIf
WEnd