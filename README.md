This is an Odin version of the tiling manager created in this video: https://www.youtube.com/watch?v=cuPirXZ6AWo.

This code requires TileWindows access from the win32 api. This is not default in the odin windows code however this file does come with it.
You can find it at the top of wm_dll.odin.

To run this code, just type: odin run . in the terminal, in the source code directory. You have to open a new window in order for the
tilling to take effect, as it's triggered based on new window creation events.
