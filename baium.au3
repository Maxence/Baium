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

#include <WinAPI.au3>
#include <GDIPlus.au3>

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
Opt("PixelCoordMode", 0)
WinMove($hwnd, "", Default, Default, 1280, 750)
;WinMove($hwnd, "", Default, Default, 960, 540)

Global $mode_test = false

Global $currentView, $isConnected

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

Func createPNG($path, $left, $top, $width, $height)
	Local Const $STM_SETIMAGE = 0x0172
	_GDIPlus_Startup()
	Local $hImage = _GDIPlus_ImageLoadFromFile($path)
	Local $iW = _GDIPlus_ImageGetWidth($hImage)
	Local $iH = _GDIPlus_ImageGetHeight($hImage)
	Local $hBitmap = _GDIPlus_BitmapCloneArea($hImage, 0, 0, $iW, $iH, $GDIP_PXF32ARGB)
	Local $hBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)

	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()

	Local $Pic = GUICtrlCreatePic("", $left, $top, $width, $height)
	GUICtrlSendMsg($Pic, $STM_SETIMAGE, 0, $hBmp)
	_WinAPI_DeleteObject($hBmp)

	return $Pic
EndFunc

Global Const $sFontGeorgia = "Georgia"
Global Const $sFontRoboto = "Roboto"
; Top bar
; Red Gems
Global $redGemsIcon = createPNG(@WorkingDir & "\img\redgems.png", 200, 2, 12, 14)
Global $redGemsIconCounter = GUICtrlCreateLabel("126 941", 220, 3, 100, 25)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
GUICtrlSetState($redGemsIcon, $GUI_HIDE)
GUICtrlSetState($redGemsIconCounter, $GUI_HIDE)
; Blue Gem
Global $blueGemsIcon = createPNG(@WorkingDir & "\img\bluegems.png", 280, 2, 13, 13)
Global $blueGemsIconCounter = GUICtrlCreateLabel("126 941", 300, 3, 100, 25)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
GUICtrlSetState($blueGemsIcon, $GUI_HIDE)
GUICtrlSetState($blueGemsIconCounter, $GUI_HIDE)
; Adena
Global $adenaIcon = createPNG(@WorkingDir & "\img\adena.png", 360, 2, 15, 14)
Global $adenaIconCounter = GUICtrlCreateLabel("926 941 456", 380, 3, 100, 25)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
GUICtrlSetState($adenaIcon, $GUI_HIDE)
GUICtrlSetState($adenaIconCounter, $GUI_HIDE)
; Friends Coin
Global $friendsCoinIcon = createPNG(@WorkingDir & "\img\friendscoin.png", 460, 2, 15, 14)
Global $friendsCoinCounter = GUICtrlCreateLabel("99 999", 480, 3, 100, 25)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
GUICtrlSetState($friendsCoinIcon, $GUI_HIDE)
GUICtrlSetState($friendsCoinCounter, $GUI_HIDE)
; Clan Coin
Global $clanCoinIcon = createPNG(@WorkingDir & "\img\clancoin.png", 540, 2, 15, 14)
Global $clanCoinCounter = GUICtrlCreateLabel("99 999", 560, 3, 100, 25)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
GUICtrlSetState($clanCoinIcon, $GUI_HIDE)
GUICtrlSetState($clanCoinCounter, $GUI_HIDE)

; Status
GUICtrlCreateLabel("Status:", 725, 4, 80, 20)
GUICtrlSetFont(-1, 8, $FW_NORMAL , '', $sFontRoboto)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT )
GUICtrlSetColor(-1, 0X00FFFFFF)
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

$RunBtn = GUICtrlCreateButton("Assist Me!", 558 , 22, 139, 40)
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
	addLog("Baium is awake!")
	fetchData()
	$Interrupt = 0
	$EventCheck = 0
EndFunc

Func StopFunc()
	$Interrupt = 1
	ConsoleWrite("StopFunc() $Interrupt " & $Interrupt & @CRLF)
	addLog("Baium is now sleeping.")
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

