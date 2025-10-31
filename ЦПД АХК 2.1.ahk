#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

; Справочное окно при запуске скрипта
HotkeysInfo := "
(
Alt+S     - открыть настройки
Ctrl+Esc  - остановить текущий набор
Ctrl+Q    - выйти из скрипта
Ctrl+Shift+R - перезагрузить скрипт
Alt+F1    - обыск задержанного
Alt+F2    - фотографирование задержанного
Alt+F3    - снятие отпечатков
Alt+Q     - использовать ключ
Alt+1     - оформление штрафа (транспорт)
Alt+2     - оформление штрафа (гражданин)
Alt+3     - вытащить подозреваемого из машины
Alt+R     - закрыть дверь машины после задержанного
Alt+E     - посадить задержанного в машину
Alt+Z     - тщательный обыск гражданина
)"

MsgBox(HotkeysInfo, "MADE BY Abrikos_ikk", "0x40") ; 0x40 = информационное окно


; ===================== НАСТРОЙКИ =====================
global gMinDelay := 150
global gMaxDelay := 350
global gMinCharDelay := 10
global gMaxCharDelay := 30
global gIniFile := A_ScriptDir "\cpd_ahk.ini"

; ===================== ЗАГРУЗКА НАСТРОЕК =====================
if FileExist(gIniFile) {
    gMinDelay := IniRead(gIniFile, "Delays", "Min", gMinDelay)
    gMaxDelay := IniRead(gIniFile, "Delays", "Max", gMaxDelay)
    gMinCharDelay := IniRead(gIniFile, "Typing", "Min", gMinCharDelay)
    gMaxCharDelay := IniRead(gIniFile, "Typing", "Max", gMaxCharDelay)
}

; ===================== ФУНКЦИИ =====================
OpenChat() {
    Send "{t}"
    Sleep Random(150, 250)
}

RandSleep() {
    global gMinDelay, gMaxDelay
    Sleep Random(gMinDelay, gMaxDelay)
}

TypeLikeHuman(text) {
    global gMinCharDelay, gMaxCharDelay
    for char in StrSplit(text) {
        Send char
        Sleep Random(gMinCharDelay, gMaxCharDelay)
    }
}

SendRP(msgs*) {
    for line in msgs {
        OpenChat()
        RandSleep()
        TypeLikeHuman(line)
        Send "{Enter}"
        RandSleep()
    }
}

; ===================== ГУИ =====================
CreateSettingsGui() {
    global gMinDelay, gMaxDelay, gMinCharDelay, gMaxCharDelay, GuiRef

    GuiRef := Gui("+AlwaysOnTop", "RPM: Настройки задержек")
    GuiRef.MarginX := 10
    GuiRef.MarginY := 10
    GuiRef.BackColor := "0x1e1e1e"
    GuiRef.SetFont("s10 cWhite", "Consolas")

    y := 10
    GuiRef.AddText("x10 y" y " w200", "Задержка между сообщениями (мс):")
    y += 25
    GuiRef.AddText("x10 y" y " w40", "Мин:")
    eMin := GuiRef.AddEdit("x50 y" y " w60", gMinDelay)
    GuiRef.AddText("x120 y" y " w40", "Макс:")
    eMax := GuiRef.AddEdit("x160 y" y " w60", gMaxDelay)

    y += 40
    GuiRef.AddText("x10 y" y " w200", "Задержка между символами (мс):")
    y += 25
    GuiRef.AddText("x10 y" y " w40", "Мин:")
    eMinChar := GuiRef.AddEdit("x50 y" y " w60", gMinCharDelay)
    GuiRef.AddText("x120 y" y " w40", "Макс:")
    eMaxChar := GuiRef.AddEdit("x160 y" y " w60", gMaxCharDelay)

    y += 45
    btnApply := GuiRef.AddButton("x10 y" y " w90", "Применить")
    btnClose := GuiRef.AddButton("x110 y" y " w90", "Закрыть")

    btnApply.OnEvent("Click", (*) => ApplyDelays(eMin, eMax, eMinChar, eMaxChar))
    btnClose.OnEvent("Click", (*) => GuiRef.Destroy())

    GuiRef.OnEvent("Close", (*) => GuiRef.Destroy())
    GuiRef.Show("w240 h220")
}

