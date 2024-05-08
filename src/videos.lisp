(in-package #:caaddr)

(defun new-video (path)
  (unless (uiop:file-exists-p path)
    (error "No such video"))
  (multiple-value-bind (info raw-info)
      (detect-information path)
    (destructuring-bind (&key video-streams bitrate size audio-streams &allow-other-keys)
        info 
      (make-instance 'video
                     :path (uiop:truename* path)
                     :bitrate bitrate                     
                     :audio-streams audio-streams
                     :video-streams video-streams
                     :height (get-video-height info)
                     :frame-rate (get-video-framerate info)
                     :raw-info raw-info
                     :discover-time (local-time:now)
                     :size size
                     :width (get-video-width info)
                     :video-codec (get-video-codec info)
                     :audio-codec (get-audio-codec info)))))
                                                        
