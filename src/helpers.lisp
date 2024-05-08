(in-package #:caaddr)

(defun run (command)
  (uiop:run-program command :output :string))

(defun parse-ratio (string)
  (destructuring-bind (num den)
      (str:split #\/ string :omit-nulls t)
    (/ (decimals:parse-decimal-number num)
       (decimals:parse-decimal-number den))))
