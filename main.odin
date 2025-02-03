package main


import "base:runtime"
import "core:fmt"
import win32 "core:sys/windows"
import "core:c/libc"


/*
	Tiling: A Windows Tiling Manager
		This is mean to be a minimul (small featured) tiling manager
		Just enough customizaton to get the job done but not much more beyond that
		reason being: Want this to be on windows and linux so less features, easier to code on other OS'

		Supported Systems
		[WIP] Windows
		[] LInux
			[] x11
			[] wayland
		

	Features:
		[x] Auto Tiling
		[] Equal Window sizes
			- Splits Evenly based on window amount
		[] Keyboard Shortcutes to navigation the program
		

	==============================================================================================================
	Code was based off of this video: https://www.youtube.com/watch?v=cuPirXZ6AWo
		as of 1/23/2024
		Depending on how far along this project is; this code may include more than what's in the video.
		There is a github repo for the code (in the video desc) but this code is not based off of that, only the video
	
*/

counter:= 0

hookHandle:win32.HHOOK

exit_callback :: proc "cdecl" (signal:i32) {
	win32.UnhookWindowsHookEx(hookHandle)
	libc.exit(0)
}


Window_Enum_Proc :: proc "system" (window_handle:win32.HWND, window_enum_param:win32.LPARAM) -> win32.BOOL {
	context = runtime.default_context()
	fmt.println("============")

	window_text:win32.LPWSTR
	// window_text:^u16
	window_text_max_count:win32.INT = 1024



	window_result := win32.GetWindowTextW(window_handle, window_text, window_text_max_count)

	fmt.println(window_result)

	// result_window_text, _ := win32.wstring_to_utf8(window_text, -1, context.allocator)
	// fmt.println(window_text)



	if window_result == 0 {
		// Current error code returned is 87: invalid parameter

		error := win32.GetLastError()
		
		fmt.printf("Error: %v\n", error)
	}

	// result:= win32.TRUE
	// fmt.println(counter)
	// counter += 1
	return win32.BOOL(true)
}
	
main :: proc () {

	fmt.println("Hello World")


	desktop_rectangle:win32.RECT
	desktop_handle:win32.HWND = win32.GetDesktopWindow() // Get Desktop Handle


	win32.GetWindowRect(desktop_handle, &desktop_rectangle)	

	fmt.println(desktop_rectangle)
	// fmt.println(desktop_rectangle.right / 2)	
	// fmt.println(desktop_rectangle.bottom)



	windows_enum_param:win32.LPARAM
	win32.EnumWindows(Window_Enum_Proc, windows_enum_param)
	

	// Main Window Tiling functionality. Commented out for testing with desktop stuff. Uncomment once testing is done
	// wmdll:= win32.LoadLibraryW(raw_data(win32.utf8_to_utf16("wm_dll"))) // load wm_dll
	// shellProc:= cast(win32.HOOKPROC)win32.GetProcAddress(wmdll, "ShellProc") // wmdll needs to be hmodule here 
	// hookHandle = win32.SetWindowsHookExW(win32.WH_SHELL, shellProc, cast(win32.HANDLE)wmdll, 0) // but needs to be handle here

	fmt.println("Tiling as Started. Press CTRL + C on this window to stop it")
	libc.signal(libc.SIGINT, exit_callback)
	for {
		
	}
}
