#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=img\baium.ico
#AutoIt3Wrapper_Res_Fileversion=1.0.0.3
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_Language=1033
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

; Choose a player
Global $player = "bluestack"
;Global $player = "noxplayer"
; We need to focus on our Nox player window
If $player = "bluestack" Then
	Global $hwnd = WinGetHandle("BlueStacks")
	Global $playerTopBarHeight = 47
	Global $playerLeftBarWidth = 7
	ConsoleWrite("Using Bluestack Player" & @CRLF)
Else
	Global $hwnd = WinGetHandle("NoxPlayer")
	Global $playerTopBarHeight = 30
	Global $playerLeftBarWidth = 0
	ConsoleWrite("Using Nox Player" & @CRLF)
EndIf
;~ Get coordinate from our handler
Opt("MouseCoordMode", 2)
Opt("GUIOnEventMode", 1)
WinMove($hwnd, "", Default, Default, 1280, 750)
;WinMove($hwnd, "", Default, Default, 960, 540)

Global $mode_test = false

; Todays actions
; Allows the script to carry on from where it stopped
$Tc = 0

Global $Interrupt = 1
$EventCheck = 0

Global $hGUI = GUICreate("Baium", 800, 512)
$hPic_background = GUICtrlCreatePic(@WorkingDir & "\background.jpg", 0, 0, 0, 0)
GUICtrlSetState($hPic_background, $GUI_DISABLE)

GUISetOnEvent($GUI_EVENT_CLOSE, "ThatExit")

Global $colorGrade[7]
$colorGradeC = "0X006A6A6A"
$colorGradeB = "0X006888AB"
$colorGradeA = "0X0071A00E"
$colorGradeS = "0X0000D0CE"
$colorGradeR = "0X00AD51F5"
$colorGradeSR = "0X00E88B2A"
$colorGradeUR = "0X00FF4246"

Global Const $sFontGeorgia = "Georgia"
Global Const $sFontRoboto = "Roboto"
; Top bar
; Status
GUICtrlCreateLabel("Status:", 725, 4, 80, 20)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00000000)
Global $statusGame = GUICtrlCreateLabel("Offline", 760, 4, 750, 25)
GUICtrlSetFont(-1, 8, $FW_HEAVY , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00E1260C)

