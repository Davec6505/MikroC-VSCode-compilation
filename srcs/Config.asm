_BootResetVector:
;Config.c,110 :: 		void BootResetVector() {
;Config.c,111 :: 		R30 = BOOTLOADER_START; // Load R30 with bootloader main address.
LUI	R30, 48415
ORI	R30, R30, 16384
;Config.c,113 :: 		JR R30              // Perform indirect jump to bootloader application,
JR	R30
;Config.c,114 :: 		NOP                 // thus changing the kseg as well.
NOP	
;Config.c,116 :: 		}
L_end_BootResetVector:
JR	RA
NOP	
; end of _BootResetVector
_Config:
;Config.c,171 :: 		void Config() {
;Config.c,174 :: 		}
L_end_Config:
JR	RA
NOP	
; end of _Config
