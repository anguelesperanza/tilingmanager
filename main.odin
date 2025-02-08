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



	--------------------------------------------------------------------------------------------------------------
	Imporoving tiling manager

	Win32 API that seems interesting to use:

	user32.odin ->
		SetActiveWindow, GetActiveWindow, ShowWindow, isWindow, isWindowVisible, RedrawWindow, GetDesktopWindow	
	
	--------------------------------------------------------------------------------------------------------------
	win32.LPARAM -> Is an int datatype
	win32.wstring -> Is [^]u16

	
*/


WindowInfo :: struct {
	hwnd:win32.HWND,
	window_name:string,
}

WindowZone :: struct {
	handle:win32.HWND,
	x:win32.INT,
	y:win32.INT,
	width:win32.INT,
	height:win32.INT,
	repaint:win32.BOOL,
}



windows:[dynamic]WindowInfo
window_zones:[dynamic]WindowZone
window_handles:[dynamic]win32.HWND

counter:= 0

hookHandle:win32.HHOOK

exit_callback :: proc "cdecl" (signal:i32) {
	win32.UnhookWindowsHookEx(hookHandle)
	libc.exit(0)
}


// The application defined callback function for win32.EnumWindows
// Odin docs have this as "stdcall" calling convention
// -> Takes paramenter types win32.HWND, int)
// window_handle is win32.HWND, 
Window_Enum_Proc :: proc "stdcall" (window_handle:win32.HWND, window_enum_param:win32.LPARAM) -> win32.BOOL {
	context = runtime.default_context()
	length := win32.GetWindowTextLengthW(window_handle)
	if length > 0 && win32.IsWindowVisible(window_handle) {
		buffer := make([]win32.WCHAR, length)
		defer delete(buffer)
		result:win32.wstring = &buffer[0]
		win32.GetWindowTextW(window_handle, result, length + 1)
		name, _ := win32.wstring_to_utf8(result, int(length + 1))
		
		window_info:WindowInfo = {window_handle, name}
		append(&windows, window_info)
		append(&window_handles, window_handle)
				
	}
	return win32.TRUE
}


get_window_zones :: proc (amount_of_windows:int, padding:int = 5) {
	desktop_rectangle:win32.RECT
	desktop_handle:win32.HWND = win32.GetDesktopWindow() // Get Desktop Handle

	win32.GetWindowRect(desktop_handle, &desktop_rectangle)
	current_x := desktop_rectangle.left
	current_y := desktop_rectangle.top
	current_width := desktop_rectangle.right / 2
	current_height := desktop_rectangle.bottom

	current_location:string = "top"

	// starts at 1 and not 0 as improper amount of zone
	// will be made if starts at 0
	for i in 1..=amount_of_windows {
		// fmt.println(i)

		
	// WindowZone :: struct {
	//  handle:win32.HWND
	// 	x:win32.INT,
	// 	y:win32.INT,
	// 	width:win32.INT,
	// 	height:win32.INT,
	// 	repaint:win32.BOOL,
	// }
		window_zone:WindowZone = {
			handle = window_handles[i],
			x = current_x,
			y = current_y,
			width = current_width,
			height = current_height,
			repaint = win32.FALSE,
		}
		append(&window_zones, window_zone)
		
		if i > 2 && amount_of_windows % i == 0{
			current_width = current_width / 2
		}
		if i > 2 && amount_of_windows % i != 0{
			current_height = current_height / 2
				
		}
		if amount_of_windows % i == 0 {
			current_x = current_width
		}
		if amount_of_windows % i != 0 {
			current_y = current_height / 2
			window_zones[i-1].height = window_zones[i-1].height / 2
		}


	}
}	
main :: proc () {

	// need to clear/delete dynamic arrays -- have not done that yet
	

	// desktop_rectangle:win32.RECT
	// desktop_handle:win32.HWND = win32.GetDesktopWindow() // Get Desktop Handle


	// win32.GetWindowRect(desktop_handle, &desktop_rectangle)	

	// fmt.println(desktop_rectangle)
	// fmt.println(desktop_rectangle.right / 2)	
	// fmt.println(desktop_rectangle.bottom)


	// WindowZone :: struct {
	//  handle:win32.HWND
	// 	x:win32.INT,
	// 	y:win32.INT,
	// 	width:win32.INT,
	// 	height:win32.INT,
	// 	repaint:win32.BOOL,
	// }

	// windows_enum_param:win32.LPARAM
	win32.EnumWindows(Window_Enum_Proc, 0)
	get_window_zones(amount_of_windows = 7 , padding = 0 )

	
	for zone in window_zones {
		fmt.println(zone)
		win32.MoveWindow(zone.handle, zone.x, zone.y, zone.width, zone.height, zone.repaint)
	}


	
	
	// for window in windows {
	// 	fmt.println(window.window_name)
	// }

	
	// OLD CODE: KEPT IN FOR THE TIME BEING
	// Main Window Tiling functionality. Commented out for testing with desktop stuff. Uncomment once testing is done
	// wmdll:= win32.LoadLibraryW(raw_data(win32.utf8_to_utf16("wm_dll"))) // load wm_dll
	// shellProc:= cast(win32.HOOKPROC)win32.GetProcAddress(wmdll, "ShellProc") // wmdll needs to be hmodule here 
	// hookHandle = win32.SetWindowsHookExW(win32.WH_SHELL, shellProc, cast(win32.HANDLE)wmdll, 0) // but needs to be handle here

	fmt.println("Tiling as Started. Press CTRL + C on this window to stop it")
	libc.signal(libc.SIGINT, exit_callback)
	for {
		
	}
}