; Basic Info
; Grade Char
Global $basicInfoGradeData = GUICtrlCreateLabel("C", 38, 66, 50, 50)
GUICtrlSetFont(-1, 32, $FW_NORMAL , '', $sFontGeorgia)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X0054EFCF)
; Nickname Char
Global $basicInfoNicknameData = GUICtrlCreateLabel("Baium", 12, 105, 147, 27)
GUICtrlSetFont(-1, 18, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
; Class Char
Global $basicInfoClassData = GUICtrlCreateLabel("N/A", 12, 130, 147, 16)
GUICtrlSetFont(-1, 10, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
; Level Char
Global $basicInfoLevelData = GUICtrlCreateLabel("Lv260", 12, 145, 147, 25)
GUICtrlSetFont(-1, 16, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
; Exp Char
Global $basicInfoExpData = GUICtrlCreateLabel("Exp.", 75, 155, 60, 16)
GUICtrlSetFont(-1, 7, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
; Combat Power
GUICtrlCreateLabel("Combat Power", 12, 184, 147, 25)
GUICtrlSetFont(-1, 12, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
Global $basicInfoCPData = GUICtrlCreateLabel("N/A", 12, 204, 147, 25)
GUICtrlSetFont(-1, 18, $FW_HEAVY , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X0055C712)
; Achievement Tier.
Global $basicInfoAchivementGradeNameData = GUICtrlCreateLabel("", 12, 235, 147, 25)
GUICtrlSetFont(-1, 11, $FW_HEAVY , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
GUICtrlCreateLabel("Achievement Tier.", 12, 250, 147, 20)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
Global $basicInfoAchivementGradeData = GUICtrlCreateLabel("N/A", 102, 250, 147, 25)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
; Arena Grade
GUICtrlCreateLabel("Arena Grade", 12, 263, 147, 20)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
Global $basicInfoArenaGradeData = GUICtrlCreateLabel("N/A", 102, 263, 147, 25)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
; Arena Rank
GUICtrlCreateLabel("Arena Rank", 12, 276, 147, 20)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
Global $basicInfoArenaRankData = GUICtrlCreateLabel("N/A", 102, 276, 147, 25)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
; Dungeon list enabled
; Depend of your choice
GUICtrlCreatePic(@WorkingDir & "\img\dungeon_daily.bmp", 24, 352, 92, 153)
GUICtrlCreatePic(@WorkingDir & "\img\dungeon_toi.bmp", 119, 352, 91, 153)
GUICtrlCreatePic(@WorkingDir & "\img\dungeon_elite.bmp", 214, 352, 92, 153)
GUICtrlCreatePic(@WorkingDir & "\img\dungeon_extraction.bmp", 309, 352, 92, 153)
GUICtrlCreatePic(@WorkingDir & "\img\dungeon_stuff.bmp", 404, 352, 92, 153)
GUICtrlCreatePic(@WorkingDir & "\img\dungeon_adena.bmp", 499, 352, 91, 153)
GUICtrlCreatePic(@WorkingDir & "\img\dungeon_exp.bmp", 594, 352, 92, 153)
GUICtrlCreatePic(@WorkingDir & "\img\dungeon_mount.bmp", 689, 352, 93, 153)
; My Dungeons
GUICtrlCreateLabel("My Dungeons", 12, 318, 215, 55)
GUICtrlSetFont(-1, 26, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)

$RunBtn = GUICtrlCreateButton("Assist Me!", 558 , 20, 139, 40)
GUICtrlSetOnEvent($RunBtn, "RunnerFunc")
GUICtrlSetFont(-1, 19, $FW_HEAVY , '', $sFontRoboto)
$StopBtn = GUICtrlCreateButton("Stop Me!", 558 , 20, 139, 40)
GUICtrlSetOnEvent($StopBtn, "StopFunc")
GUICtrlSetFont(-1, 19, $FW_HEAVY , '', $sFontRoboto)
;~ GUICtrlSetLimit(-1, 200) ; to limit horizontal scrolling
Global $idListview = GUICtrlCreateListView("Date|Message", 477, 66, 300, 260,$LVS_SORTDESCENDING)
_GUICtrlListView_SetBkImage(GUICtrlGetHandle($idListview), @WorkingDir & "\img\listBackground.bmp", 1, 0, 0)
GUICtrlSetFont(-1, 9, $FW_NORMAL, '', $sFontRoboto)
_GUICtrlListView_SetColumnWidth($idListview,0,80)
_GUICtrlListView_SetColumnWidth($idListview,1,215)
;GUICtrlSetOnEvent($RunBtn, "RunnerFunc")
GUICtrlSetState($StopBtn, $GUI_HIDE)
GUISetState()
GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")

Func addLog($string)
	GUICtrlCreateListViewItem(StringTrimRight(_NowDate(), 5) & " " & StringTrimRight(_NowTime(),3) & "|"& $string, $idListview)
EndFunc

Func RunnerFunc()
	; This check avoids GUI flicker
	If $EventCheck = 0 Then
		GUICtrlSetState($RunBtn, $GUI_HIDE)
		GUICtrlSetState($StopBtn, $GUI_SHOW)
	EndIf
	addLog("Biaum is awake!")
	fetchData()
	$Interrupt = 0
	$EventCheck = 0
EndFunc

Func StopFunc()
	$Interrupt = 1
	ConsoleWrite("StopFunc() $Interrupt " & $Interrupt & @CRLF)
	addLog("Biaum is now sleeping.")
	GUICtrlSetState($StopBtn, $GUI_HIDE)
	GUICtrlSetState($RunBtn, $GUI_SHOW)
	ConsoleWrite(">Stopped" & @CRLF)
EndFunc

Func _WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	If BitAND($wParam, 0x0000FFFF) =  $StopBtn Then
	  $Interrupt = 1
	EndIf
  Return $GUI_RUNDEFMSG
EndFunc

Func ThatExit()
   Exit
EndFunc

Func tap($posX,$posY,$sleepTime = 0)
	Local $currentWindow = WinGetHandle("")
	WinActivate($hwnd)
	Local $randomPosX = randomTapPosition($posX, Random(1, 25, 1)) + $playerLeftBarWidth
	Local $randomPosY = randomTapPosition($posY, Random(1, 10, 1)) + $playerTopBarHeight
	Local $mousePos = MouseGetPos()
	MouseClick($MOUSE_CLICK_LEFT, $randomPosX, $randomPosY, 1, 0)
	ConsoleWrite("$MOUSE_CLICK_LEFT x:" & $randomPosX & " y:" & $randomPosY & @CRLF)
	MouseMove($mousePos[0],$mousePos[1],0)
	WinActivate($currentWindow)
	sleep($sleepTime + Random(1, 250, 1))
EndFunc

Func fetchData()
	readBasicInfo()
EndFunc

Func readBasicInfo()
	; Menu -> Character -> Character
	tap(836,28, 120)
	tap(218,44, 200)
	tap(217,156, 1500)

	; Nickname
	;$basicInfoNickname = readScreenPlayer("basicInfoNickname",913,305,997,334)
	Global $basicInfoNickname = readScreenPlayer("basicInfoNickname",700,278,1000,308)
	ConsoleWrite("$basicInfoNickname " & $basicInfoNickname & @CRLF)
	; Grade
	;$basicInfoGrade = readScreenPlayer("basicInfoGrade",911,193,1015,288)
	Global $basicInfoGrade = readScreenPlayer("basicInfoGrade",828,172,930,277)
	ConsoleWrite("$basicInfoGrade " & $basicInfoGrade & @CRLF)
	; CP
	;$basicInfoCP = readScreenPlayer("basicInfoCP",833,337,929,367)
	;$basicInfoCP = readScreenPlayer("basicInfoCP",242,468,350,497)
	Global $basicInfoCP = readScreenPlayer("basicInfoCP",760,305,853,332)
	ConsoleWrite("$basicInfoCP " & $basicInfoCP & @CRLF)
	; Class
	;$basicInfoClass = readScreenPlayer("basicInfoClass",733,402,941,430)
	Global $basicInfoClass = readScreenPlayer("basicInfoClass",670,366,847,390)
	ConsoleWrite("$basicInfoClass " & $basicInfoClass & @CRLF)
	; Achievement Grade
	;$basicInfoAchivementGrade = readScreenPlayer("basicInfoAchivementGrade",960,502,987,533)
	Global $basicInfoAchivementGrade = readScreenPlayer("basicInfoAchivementGrade",874,460,903,480)
	ConsoleWrite("$basicInfoAchivementGrade " & $basicInfoAchivementGrade & @CRLF)
	; Achievement Grade Name
	;$basicInfoAchivementGradeName = readScreenPlayer("basicInfoAchivementGradeName",988,505,1164,537)
	Global $basicInfoAchivementGradeName = readScreenPlayer("basicInfoAchivementGradeName",904,459,1064,488)
	ConsoleWrite("$basicInfoAchivementGradeName " & $basicInfoAchivementGradeName & @CRLF)
	; Arena Grade
	Global $basicInfoArenaGrade = readScreenPlayer("basicInfoArenaGrade",874,530,903,555)
	ConsoleWrite("$basicInfoArenaGrade " & $basicInfoArenaGrade & @CRLF)
	; Arena Rank
	Global $basicInfoArenaRank = readScreenPlayer("basicInfoArenaRank",745,604,780,625)
	ConsoleWrite("$basicInfoArenaRank " & $basicInfoArenaRank & @CRLF)
	; Level
	Global $basicInfoLevel = "Lv" & readScreenPlayer("basicInfoLevel",133,452,173,470)
	ConsoleWrite("$basicInfoLevel " & $basicInfoLevel & @CRLF)
	; Red Gems
	Global $basicInfoRedGems = readScreenPlayer("basicInfoRedGems",596,25,698,45)
	ConsoleWrite("$basicInfoRedGems " & $basicInfoRedGems & @CRLF)
	; Blue Gems
	Global $basicInfoBlueGems = readScreenPlayer("basicInfoBlueGems",756,25,864,45)
	ConsoleWrite("$basicInfoBlueGems " & $basicInfoBlueGems & @CRLF)
	; Adena
	Global $basicInfoAdena = readScreenPlayer("basicInfoAdena",944,25,1064,45)
	ConsoleWrite("$basicInfoAdena " & $basicInfoAdena & @CRLF)
	tap(1133,35, 200)
	updateBasicInfo()
EndFunc

Func updateBasicInfo()
	GUICtrlSetData($basicInfoNicknameData,$basicInfoNickname)
	GUICtrlSetData($basicInfoGradeData,$basicInfoGrade)
		If $basicInfoGrade = "C" Then
			GUICtrlSetColor($basicInfoGradeData, $colorGradeC)
		ElseIf $basicInfoGrade = "B" Then
			GUICtrlSetColor($basicInfoGradeData, $colorGradeB)
		ElseIf $basicInfoGrade = "A" Then
			GUICtrlSetColor($basicInfoGradeData, $colorGradeA)
		ElseIf $basicInfoGrade = "S" Then
			GUICtrlSetColor($basicInfoGradeData, $colorGradeS)
		ElseIf $basicInfoGrade = "R" Then
			GUICtrlSetColor($basicInfoGradeData, $colorGradeR)
		ElseIf $basicInfoGrade = "SR" Then
			GUICtrlSetColor($basicInfoGradeData, $colorGradeSR)
		ElseIf $basicInfoGrade = "UR" Then
			GUICtrlSetColor($basicInfoGradeData, $colorGradeUR)
		EndIf
	GUICtrlSetData($basicInfoCPData,$basicInfoCP)
	GUICtrlSetData($basicInfoClassData,$basicInfoClass)
	GUICtrlSetData($basicInfoAchivementGradeData,$basicInfoAchivementGrade)
	GUICtrlSetData($basicInfoAchivementGradeNameData,$basicInfoAchivementGradeName)
	GUICtrlSetData($basicInfoArenaGradeData,$basicInfoArenaGrade)
	GUICtrlSetData($basicInfoArenaRankData,$basicInfoArenaRank)
	GUICtrlSetData($basicInfoLevelData,$basicInfoLevel)
EndFunc

Func randomTapPosition($pos, $range)
	Local $randomValue = Random(1, 2, 1)
	If $randomValue = 2 Then
		$pos = $pos + $range
	Else
		$pos = $pos - $range
	EndIf
	Return $pos
 EndFunc

Func LogInGame()
	$loginPage = readScreenPlayer("loginscreen",24,21,170,48)
	ConsoleWrite("$loginPage " & $loginPage & @CRLF)
EndFunc

Func readScreenPlayer($filename, $startPosX, $startPosY, $endPostX, $endPosdY, $multiLine = False)
	_ScreenCapture_CaptureWnd(@WorkingDir & "\cache\" & $filename & ".png", $hwnd, $startPosX+$playerLeftBarWidth, $startPosY+$playerTopBarHeight, $endPostX+$playerLeftBarWidth, $endPosdY+$playerTopBarHeight)
	Local $value = _TessOcr(@WorkingDir & "\cache\" & $filename & ".png", @WorkingDir & "\cache\" & $filename)
	Local $hFileOpen = FileOpen(@WorkingDir & "\cache\" & $filename & ".txt", $FO_READ)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
        Return False
    EndIf
	; Read the contents of the file using the handle returned by FileOpen.
    Local $sFileRead = FileRead($hFileOpen)
	; Close the handle returned by FileOpen.
    FileClose($hFileOpen)
	If $multiLine = False Then
		$sFileRead = StringRegExpReplace($sFileRead, "\n", "")
	EndIf
	return $sFileRead
EndFunc

;~ Fonction OCR qui utilise la librairie Tesseract de HP & Google
Func _TessOcr($in_image, $out_file)
	Local $Read
	;Local $iReturn = ShellExecuteWait(@WorkingDir & "\lib\tesseract-ocr\tesseract.exe", $in_image & " " & $out_file & " -psm 6", Null, Null, @SW_HIDE)
	Local $iReturn = ShellExecuteWait(@WorkingDir & "\lib\tesseract-4.0.0-alpha\tesseract.exe", $in_image & " " & $out_file & " -psm 6", Null, Null, @SW_HIDE)
	;ConsoleWrite("@ProgramFilesDir:" & @ProgramFilesDir & " (x86)\Tesseract-OCR\tesseract.exe" & @CRLF)
	;ConsoleWrite("param:" & '"' & $in_image & '" "' & $out_file & '" ' & '"-l eng"'  & '" ' &'" -psm 6"' & @CRLF)
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

Func updateData($value, $element, $fontColor = "0x0000FFFF")
	GUICtrlSetData($element, $value)
	GUICtrlSetColor($element, $fontColor)
EndFunc

Func checkIsConnected()
	sleep(5000) ; delay because this function is a recursive function
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
		updateData('Online', $statusGame, "0X0055C712")
	Else
		updateData('Offline', $statusGame, "0X00E1260C")
	EndIf
	checkIsConnected()
EndFunc

Func _startPlaying()

EndFunc

;_ScreenCapture_CaptureWnd(@WorkingDir & "\cache\currentview.png", $hwnd, 0,0, 1280, 750)
checkIsConnected()
While 1
	If $Interrupt <> 0 Then
		$EventCheck = 0
	Else
		$EventCheck = 1
		_startPlaying()
	EndIf
WEnd