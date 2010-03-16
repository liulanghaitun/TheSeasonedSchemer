;; capter.14


; leftmost

;; (leftmost '(((a) b)(c d)))
;;  -> a

; The Seasoned Schemer
(define atom?
  (lambda (a)
    (and (not (pair? a))
         (not (null? a)))))

(define leftmost
  (lambda (l)
    (cond
     ((atom? (car l))(car l))
     (else (leftmost (car l))))))

(leftmost '(((a) b)(c d)))
; -> a
(leftmost '(((a)())()(e)))
; -> a

(leftmost '(((() a)())))
; -> *** ERROR: pair required, but got ()


; leftmost * The Seasoned Schemer
(define leftmost
  (lambda (l)
    (cond
     ((null? l)(quote ()))
     ((atom? (car l))(car l))
     (else (cond
            ((atom? (leftmost (car l)))
             (leftmost (car l)))
            (else (leftmost (cdr l))))))))

(leftmost '(((a) b)(c d)))
; -> a
(leftmost '(((a)())()(e)))
; -> a
(leftmost '(((() a)())))
; -> a


(define leftmost
  (lambda (l)
    (cond
     ((null? l)(quote ()))
     ((atom? (car l))(car l))
     (else (let ((a (leftmost (car l))))
             (cond
              ((atom? a) a)
              (else (leftmost (cdr l)))))))))

(leftmost '(((a) b)(c d)))
; -> a
(leftmost '(((a)())()(e)))
; -> a
(leftmost '(((() a)())))
; -> a


(use srfi-1)
(define (eqlist? l1 l2)
  (list= eq? l1 l2))


; rember1*

;; (rember1* 'salad '((Swedish rye)
;;                    (French (mustard salad turkey))
;;                    salad))
;;  -> ((Swedish rye)
;;      (French (mustard turkey))
;;      salad)


; The Seasoned Schemer
(define rember1*
  (lambda (a lat)
    (cond
     ((null? lat)(quote ()))
     ((atom? (car lat))
      (cond
       ((eq? (car lat) a)(cdr lat))
       (else (cons (car lat)
                   (rember1* a (cdr lat))))))
     (else
      (cond
       ((eqlist?
         (rember1* a (car lat)) ; *
         (car lat))
        (cons (car lat)
              (rember1* a (cdr lat))))
       (else (cons (rember1* a (car lat)) ; *
                   (cdr lat))))))))

(rember1* 'salad '((Swedish rye)
                   (French (mustard salad turkey))
                   salad))
; -> ((Swedish rye) (French (mustard turkey)) salad)
                      
; The Seasoned Schemer letrec
(define rember1*
  (lambda (a l)
    (letrec
        ((R (lambda (l)
              (cond
               ((null? l)(quote ()))
               ((atom? (car l))
                (cond
                 ((eq? (car l) a)(cdr l))
                 (else (cons (car l)
                             (R (cdr l))))))
               (else
                (cond
                 ((eqlist?
                   (R (car l)) ; *
                   (car l))
                  (cons (car l)
                        (R (cdr l))))
                 (else (cons (R (car l)) ; *
                             (cdr l)))))))))
      (R l))))
                 
(rember1* 'salad '((Swedish rye)
                   (French (mustard salad turkey))
                   salad))
; -> ((Swedish rye) (French (mustard turkey)) salad)


; The Seasoned Schemer letrec, let
(define rember1*
  (lambda (a l)
    (letrec
        ((R (lambda (l)
              (cond
               ((null? l)(quote ()))
               ((atom? (car l))
                (cond
                 ((eq? (car l) a)(cdr l))
                 (else (cons (car l)
                             (R (cdr l))))))
               (else (let ((av (R (car l))))
                       (cond
                        ((eqlist? (car l) av)
                         (cons (car l)(R (cdr l))))
                        (else (cons av (cdr l))))))))))
      (R l))))

(rember1* 'salad '((Swedish rye)
                   (French (mustard salad turkey))
                   salad))
; -> ((Swedish rye) (French (mustard turkey)) salad)


; rember*

; fold-right
(use srfi-1)
(define (rember* a l)
  (fold-right (lambda (e acc)
                (if (list? e)
                    (cons (rember* a e)
                          acc)
                    (if (eq? a e)
                        acc
                        (cons e
                              acc))))
              '() l))

(rember* 'salad '((Swedish rye)
                   (French (mustard salad turkey))
                   salad))

(define (rember* a l)
  (fold-right (lambda (e acc)
                (let ((kons (lambda (kar)
                              (cons kar acc))))
                  (if (list? e)
                      (kons (rember* a e))
                      (if (eq? a e)
                          acc
                          (kons e)))))
              '() l))

(rember* 'salad '((Swedish rye)
                   (French (mustard salad turkey))
                   salad))

(define (rember* a l)
  (fold-right (lambda (e acc)
                (if (eq? a e)
                    acc
                    (cons (if (list? e)
                              (rember* a e)
                              e)
                          acc)))
              '() l))


(rember* 'salad '((Swedish rye)
                   (French (mustard salad turkey))
                   salad))