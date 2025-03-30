#Version = "1.01"

Global Window_0

Global Dim Segment.l(7,5,8)
Global Zeichenkette.s
Global Editor_1
Global Dim Frame.l(7)
Global Dim CheckBox.l(7)
Global Dim Option.l(7)

Global Img_New, Img_Gruen, Img_Copy, Img_Invers
Global Img_Load, Img_Save, Img_SaveAs, Img_Schwarz
Global File$

Enumeration FormMenu
  #Toolbar_0
  #Toolbar_1
  #Toolbar_2
  #Toolbar_3
  #Toolbar_4
  #Toolbar_5
EndEnumeration

Img_New = LoadImage(#PB_Any,"Icons\New.ico")
Img_Gruen = LoadImage(#PB_Any,"gruen.bmp")
Img_Copy = LoadImage(#PB_Any,"Icons\Copy1.ico")
Img_Invers = LoadImage(#PB_Any,"Icons\Refresh.ico")
Img_Load = LoadImage(#PB_Any,"Icons\Open.ico")
Img_Save = LoadImage(#PB_Any,"Icons\Save.ico")
Img_SaveAs = LoadImage(#PB_Any,"Icons\SaveAs.ico")
Img_Schwarz = LoadImage(#PB_Any,"schwarz.bmp")

Declare Neu(Event)
Declare Kopieren(Event)
Declare Invers(Event)
Declare Laden(Event)
Declare Speichern(Event)
Declare SpeichernUnter(Event)

Procedure HorizontalBarGadget(Window, x, y, Width)
 hwnd = CreateWindowEx_(0, "Static", "", #WS_CHILD|#WS_VISIBLE|#SS_ETCHEDHORZ, x, y, Width, 2, WindowID(Window), 0, GetModuleHandle_(0), 0)
 ProcedureReturn hwnd
EndProcedure

Procedure versatz_x(s)
  Select s
    Case 0,4
      ProcedureReturn 20
    Case 1,5
      ProcedureReturn 20+145
    Case 2,6
      ProcedureReturn 20+2*145
    Case 3,7
      ProcedureReturn 20+3*145      
  EndSelect
EndProcedure

Procedure versatz_y(s)
  Select s
    Case 0,1,2,3
      ProcedureReturn 10
    Case 4,5,6,7
      ProcedureReturn 250    
  EndSelect
EndProcedure

;Bei anklicken eines Dots entsprechnedes Segment auf aktiv
Procedure GagdetAngeklickt(GadgetNummer)
  For z = 0 To 7
    For y = 1 To 8
      For x = 1 To 5
        If Segment(z,x,y) = GadgetNummer
          SetGadgetState(Option(z), 1)
        EndIf
      Next x
    Next y
  Next z

EndProcedure

;Gibt als Zahl zurück, welches Segment aktiv ist
Procedure AktivesSegment()
  If GetGadgetState(Option(0))
    ProcedureReturn 0
  ElseIf GetGadgetState(Option(1))
    ProcedureReturn 1
  ElseIf GetGadgetState(Option(2))
    ProcedureReturn 2
  ElseIf GetGadgetState(Option(3))
    ProcedureReturn 3
  ElseIf GetGadgetState(Option(4))
    ProcedureReturn 4
  ElseIf GetGadgetState(Option(5))
    ProcedureReturn 5
  ElseIf GetGadgetState(Option(6))
    ProcedureReturn 6
  ElseIf GetGadgetState(Option(7))
    ProcedureReturn 7
  EndIf  
EndProcedure

Procedure OpenWindow_0(x = 50, y = 50, width = 600, height = 650)
  Window_0 = OpenWindow(#PB_Any, x, y, width, height, "eLCeDe V"+#Version, #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ;SetWindowColor(Window_0, RGB(125, 159, 49))
  CreateToolBar(0, WindowID(Window_0),#PB_ToolBar_Large|#PB_ToolBar_Text)
  ToolBarImageButton(#Toolbar_0,ImageID(Img_New),#PB_ToolBar_Normal,"Neu")
  ToolBarToolTip(0, #Toolbar_0, "Neu")
  ToolBarImageButton(#Toolbar_3,ImageID(Img_Load),#PB_ToolBar_Normal,"Laden")
  ToolBarToolTip(0, #Toolbar_3, "Laden...")
  ToolBarImageButton(#Toolbar_4,ImageID(Img_Save),#PB_ToolBar_Normal,"Speichern")
  ToolBarToolTip(0, #Toolbar_4, "Speichern")
  ToolBarImageButton(#Toolbar_5,ImageID(Img_SaveAs),#PB_ToolBar_Normal,"Speichern unter...")
  ToolBarToolTip(0, #Toolbar_5, "Speichern unter...")
  ToolBarSeparator()
  ToolBarImageButton(#Toolbar_1,ImageID(Img_Copy),#PB_ToolBar_Normal,"Kopieren")
  ToolBarToolTip(0, #Toolbar_1, "In Zwischenablage kopieren")
  ToolBarImageButton(#Toolbar_2,ImageID(Img_Invers),#PB_ToolBar_Normal,"Invers")
  ToolBarToolTip(0, #Toolbar_2, "Aktives Segment invertieren")
  HorizontalBarGadget(Window_0, 0, ToolBarHeight(0) + 0, 605)
  For z = 0 To 7
    Frame(z) = FrameGadget(#PB_Any, versatz_x(z), ToolBarHeight(0) + versatz_y(z), 130, 230, "Segment " + z)
    Checkbox(z) = CheckBoxGadget(#PB_Any, versatz_x(z)+75, ToolBarHeight(0) + versatz_y(z)+20, 40, 25, "Inc")
    For y = 1 To 8
      For x = 1 To 5
        Segment(z,x,y) = ButtonImageGadget(#PB_Any, (x*20)-5+versatz_x(z), ToolBarHeight(0) + (y*20)+30+versatz_y(z), 18, 18, ImageID(Img_Gruen), #PB_Button_Toggle)
      Next x
    Next y
  Next z
  For z = 0 To 7
    Option(z) = OptionGadget(#PB_Any, versatz_x(z)+15, ToolBarHeight(0) + versatz_y(z)+20, 50, 25, "Aktiv")
  Next z
  Editor_1 = EditorGadget(#PB_Any, 20, ToolBarHeight(0) + 495, 565, 80)
  SetGadgetColor(Editor_1, #PB_Gadget_BackColor, RGB(255, 255, 255))
  SetGadgetState(Option(0), 1)
EndProcedure

Procedure Window_0_Events(event)
  Select event
    Case #PB_Event_CloseWindow
      ProcedureReturn #False

    Case #PB_Event_Menu
      Select EventMenu()
        Case #Toolbar_0
          Neu(EventMenu())
        Case #Toolbar_1
          Kopieren(EventMenu())
        Case #Toolbar_2
          Invers(EventMenu())
        Case #Toolbar_3
          Laden(EventMenu())
        Case #Toolbar_4
          Speichern(EventMenu())
        Case #Toolbar_5
          SpeichernUnter(EventMenu())
      EndSelect

    Case #PB_Event_Gadget
      ;Im Unterprogramm werden ALLE Gadgets ausgewertet
      ;Select EventGadget()
      ;EndSelect
      GagdetAngeklickt(EventGadget())
  EndSelect
  ProcedureReturn #True
EndProcedure


OpenWindow_0()


For z = 0 To 7 ;Segmente durchnummerieren
  For y = 1 To 8 ;die einzelnen Zeilen des Segments durchnummerieren
    For x = 1 To 5 ;und dann noch die einzelnen Pixel
      SetGadgetAttribute(Segment(z,x,y), #PB_Button_PressedImage, ImageID(Img_Schwarz))
    Next x
  Next y
Next z


Procedure Kopieren(EventType)
  ;Ausgabeformat Zeichenkette:
  ;Lcddefchar 0, %10000, %01111, %01111, %10001, %11110, %11110, %00001, %11111
  Zeichenkette.s = "Lcddefchar " + Str(AktivesSegment())
  For y = 1 To 8
    Zeichenkette.s = Zeichenkette.s + ", %"
    For x = 1 To 5
      Zeichenkette.s = Zeichenkette.s + Str(GetGadgetState(Segment(AktivesSegment(),x,y)))
    Next x
  Next y
  SetClipboardText(Zeichenkette.s)
  AddGadgetItem(Editor_1, 0, Zeichenkette.s)
EndProcedure

Procedure Neu(EventType)
  For z = 0 To 7
    For y = 1 To 8
      For x = 1 To 5
        SetGadgetState(Segment(z,x,y), 0)
      Next x
    Next y
  Next z
  File$ = "" ;damit beim Speichern der Dateiname neu angefordert wird
  SetGadgetState(Option(0), 1) ;das erste Segment aktivieren
EndProcedure

Procedure Invers(EventType)
  For y = 1 To 8
    For x = 1 To 5
      If GetGadgetState(Segment(AktivesSegment(),x,y))
        SetGadgetState(Segment(AktivesSegment(),x,y), 0)
      Else
        SetGadgetState(Segment(AktivesSegment(),x,y), 1)
      EndIf
    Next x
  Next y
EndProcedure

Procedure Laden(EventType)
  Pattern$ = "Include-Dateien (*.inc)|*.inc|Include-Dateien (*.include)|*.include|eLCeDe-Dateien (*.lcd)|*.lcd|Alle Dateien (*.*)|*.*"
  File$ = OpenFileRequester("Bitte Datei zum Laden auswählen", "", Pattern$, 0)
  If ReadFile(0, File$)
    First$ =  Trim(ReadString(0))
    Position = FindString(First$, "Segmente", 1, #PB_String_NoCase)
    First$ = Mid(First$, Position)
    First$ = StringField(First$, 2, "=")
    ;Kommentarzeile parsen;
    For z = 1 To 8
      If Mid(First$, z, 1) = "1"
        SetGadgetState(Checkbox(z-1), #PB_Checkbox_Checked)
      Else
        SetGadgetState(Checkbox(z-1), #PB_Checkbox_Unchecked)
      EndIf
    Next z
    ;Alle restlichen Zeilen parsen:
    While Eof(0) = 0
      First$ =  Trim(ReadString(0))
      ;SegmentNummer ermitteln:
      z = Val(Trim(StringField(First$, 2, " "), ","))
      For y = 1 To 8 ;Reihen durchnummerieren
        Reihe$ = Trim(StringField(First$, y+2, " "), ",")
        For x = 1 To 5 ;Pixel durchnummerieren
          If Mid(Reihe$, x, 1) = "1"
            SetGadgetState(Segment(z,x,y), 1)
          Else
            SetGadgetState(Segment(z,x,y), 0)
          EndIf
        Next x
      Next y
    Wend
    CloseFile(0)
  EndIf
EndProcedure

Procedure DateiSchreiben()
  If OpenFile(0, File$)
    WriteString(0, "'Diese Zeile nicht löschen! Segmente=")
    ;Speichern ob Inc aktiviert ist:
    For z = 0 To 7
      If GetGadgetState(Checkbox(z)) = #PB_Checkbox_Checked 
        WriteString(0, "1")
      Else
        WriteString(0, "0")
      EndIf
    Next z
    WriteStringN(0, "")
    ;Segmente speichern:
    For z = 0 To 7
      If GetGadgetState(Checkbox(z)) = #PB_Checkbox_Checked
        WriteString(0, "Lcddefchar " + Str(z))
        For y = 1 To 8 ;Reihen durchnummerieren
          WriteString(0, ", %")
          For x = 1 To 5 ;Pixel durchnummerieren
            WriteString(0, Str(GetGadgetState(Segment(z,x,y))))
          Next x
        Next y
        WriteStringN(0, "")
      EndIf
    Next z
    TruncateFile(0)
    CloseFile(0)
  EndIf  
EndProcedure

Procedure Speichern(EventType)
  If File$ = ""
    SpeichernUnter(0)
  Else
    DateiSchreiben()
  EndIf
EndProcedure

Procedure SpeichernUnter(EventType)
  Pattern$ = "Include-Dateien (*.inc)|*.inc|Include-Dateien (*.include)|*.include|eLCeDe-Dateien (*.lcd)|*.lcd|Alle Dateien (*.*)|*.*"
  File$ = SaveFileRequester("Bitte Datei zum Speichern auswählen", "", Pattern$, 0)
  If File$ = ""
    MessageRequester("Information", "Keine Datei ausgewählt", #PB_MessageRequester_Ok)
  Else
    DateiSchreiben()
  EndIf
EndProcedure


Repeat
  Event = WaitWindowEvent()
  Select EventWindow() ;die Fensternummer, in dem das Ereignis auftrat
    Case Window_0
      Window_0_Events(Event) ; Dieser Prozedurname ist immer der Fenstername gefolgt von '_Events'
  EndSelect
Until Event = #PB_Event_CloseWindow ; Beenden, wenn eines der Fenster geschlossen wird.

; IDE Options = PureBasic 5.62 (Windows - x86)
; CursorPosition = 302
; FirstLine = 255
; Folding = ---
; EnableXP
; UseIcon = Logo.ico
; Executable = eLCeDe.exe
; DisableDebugger