#SingleInstance force

global browser = "firefox"
; -private"
global instagram = "instagram.com/"

global logins := Object()
Loop Read, logins.csv
{
	subarray := StrSplit(A_LoopReadLine, "csv")
	logins.Insert(subarray)
}


global accs := Object()
Loop Read, accounts.csv
{
	subarray := StrSplit(A_LoopReadLine, "csv")
	accs.Insert(subarray)
}
StrSplit(InputVar, Delimiter="", OmitChars="") {
	array := []
	Loop Parse, InputVar, %Delimiter%, %OmitChars%
		array.Insert(A_LoopField)
	return array
}

MyGui()
; Overlay()

Overlay(){
	global
	CustomColor = EEAA99  ; Can be any RGB color (it will be made transparent below).
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, Color, %CustomColor%
	Gui, Font, s32  ; Set a large font size (32-point).
	Gui, Add, Text, vMyText cLime, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
	WinSet, TransColor, %CustomColor% 150
	SetTimer, UpdateOSD, 500
	Gui, Show, x0 y100 NoActivate  ; NoActivate avoids deactivating the currently active window.

}

UpdateOSD:
MouseGetPos, MouseX, MouseY
GuiControl,, MyText, X%MouseX%, Y%MouseY%

Return



MyGui(){
global

	gui, font, s10, Verdana
	Gui, Add, Tab2,, Main | Follow | Unfollow | Contas
	Gui, Add, Checkbox, vMenu1, Abrir Firefox
	Gui, Add, Checkbox, vMenu2, Logar usuarios
	Gui, Add, Checkbox, vMenu3, Nova janela
	Gui, Tab, 2
	
	Gui, Add, Checkbox, vMenu4, Abrir contas em novas abas
	Gui, Add, Checkbox, vMenu5, Fechar janela anterior
	Gui, Add, Checkbox, vMenu6, Navegar para Followers

	Gui, Add, Checkbox, vMenu7, Follow
	


	Gui, Tab, 3
	Gui, Add, Checkbox, vMenu8, Abrir usuarios
	Gui, Add, Checkbox, vMenu9, Navegar para Following
	
	Gui, Add, Checkbox, vMenu91, Descer 200
	
	Gui, Add, Checkbox, vMenu10, Unfollow

	Gui, Tab, 4


	For row, subArray in logins{
		For column, value in subArray{
			if (column == 1){
				Gui, Add, Checkbox, vMenu99%row%%column%, %value%
			}
		}
	}
	; Gui, Add, Edit, vMyEdit r10 

	Gui, Tab 


	Gui, Add, Button, Default, Go 
	Gui, Show

}
 


