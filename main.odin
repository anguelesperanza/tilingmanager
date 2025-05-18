package main

import "core:fmt"
import win "core:sys/windows"
import "core:c/libc"

hook_handle:win.HHOOK



exit_callback :: proc "cdecl" (signal:i32) {
	win.UnhookWindowsHookEx(hhk = hook_handle)
	libc.exit(0)
}


main :: proc() {
	wm_dll:= win.LoadLibraryW(c_str = raw_data(win.utf8_to_utf16(s = "wm_dll"))) // load wm_dll
	shell_proc := cast(win.HOOKPROC)win.GetProcAddress(h = wm_dll, c_str = "shell_proc")
	hook_handle := win.SetWindowsHookExW(idHook = win.WH_SHELL,lpfn = shell_proc,hmod = cast(win.HANDLE)wm_dll,dwThreadId = 0)


	// wmdll:= win32.LoadLibraryW(raw_data(win32.utf8_to_utf16("wm_dll"))) // load wm_dll
	// shellProc:= cast(win32.HOOKPROC)win32.GetProcAddress(wmdll, "ShellProc") // wmdll needs to be hmodule here 
	// hookHandle = win32.SetWindowsHookExW(win32.WH_SHELL, shellProc, cast(win32.HANDLE)wmdll, 0) // but needs to be handle here

	fmt.println("\nTiling as Started. Press CTRL + C on this window to stop it")
	libc.signal(libc.SIGINT, exit_callback)
	for {
		
	}
	
}
