#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

MsgBox(
"🔥 Горячие клавиши - Пожаротушение 🔥`n`n" .
"Alt+S — открыть настройки`n" .
"Ctrl+Esc — остановить текущий набор`n" .
"Ctrl+Q — выйти из скрипта`n" .
"Ctrl+1 - Ctrl+0 - тушение пожара`n" .
)

; ===================== НАСТРОЙКИ =====================
global gMinDelay := 150
global gMaxDelay := 350
global gMinCharDelay := 10
global gMaxCharDelay := 30
global gIniFile := A_ScriptDir "\1_ahk.ini"
global gStopTyping := false

; ===================== ЗАГРУЗКА НАСТРОЕК =====================
if FileExist(gIniFile) {
    gMinDelay := IniRead(gIniFile, "Delays", "Min", gMinDelay)
    gMaxDelay := IniRead(gIniFile, "Delays", "Max", gMaxDelay)
    gMinCharDelay := IniRead(gIniFile, "Typing", "Min", gMinCharDelay)
    gMaxCharDelay := IniRead(gIniFile, "Typing", "Max", gMaxCharDelay)
} else {
    IniWrite(gMinDelay, gIniFile, "Delays", "Min")
    IniWrite(gMaxDelay, gIniFile, "Delays", "Max")
    IniWrite(gMinCharDelay, gIniFile, "Typing", "Min")
    IniWrite(gMaxCharDelay, gIniFile, "Typing", "Max")
    IniWrite("Дин", gIniFile, "PLAYER", "Name")
    IniWrite("Полицейский", gIniFile, "PLAYER", "fraction")
}

; ===================== ЗАГРУЗКА ИМЕНИ И ФРАКЦИИ =====================
global PlayerName := IniRead(gIniFile, "PLAYER", "Name", "Дин")
global Playerfraction := IniRead(gIniFile, "PLAYER", "fraction", "Полицейский")

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
    global gMinCharDelay, gMaxCharDelay, gStopTyping
    for char in StrSplit(text) {
        if (gStopTyping) {
            gStopTyping := false
            return
        }
        SendEvent("{Raw}" char)
        Sleep Random(gMinCharDelay, gMaxCharDelay)
    }
}

SendRP(msgs*) {
    global PlayerName, Playerfraction, gStopTyping
    gStopTyping := false
    for line in msgs {
        if (gStopTyping)
            break
        line := StrReplace(line, "%name%", PlayerName)
        line := StrReplace(line, "%fraction%", Playerfraction)
        OpenChat()
        RandSleep()
        TypeLikeHuman(line)
        Send "{Enter}"
        RandSleep()
    }
}

