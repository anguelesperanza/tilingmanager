package main

import win32 "core:sys/windows"
import "core:c"


@(export)
ShellProc :: proc "stdcall" (code:c.int, wParam:win32.WPARAM, lParam:win32.LPARAM) -> win32.LRESULT{
	if code == 1 || code == 2 {
		win32.TileWindows(nil, 1, nil, 0, nil)
	}

	return win32.CallNextHookEx(nil, code, wParam, lParam)
}
// @export
// ShellProc :: proc "stdcall" (code:c.int, wParam:win32.WPARAM, lParam:win32.LPARAM) -> win32.LRESULT{
// 	if code == win32.HSHELL_WINDOWCREATED || code == win32.HSHELL_WINDOWDESTROYED {
// 		win32.TileWindows(nil, win32.MDITILE_VERTICAL, nil, nil, nil)
// 	}

// 	return win32.CallNextHookEx(nil, code, wParam, lParam)
// }

