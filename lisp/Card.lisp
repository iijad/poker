;; Define the Cards class
(defclass Cards ()
  ((rank :initarg :rank :accessor get-rank)
   (suit :initarg :suit :accessor get-suit)))

;; Define methods for Cards class
(defmethod print-object ((card Cards) stream)
  (format stream "~a~a" (get-rank card) (get-suit card)))

(defmethod initialize-instance :after ((card Cards) &rest initargs)
  (setf (slot-value card 'rank-value)
        (get-rank-value (get-rank card))))

;; Define the Deck class
(defclass Deck ()
  ((cards :initarg :cards :accessor get-cards)
   (suits "SHDC")
   (ranks '("2" "3" "4" "5" "6" "7" "8" "9" "10" "J" "Q" "K" "A"))))

;; Define methods for Deck class
(defmethod initialize-instance :after ((deck Deck) &rest initargs)
  (setf (get-cards deck)
        (loop for suit in (suits deck)
              append (loop for rank in (ranks deck)
                           collect (make-instance 'Cards :rank rank :suit suit)))))

(defmethod shuffle ((deck Deck))
  (setf (get-cards deck) (shuffle-list (get-cards deck))))

(defmethod deal-cards ((deck Deck) &optional (num 1))
  (loop repeat num
        collect (pop (get-cards deck))))

(defmethod size ((deck Deck))
  (length (get-cards deck)))

(defmethod print-deck ((deck Deck))
  (dolist (card (get-cards deck))
    (princ card)
    (princ "\t")
    (when (= (% (incf count) 13) 0) (terpri))))

;; Define the Hand class
(defclass Hand ()
  ((cards :initarg :cards :accessor get-cards)))

;; Define methods for Hand class
(defmethod initialize-instance :after ((hand Hand) &rest initargs)
  (setf (get-cards hand) (sort (get-cards hand) #'< :key #'get-rank-value)))

(defmethod print-hand ((hand Hand))
  (dolist (card (get-cards hand))
    (princ card)
    (princ "\t")
    (when (= (% (incf count) 5) 0) (terpri))))

;; Define the Player class
(defclass Player ()
  ((name :initarg :name :accessor get-name)
   (hand :initarg :hand :accessor get-hand)))

;; Define methods for Player class
(defmethod initialize-instance :after ((player Player) &rest initargs)
  (setf (get-hand player) (make-instance 'Hand)))

(defmethod add-to-hand ((player Player) card)
  (push card (get-cards (get-hand player))))

(defmethod print-player ((player Player))
  (format t "~a's hand:~%" (get-name player))
  (print-hand (get-hand player)))

;; Define the PlayerRank class
(defclass PlayerRank ()
  ((player :initarg :player :accessor get-player)
   (rank :initarg :rank :accessor get-rank)
   (suit :initarg :suit :accessor get-suit)))

;; Define methods for PlayerRank class
(defmethod initialize-instance :after ((player-rank PlayerRank) &rest initargs)
  (setf (get-rank player-rank) (rank-hand (get-cards (get-hand (get-player player-rank))))))

;; Helper function to shuffle a list
(defun shuffle-list (lst)
  (loop for i from (1- (length lst)) downto 1 do
        (rotatef (elt lst i) (elt lst (random (1+ i)))))
  lst)

;; Helper function to get the rank value of a card
(defun get-rank-value (rank)
  (case rank
    ("2" 2) ("3" 3) ("4" 4) ("5" 5) ("6" 6) ("7" 7) ("8" 8) ("9" 9) ("10" 10) ("J" 11) ("Q" 12) ("K" 13) ("A" 14)))

;; Helper function to check for a straight in a hand
(defun straightp (hand)
  (let* ((ranks (mapcar #'get-rank (get-cards hand)))
         (rank-values (remove-duplicates (mapcar #'get-rank-value ranks)))
         (sorted-ranks (sort rank-values #'<)))
    (if (= (length sorted-ranks) 5)
        (or (equal (cdr sorted-ranks) (cdr (1- sorted-ranks)))  ; Regular straight
            (and (member 14 sorted-ranks)                    ; Ace-low straight
                 (= (length (remove 14 sorted-ranks)) 4)))
        nil)))

;; Helper function to check for a flush in a hand
(defun flushp (hand)
  (let ((suits (remove-duplicates (mapcar #'get-suit (get-cards hand)))))
    (= (length suits) 1)))

;; Helper function to rank a hand
(defun rank-hand (hand)
  (if (and (straightp hand) (flushp hand))
      "Straight Flush"
      (if (straightp hand)
          "Straight"
          (if (flushp hand)
              "Flush"
              "High Card"))))

;; Example Usage:
(let* ((deck (make-instance 'Deck))
       (player (make-instance 'Player :name "Alice"))
       (cards (deal-cards deck 5)))
  (dolist (card cards)
    (add-to-hand player card))
  (print-player player)
  (format t "Hand Rank: ~a~%" (rank-hand (get-cards (get-hand player)))))
