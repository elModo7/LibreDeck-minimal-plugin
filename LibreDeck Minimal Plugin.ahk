;@Ahk2Exe-SetName LibreDeck Minimal Plugin
;@Ahk2Exe-SetDescription LibreDeck Minimal plugin demo
;@Ahk2Exe-SetVersion 1.0.1
;@Ahk2Exe-SetCopyright 2026 elModo7 - VictorDevLog
;@Ahk2Exe-SetOrigFilename LibreDeck Minimal Plugin.exe
#SingleInstance Force
#Persistent
#NoEnv
#Include <nm_msg>
#Include <LibreDeckButtonImage>
SetBatchLines -1
version := "1.0.1"

; Check LibreDeck process
detectHiddenWindowsPrev := A_DetectHiddenWindows
DetectHiddenWindows, On
if (!WinExist("ahk_exe LibreDeck Client.exe")) {
	MsgBox 0x10, Client not found!, LibreDeck Client was not found!
	ExitApp
}

global receiver := new talk("ahk_exe LibreDeck Client.exe") ; Hook

; Set page 0 of folder "MinimalPlugin" (empty page if it does not exist)
; Last param, 0, means not to wait for LibreDeck to respond, this is a fire and forget behaviour and is recommended due to AutoHotkey's single thread behaviour which could otherwise lock third party integration scripts by never getting a response
receiver.setVar("incomingPageChange", "{""pageNumber"": 0, ""isFolder"": 1, ""folderName"": ""MinimalPlugin""}", 0)
receiver.runlabel("remotePageChange", 0) 

; LibreDeckButtonImage for custom image buttons
outDir := A_ScriptDir "\res\img"
FileCreateDir, %outDir%
LD_ButtonImage_Start()

; Tray Menu
Menu, Tray, NoStandard
Menu, Tray, Tip, LibreDeck Minimal Plugin %version% 
Menu, Tray, Add, Exit, exit

demoTime := 15 ; Runs for 15 seconds
gosub, helloWorld
SetTimer, setCountdownButtonAndMessage, 1000 ; Update buttons every second
SetTimer, exit, % demoTime * 1000 ; Exit in 15s
Return

helloWorld:
    ; Hello World (First 10 buttons)
    str := "HELLOWORLD"
    Loop, Parse, % str
    {
        LD_ButtonImage_Render(outDir "\" A_Index ".png", {style:"minimal", title:"" A_Index "", value: "" A_LoopField "", subtitle:"Demo"})
        receiver.setVar("incomingButtonChange", "{""imagePathOrName"": """ escapeBackSlashes(A_ScriptDir) "\\res\\img\\" A_Index ".png"", ""buttonId"": " A_Index ", ""folderName"": ""MinimalPlugin"", ""page"": 0}", 0)
        receiver.runlabel("setButtonIconRemote", 0)
    }
    
    ; elModo7 / VictorDevLog Button just to show another style
    LD_ButtonImage_Render(outDir "\info.png", {style:"pokemon", title:"elModo7", value: "LibreDeck", valueSize:24, subtitle:"VictorDevLog"})
    receiver.setVar("incomingButtonChange", "{""imagePathOrName"": """ escapeBackSlashes(A_ScriptDir) "\\res\\img\\info.png"", ""buttonId"": 13, ""folderName"": ""MinimalPlugin"", ""page"": 0}", 0)
    receiver.runlabel("setButtonIconRemote", 0)
    
    ; Date Button (We could check for changes here and update it but this is just a demo, see Clock button, it's done there)
    LD_ButtonImage_Render(outDir "\date.png", {style:"dark", title:"" A_DDDD "", value: A_DD "/" A_MM, subtitle:"" A_MMMM ""})
    receiver.setVar("incomingButtonChange", "{""imagePathOrName"": """ escapeBackSlashes(A_ScriptDir) "\\res\\img\\date.png"", ""buttonId"": 14, ""folderName"": ""MinimalPlugin"", ""page"": 0}", 0)
    receiver.runlabel("setButtonIconRemote", 0)
return

setCountdownButtonAndMessage:
    ; Bottom Countdown
    nmMsg("Demo stopping in " --demoTime " seconds", 1.3) ; 1.3s so that new updates replace previous ones so text won't flicker (default notification time is 1 second)
    
    ; Clock Button (updates only if minute has changed)
    if (A_Min != previousMinute) {
        previousMinute := A_Min
        LD_ButtonImage_Render(outDir "\clock.png", {style:"glass", title:"CLOCK", value: A_Hour ":" A_Min, subtitle:"Hour/Min"})
        receiver.setVar("incomingButtonChange", "{""imagePathOrName"": """ escapeBackSlashes(A_ScriptDir) "\\res\\img\\clock.png"", ""buttonId"": 11, ""folderName"": ""MinimalPlugin"", ""page"": 0}", 0)
        receiver.runlabel("setButtonIconRemote", 0)
    }
    
    ; Seconds Button
    LD_ButtonImage_Render(outDir "\millis.png", {style:"warning", title:"Seconds", value: A_Sec, subtitle: "" A_MSec "ms"})
    receiver.setVar("incomingButtonChange", "{""imagePathOrName"": """ escapeBackSlashes(A_ScriptDir) "\\res\\img\\millis.png"", ""buttonId"": 12, ""folderName"": ""MinimalPlugin"", ""page"": 0}", 0)
    receiver.runlabel("setButtonIconRemote", 0)    
return

escapeBackSlashes(txt) {
    return StrReplace(txt, "\", "\\")
}

exit:
    ; Revert to page 0 and exit.
    receiver.setVar("incomingPageChange", "{""pageNumber"": 0, ""isFolder"": 0, ""folderName"": """"}", 0)
    receiver.runlabel("remotePageChange", 0)
    LD_ButtonImage_Shutdown()
    ExitApp