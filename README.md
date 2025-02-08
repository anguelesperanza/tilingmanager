If you're seeing this on Github; please know this is a backup of the main repository you can find on codeberg
https://codeberg.org/anguelesperanza/tilingmanager

Update as of 2/7/2025 (febuary 7th, 2025)

This tiling manager is currenlty being imporoved with custom logic and tiling zones
The old tiling is still included for the time being. The plan is to leave it in for the time being
until I can document how to write the tool using the old logic. Or move it to it's own repo.

For now, the new logic is incomplete and will take. This is ultimatly a learning project so it will be updated at a slower pace

==============================================================================================================
This is an Odin version of the tiling manager created in this video: https://www.youtube.com/watch?v=cuPirXZ6AWo.

This code requires TileWindows access from the win32 api. This is not default in the odin packages. I recommend adding the following line inside the forieng inmport for core:sys/windows/user32.odin

// START OF ADDED FUNCTION

TileWindows :: proc(hwndParent:HWND, wHow:UINT, lpRect:^RECT, cKids:UINT, lpKids:^HWND) -> DWORD ---

// END OF ADDED FUNCTIONS
