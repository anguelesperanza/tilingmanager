package main

import win "core:sys/windows"
import "core:c"

foreign import user32 "system:User32.lib"
@(default_calling_convention="system")

foreign user32 {
	TileWindows :: proc(hwndParent:win.HWND, wHow:win.UINT, lpRect:^win.RECT, cKids:win.UINT, lpKids:^win.HWND) -> win.DWORD ---
}

@(export)
shell_proc:: proc "stdcall" (code:c.int, wParam:win.WPARAM, lParam:win.LPARAM) -> win.LRESULT{
	if code == 1 || code == 2 {
		// parameters:
		// hwndParant -> handle for window parant. If nil, then desktop is used as parent window
		// wHow -> How to tile the windowsw (0 is vertical, 1 is horizontal)
		//      -> uses Multiple-document interface (MDI) for the windows
		// const RECT* -> pointer to a struct that specifices the rectangular area to tile the windows
		//      -> if nuil, then the parent area is used for the coords
		// cKids -> number of specific child windows (of the parent window) to arrange
		//      -> ignored if lpKids is null
		// lpKids -> array of child windows (of the parent window) to arrange
		//      -> if nil, all hcild windows of the parent window will be arranged
		TileWindows(nil, 0, nil, 0, nil)
	}

	return win.CallNextHookEx(hhk = nil, nCode = code, wParam = wParam, lParam = lParam)
}
