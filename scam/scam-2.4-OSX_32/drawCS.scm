(include "draw.scm")

(define NULL "{\\it null}")
(define NULL_CHARACTER "\\tt\\char92 0")
(define EMPTY " ")

(define linkedListCellWidth 1)
(define linkedListCellHeight 1)
(define arrayCellWidth 1)
(define arrayCellHeight 1)
(define variableColor 'black)
(define italics #t)

(define static 'static)
(define dynamic 'dynamic)

(define (setItalics it)
    (define temp italics)
    (set! italics it)
    temp
    )

(define (getItalics)
    italics
    )

(define (setVariableColor co)
    (define temp variableColor)
    (set! variableColor co)
    temp
    )

(define (getVariableColor)
    variableColor
    )

(define (setLinkedListCellHeight ch)
    (define temp linkedListCellHeight)
    (set! linkedListCellHeight ch)
    temp
    )

(define (getLinkedListCellHeight)
    linkedListCellHeight
    )

(define (setLinkedListCellWidth cw)
    (define temp linkedListCellWidth)
    (set! linkedListCellWidth cw)
    temp
    )

(define (getLinkedListCellWidth)
    linkedListCellWidth
    )

(define (setArrayCellHeight ch)
    (define temp arrayCellHeight)
    (set! arrayCellHeight ch)
    temp
    )

(define (getArrayCellHeight)
    arrayCellHeight
    )

(define (setArrayCellWidth cw)
    (define temp arrayCellWidth)
    (set! arrayCellWidth cw)
    temp
    )

(define (getArrayCellWidth)
    arrayCellWidth
    )

(define (variableWrap name)
    (cond
        ((and italics (eq? variableColor 'black))
            (string+ "{\\it " name "}"))
        (italics
            (string+ "{\\color{" variableColor "}\\it " name "}"))
        ((eq? variableColor 'black)
            name)
        (else
            (string+ "{\\color{" variableColor "}" name "}"))
        )
    )

(define (variable name value)
    (setJustification 'r)
    (label (string+ (variableWrap name) "~:~"))
    (setJustification 'l)
    (label value)
    )

(define (node name value next)
    (define height linkedListCellHeight)
    (define width linkedListCellWidth)
    (define spacing 1)
    (define ndx 0.05)
    (define vdy 0.15)
    (define ndy -0.10)
    (define spot (getLocation))
    (structureName name 'dynamic width height)
    (setJustification 't)
    (rectangle width height)
    (shift (/ width 2.0) 0)
    (arrowShift 0 (- spacing))
    (label value)
    (shift 0 (+ spacing vdy))
    (cond
        ((valid? next)
            (shift (/ width 2.0) (/ height 2.0))
            (arrowShift spacing 0)
            (setJustification 'lB)
            (shift ndx ndy)
            (label next)
            (setJustification 'c)
            )
        )
    (setLocation spot)
    )

(define (linkedList name @)
    (define spot (getLocation))
    (define height linkedListCellHeight)
    (define width linkedListCellWidth)
    (define spacing 1)
    (define ndx -0.15)
    (define vdy 0.15)
    (define ndy -0.1)
    (structureName name 'dynamic width height)
    (setJustification 't)
    (while (and (valid? @) (not (eq? (car @) EMPTY)))
        (rectangle width height)
        (shift (/ width 2.0) 0)
        (line down spacing arrow)
        (shift 0 (- vdy))
        (label (car @))
        (shift 0 (+ vdy))
        (shift 0 spacing)
        (shift (/ width 2.0) 0)
        (set! @ (cdr @))
        (if (and (valid? @) (not (eq? (car @) EMPTY)))
            (begin
                (shift 0 (/ height 2.0))
                (line right spacing arrow)
                (shift 0 (/ height -2.0))
                )
            )
        )
    ; now add the null
    (if (null? @)
        (begin
            (setJustification 'lB)
            (shift 0 (/ height 2.0))
            (line right spacing arrow)
            (shift (/ ndx -2.0) ndy)
            (label NULL)
            (setJustification 'c)
            (setLocation spot)
            )
        )
    )

(define (shiftCellOffset offset width height)
    (cond
        ((eq? offset 'bottom-in)
            )
        ((eq? offset 'bottom-out)
            (shift width 0))
        ((eq? offset 'very-low-in)
            (shift 0 (* height 0.1)))
        ((eq? offset 'very-low-out)
            (shift width (* height 0.1)))
        ((eq? offset 'low-in)
            (shift 0 (* height 0.25)))
        ((eq? offset 'low-out)
            (shift width (* height 0.25)))
        ((eq? offset 'in)
            (shift 0 (* height 0.5)))
        ((eq? offset 'out)
            (shift width (* height 0.5)))
        ((eq? offset 'high-in)
            (shift 0 (* height 0.75)))
        ((eq? offset 'high-out)
            (shift width (* height 0.75)))
        ((eq? offset 'very-high-in)
            (shift 0 (* height 0.9)))
        ((eq? offset 'very-high-out)
            (shift width (* height 0.9)))
        ((eq? offset 'top-in)
            (shift 0 height))
        ((eq? offset 'top-out)
            (shift width height))
        ((eq? offset 'center)
            (shift (/ width 2.0) (/ height 2.0)))
        ((eq? offset 'top)
            (shift (/ width 2.0) height))
        ((eq? offset 'bottom)
            (shift (/ width 2.0) 0))
        (else
            (throw 'unknownConstant
                (string+ "constant " (string offset) " not understood"))
            )
        )
    )

(define (cellSpot start count offset)
    (define spot (getLocation))
    (define width (getArrayCellWidth))
    (define height (getArrayCellHeight))
    (define where spot)
    (moveToMark start)
    (while (> count 0)
        (shift width 0)
        (set! count (- count 1))
        (if (> count 0) (shift (* (getLineWidth) -1.0) 0))
        )
    (shiftCellOffset offset width height)
    (set! where (getLocation))
    (setLocation spot)
    where
    )

(define (vcellSpot start count offset)
    (define spot (getLocation))
    (define width (getArrayCellWidth))
    (define height (getArrayCellHeight))
    (define where spot)
    (moveToMark start)
    (while (> count 0)
        (shift 0 (- height))
        (set! count (- count 1))
        (if (> count 0) (shift 0 (* (getLineWidth) 1.0)))
        )
    (shiftCellOffset offset width height)
    (set! where (getLocation))
    (setLocation spot)
    where
    )

(define (nodeSpot start count offset)
    (define spot (getLocation))
    (define width (getLinkedListCellWidth))
    (define height (getLinkedListCellHeight))
    (define where spot)
    (moveToMark start)
    (while (> count 0)
        (shift (* width 2) 0)
        (set! count (- count 1))
        )
    (shiftCellOffset offset width height)
    (set! where (getLocation))
    (setLocation spot)
    where
    )

(define (memLabel m)
    ;(inspect m)
    (define spot (getLocation))
    (cond
        ((valid? m)
            (define spacing (* (getArrayCellHeight) 0.375))
            (shift 0 (- spacing))
            (setJustification 'B)
            (label (string+ "{\\small\\textit{" (string m) "}}"))
            )
        )
    (setLocation spot)
    )

(define (vmemLabel m)
    ;(inspect m)
    (define spot (getLocation))
    (cond
        ((valid? m)
            (shift (* (getArrayCellWidth) -0.2) 0)
            (setJustification 'r)
            (label (string+ "{\\small\\textit{" (string m) "}}"))
            )
        )
    (setLocation spot)
    )

(define (memValue v)
    (define spot (getLocation))
    (cond
        ((valid? v)
            (define height (getArrayCellHeight))
            (shift 0 (/ height 2.0))
            (setJustification 'c)
            (label v)
            )
        )
    (setLocation spot)
    )

(define (vmemValue v)
    (define spot (getLocation))
    (cond
        ((valid? v)
            (shift (/ (getArrayCellWidth) 2.0) 0)
            (setJustification 'c)
            (label v)
            )
        )
    (setLocation spot)
    )

(define (memAddress a)
    ;(inspect a)
    (define spot (getLocation))
    (cond
        ((valid? a)
            (shift 0 (* (getArrayCellHeight) 1.15))
            (setJustification 'B)
            (label (string+ "{\\small " (string a) "}"))
            )
        )
    (setLocation spot)
    )

(define (vmemAddress a)
    ;(inspect a)
    (define spot (getLocation))
    (cond
        ((valid? a)
            (shift (* (getArrayCellWidth) 1.15) 0)
            (setJustification 'l)
            (label (string+ "{\\small " (string a) "}"))
            )
        )
    (setLocation spot)
    )

(define (memory count @)
    (define i 0)
    (define height arrayCellHeight)
    (define width arrayCellWidth)
    (define contents nil)
    (define spot (getLocation))
    (line right (/ width 2.0))
    (shift (/ width -2.0) height)
    (shift 0 (- (getLineWidth)))
    (line right (/ width 2.0))
    (shift (/ width 2) (- height))
    (shift 0 (/ (getLineWidth) 2.0))
    (for (set! i 0) (< i count) (set! i (+ i 1))
        (rectangle width height)
        (set! contents (assoc i @))
        (if (neq? contents #f)
            (begin
                (shift (/ width 2.0) 0)
                (memLabel (cadr contents))
                (memValue (caddr contents))
                (memAddress (cadddr contents))
                (shift (/ width 2.0) 0)
                )
            (shift width 0)
            )
        (shift (* (getLineWidth) -1.0) 0)
        )
    (shift 0 (/ (getLineWidth) 2.0))
    (line right (/ width 2.0))
    (shift (/ width -2.0) height)
    (shift 0 (- (getLineWidth)))
    (line right (/ width 2.0))
    (setLocation spot)
    )

(define (structureName name type width height)
    (define ndx -0.15)
    (define ndy -0.10)
    (define spot (getLocation))
    (cond 
        ((and (valid? name) (eq? type 'static))
            (shift 0 (/ height 2.0))
            (setJustification 'rB)
            (shift 0 ndy)
            (label (string+ (variableWrap name) "~:~"))
            )
        ((valid? name)
            (shift (- width) (/ height 2.0))
            (setJustification 'rB)
            (shift ndx ndy)
            (label (variableWrap name))
            (shift (- ndx) (- ndy))
            (arrowShift width 0)
            )
        )
    (setLocation spot)
    )

(define (array name type count @)
    (define i 0)
    (define height arrayCellHeight)
    (define width arrayCellWidth)
    (define contents nil)
    (define spot (getLocation))
    ;(inspect @)
    (structureName name type width height)
    (for (set! i 0) (< i count) (set! i (+ i 1))
        (rectangle width height)
        (set! contents (assoc i @))
        ;(inspect contents)
        (if (neq? contents #f)
            (begin
                (shift (/ width 2.0) 0)
                (memLabel (cadr contents))
                (memValue (caddr contents))
                (memAddress (cadddr contents))
                (shift (/ width 2.0) 0)
                )
            (shift width 0)
            )
        (shift (* (getLineWidth) -1.0) 0)
        )
    ; see if array boundary violation should be drawn
    (set! contents (assoc count @))
    (if (neq? contents #f)
        (begin
            (shift (/ width 2.0) 0)
            (memLabel (cadr contents))
            (memValue (caddr contents))
            (memAddress (cadddr contents))
            (shift (/ width 2.0) 0)
            )
        (shift width 0)
        )
    (setLocation spot)
    )

(define (varray name type count @)
    (define i 0)
    (define height arrayCellHeight)
    (define width arrayCellWidth)
    (define contents nil)
    (define spot (getLocation))
    (structureName name type width height)
    (for (set! i 0) (< i count) (set! i (+ i 1))
        (rectangle width height)
        (set! contents (assoc i @))
        (if (neq? contents #f)
            (begin
                (shift 0 (/ height 2.0))
                (vmemLabel (cadr contents))
                (vmemValue (caddr contents))
                (vmemAddress (cadddr contents))
                (shift 0 (* height -1.5))
                )
            (shift 0 (- height))
            )
        (shift 0 (* (getLineWidth) 1.0))
        )
    ; see if array boundary violation should be drawn
    (set! contents (assoc count @))
    (if (neq? contents #f)
        (begin
            (shift 0 (/ height -2.0))
            ;(vmemLabel (cadr contents))
            ;(vmemValue (caddr contents))
            ;(vmemAddress (cadddr contents))
            )
        )
    (setLocation spot)
    )

(define (array* name type @)
    (define height arrayCellHeight)
    (define width arrayCellWidth)
    (define spot (getLocation))
    (structureName name type width height)
    (setJustification 'c)
    (while (valid? @)
        (rectangle width height)
        (shift (/ width 2.0) (/ height 2.0))
        (label (car @))
        (shift (/ width 2.0) (/ height -2.0))
        (shift (- (getLineWidth)) 0)
        (set! @ (cdr @))
        )
    (setLocation spot)
    )

(define (heap @)
    (define spot (getLocation))
    (define level 1)
    (define levelCount 1)
    (define size 0.5)
    (define hspacing 1.5)
    (define vspacing 1.5)
    (define levelShift (/ hspacing 2.0))
    (define parents (queue))
    (define count 0)
    (define parentLocation nil)
    (define where nil)
    (shift 0 (- size))
    (mark 'top)
    (mark 'heap)
    ; draw the edges
    (set! where @)
    (while (valid? where)
        (if (> level 1)
            (begin
                (set! parentLocation ((parents'dequeue)))
                (mark 'current)
                (moveTo parentLocation)
                (lineToMark 'current)
                (moveToMark 'current)
                )
            )
        ((parents'enqueue) (getLocation))
        ((parents'enqueue) (getLocation))
        (set! count (+ count 1))
        (cond
            ((>= count levelCount)
                (moveToMark 'heap)
                (shift (- levelShift) (- vspacing))
                (mark 'heap)
                (set! level (+ level 1))
                (set! levelCount (* 2 levelCount))
                (set! levelShift (* 2 levelShift))
                (set! count 0)
                )
            (else
                (shift hspacing 0)
                )
            )
        (set! where (cdr where))
        )

    ; draw the vertices
    (moveToMark 'top)
    (mark 'heap)
    (setFillColor 'white)
    (set! count 0)
    (set! level 1)
    (set! levelCount 1)
    (set! where @)
    (set! levelShift (/ hspacing 2.0))
    ;(inspect hspacing)
    (define oj (setJustification 'c))
    (while (valid? where)
        (filledCircle size white 'solid)
        (label (car where))
        (set! count (+ count 1))
        (cond
            ((>= count levelCount)
                (moveToMark 'heap)
                (shift (- levelShift) (- vspacing))
                (mark 'heap)
                (set! level (+ level 1))
                (set! levelCount (* 2 levelCount))
                (set! levelShift (* 2 levelShift))
                (set! count 0)
                )
            (else
                (shift hspacing 0)
                )
            )
        (set! where (cdr where))
        )
    (setJustification oj)
    (setLocation spot)
    )

(define (binomialHeap degree)
    (define levelShift 2)
    (define siblingShift 2)
    (define size .5)
    (define spot nil)
    (cond
        ((= degree 0)
            (filledCircle size red solid)
            )
        (else
            (filledCircle size red solid)
            (shift 0 (- levelShift))
            (define hop 1)
            (for (define i 0) (< i degree) (++ i)
                (set! spot (getLocation))
                (binomialHeap i)
                (setLocation spot)
                (shift (* -1 siblingShift hop) 0)
                (if (> i 0) (<- hop (* hop 2)))
                )
            )
        )
    )
            
(define (queue)
    (define (node value next) this)
    (define store (node nil nil))
    (define last store)
    (define (dequeue)
        (define temp (get 'value (store'next)))
        ;(if (valid? (store'next)) (inspect (store'next'value)))
        (set 'next (store'next'next) store)
        temp
        )
    (define (enqueue value)
        (set 'next (node value nil) last)
        (set! last (get 'next last))
        )
    (define (display)
        (define spot (store'next))
        (print "%")
        (while (valid? spot)
            (print " " (spot'value))
            (set! spot (spot'next))
            )
        (println)
        )
    this
    )

(define (pointerToMark name loc wiggle @)
    (define dx -0.10)
    (define dy 0.05)
    (define ju (setJustification 'r))
    (define spot (getLocation))
    (shift dx dy)
    (if (valid? name)
        (label (variableWrap name)))
    (setLocation spot)
    (if (valid? @)
        (vbarrowToMark loc wiggle)
        (hbarrowToMark loc wiggle)
        )
    (setJustification ju)
    (setLocation spot)
    )

(define (pointerToLocation name dest wiggle @)
    (define dx -0.10)
    (define dy 0.05)
    (define ju (setJustification 'r))
    (define spot (getLocation))
    (shift dx dy)
    (if (valid? name)
        (label (variableWrap name)))
    (setLocation spot)
    (if (valid? @)
        (vbarrowToLocation dest wiggle)
        (hbarrowToLocation dest wiggle)
        )
    (setJustification ju)
    (setLocation spot)
    )

(if #f
    (begin
        (openImage "a")
        (setFillColor 'blue)
        (linkedList "{\\it alpha}" 1 2 0)
        (shift 0 3)
        (array* "{\\it alpha}" 'dynamic 1 2 3 4 NULL_CHARACTER)
        (shift 0 3)
        (array "{\\it alpha}" 'dynamic 10
            (list 2 nil 1 "1000")
            (list 3 "X" 2 "1032")
            (list 4 nil 3 "1064")
            (list 5 nil 4 "1096")
            )
        (shift 0 3)
        (memory 10
            (list 2 nil 1 "1000")
            (list 3 "X" 2 "1032")
            (list 4 nil 3 "1064")
            (list 5 nil 4 "1096")
            )
        (shift 13 0)
        (varray "{\\it alpha}" 'dynamic 10
            (list 2 nil 1 "1000")
            (list 3 "Xyzzy" 2 "1032")
            (list 4 nil 3 "1064")
            (list 5 nil 4 "1096")
            )
        (shift -4 -10)
        (heap 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
            17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
        (shift 10 -10)
        (binomialHeap 5)
        (closeImage)
        (convertImage "png")
        (println "done")
        )
    )
