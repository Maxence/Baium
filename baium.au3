#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.jpg
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_Language=1036
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ L2R Assitance
;~ This helper can optimise your farming time to be free to PVP

; Scheme
; Auto Launch if game is crashed
; Auto Login
; Auto Select char

; What we need :
#include <Date.au3>
#include <ColorConstants.au3>
#include <FontConstants.au3>
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
WinMove($hwnd, "", Default, Default, 1280, 720)
;WinMove($hwnd, "", Default, Default, 960, 540)

Global $mode_test = false

Global $noxPlayerTopBarHeight = 30;

; Todays actions
; Allows the script to carry on from where it stopped
$Tc = 0

Global $Interrupt = 1
$EventCheck = 0

Global $hGUI = GUICreate("Baium", 800, 512)
$hPic_background = GUICtrlCreatePic(@WorkingDir & "\background.jpg", 0, 0, 0, 0)
;; create more controls here
GUICtrlSetState($hPic_background, $GUI_DISABLE)

GUISetOnEvent($GUI_EVENT_CLOSE, "ThatExit")

Local Const $sFont = "Roboto"
$RunBtn = GUICtrlCreateButton("Assist Me!", 569 , 20, 139, 40)
GUICtrlSetFont(-1, 19, $FW_HEAVY , '', $sFont)
$StopBtn = GUICtrlCreateButton("Stop Me!", 569 , 20, 139, 40)
GUICtrlSetFont(-1, 9, $FW_HEAVY , '', $sFont)
;~ GUICtrlSetLimit(-1, 200) ; to limit horizontal scrolling
Global $idListview = GUICtrlCreateListView("Date|Message", 500, 66, 277, 260,$LVS_SORTDESCENDING)
GUICtrlSetFont(-1, 9, $FW_NORMAL, '', $sFont)
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
	WinSetState($hwnd, "", @SW_SHOW)
	_ScreenCapture_CaptureWnd(@WorkingDir & "\cache\login.png", $hwnd, 24, 21+$noxPlayerTopBarHeight, 170, 48+$noxPlayerTopBarHeight)
	;WinSetState($hwnd, "", @SW_HIDE)
	$disconnectedTxt = _TessOcr(@WorkingDir & "\cache\login.png", @WorkingDir & "\cache\loginscreen")
	ConsoleWrite("$disconnectedTxt " & $disconnectedTxt & @CRLF)
EndFunc

;~ Fonction OCR qui utilise la librairie Tesseract de HP & Google
Func _TessOcr($in_image, $out_file)
	Local $Read
	Local $iReturn = ShellExecuteWait(@WorkingDir & "\lib\tesseract-ocr\tesseract.exe", $in_image & " " & $out_file & " -psm 6", Null, Null, @SW_HIDE)
;~ 	ConsoleWrite("@ProgramFilesDir:" & @ProgramFilesDir & " (x86)\Tesseract-OCR\tesseract.exe" & @CRLF)
;~ 	ConsoleWrite("param:" & '"' & $in_image & '" "' & $out_file & '" ' & '"-l eng"'  & '" ' &'" -psm 6"' & @CRLF)
	If @error Then
		MsgBox(0,"Error","ShellExecuteWait Error")
		Exit
	EndIf
	If FileExists($out_file & ".txt") Then
		$Read = FileRead($out_file & ".txt")
		;FileDelete($out_file & ".txt")
	Else
		$Read = "No file created"
	EndIf
	$result = StringSplit($Read, @CRLF)
	Return $result
EndFunc   ;==>_TessOcr

Func _checkIsConnected()
	$sFilePath = @WorkingDir & '\cache\logged.txt'
	$command = 'netstat -na | find "12000" > ' & $sFilePath
	RunWait( @ComSpec & " /C " & $command, "", @SW_HIDE )
	; Open the file for reading and store the handle to a variable.
    Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
        Return False
    EndIf
	; Read the contents of the file using the handle returned by FileOpen.
    Local $sFileRead = FileRead($hFileOpen)
	; Close the handle returned by FileOpen.
    FileClose($hFileOpen)
	$check = StringInStr( $sFileRead, "ESTABLISHED")
	;ConsoleWrite("$check:" & $check & @CRLF)
	If $check > 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc

LogInGame()
$test = _checkIsConnected()
ConsoleWrite("$test " & $test & @CRLF)
While 1
	If $Interrupt <> 0 Then
		$EventCheck = 0
	Else
		$EventCheck = 1
		;_startPlaying()
	EndIf
WEnd