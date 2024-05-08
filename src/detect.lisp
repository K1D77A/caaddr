(in-package #:caaddr)

#||
Detect information about a video
||#

(defun ffprobe-info (path)
  (shasht:read-json
   (run
    (format nil "ffprobe -v quiet -print_format json -show_format -show_streams '~A'"
            path))))

(defun stream-type-p (type stream)
  (string= (gethash "codec_type" stream) type))

(defun get-video-streams (streams)
  (remove-if-not (lambda (stream)
                   (stream-type-p "video" stream))
                 streams))

(defun get-audio-streams (streams)
  (remove-if-not (lambda (stream)
                   (stream-type-p "audio" stream))
                 streams))
            

(defun video-stream-info (video-stream)
  (let ((height (gethash "height" video-stream))
        (width (gethash "width" video-stream))
        (codec (gethash "codec_name" video-stream))
        (index (gethash "index" video-stream))
        (frame-rate (parse-ratio (gethash "avg_frame_rate" video-stream))))
    (list :stream-index index
          :height height :width width
          :codec codec :frame-rate frame-rate)))

(defun audio-stream-info (audio-stream)
  (list :stream-index (gethash "index" audio-stream)
        :codec (gethash "codec_name" audio-stream)))
                       
(defun disect-information (info)
  (let* ((format (gethash "format" info))
         (streams (gethash "streams" info))
         (bitrate (parse-integer (gethash "bit_rate" format)))
         (size (parse-integer (gethash "size" format)))
         (video-streams (get-video-streams streams))
         (audio-streams (get-audio-streams streams)))
    (list :format format :bitrate bitrate
          :size size
          :video-streams (map 'list #'video-stream-info video-streams)
          :audio-streams (map 'list #'audio-stream-info audio-streams)
          :video-streams-raw video-streams
          :audio-streams-raw audio-streams)))

(defun video-info (key info)
  (destructuring-bind (&key video-streams &allow-other-keys)
      info
    (let ((s (first video-streams)))
      (getf s key))))

(defun audio-info (key info)
  (destructuring-bind (&key audio-streams &allow-other-keys)
      info
    (let ((s (first audio-streams)))
      (getf s key))))

(defun get-video-codec (info)
  (video-info :codec info))

(defun get-video-framerate (info)
  (video-info :frame-rate info))

(defun get-video-height (info)
  (video-info :height info))

(defun get-video-width (info)
  (video-info :width info))

(defun get-audio-codec (info)
  (audio-info :codec info))

(defun detect-information (path)
  (let ((info (ffprobe-info path)))
    (values (disect-information info) info)))


(defun video-complete-p (path)
  (let ((res
          (run
           (format nil "ffprobe -v error -threads ~D -count_frames -i '~A'"
                   *probe-threads* path))))
    (string= res "")))
