(defpackage "COUNT-WORDS"
  (:use "COMMON-LISP")
  (:export "MAIN"))
(in-package "COUNT-WORDS")

;; Find all files with the extension .txt recursively in the
;; subdirectories of the current directory, count the number of times
;; each word appears in them and print the ten most common words and
;; the number of times they are used.

(defun split-words (text)
  (loop
     :for start := (position-if (function alpha-char-p) text :start 0)
     :then (position-if (function alpha-char-p) text :start (or end (length text)))
     :for end := (when start (position-if-not (function alpha-char-p) text :start start))
     :while start
     :collect (com.informatimago.common-lisp.cesarum.utility:nsubseq text start end)))

(defun count-words (files)
  (let ((words (make-hash-table :test 'equalp)))
    (dolist (file files words)
      (dolist (word (split-words
                     (com.informatimago.common-lisp.cesarum.file:text-file-contents file)))
        (incf (gethash word words 0))))))


(defun main (&rest arguments)
  (declare (ignore arguments))
  (terpri)
  (format t "~10:{~40A ~8D~%~}"
          (mapcar (lambda (k) (list (car k) (cdr k)))
                  (sort (com.informatimago.common-lisp.cesarum.utility:hash-table-entries
                         (count-words (directory #P";**;*.txt")))
                        (function >) :key (function cdr))))
  (values))
