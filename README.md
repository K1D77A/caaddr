# caaddr

This is a daemon that will watch directories for new videos files that are downloaded and automatically convert them using FFMPEG.

It will
- Watch directories.
- Check that files are complete.
- Black list certain conversions (e.g Sometimes there is no need to convert x265 to av1)
- Autodetect bitrates to create files of the same bitrate but are smaller.
- Wait X amount of time before removing the originals.
- Use ffmpeg for conversion.
- Use basic templates for ffmpeg flags.
- Have a basic web GUI.
- Persist between restarts.

## License

GPL-3.0

