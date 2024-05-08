;;;; caaddr.asd

(asdf:defsystem #:caaddr
  :description "A Daemon that watches a set directory, initiates automatic conversion of files when they are downloaded and then removes the original after X amount of time."
  :author "K1D77A"
  :license  "GPL-3.0"
  :version "0.0.1"
  :depends-on (#:cl-naive-store
               #:clog
               #:alexandria
               #:local-time
               #:bordeaux-threads
               #:log4cl
               #:str
               #:shasht)
  :serial t
  :pathname "src"
  :components ((:file "package")
               (:file "classes")
               (:file "environment")
               (:file "startup")))
