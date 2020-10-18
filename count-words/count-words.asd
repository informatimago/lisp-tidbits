(asdf:defsystem "count-words"
  ;; system attributes:
  :description "Count Words"
  :long-description "

Find all files with the extension .txt recursively in the
subdirectories of the current directory, count the number of times
each word appears in them and print the ten most common words and
the number of times they are used.

"
  :author     "Pascal J. Bourguignon <pjb@informatimago.com>"
  :maintainer "Pascal J. Bourguignon <pjb@informatimago.com>"
  :licence "AGPL3"
  ;; component attributes:
  :version "1.0.0"
  :properties ((#:author-email                   . "pjb@informatimago.com")
               (#:date                           . "Autumn 2020")
               ((#:albert #:output-dir)          . "../documentation/count-words/")
               ((#:albert #:formats)             . ("docbook"))
               ((#:albert #:docbook #:template)  . "book")
               ((#:albert #:docbook #:bgcolor)   . "white")
               ((#:albert #:docbook #:textcolor) . "black"))
  :depends-on ()
  :components ((:file "count-words" :depends-on ()))
  #+asdf-unicode :encoding #+asdf-unicode :utf-8)

