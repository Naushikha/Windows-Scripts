; Enables shortcuts to shutdown, sleep, hibernate
; https://www.autohotkey.com/boards/viewtopic.php?t=1150

;Hibernate mode with Hotkey - Win + Shift + H
#+h::DllCall("PowrProf\SetSuspendState", "int", 1, "int", 1, "int", 1)

;Sleep mode - Win + Shift + S
#+s::DllCall("PowrProf\SetSuspendState", "int", 0, "int", 1, "int", 1)

;Shutdown mode with Hotkey - Win + Shift + P (P, like PowerDown)
#+p::Shutdown, 5