Func tap($posX,$posY,$sleepTime = 0, $size = "normal")
	Local $currentWindow = WinGetHandle("")
	WinActivate($hwnd)
	If $size = "small" Then
		Local $randPosX = Random(1, 2, 1)
		Local $randPosY = Random(1, 2, 1)
	ElseIf $size = "long" Then
		Local $randPosX = Random(1, 15, 1)
		Local $randPosY = Random(1, 2, 1)
	Else
		Local $randPosX = Random(1, 5, 1)
		Local $randPosY = Random(1, 5, 1)
	EndIf

	Local $randomPosX = randomTapPosition($posX, $randPosX) + $playerLeftBarWidth
	Local $randomPosY = randomTapPosition($posY, $randPosY) + $playerTopBarHeight
	Local $mousePos = MouseGetPos()
	MouseClick($MOUSE_CLICK_LEFT, $randomPosX, $randomPosY, 1, 0)
	ConsoleWrite("$MOUSE_CLICK_LEFT x:" & $randomPosX & " y:" & $randomPosY & @CRLF)
	MouseMove($mousePos[0],$mousePos[1],0)
	WinActivate($currentWindow)
	Sleep($sleepTime + Random(1, 250, 1))
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
	; Exp.
	Global $basicInfoExp = "Exp. " & readScreenPlayer("basicInfoExp",774,394,830,412)
	ConsoleWrite("$basicInfoExp " & $basicInfoExp & @CRLF)
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
	GUICtrlSetData($basicInfoCPData, $basicInfoCP)
	GUICtrlSetData($basicInfoClassData, $basicInfoClass)
	GUICtrlSetData($basicInfoAchivementGradeData, $basicInfoAchivementGrade)
	GUICtrlSetData($basicInfoAchivementGradeNameData, $basicInfoAchivementGradeName)
	GUICtrlSetData($basicInfoArenaGradeData, $basicInfoArenaGrade)
	GUICtrlSetData($basicInfoArenaRankData, $basicInfoArenaRank)
	GUICtrlSetData($basicInfoLevelData, $basicInfoLevel)
	GUICtrlSetData($basicInfoExpData, $basicInfoExp)
	GUICtrlSetData($redGemsIconCounter,$basicInfoRedGems)
	GUICtrlSetState($redGemsIcon, $GUI_SHOW)
	GUICtrlSetState($redGemsIconCounter, $GUI_SHOW)

	GUICtrlSetData($blueGemsIconCounter,$basicInfoBlueGems)
	GUICtrlSetState($blueGemsIcon, $GUI_SHOW)
	GUICtrlSetState($blueGemsIconCounter, $GUI_SHOW)

	GUICtrlSetData($adenaIconCounter,$basicInfoAdena)
	GUICtrlSetState($adenaIcon, $GUI_SHOW)
	GUICtrlSetState($adenaIconCounter, $GUI_SHOW)
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

Func isLoginView()
	Local $loginPage = readScreenPlayer("loginscreen",605,440,805,468)
	If $loginPage = "Find My Character" Then
		Return True
	Else
		Return False
	EndIf
	ConsoleWrite("$loginPage " & $loginPage & @CRLF)
EndFunc

; Checking if New Popup at the login page are showing
Func isPopupShow()
	Local $lookingForWhite = Hex(PixelGetColor(1140+$playerLeftBarWidth, 22+$playerTopBarHeight, $hwnd), 6)
	Local $lookingForWhite2 = Hex(PixelGetColor(1142+$playerLeftBarWidth, 22+$playerTopBarHeight, $hwnd), 6)
	Local $lookingForBlack = Hex(PixelGetColor(1132+$playerLeftBarWidth, 25+$playerTopBarHeight, $hwnd), 6)
	Local $lookingForBlack2 = Hex(PixelGetColor(1141+$playerLeftBarWidth, 18+$playerTopBarHeight, $hwnd), 6)
	ConsoleWrite("$lookingForWhite: " & $lookingForWhite & @CRLF)
	ConsoleWrite("$lookingForWhite2: " & $lookingForWhite2 & @CRLF)
	ConsoleWrite("$lookingForBlack: " & $lookingForBlack & @CRLF)
	ConsoleWrite("$lookingForBlack2: " & $lookingForBlack2 & @CRLF)
	If $lookingForWhite = "2B2B2B" And $lookingForWhite2 = "FFFFFF" And $lookingForBlack = "000000" And $lookingForBlack2 = "000000" Then
		Return True
	Else
		Return False
	EndIf
EndFunc

; This function close any popup
Func closePopup()
	tap(1139,25, 120)
EndFunc

Func pressPlayButton()
	tap(982,587, 200)
	addLog("Play!")
EndFunc

