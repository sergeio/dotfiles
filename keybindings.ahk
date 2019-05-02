#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force ;autoreload
#IfWinNotActive ahk_class ConsoleWindowClass

!^+t::
; test if ahk active
Send ahk active
return

!a::
; Alt-a selects all
send ^{end}^+{home}
return

^e::
Send {end}
return

^a::
Send {home}
return

^u::
Send +{home}{delete}
return

; emacs-like forward + back bindings.  Backup ctrl-f to ctrl-alt-f
^!f::
Send ^f
return

^!b::
Send ^b
return

^f::
Send {right}
return

^b::
Send {left}
return

!f::
Send ^{right}
return

!b::
Send ^{left}
return

#IfWinActive ahk_class MozillaWindowClass
;firefox forward and back

    ^[::
    Send !{left}
    return

    ^]::
    Send !{right}
    return

#IfWinActive

#IfWinNotActive
