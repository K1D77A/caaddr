(in-package #:caaddr)

(defclass caaddr-daemon ()
  ((last-check
    :accessor last-check
    :initarg :last-check
    :initform (local-time:now)
    :type local-time:timestamp)
   (directory-tree
    :accessor directory-tree
    :initarg :directory-tree
    :initform ())))

(defclass dry-caaddr-daemon (caadr-daemon)
  ())

(defclass running-caadr-daemon (caadr-daemon)
  ())

(defclass video ()
  ((size
    :accessor size
    :initarg :size)
   (final-size
    :accessor final-size
    :type float)
   (raw-info
    :accessor raw-info
    :initarg :raw-info
    :type hash-table)
   (path
    :accessor path
    :initarg :path
    :type pathname)
   (bitrate
    :accessor bitrate
    :initarg :bitrate)
   (audio-streams
    :accessor audio-streams
    :initarg :audio-streams)
   (video-streams
    :accessor video-streams
    :initarg :video-streams)   
   (video-codec
    :accessor video-codec 
    :initarg :video-codec)
   (audio-codec
    :accessor audio-codec
    :initarg :audio-codec)
   (height 
    :accessor height
    :initarg :height)
   (width 
    :accessor width
    :initarg :width)
   (discover-time
    :accessor discover-time
    :initarg :discover-time
    :type local-time:timestamp)
   (frame-rate
    :accessor frame-rate
    :initarg :frame-rate)))

(defclass conversion ()
  ((conversion-process
    :accessor conversion-process
    :initarg :conversion-process
    :type bt:thread)))

(defclass encoder ()
  ())