`::
	For row, subArray in logins{
		For column, value in subArray{
			if (column == 1){
				Msgbox, %value%
			}
		}
	}
Return


ButtonGo:
	Gui, Submit, Hide

	if (Menu1){
		Gosub, OpenBrowser
		Sleep, 200
	}
	if (Menu2){

		Gosub, Login
		Sleep, 300

	}
	if (Menu3){
		Gosub, NewWindow

	}
	if (Menu4){
		OpenAccsNewTabs()

	}
	if (Menu5){
		Gosub, SwitchWindows
		Gosub, CloseWindow
	}
	if (Menu6){
		Sleep, 5500
		Gosub, GotoFollowers
	}
	if (Menu7){
		Sleep, 200
		Gosub, Looping
	}
	if (Menu8){
		Sleep, 200
		OpenUsersNewTabs()
	}
	if (Menu9){
		Sleep, 200
		Gosub, GotoFollowing
	}
	if (Menu91){
		Sleep, 200
		Gosub, GoDown
	}

	if (Menu10){
		Sleep, 200
		Gosub, Looping
	}

return

SwitchWindows:
	Sleep,200
	Send, {Alt DOWN}
	Send, {Tab}
	Send, {Alt UP}	
	Sleep,200
return
CloseWindow:
	Sleep,200
	Send, {Alt Down}
	Send, {F4}
	Send, {Alt UP}
	Sleep,200
return

NewWindow:
	Send, {Ctrl DOWN}
	Send, {n}
	Send, {Ctrl UP}
return

OpenBrowser:

	Send, {LWin DOWN}
	Send, {r}
	Send, {LWin UP}
	Sleep, 200
	Send, %browser% {Enter}
	Sleep, 1666

return
Login:
	For row, subArray in logins{

			Sleep, 100
			NewTab(row)
			Sleep, 200
			Send, %instagram% 
			Send, {Enter}
			Sleep, 4500

			Loop, 9{
				Send, {Tab}
				Sleep,6
			}
			Send, {Enter}
			Sleep,2000

		For column, value in subArray{
			SendRaw, %value%
			Sleep, 600
			if(column=1){
				Send, {Tab}
				Sleep, 300
			}else{
				Send, {Enter}
				Sleep, 5555
			}

			;Gosub, NextTab
			;Gosub, CloseTab
			Sleep, 200
		}
	}
	;Gosub, NextTab
	;Gosub, CloseTab

return
Looping:

	Random, rand, 1, 4
	Sleep, 100*rand
	if(rand = 1){
		Gosub, NextTab
	}
	Sleep, 66*rand
	Gosub, Follow
	Gosub, Looping
return

OpenUsersNewTabs(){

	
	For row, subArray in logins{
		for column, value in subArray{
			if (column == 1){

				Sleep, 20
				NewTab(row)
				Sleep, 20
				Send, %instagram%%value%
				Send, {Enter}
				Sleep, 20
			}
		}
		
	}

	Gosub, NextTab
	Gosub, CloseTab
}

OpenAccsNewTabs(){
	For row, subArray in accs{
		For column, value in subArray{
			Sleep, 200
			NewTab(row)
			Sleep, 200
			Send, %instagram%%value% 
			Send, {Enter}
			Sleep, 300
			;Msgbox, row: %row%`ncolumn: %column%`nvalue: %value%
		}
	}
	Gosub, NextTab
	Gosub, CloseTab
}

GotoFollowers:
	For row, subArray in accs{
		For column, value in subArray{
		Sleep, 155
		Gosub, NextTab
		Sleep, 700
		Loop, 4{
			Send, {Tab}
			Sleep, 6
		}
		Send, {Enter}
		Sleep, 50
		}
	}
return

GotoFollowing:
	For row, subArray in accs{
		For column, value in subArray{
		Sleep, 155
		Gosub, NextTab
		Sleep, 700
		Loop, 6{
			Send, {Tab}
			Sleep, 6
		}
		Send, {Enter}
		Sleep, 50
		}
	}
return


GoDown:
	Loop, 200{
		Sleep,50
		Loop,3{
			Send, {Tab}
			Sleep, 6
		}
		Sleep,50
	}

Follow:
	Sleep,50
	Loop,3{
		Send, {Tab}
	}
	Send, {Enter}
	Sleep,50
return

NextTab:
	Sleep,50
	Send, {Ctrl DOWN}
	Send, {Tab}
	Send, {Ctrl UP}
	Sleep, 50
return

CloseTab:
	Sleep,50
	Send, {Ctrl DOWN}
	Send, {w}
	Send, {Ctrl UP}
	Sleep, 50
return

NewTab(container){		
	Sleep,250
	if (contairer = 0){
		Send, {Ctrl DOWN}
		Send, {t}
		Send, {Ctrl UP}
		Sleep, 150
	}else{
		Send, {Alt DOWN}
		Send, {f}
		Send, {Alt UP}
		Sleep, 200
		Send, {b}
		Sleep, 100
		while (container>1){
			Sleep,20
			Send, {Down}
			Sleep,20
			container--
		}
		Sleep, 100
		Send, {Enter}
	}
	Sleep, 100
}

F1::
	ExitApp
return

Esc::
	Reload
return