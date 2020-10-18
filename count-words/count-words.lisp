(defpackage "COUNT-WORDS"
  (:use "COMMON-LISP")
  (:export "MAIN"))
(in-package "COUNT-WORDS")

;; Find all files with the extension .txt recursively in the
;; subdirectories of the current directory, count the number of times
;; each word appears in them and print the ten most common words and
;; the number of times they are used.


(defun main (&rest arguments)
  (declare (ignore arguments))
  (write-line "Hi!")
  (values))
