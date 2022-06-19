rem windows update - wuauserv WaaSMedicSvc
rem update ochestrator - UsoSvc
rem backgrund intel transfer - BITS
rem delivery optimization - DoSvc
rem AppX Deployement service - AppXSVC

sc stop "wuauserv"
sc config "wuauserv" start= disabled
sc stop "WaaSMedicSvc"
sc config "WaaSMedicSvc" start= disabled
sc stop "UsoSvc"
sc config "UsoSvc" start= disabled
sc stop "BITS"
sc config "BITS" start= disabled
sc stop "DoSvc"
sc config "DoSvc" start= disabled
sc stop "AppXSVC"
sc config "AppXSVC" start= disabled