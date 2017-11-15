
;;;======================================================
;;;   Who Drinks Water? And Who owns the Zebra?
;;;
;;;     Another puzzle problem in which there are five
;;;     houses, each of a different color, inhabited by
;;;     men of different nationalities, with different
;;;     pets, drinks, and cigarettes. Given the initial
;;;     set of conditions, it must be determined which
;;;     attributes are assigned to each man.
;;;
;;;     CLIPS Version 6.0 Example
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================


(deftemplate student "a student record"

(slot name (type STRING)) (slot age (type NUMBER) (default 18))
)

(deffacts students
(student (name "fred"))

(student (name "freda") (age 19)) )




(deftemplate plane
   (slot name  (type STRING))
   (slot start  (type STRING))
   (slot end  (type STRING))
  )

(deffacts planes
  (plane (name plane1)(start A)(end B))
  (plane (name plane2)(start C)(end D))
   )


;;;(deftemplate avh (field a) (field v) (field h))
;;;(deftemplate output (multislot values))

(deftemplate bottle
 (slot volume (type INTEGER))
)

(deftemplate goal
 (slot action (type SYMBOL))
 (slot machine-volume (type INTEGER))
 (slot bottles-count (type INTEGER))
)

(defrule find-solution
  ; The Englishman lives in the red house.

  (avh (a nationality) (v englishman) (h ?n1))
  (avh (a color) (v red) (h ?c1&?n1))

  ; The Spaniard owns the dog.

  (avh (a nationality) (v spaniard) (h ?n2&~?n1))
  (avh (a pet) (v dog) (h ?p1&?n2))

  ; The ivory house is immediately to the left of the green house,
  ; where the coffee drinker lives.

  (avh (a color) (v ivory) (h ?c2&~?c1))
  (avh (a color) (v green) (h ?c3&~?c2&~?c1&=(+ ?c2 1)))
  (avh (a drink) (v coffee) (h ?d1&?c3))

  ; The milk drinker lives in the middle house.

  (avh (a drink) (v milk) (h ?d2&~?d1&3))

  ; The man who smokes Old Golds also keeps snails.

  (avh (a smokes) (v old-golds) (h ?s1))
  (avh (a pet) (v snails) (h ?p2&~?p1&?s1))

  ; The Ukrainian drinks tea.

  (avh (a nationality) (v ukrainian) (h ?n3&~?n2&~?n1))
  (avh (a drink) (v tea) (h ?d3&~?d2&~?d1&?n3))

  ; The Norwegian resides in the first house on the left.

  (avh (a nationality) (v norwegian) (h ?n4&~?n3&~?n2&~?n1&1))

  ; Chesterfields smoker lives next door to the fox owner.

  (avh (a smokes) (v chesterfields) (h ?s2&~?s1))
  (avh (a pet) (v fox) (h ?p3&~?p2&~?p1&:(or (= ?s2 (- ?p3 1)) (= ?s2 (+ ?p3 1)))))

  ; The Lucky Strike smoker drinks orange juice.

  (avh (a smokes) (v lucky-strikes) (h ?s3&~?s2&~?s1))
  (avh (a drink) (v orange-juice) (h ?d4&~?d3&~?d2&~?d1&?s3))

  ; The Japanese smokes Parliaments

  (avh (a nationality) (v japanese) (h ?n5&~?n4&~?n3&~?n2&~?n1))
  (avh (a smokes) (v parliaments) (h ?s4&~?s3&~?s2&~?s1&?n5))

  ; The horse owner lives next to the Kools smoker,
  ; whose house is yellow.

  (avh (a pet) (v horse) (h ?p4&~?p3&~?p2&~?p1))
  (avh (a smokes) (v kools) (h ?s5&~?s4&~?s3&~?s2&~?s1&:(or (= ?p4 (- ?s5 1)) (= ?p4 (+ ?s5 1)))))
  (avh (a color) (v yellow) (h ?c4&~?c3&~?c2&~?c1&?s5))

  ; The Norwegian lives next to the blue house.

  (avh (a color) (v blue) (h ?c5&~?c4&~?c3&~?c2&~?c1&:(or (= ?c5 (- ?n4 1)) (= ?c5 (+ ?n4 1)))))

  ; Who drinks water?  And Who owns the zebra?

  (avh (a drink) (v water) (h ?d5&~?d4&~?d3&~?d2&~?d1))
  (avh (a pet) (v zebra) (h ?p5&~?p4&~?p3&~?p2&~?p1))

  =>
  (assert (solution nationality englishman ?n1)
          (solution color red ?c1)
          (solution nationality spaniard ?n2)
          (solution pet dog ?p1)
          (solution color ivory ?c2)
          (solution color green ?c3)
          (solution drink coffee ?d1)
          (solution drink milk ?d2)
          (solution smokes old-golds ?s1)
          (solution pet snails ?p2)
          (solution nationality ukrainian ?n3)
          (solution drink tea ?d3)
          (solution nationality norwegian ?n4)
          (solution smokes chesterfields ?s2)
          (solution pet fox ?p3)
          (solution smokes lucky-strikes ?s3)
          (solution drink orange-juice ?d4)
          (solution nationality japanese ?n5)
          (solution smokes parliaments ?s4)
          (solution pet horse ?p4)
          (solution smokes kools ?s5)
          (solution color yellow ?c4)
          (solution color blue ?c5)
          (solution drink water ?d5)
          (solution pet zebra ?p5))
  )

(defrule generate-output
  ?f1 <- (solution nationality ?n1 ?i)
  ?f2 <- (solution color ?c1 ?i)
  ?f3 <- (solution pet ?p1 ?i)
  ?f4 <- (solution drink ?d1 ?i)
  ?f5 <- (solution smokes ?s1 ?i)
  =>
  (retract ?f1 ?f2 ?f3 ?f4 ?f5)
  (assert (output (values ?i ?n1 ?c1 ?p1 ?d1 ?s1)))
  )

(defrule startup
   =>
   (assert (value color red)
           (value color green)
           (value color ivory)
           (value color yellow)
           (value color blue)
           (value nationality englishman)
           (value nationality spaniard)
           (value nationality ukrainian)
           (value nationality norwegian)
           (value nationality japanese)
           (value pet dog)
           (value pet snails)
           (value pet fox)
           (value pet horse)
           (value pet zebra)
           (value drink water)
           (value drink coffee)
           (value drink milk)
           (value drink orange-juice)
           (value drink tea)
           (value smokes old-golds)
           (value smokes kools)
           (value smokes chesterfields)
           (value smokes lucky-strikes)
           (value smokes parliaments))
   )

(defrule generate-combinations
   ?f <- (value ?s ?e)
   =>
   (retract ?f)
   (assert (avh (a ?s) (v ?e) (h 1))
           (avh (a ?s) (v ?e) (h 2))
           (avh (a ?s) (v ?e) (h 3))
           (avh (a ?s) (v ?e) (h 4))
           (avh (a ?s) (v ?e) (h 5))))


