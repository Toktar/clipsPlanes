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




(deftemplate plane "all planes"
   (slot weight  (type FLOAT))
   (slot cost  (type FLOAT))
   (slot start (type STRING))
   (slot end  (type STRING))
  )

  (deftemplate answer
     (slot id  (type NUMBER))
     (slot weight  (type FLOAT))
     (slot cost  (type FLOAT))
     (slot start (type STRING))
     (slot end  (type STRING))
    )


  (deftemplate query
     (slot weight  (type FLOAT))
     (slot id  (type NUMBER))
     (slot start (type STRING))
     (slot end  (type STRING))
    )

(deffacts planes
  (plane (weight 10.0)(start "A")(end "B")(cost 1200.0))
  (plane (weight 3.0)(start "C")(end "D")(cost 1190.0))
   )




(deffunction can-fly(?start-tmp ?end-tmp ?weight-tmp ?id)
    (if(integerp ?weight-tmp)
    then
    (printout t "thenFunc")
    ;;(assert (can-i))
    (assert (query (weight ?weight-tmp)(start ?start-tmp)(end ?end-tmp)(id ?id)))
    else (printout t "elseFunc")
    )

)


(deffunction true-fact(?query-start ?start
                       ?query-end ?end
                       ?query-weight ?weight
                       ?cost
                       ?id)
    (if(and (= (str-compare ?query-start ?start) 0)
            (= (str-compare ?query-end ?end) 0)
            (<= ?query-weight ?weight)
        )
    then
    (assert (answer (weight ?weight)(start ?start)(end ?end)(id ?id)(cost ?cost)))
    (printout t "!!!!!!" ?start " " ?end " " ?weight " " ?cost)
    ;;else (printout t "nope!")
    )

)


(defrule can-i
   (plane (weight ?weight)(start ?start)(end ?end)(cost ?cost))
   ?query <- (query (weight ?query-weight)(start ?query-start)(end ?query-end)(id ?id))
   =>
   (printout t "\n debug: plane - " ?start " " ?end " query - " ?query-start " " ?query-end)
   (true-fact
   ?query-start ?start
   ?query-end ?end
   ?query-weight ?weight
   ?cost
   ?id
   )
   (retract ?query)
   )

