#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

; ===== Функции =====
OpenChat() {
    Sleep Random(300, 800) ; естественная пауза перед открытием чата
    Send "{t}"
    Sleep Random(250, 600)
}

MyRandomSleep(min := 500, max := 1500) { ; увеличены интервалы по умолчанию
    Sleep Random(min, max)
}

; ======== Конфигурация сотрудника ========
EmployeeFile := A_ScriptDir "\employee_data.ini"

if !FileExist(EmployeeFile) {
    IniWrite("Майкл Джонсон", EmployeeFile, "Employee", "Name")
    IniWrite("CPD", EmployeeFile, "Employee", "Org")
    IniWrite("Шериф", EmployeeFile, "Employee", "Rank")
    IniWrite("klr", EmployeeFile, "Employee", "Signature")
    IniWrite("16.09.2025", EmployeeFile, "Employee", "IssueDate")
}

; ======== Горячие клавиши ========

; Alt+F1 — Фотофиксация
!F1:: {
    OpenChat()
    MyRandomSleep(600, 1400)
    Send "/do Поставив задержанного на однотонный фон, сотрудник снял КПК с подсумки на поясе, включил камеру и начал настраивать её для снимка задержанного.{Enter}"
    MyRandomSleep(900, 1600)
    OpenChat()
    MyRandomSleep(600, 1200)
    Send "/me Направив камеру КПК на задержанного, сделал несколько снимков лица гражданина с разных сторон. Завершив процедуру, выключил КПК и закрепил его на исходное место.{Enter}"
}

; Alt+F2 — Дактилоскопия
!F2:: {
    OpenChat()
    MyRandomSleep(600, 1200)
    Send "/me Поставил кейс на стол, достал дактилоскопическую карту, баночку с типографской краской и каток. Взял спиртовые салфетки и протёр подушечки пальцев преступника, после чего намазал краску 'A4' и начал раскатывать её на бумаге.{Enter}"
    MyRandomSleep(900, 1700)
    OpenChat()
    MyRandomSleep(700, 1500)
    Send "/me Взял кисть преступника, раскатал краску по кончикам пальцев и поднёс их к дактилоскопической бумаге. Повторил действия со второй рукой, затем убрал карту в кейс.{Enter}"
    MyRandomSleep(800, 1600)
    OpenChat()
    MyRandomSleep(600, 1200)
    Send "/do На бумаге чётко отпечатаны пальцы подозреваемого.{Enter}"
}

; Alt+F3 — Помещение в камеру
!F3:: {
    OpenChat()
    MyRandomSleep(500, 1000)
    Send "/me Достал из кармана бронежилета ключ, вставил его в замок, открыл дверь, схватил преступника за куртку и толкнул его в камеру.{Enter}"
}

; Alt+F12 — Починка двери
!F12:: {
    OpenChat()
    MyRandomSleep(600, 1200)
    Send "/do Выбитая дверь и сорванные петли с болтами лежат на полу.{Enter}"
    MyRandomSleep(800, 1600)
    OpenChat()
    MyRandomSleep(600, 1400)
    Send "/me Поднял дверь, подобрал с пола петли и болты, достал из сумки дрель и прикрутил одну сторону петли к двери, а другую к коробке.{Enter}"
}

; Alt+1 — Обыск
!1:: {
    OpenChat()
    MyRandomSleep(400, 900)
    Send "/me Достал из нагрудного кармана белые перчатки, надел их и начал ощупывать торс, ноги, руки и голову человека.{Enter}"
}

; Alt+P — Разрешение
!p:: {
    OpenChat()
    MyRandomSleep(600, 1100)
    Send "/me Взял с полки листочек 'Разрешение на перевозку сотрудников правительства' с печатью CPD, расстегнул карман и достал ручку.{Enter}"
    MyRandomSleep(1000, 1800)
    OpenChat()
    MyRandomSleep(700, 1300)
    Send "/me Поставил подпись на листочке, убрал ручку в карман и застегнул пуговицу.{Enter}"
    MyRandomSleep(900, 1500)
    OpenChat()
    MyRandomSleep(700, 1200)
    Send "/n По РП забери лист.{Enter}"
}

; Alt+O — Тест ПДД
!o:: {
    OpenChat()
    MyRandomSleep(600, 1200)
    Send "/me Взял со стола листочек 'Тест на знание ПДД', осмотрел его, затем расстегнул карман и достал ручку.{Enter}"
    MyRandomSleep(900, 1600)
    OpenChat()
    MyRandomSleep(600, 1100)
    Send "/me Поставил подпись на листочке, убрал ручку в карман и застегнул пуговицу.{Enter}"
}

; Alt+2 — Мегафон
!2:: {
    OpenChat()
    MyRandomSleep(400, 900)
    Send "/shout [Мегафон] Прижмитесь к обочине, остановите и заглушите двигатель. Положите руки на руль. В противном случае будут приняты меры.{Enter}"
}

; Alt+3 — Штраф гражданину
!3:: {
    OpenChat()
    MyRandomSleep(600, 1300)
    Send "/me Достал из кармана служебный КПК, завёл дело о штрафе на гражданина, выписал постановление и выслал его на электронную почту. После чего убрал КПК обратно.{Enter}"
    MyRandomSleep(900, 1600)
    OpenChat()
    MyRandomSleep(500, 1100)
    Send "/police card"
}

; Alt+T — Штраф машине
!t:: {
    OpenChat()
    MyRandomSleep(600, 1300)
    Send "/me Снял личный КПК с пояса, завёл дело на транспортное средство, внёс данные машины и фото номера. Завершив оформление, выслал штраф владельцу.{Enter}"
    MyRandomSleep(900, 1600)
    OpenChat()
    MyRandomSleep(600, 1200)
    Send "/police card"
}

; Alt+K — Таран двери
!k:: {
    OpenChat()
    MyRandomSleep(500, 1000)
    Send "/me Расстегнул сумку, достал таран, размахнулся и ударил по замку, выбив дверь.{Enter}"
}

; Alt+N — Извлечение из машины
!n:: {
    OpenChat()
    MyRandomSleep(500, 1000)
    Send "/me Разбил стекло машины дубинкой, схватил подозреваемого двумя руками и вытащил его с машины.{Enter}"
}

; ======== Удостоверение ======== 
!e:: {
    Name := IniRead(EmployeeFile, "Employee", "Name")
    Org := IniRead(EmployeeFile, "Employee", "Org")
    Rank := IniRead(EmployeeFile, "Employee", "Rank")
    Signature := IniRead(EmployeeFile, "Employee", "Signature")
    IssueDate := IniRead(EmployeeFile, "Employee", "IssueDate")

    OpenChat()
    MyRandomSleep(600, 1200)
    Send "/mee вытащил удостоверение из кармана, показав СУ, захлопнул документ и положил обратно в карман{Enter}"

    MyRandomSleep(1000, 1800)
    OpenChat()
    MyRandomSleep(700, 1300)
    Send "/do Информация в удостоверении: ИФ: " Name " | ОРГ: " Org " | Д: " Rank " | Фотография сотрудника | Дата выдачи: " IssueDate " | Подпись Шерифа: " Signature " | Штамп CPD {Enter}"

    MyRandomSleep(900, 1600)
    OpenChat()
    MyRandomSleep(600, 1100)
    Send "/do На поясе сотрудника висел золотой жетон Центрального Полицейского Департамента Штата РПМ{Enter}"
}
