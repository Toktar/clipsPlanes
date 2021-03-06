
;;;======================================================
;;;   Sticks Program
;;;
;;;     This program was introduced in Chapter 8.
;;;
;;;     CLIPS Version 6.0 Example
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

; **************
; ШАБЛОНЫ ФАКТОВ
; **************

; Факт phase показывает текущее действие, которое должно
; быть вызвано перед началом игры

; (phase 
;    <action>)      ; Или choose-player,
                    ; или select-pile-size

; Факт player-select содержит введенные игроком данные в ответ на 
; вопрос "Кто ходит первым?".

; (player-select
;    <choice>)      ; Верными ответами считаются c (компьютер)
                    ; и h (человек).
    
; Факт pile-select содержит ответ игрока на
; вопрос "Как много палочек находится в куче?".

; (pile-select
;    <choice>)      ; Правильным ответом является
		    ; положительное целое число

; Факт pile-size содержит текущее количество палочек в куче.

; (pile-size
;    <sticks>)      ; Положительное целое число.

; Факт player-move указывает, кому принадлежит ход.

; (player-move
;    <player)       ; c (компьютер) 
                    ; или h (человек).

; Факт human-takes содержит ответ игрока на вопрос
; "Сколько палочек нужно взять?".


; (human-takes
;    <choice>)      ; Верные ответы: 1, 2, и 3.


; Шаблонный факт take-sticks показывает, как много палочек
; компьютер должен взять, в зависимости от результата деления
; количества палочек на 4

; Шаблонный факт напоминает структуру в языке C, how-many и for-remainder
; в примере ниже - слоты (аналог полей в стуктурах C)
; в шаблоне take-sticks могут быть заданы значения по умолчанию с
; помощью ключевого слова default
; Пример:
; (slot how-many) (slot for-remainder) (default 1)

(deftemplate take-sticks
   (slot how-many)         ; Number of sticks to take.
   (slot for-remainder))   ; Remainder when stack is
                           ; divided by 4.

; ********
; ФАКТЫ 
; ********

; Создается факт phase со значением choose-player.
(deffacts initial-phase
   (phase choose-player))


; deffacts указыват интерпретатору, что существует массив 
; take-sticks-information, который содержит 4 факта.
; В каждой строке с описанием факта указываются значения для
; полей how-many и for-reminder.

(deffacts take-sticks-information
   (take-sticks (how-many 1) (for-remainder 1))
   (take-sticks (how-many 1) (for-remainder 2))
   (take-sticks (how-many 2) (for-remainder 3))
   (take-sticks (how-many 3) (for-remainder 0)))

; *****
; ПРАВИЛА 
; *****

; Данное правило срабатывает, если текущее значение phase равно choose-player.
; При срабатывании на экран с помощью функции printout выведется сообщение,
; узазанное в "". Затем в память будет помощен факт player-select,
; значение которого будет получено с помощью функции read.

(defrule player-select
   (phase choose-player)
   =>
   (printout t "Who moves first (Computer: c "
               "Human: h)? ")
   (assert (player-select (read))))

; Данное правило сработает, если значение phase равно chose-player,
; и пользователь ввел корреткные данные (c или h)
; Замечание: здесь значения переменных ?phase и ?choice связываются
; с адресами фактов с помощью оператора связывания с шаблоном <-.
; При срабатывании правила из списка фактов удаляются факты phase
; и player-select (см. замечание), затем добавляются факты
; player-move и phase с соответствующими значениями.

(defrule good-player-choice
   ?phase <- (phase choose-player)
   ?choice <- (player-select ?player&c | h)
   =>
   (retract ?phase ?choice)
   (assert (player-move ?player))
   (assert (phase select-pile-size)))

; Аналогично предыдущему правилу, проверяется текущая фаза и
; введенные данные, однако в этот раз проверяется, что
; пользователь не ввел 'c' и не ввел 'h'.
; При срабатывании правила аналогично предыдущему правилу очищаются
; факты phase и player-select, но затем phase снова становится равен
; player-select и пользователю предлгается заново ввести данные.

(defrule bad-player-choice 
   ?phase <- (phase choose-player)
   ?choice <- (player-select ?player&~c&~h)
   =>
   (retract ?phase ?choice)
   (assert (phase choose-player))
   (printout t "Choose c or h." crlf))

; Данное правило работает аналогично правилу player-select:
; проверяется значение phase, выводится сообщение и добавляется
; новый факт pile-select со считанным значением.

(defrule pile-select 
   (phase select-pile-size)
   =>
   (printout t "How many sticks in the pile? ")
   (assert (pile-select (read))))

; Данное правило работает аналогично правилу good-player-choice.
; В данном правиле значение pile-select сначала проверяется на
; соответствие типа integer, а затем проверяется, что его значение > 0.
; При срабатывании правила удаляются факты phase и pile-select и добавляется
; факт pile-size со значением ?size.

(defrule good-pile-choice
   ?phase <- (phase select-pile-size)
   ?choice <- (pile-select ?size&:(integerp ?size)
                                &:(> ?size 0))
   =>
   (retract ?phase ?choice)
   (assert (pile-size ?size)))

