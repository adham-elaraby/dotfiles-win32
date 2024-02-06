#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#WinActivateForce
#SingleInstance, Force
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetWorkingDir C:\Users\USERNAME ; Ensures a consistent starting directory.
#HotkeyModifierTimeout -1
#InstallKeybdHook
#Persistent

Gui, Margin, 0, 0
Gui, Font,, Hack NF
Gui, Font, s11
Gui, Font, cD2BCCD 
Gui, Add, Text,x7 y1.9 vKeyboardLayout, xx
Gui, Color, 170C0D
Gui, +Alwaysontop +Toolwindow +Disabled -SysMenu +Owner -resize +E0x8000000
Gui, Show, autosize NoActivate
gui, -caption
Gui, Show, % "x" A_ScreenWidth - 284 " y" A_ScreenHeight - 1080 " w" 30 " h" 20.5, The GUI

keybool := "true"
checklang()
{
  global keybool
  if (keybool = "true") {
    ;KeyWait Control
    KeyWait LWin
    Sleep, 150
    WinGet, WinID,, A
    ThreadID:=DllCall("GetWindowThreadProcessId", "UInt", WinID, "UInt", 0)
    InputLocaleID:=DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt")
    if (InputLocaleID = "67699721") { 
      GuiControl, , KeyboardLayout, en
    }
    else if (InputLocaleID = "67568647") { 
      ;MsgBox, de
      GuiControl, , KeyboardLayout, de
    }
    else {
      GuiControl, , KeyboardLayout, %InputLocaleID%
    }
    Gui, Show, NA
    return
  }
}

; Initialise it
checklang()
~#^Space:: checklang()

openterminal()
{
  WinActivate Program Manager ; desktop
  Run wt.exe
  ;return
}

close()
{
WinClose, A
}
   
HideShowTaskbar(action)
{
   if action
      WinHide, ahk_class Shell_TrayWnd
   else
      WinShow, ahk_class Shell_TrayWnd
}

KeyboardLayout(action)
{
  global keybool 
   if action {
      Gui, Hide
      keybool := "false"
   }
   else {
      keybool := "true"
      Sleep, 70
      checklang()
   }
}

$F1:: HideShowTaskbar(hide := !hide)
~#^b:: KeyboardLayout(hide := !hide)
;^SPACE::  Winset, Alwaysontop, , A
;#Enter::  Run alacritty.exe
#Enter::openterminal()
#W:: Run firefox.exe
#B:: Run "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" --profile-directory="Default" ---disable-features=RendererCodeIntegrity
#+B:: Run "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" --profile-directory="Profile 1" --silent-debugger-extension-api ---disable-features=RendererCodeIntegrity
;#Q:: Send !{f4}
;#Q::close()
~LWin::Send {Blind}{vkFF}

;POWERTOYS RUN
#/:: Send #{-}


>!a:: Send {ä}
>!o:: Send {ö}
>!u:: Send {ü}
>!s:: Send {ß}

>!+a:: Send {Ä}
>!+o:: Send {Ö}
>!+u:: Send {Ü}

LShift & RShift:: CapsLock