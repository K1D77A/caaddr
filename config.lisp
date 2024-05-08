(
 :WATCH-DIRS ((:in "./test-videos/test-watch/" :out "./test-videos./test-output/"))
 :REMOVE-TIME (3 . :days)
 :CHECK-TIME (1 . :hours)
 :video-extensions ("mp4" "avi" "mkv" "mov")
 :FFPROBE-THREADS 8
)
