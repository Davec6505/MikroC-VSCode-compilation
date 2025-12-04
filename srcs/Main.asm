_main:
;Main.c,77 :: 		void main(void) {
;Main.c,79 :: 		NVMKEY = 0xAA996655;
LUI	R2, 43673
ORI	R2, R2, 26197
SW	R2, Offset(NVMKEY+0)(GP)
;Main.c,80 :: 		NVMKEY = 0x556699AA;
LUI	R2, 21862
ORI	R2, R2, 39338
SW	R2, Offset(NVMKEY+0)(GP)
;Main.c,81 :: 		NVMBWPCLR = 0x1F1F;
ORI	R2, R0, 7967
SW	R2, Offset(NVMBWPCLR+0)(GP)
;Main.c,83 :: 		Config(); // Configure device and memory allocation.
JAL	_Config+0
NOP	
;Main.c,85 :: 		HID_Enable(HidReadBuff, HidWriteBuff); // Enable USB HID communication.
LUI	R26, hi_addr(_HidWriteBuff+0)
ORI	R26, R26, lo_addr(_HidWriteBuff+0)
LUI	R25, hi_addr(_HidReadBuff+0)
ORI	R25, R25, lo_addr(_HidReadBuff+0)
JAL	_HID_Enable+0
NOP	
;Main.c,88 :: 		if (!EnterBootloaderMode()) { // Should we enter bootloader mode?
JAL	_EnterBootloaderMode+0
NOP	
BEQ	R2, R0, L__main3
NOP	
J	L_main0
NOP	
L__main3:
;Main.c,89 :: 		HID_Disable();              // No, disable USB HID module.
JAL	_HID_Disable+0
NOP	
;Main.c,90 :: 		Delay_10ms();               // Wait a little bit.
JAL	_Delay_10ms+0
NOP	
;Main.c,92 :: 		StartProgram();             // Start already loaded application.
JAL	_StartProgram+0
NOP	
;Main.c,93 :: 		}
J	L_main1
NOP	
L_main0:
;Main.c,95 :: 		StartBootloader();          // Yes, enter bootloader mode.
JAL	_StartBootloader+0
NOP	
L_main1:
;Main.c,96 :: 		}
L_end_main:
L__main_end_loop:
J	L__main_end_loop
NOP	
; end of _main