Func login()
	tap(579,305, 120)
	addLog("Logging")
	Sleep(10000)
	; We check if a popup is there
	If isPopupShow() = True Then
		addLog("Closing the popup")
		closePopup()
	EndIf
	Sleep(5000)
	; Sometime, 2 popup is there
	If isPopupShow() = True Then
		addLog("Closing the second popup")
		closePopup()
	EndIf
	Sleep(2000)
	pressPlayButton()
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

Func relaunchApp()
	Local $posX = 564-7
	Local $posY = 79-35
	tap($posX,$posY, 120, "small")
	;_ScreenCapture_CaptureWnd(@WorkingDir & "\cache\test.png", $hwnd, $posX+$playerLeftBarWidth, $posY+$playerTopBarHeight, $posX+40+$playerLeftBarWidth, $posY+40+$playerTopBarHeight)
	;Sleep(25000)
	;tap(233,312, 120, "small")
	addLog("Launching L2R app")
	Sleep(20000)
	checkAppPosition()
	ConsoleWrite("$currentView: " & $currentView & @CRLF)
	If $currentView = "loginView" Then
		login()
	EndIf
EndFunc

Func checkAppPosition()
	Local $loginView = isLoginView()
	If $loginView = True Then
		addLog("Detecting login screen")
		$currentView = "loginView"
	EndIf

	Return $currentView
EndFunc

; Am I Dead ? I should respawn ?
Func amIDead()
	Local $youWereKilledBy = readScreenPlayer("youWereKilledBy",280,65,859,108)
	Local $check = StringInStr( $youWereKilledBy, "ou were killed by")
	Local $check2 = StringInStr( $youWereKilledBy, "ouwere killed by")
	Local $check3 = StringInStr( $youWereKilledBy, "Died.")
	Local $check4 = StringInStr( $youWereKilledBy, "Dled.")
	ConsoleWrite("$youWereKilledBy " & $youWereKilledBy & @CRLF)
	If $check > 0 Or $check2 > 0 Or $check3 > 0 Or $check4 > 0 Then
		addLog("Someone killed you!")
		_ScreenCapture_CaptureWnd(@WorkingDir & "\deathLog\" & StringReplace(_NowDate(), "/", "-") & "_" & StringReplace(_NowTime(), ":", ".") & ".png", $hwnd)
		Local $randSleep = Random(1000, 2500, 1)
		Local $randSpawnStyle = Random(1, 5, 1)
		Sleep($randSleep)
		If $randSpawnStyle = 5 Then
			waitingSpawnAuto()
		Else
			spotRevival()
		EndIf
		Return True
	Else
		Return False
	EndIf
EndFunc

; Am I Disconnected ? I should relog ?
Func amIDisconnected()
	Local $disconnectedFromTheServer = readScreenPlayer("disconnectedFromTheServer",280,65,859,108)
	Local $check = StringInStr( $disconnectedFromTheServer, "Disconnected from the server")
	ConsoleWrite("$disconnectedFromTheServer " & $disconnectedFromTheServer & @CRLF)
	If $check > 0 Then
		addLog("You are disconnected, trying to reconnect...")
		tap(709,469, 450, "long")
		Return True
	Else
		Return False
	EndIf
EndFunc

Func spotRevival()
	tap(1042, 400, 250)
	addLog("Respawning now to Spot Revival")
	Sleep(1000)
	closeDifferentWaysToStrengthenYourChar()
EndFunc

Func waitingSpawnAuto()
	addLog("We are waiting to respawn automatically")
	Local $randSleep = Random(35000, 65000, 1)
	Sleep($randSleep)
	closeDifferentWaysToStrengthenYourChar()
EndFunc

Func closeDifferentWaysToStrengthenYourChar()
	tap(1128, 234, 250, 'small')
EndFunc

Func checkIsConnected()
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
		Return True
	Else
		updateData('Offline', $statusGame, "0X00E1260C")
		relaunchApp()
		Return False
	EndIf
EndFunc

Func cron()
	sleep(5000) ; delay because this function is a recursive function
	$isConnected = checkIsConnected()
	If $isConnected = True Then
		amIDead()
	EndIf
	amIDisconnected()

	cron()
EndFunc

;_ScreenCapture_CaptureWnd(@WorkingDir & "\cache\currentview.png", $hwnd, 0,0, 1280, 750)
;login() ;test
cron()
While 1
	If $Interrupt <> 0 Then
		$EventCheck = 0
	Else
		$EventCheck = 1
	EndIf
WEnd