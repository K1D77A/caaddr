(in-package #:caaddr)

(defun load-config (&optional (path "./config.lisp"))
  (setf *config* (uiop:read-file-form path :if-does-not-exist :error)))
  
(defun get-env-val (key)
  (let ((val (getf *config* key)))
    (typecase val 
      (function (funcall val))
      (otherwise val))))

(defun configure-global-parameters ()
  (maphash (lambda (symbol plist)
             (declare (ignore symbol))
             (destructuring-bind (&key var env &allow-other-keys)
                 plist
               (when env 
                 (let ((env-val (get-env-val env)))
                   (log:info "Setting ~A to ~A (from key ~A)" var env-val env)
                   (setf (symbol-value var) env-val)))))
           *environment-variables*))

(defun startup ()
  (load-config)
  (configure-global-parameters))


