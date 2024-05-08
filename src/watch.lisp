(in-package #:caaddr)

#||
Code for looking through the watch directories and accumulating video files.
||#


(defclass wft-file ()
  ((last-check
    :accessor last-check
    :initarg :last-check
    :initform nil)
   (completep
    :accessor completep
    :initarg :completep
    :initform nil)
   (extension
    :accessor extension
    :initarg :extension)
   (path
    :accessor path
    :initarg :path)))

(defclass complete-wft-file (wft-file)
  ())

(defmethod print-object ((o wft-file) stream)
  (print-unreadable-object (o stream :type t)
    (with-accessors ((extension extension)
                     (completep completep)
                     (path path)
                     (last-check last-check))
        o
      (format stream "~%Path: ~A~%Extension: ~A~%Completep: ~A~%Last check: ~A"
              path extension completep last-check))))

(defun classify-file (path)
  (make-instance 'wft-file
                 :path path
                 :extension (pathname-type path)))

(defun workable-file-p (wft-file)
  (with-accessors ((extension extension))
      wft-file
    (member extension *video-extensions* :test #'string=)))

(defun workable-files-in-directory (dir)
  (let ((tree ()))
    (labels ((collect (d)
               (let ((files (remove-if-not
                             #'workable-file-p 
                             (mapcar #'classify-file (uiop:directory-files d))))
                     (subdirectories (uiop:subdirectories d)))
                 (push (list :directory d :files files) tree)
                 (dolist (i subdirectories)
                   (collect i)))))
      (collect dir)
      tree)))

(defun wft-directory (wft)
  (getf wft :directory))

(defun wft-files (wft)
  (getf wft :files))

(defun find-wft-directory (dir wft)
  (find dir wft :key #'wft-directory :test #'equal))

(defun files-in-dir (dir wft)
  (wft-files (find-wft-directory dir wft)))

(defun check-wft-file (wft-file)
  (with-accessors ((extension extension)
                   (completep completep)
                   (path path)
                   (last-check last-check))
      wft-file
    (if completep 
        wft-file 
        (if (video-complete-p path)
            (change-class wft-file 'complete-wft-file :completep t)
            (setf (last-check wft-file) (local-time:now))))))
;;might flatten the list actually
(defun check-wft-files (wft-files)
  (mapc #'check-wft-file wft-files))

(defmethod watch-files ((caaddr running-caadr-daemon)))

(defmethod watch-files ((caaddr dry-caaddr-daemon))
  (let ((res
          (mapcan (lambda (plist)            
                    (destructuring-bind (&key in &allow-other-keys)
                        plist
                      (let ((tree (workable-files-in-directory in)))
                        (mapcar (lambda (workable)
                                  (destructuring-bind (&key directory files
                                                       &allow-other-keys)
                                      workable
                                    (log:info "Checking ~D" directory)
                                    (list :directory directory 
                                          :files  (check-wft-files files))))
                                tree))))
                  *watch-dirs*)))
    (setf (directory-tree caaddr) res)))
