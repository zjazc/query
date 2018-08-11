#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#include adosql.ahk
; Connection strings are typically semicolon-separated lists of key/value pairs
connection_string :=
(
"Provider=Microsoft.Jet.OLEDB.4.0; Data Source=.\Database1.mdb;Jet OLEDB:Database Password=1"
)

SendMode Input
#SingleInstance Force
SetBatchLines -1
#Persistent
DetectHiddenWindows, On
SetControlDelay,0

IfNotExist, %A_ScriptDir%\work.ico
{
MsgBox , , Error,图标文件不存在，5秒后程序自动退出。,5
ExitApp
}

Menu, Tray, DeleteAll
Menu, tray, NoStandard
Menu, tray, Icon , %A_ScriptDir%\work.ico
;, IconNumber, 1
Menu, Tray, Add, 窗口置顶, Menu_AlwaysOnTop
;Menu, tray, add, 窗口置顶,ontop
;Menu, tray, ToggleCheck, 窗口置顶
Menu, tray, add,
Menu, tray, add, 关于..., about
Menu, tray, add,
Menu, tray, add, 退出, exit


Gui, Add, GroupBox, x16 y+5 w400 h100 , 检索
;InputBox, OutputVar [, Title, Prompt, HIDE, Width, Height, X, Y, Font, Timeout, Default]
Gui, Add, Edit, x66 y47 w140 h30 vEdit1 gChange, type code here

;Gui, Add, Edit, x230 y47 w140 h30 vEdit2 gChange2, type code here


Gui, Add, Radio,x16 y115 w100 h30 radio1 , 科室
Gui, Add, Radio,x150 y115 w100 h30 radio2 checked vRadioButton, 人员

Gui, Add, Text, x250 y122 w70 h30 Section, 取结果数
Gui, Add, Edit, x320 y119 w70 h20 +Center vTop
Gui, add, UpDown,Range1-99 0x80,15

;Gui, Add, Text, x250 y115 w70 h30 Section, 循环时间
;Gui, add, UpDown, vUpdown Range1-99999 0x80,15
;Gui, Add, UpDown,x550 y115 w100 h30 vUpDown Range1-99, 15
Gui, Add, GroupBox, x16 y155 w400 h250 , 结果
;Gui, Add, DropDownList, x66 y117 w140 h80 vDroplist, DropDownList

Gui, Font, S10 CBlue Bold, 宋体
Gui, Add, Edit, x66 y177 w300 h220 +VScroll +HScroll vEdit2, result here

;Gui, Add, ListView, x66 y157 w300 h220 vedit2,dname|num1|num2


Gui, Show, x131 y91 h420 w430, Tele dict for 
;Gui, Show, x131 y91 h420 w430, Tele dict
Return


GuiClose:
ExitApp

;WHERE ab LIKE 'WLYY';

Change:
Gui, Submit,NoHide

if RadioButton=1
opt=department
else
opt=official

if edit1=
{
GuiControl,,edit2,null
}
else
{
query =(select top %top% dname,num1,num2 from %opt% where ab like '`%%edit1%`%' or py like '`%%edit1%`%' or dname like '`%%edit1%`%' or num1 like '`%%edit1%`%'  or num2 like '`%%edit1%`%' order by id)
;MsgBox %query% ; verify
result := ADOSQL( connection_string ";coldelim= `t", query )

GuiControl,,edit2,%result%
;msgbox %result%
}
return
;LV_Add("",%result%)


Menu_AlwaysOnTop:
    WinSet, AlwaysOnTop, Toggle, Tele dict for 
    Menu, Tray, ToggleCheck, 窗口置顶
return

exit:
exitapp

About:
MsgBox,262144,about,`nspecial for ??.`n `nwish you a good day!`n `nthis message will disappear after 3s.,3
Return