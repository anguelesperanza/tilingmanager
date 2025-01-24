package main


import "core:fmt"
import win32 "core:sys/windows"
import "core:c/libc"


/*
	Tiling: A Windows Tiling Manager

	Functions used:
	win32.StWindowsHookExW()
		Args:
			idHook: i32, lpfn: HOOKPROC, hmod: HNDLE, dwThreadId:u32
			--------------------------------------------------------


	
*/


hookHandle:win32.HHOOK


exit_callback :: proc "cdecl" (signal:i32) {
	win32.UnhookWindowsHookEx(hookHandle)
	libc.exit(0)
}


main :: proc () {
	fmt.println("Hello World: Tiling")
	wmdll:= win32.LoadLibraryW(raw_data(win32.utf8_to_utf16("wm_dll"))) // load wm_dll
	shellProc:= cast(win32.HOOKPROC)win32.GetProcAddress(wmdll, "ShellProc") // wmdll needs to be hmodule here 
	hookHandle = win32.SetWindowsHookExW(win32.WH_SHELL, shellProc, cast(win32.HANDLE)wmdll, 0) // but needs to be handle here
	// hookHandle = win32.SetWindowsHookExW(win32.WH_SHELL, win32.GetProcAddress(wmdll, "ShellProc"), wmdll, 0)


	libc.signal(libc.SIGINT, exit_callback)
	for {
		
	}
}