ReloadPlayerData() {
    global gIniFile, PlayerName, Playerfraction
    PlayerName := IniRead(gIniFile, "PLAYER", "Name", "Дин")
    Playerfraction := IniRead(gIniFile, "PLAYER", "fraction", "Полицейский")
    TrayTip("RPM Hotkeys", "Имя и фракция обновлены из INI.")
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
^r::ReloadPlayerData()     ; Ctrl+R — обновить имя/фракцию
^Esc:: gStopTyping := true  ; Ctrl+Esc — остановить текущий набор
^q::ExitApp                ; Ctrl+Q — выйти из скрипта
^+r::Reload                ; Ctrl+Shift+R — перезагрузить скрипт

^1::SendRP(
    "/me осмотрел огнетушитель, проверив целостность корпуса и уровень давления на индикаторе",
    "/me аккуратно сорвал пломбу с рычага и подготовил сопло к работе",
    "/me направил струю пены на очаг, контролируя равномерность и интенсивность подачи",
    "/do %name% следил за распределением пены, покрывая весь огонь и предотвращая его распространение",
    "/me контролировал все горячие точки и корректировал подачу пены",
    "/do %fraction% удостоверился, что огонь полностью погас и дым рассеивается"
)

^2::SendRP(
    "/me внимательно осмотрел огнетушитель, убедившись в исправности и достаточном давлении",
    "/me сорвал пломбу и снял блокиратор с рычага",
    "/me направил струю пены на центр огня, двигая сопло круговыми движениями",
    "/do %name% следил за тем, как пламя постепенно ослабевает, корректируя траекторию струи",
    "/me равномерно покрывал все участки очага пеной",
    "/do %fraction% наблюдал за полным исчезновением огня"
)

^3::SendRP(
    "/me проверил индикатор давления и осмотрел корпус огнетушителя",
    "/me снял предохранитель и подготовил сопло к тушению",
    "/me аккуратно направил струю на очаг, двигаясь по периметру",
    "/do %name% следил за распределением пены и уменьшением пламени",
    "/me корректировал направление струи, обрабатывая скрытые очаги",
    "/do %fraction% контролировал полное затухание огня"
)

^4::SendRP(
    "/me осмотрел огнетушитель на наличие повреждений и давления в корпусе",
    "/me сорвал чеку и приготовил сопло к тушению",
    "/me направил струю пены на самые активные языки огня",
    "/do %name% следил за постепенным уменьшением интенсивности пламени",
    "/me обрабатывал все горячие участки",
    "/do %fraction% удостоверился в полном тушении"
)

^5::SendRP(
    "/me проверил огнетушитель и убедился, что индикатор показывает нормальное давление",
    "/me снял предохранитель и подготовил к работе сопло",
    "/me направил струю пены на очаг, делая плавные круговые движения",
    "/do %name% наблюдал, как огонь ослабевает и дым постепенно рассеивается",
    "/me тщательно обрабатывал все активные участки огня",
    "/do %fraction% контролировал безопасность и полное затухание пламени"
)

^6::SendRP(
    "/me осмотрел корпус огнетушителя и проверил давление",
    "/me сорвал пломбу с рычага и подготовил его к подаче пены",
    "/me направил струю на центр очага, аккуратно двигая сопло",
    "/do %name% следил за равномерным покрытием пламени пеной",
    "/me контролировал все горячие точки, не оставляя очагов возгорания",
    "/do %fraction% удостоверился, что огонь полностью потушен"
)

^7::SendRP(
    "/me проверил состояние огнетушителя, убедившись в целостности и давлении",
    "/me снял чеку и подготовил сопло к работе",
    "/me направил струю пены на очаг, двигая её равномерно по площади огня",
    "/do %name% наблюдал за постепенным исчезновением пламени",
    "/me обработал все участки для полного тушения",
    "/do %fraction% контролировал безопасное рассеивание дыма и огня"
)

^8::SendRP(
    "/me осмотрел огнетушитель и индикатор давления, убедившись в исправности",
    "/me снял пломбу и проверил сопло на подвижность",
    "/me направил струю пены на центр пламени и начал тушение",
    "/do %name% контролировал уменьшение интенсивности огня",
    "/me корректировал направление струи, обрабатывая горячие точки",
    "/do %fraction% следил за полным исчезновением огня"
)

^9::SendRP(
    "/me проверил огнетушитель на исправность и давление",
    "/me снял чеку и подготовил сопло",
    "/me направил струю пены на очаг, двигая сопло медленными круговыми движениями",
    "/do %name% следил за равномерным покрытием пламени и его ослаблением",
    "/me корректировал подачу на скрытые точки возгорания",
    "/do %fraction% удостоверился в полном затухании огня"
)

^0::SendRP(
    "/me осмотрел огнетушитель, убедился в целостности корпуса и норме давления",
    "/me снял предохранитель с рычага и подготовил сопло к работе",
    "/me направил струю пены на огонь, равномерно распределяя её по всей площади",
    "/do %name% наблюдал, как огонь постепенно исчезает, оставляя лёгкий дым",
    "/me тщательно проверял все участки на наличие оставшихся горячих точек",
    "/do %fraction% удостоверился в полной ликвидации очага"
)


