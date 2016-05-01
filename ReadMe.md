Installation

Just run the exe.  The project doesn't use any non standard libraries and so should just compile and run.

Contained in the \release link is the binary x64 .exe.

Usage

The programme operates from the system tray with an hourglass icon.

The easiest way to describe the application is with my usage case.  
I have delphi/lazarus open on monitor 1 and a twitch or other stream open on monitor 2.   Moving between
delphi and chrome results in my constantly typing code into twitch chat and snark into my source-code.  
This programme works similarly to the optional window's behaviour of keeping window focus beneath the mouse
except that the focus is only changed to the new window when the mouse has moved to a different monitor.
Because of this I can now switfly and reliably move between my main programmes on each monitor and 
begin typing without focus errors. 

Issues.

Because the software uses GetWindowFromPoint it is best used when frequently switching between maximised
applications. 