; Данное правило работает аналогично правилу bad-player-choice.
; В данном правиле проверяется то, что значение
; pile-select не принадлежит типу integer, а так же то, что оно <= 0.
; При выполнении одного из двух условий срабатывает данное правило.
; При срабатывании данного правила удаляются факты phase и pile-select и
; выводится сообщение о необходимости повторного ввода значения для select-pile-size

(defrule bad-pile-choice
   ?phase <- (phase select-pile-size)
   ?choice <- (pile-select ?size&~:(integerp ?size)
                                 |:(<= ?size 0))
   =>
   (retract ?phase ?choice)
   (assert (phase select-pile-size))
   (printout t "Choose an integer greater than zero."
               crlf))


; Данное правило служит для проверки поражения компьютера.
; Оно сработает, если в данный момент количество палочек равно 1
; и ход переходит компьютеру.
; При срабатывании правила выводится сообщение о поражении компьютера.

(defrule computer-loses
   (pile-size 1)
   (player-move c)
   =>
   (printout t "Computer must take the last stick!" crlf)
   (printout t "I lose!" crlf))

; Данное правило полностью аналогично правилу computer-loses, но
; срабатывает, если ход переходит человеку.

(defrule human-loses
   (pile-size 1)
   (player-move h)
   =>
   (printout t "You must take the last stick!" crlf)
   (printout t "You lose!" crlf))

; Данное правило служит для считывания информации о том,
; сколько палочек хочет взять игрок.
; Данное правило срабатывает, если палочек больше одной
; и ход принадлежит игроку.
; При срабатывании данного правила выводится сообщение и
; заносится новый факт human-takes со считанным значением

(defrule get-human-move
   (pile-size ?size&:(> ?size 1))
   (player-move h)
   =>
   (printout t "How many sticks do you wish to take? ")
   (assert (human-takes =(read))))


; Данное правило описывает поведение системы, если пользователь
; ввел правильные данные в свой ход.
; Данное правило срабатывает, если ход принадлежит игроку, а так же
; игрок ввел целочисленное значение от 1 до 3, меньшее числу палочек в куче.
; При срабатывании данного правила удаляются факты pile-size, human-takes,
; player-move; создается переменная ?new-size, содержащая значение нового
; размера кучи; выводится сообщение с информацией о новом количестве палочек;
; ход передается компьютеру путем добавления факта player-move c.

(defrule good-human-move
   ?pile <- (pile-size ?size)
   ?move <- (human-takes ?choice)
   ?whose-turn <- (player-move h)
   (test (and (integerp ?choice)
              (>= ?choice 1) 
              (<= ?choice 3)
              (< ?choice ?size)))
   =>
   (retract ?pile ?move ?whose-turn)
   (bind ?new-size (- ?size ?choice))
   (assert (pile-size ?new-size))
   (printout t ?new-size " stick(s) left in the pile."
               crlf)
   (assert (player-move c)))

; Данное правило срабатывает, если введенные пользователем данные не верны:
; существует куча из палочек, ход принадлежит игроку, но при этом игрок либо
; ввел данные, отличные от integer, либо ввел число х, где x < 1 или x > 3 или
; x >= числу палочек в куче.
; При срабатывании правила, будет выведено сообщение, затем удалены факты human-takes и player-move,
; после чего будет добавлен факт player-move h.

(defrule bad-human-move
   (pile-size ?size)
   ?move <- (human-takes ?choice)
   ?whose-turn <- (player-move h)
   (test (or (not (integerp ?choice)) 
             (< ?choice 1) 
             (> ?choice 3)
             (>= ?choice ?size)))
   =>
   (printout t "Number of sticks must be between 1 and 3,"
               crlf
               "and you must be forced to take the last "
               "stick." crlf)
   (retract ?move ?whose-turn)
   (assert (player-move h)))

; Данное правило описывает логику хода компьютера.
; Данное правило срабатывает, если в куче более одной палочки и ход принадлежит компьютеру
; и компьютер может сделать ход, что определяется фактом take-sticks (см. описание шаблонного факта
; take-sticks).
; При срабатывании данного правила удаляются факты player-move и pile-size, после чего высчитывается
; новый размер кучи и заносится в переменную ?new-size, затем выводится сообщение о ходе компьютера и
; новом размере кучи, после чего создаются факты pile-size, в который заносится новый размер кучи и player-move h,
; что означает передачу хода игроку.

(defrule computer-move
   ?whose-turn <- (player-move c)
   ?pile <- (pile-size ?size&:(> ?size 1))
   (take-sticks (how-many ?number)
                (for-remainder =(mod ?size 4)))
   =>
   (retract ?whose-turn ?pile)
   (bind ?new-size (- ?size ?number))
   (printout t "Computer takes " ?number " stick(s)."
               crlf)
   (printout t ?new-size " stick(s) left in the pile."
               crlf)
   (assert (pile-size ?new-size))
   (assert (player-move h)))