ApplyDelays(eMin, eMax, eMinChar, eMaxChar) {
    global gMinDelay, gMaxDelay, gMinCharDelay, gMaxCharDelay, gIniFile

    newMin := eMin.Value
    newMax := eMax.Value
    newMinChar := eMinChar.Value
    newMaxChar := eMaxChar.Value

    if (newMin = "" or newMax = "" or newMinChar = "" or newMaxChar = "") {
        MsgBox "Все поля должны быть заполнены.", "Ошибка", "Iconx"
        return
    }

    if (newMin > newMax or newMinChar > newMaxChar) {
        MsgBox "Минимум не может быть больше максимума.", "Ошибка", "Iconx"
        return
    }

    gMinDelay := newMin
    gMaxDelay := newMax
    gMinCharDelay := newMinChar
    gMaxCharDelay := newMaxChar

    IniWrite(gMinDelay, gIniFile, "Delays", "Min")
    IniWrite(gMaxDelay, gIniFile, "Delays", "Max")
    IniWrite(gMinCharDelay, gIniFile, "Typing", "Min")
    IniWrite(gMaxCharDelay, gIniFile, "Typing", "Max")

    TrayTip("RPM Hotkeys", "Настройки сохранены и применены.")
}

; ===================== ГОРЯЧИЕ КЛАВИШИ =====================
!s::CreateSettingsGui()    ; Alt+S — настройки
^Esc:: gStopTyping := true  ; Ctrl+Esc — остановить текущий набор
^q::ExitApp                ; Ctrl+Q — выйти из скрипта
^+r::Reload                ; Ctrl+Shift+R — перезагрузить скрипт

!F1:: {
    SendRP(
    "/me достав из кармана черные нитриловые перчатки, приступил к обыску задержанного",
    "/me ощупывает торс, ноги и руки задержанного"
    )
}

!F2:: {
    SendRP(
    "/do Поставив задержанного на однотонный фон, сотрудник снял КПК с подсумки на поясе, включил камеру и начал настраивать её для снимка задержанного",
    "/me Направив камеру КПК на задержанного, сделал несколько снимков лица гражданина с разных сторон. Завершив процедуру, выключил КПК и закрепил его на исходное место."
    )
}

!F3:: {
    SendRP(
    "/me Поставил кейс на стол, достал дактилоскопическую карту, баночку с типографской краской и каток. Взял спиртовые салфетки и протёр подушечки пальцев преступника.",
    "/me Намазал краску 'A4' на каток и раскатал её на бумаге, взял кисть преступника и снял отпечатки обеих рук.",
    "/do На бумаге чётко отпечатаны пальцы подозреваемого."
    )
}

!q:: {
    SendRP(
    "/me Достал из кармана бронежилета ключ, вставил его в замок, открыл дверь, схватил преступника за куртку и толкнул его в камеру."
    )
}

!1:: {
    OpenChat()
    Send "/me Снял личный КПК с пояса, завёл дело на транспортное средство, внёс данные машины и фото номера. Завершив оформление, выслал штраф владельцу."
    Send "{Enter}"
    OpenChat()
    Send "/police card "
}
!2:: {
    OpenChat()
    Send "/me Достал из кармана служебный КПК, завёл дело о штрафе на гражданина, выписал постановление и выслал его на электронную почту."
    Send "{Enter}"
    OpenChat()
    Send "/police card "
}

!3:: {
    OpenChat()
    Send "/me Разбил стекло машины дубинкой, схватил подозреваемого двумя руками и вытащил его с машины."
    Send "{Enter}"
}

!r:: {
    OpenChat()
    Send "/me открыв дверь машины и вытащив оттуда преступника, закрыл за ним дверь и заблокировал двери машины с кнопки ключа"
    Send "{Enter}"
}

!e:: {
    OpenChat()
    Send "/me открыв дверь машины, затолкал преступника внутрь и усадил его на пассажирское сидение"
    Send "{Enter}"
}

!z:: {
    SendRP(
    "/me надев черные нитриловые перчатки, принялся ощупывать торс, ноги и руки гражданина",
    "/me тщательно прощупывает тело гражданина на наличие нелегала, открывает его сумки и просматривает также и их",
    "/do Был ли найден у гражданина нелегал в виде огнестрельного, холодного оружия, болтов для арбалета?",
    "/n /do Было найдено: Ответ. Сумки тоже обыскал, пиши все что было найдено"
    )
}