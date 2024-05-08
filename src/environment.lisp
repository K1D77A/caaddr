(in-package #:caaddr)

(defparameter *environment-variables* (make-hash-table :test #'eq))

(defmacro def-environment-variable (var val &optional doc env-location)
  `(progn (defvar ,var ,val ,doc)
          (setf (gethash ',var *environment-variables*)
                (list :var ',var :val ,val :doc ,doc :env ,env-location))
          (export ',var)))

(def-environment-variable
    *caaddr*
    ()
  "Top level instance of caaddr.")

(def-environment-variable
    *config*
    ()
  "Loaded config as plist.")
  
(def-environment-variable
    *watch-dirs*
    ()
  "Directories to watch"
  :WATCH-DIRS)

(def-environment-variable
    *remove-time*
    ()
  "How long to wait before removing a video after its completed."
  :REMOVE-TIME)

(def-environment-variable
    *check-time*
    ()
  "How long to wait between checking for new videos."
  :CHECK-TIME)




