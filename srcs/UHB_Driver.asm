UHB_Driver__Buffer_SaveToFlash:
;UHB_Driver.c,155 :: 		static void _Buffer_SaveToFlash() {
ADDIU	SP, SP, -12
SW	RA, 0(SP)
;UHB_Driver.c,158 :: 		bCount = Buffer_Count();                        // Get number of bytes in buffer.
SW	R25, 4(SP)
SW	R26, 8(SP)
LW	R3, Offset(_Buffer+16384)(GP)
LUI	R2, hi_addr(_Buffer+0)
ORI	R2, R2, lo_addr(_Buffer+0)
SUBU	R2, R3, R2
; bCount start address is: 12 (R3)
MOVZ	R3, R2, R0
;UHB_Driver.c,159 :: 		Buffer.fRWPtr = Buffer.fBuffer;                 // Reset buffer pointer.
LUI	R2, hi_addr(_Buffer+0)
ORI	R2, R2, lo_addr(_Buffer+0)
SW	R2, Offset(_Buffer+16384)(GP)
; bCount end address is: 12 (R3)
SEH	R5, R3
;UHB_Driver.c,160 :: 		while (bCount > 0) {
L_UHB_Driver__Buffer_SaveToFlash0:
; bCount start address is: 20 (R5)
SEH	R2, R5
SLTI	R2, R2, 1
BEQ	R2, R0, L_UHB_Driver__Buffer_SaveToFlash55
NOP	
J	L_UHB_Driver__Buffer_SaveToFlash1
NOP	
L_UHB_Driver__Buffer_SaveToFlash55:
;UHB_Driver.c,161 :: 		FLASH_Write(StartAddress, Buffer.fRWPtr);     // Write chunk (flash write latch size) of buffer data.
LW	R26, Offset(_Buffer+16384)(GP)
LW	R25, Offset(_GPAddress+0)(GP)
JAL	_Flash_Write_Row+0
NOP	
;UHB_Driver.c,162 :: 		bCount -= _FLASH_WRITE_LATCH;                 // Decrement bytes count.
ADDIU	R2, R5, -2048
ANDI	R5, R2, 65535
;UHB_Driver.c,163 :: 		Buffer.fRWPtr += _FLASH_WRITE_LATCH;          // Increment buffer pointer.
LW	R2, Offset(_Buffer+16384)(GP)
ADDIU	R2, R2, 2048
SW	R2, Offset(_Buffer+16384)(GP)
;UHB_Driver.c,167 :: 		StartAddress += _FLASH_WRITE_LATCH;           // Increment flash address.
LW	R2, Offset(_GPAddress+0)(GP)
ADDIU	R2, R2, 2048
SW	R2, Offset(_GPAddress+0)(GP)
;UHB_Driver.c,169 :: 		}
; bCount end address is: 20 (R5)
J	L_UHB_Driver__Buffer_SaveToFlash0
NOP	
L_UHB_Driver__Buffer_SaveToFlash1:
;UHB_Driver.c,170 :: 		}
L_end__Buffer_SaveToFlash:
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 12
JR	RA
NOP	
; end of UHB_Driver__Buffer_SaveToFlash
UHB_Driver_SendBootInfo:
;UHB_Driver.c,194 :: 		static void SendBootInfo() {
ADDIU	SP, SP, -12
SW	RA, 0(SP)
;UHB_Driver.c,201 :: 		*(TBootInfoArray *)(void *)HidWriteBuff = BootInfo; // Copy boot info record into transmit buffer.
SW	R25, 4(SP)
SW	R26, 8(SP)
ORI	R4, R0, 56
ADDIU	R3, GP, Offset(_HidWriteBuff+0)
LUI	R2, hi_addr(_BootInfo+0)
ORI	R2, R2, lo_addr(_BootInfo+0)
L_UHB_Driver_SendBootInfo2:
LBU	R30, 0(R2)
SB	R30, 0(R3)
ADDIU	R4, R4, -1
ADDIU	R2, R2, 1
ADDIU	R3, R3, 1
BEQ	R4, R0, L_UHB_Driver_SendBootInfo57
NOP	
J	L_UHB_Driver_SendBootInfo2
NOP	
L_UHB_Driver_SendBootInfo57:
;UHB_Driver.c,202 :: 		HID_Write(HidWriteBuff, 64);                        // Send boot info.
ORI	R26, R0, 64
LUI	R25, hi_addr(_HidWriteBuff+0)
ORI	R25, R25, lo_addr(_HidWriteBuff+0)
JAL	_HID_Write+0
NOP	
;UHB_Driver.c,203 :: 		}
L_end_SendBootInfo:
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 12
JR	RA
NOP	
; end of UHB_Driver_SendBootInfo
UHB_Driver_Check4Cmd:
;UHB_Driver.c,227 :: 		static void Check4Cmd() {
;UHB_Driver.c,228 :: 		if (CmdCode == cmdNON) {               // Are we in 'Idle' mode?
LBU	R2, Offset(_CmdCode+0)(GP)
BEQ	R2, R0, L_UHB_Driver_Check4Cmd59
NOP	
J	L_UHB_Driver_Check4Cmd3
NOP	
L_UHB_Driver_Check4Cmd59:
;UHB_Driver.c,230 :: 		if (HidReadBuff[0] != STX)           // Do we have an 'STX' at start?
LBU	R3, Offset(_HidReadBuff+0)(GP)
ORI	R2, R0, 15
BNE	R3, R2, L_UHB_Driver_Check4Cmd61
NOP	
J	L_UHB_Driver_Check4Cmd4
NOP	
L_UHB_Driver_Check4Cmd61:
;UHB_Driver.c,232 :: 		return ;                           // No, then exit.
J	L_end_Check4Cmd
NOP	
L_UHB_Driver_Check4Cmd4:
;UHB_Driver.c,235 :: 		CmdCode = HidReadBuff[1];            // Get command code.
LBU	R2, Offset(_HidReadBuff+1)(GP)
SB	R2, Offset(_CmdCode+0)(GP)
;UHB_Driver.c,236 :: 		Lo(GPAddress) = HidReadBuff[2];      // Get address lo byte.
LBU	R2, Offset(_HidReadBuff+2)(GP)
SB	R2, Offset(_GPAddress+0)(GP)
;UHB_Driver.c,237 :: 		Hi(GPAddress) = HidReadBuff[3];      // Get address hi byte.
LBU	R2, Offset(_HidReadBuff+3)(GP)
SB	R2, Offset(_GPAddress+1)(GP)
;UHB_Driver.c,238 :: 		Higher(GPAddress) = HidReadBuff[4];  // Get address higher byte.
LBU	R2, Offset(_HidReadBuff+4)(GP)
SB	R2, Offset(_GPAddress+2)(GP)
;UHB_Driver.c,239 :: 		Highest(GPAddress) = HidReadBuff[5]; // Get address highest byte.
LBU	R2, Offset(_HidReadBuff+5)(GP)
SB	R2, Offset(_GPAddress+3)(GP)
;UHB_Driver.c,240 :: 		Lo(GPCounter) = HidReadBuff[6];      // Get counter lo byte.
LBU	R2, Offset(_HidReadBuff+6)(GP)
SB	R2, Offset(_GPCounter+0)(GP)
;UHB_Driver.c,241 :: 		Hi(GPCounter) = HidReadBuff[7];      // Get counter hi byte.
LBU	R2, Offset(_HidReadBuff+7)(GP)
SB	R2, Offset(_GPCounter+1)(GP)
;UHB_Driver.c,242 :: 		}
J	L_UHB_Driver_Check4Cmd5
NOP	
L_UHB_Driver_Check4Cmd3:
;UHB_Driver.c,245 :: 		}
L_UHB_Driver_Check4Cmd5:
;UHB_Driver.c,246 :: 		}
L_end_Check4Cmd:
JR	RA
NOP	
; end of UHB_Driver_Check4Cmd
UHB_Driver_GetData:
;UHB_Driver.c,275 :: 		static char GetData() {
;UHB_Driver.c,280 :: 		sPtr = HidReadBuff;                    // Set local pointer to HID read buffer.
; sPtr start address is: 20 (R5)
LUI	R5, hi_addr(_HidReadBuff+0)
ORI	R5, R5, lo_addr(_HidReadBuff+0)
;UHB_Driver.c,281 :: 		i = 0;                                 // Clear HID read buffer byte counter.
; i start address is: 16 (R4)
MOVZ	R4, R0, R0
; sPtr end address is: 20 (R5)
; i end address is: 16 (R4)
;UHB_Driver.c,282 :: 		while (1) {
L_UHB_Driver_GetData6:
;UHB_Driver.c,283 :: 		if (!BytesToGet)                     // Did we get it all?
; i start address is: 16 (R4)
; sPtr start address is: 20 (R5)
LH	R2, Offset(_GPCounter+0)(GP)
BEQ	R2, R0, L_UHB_Driver_GetData63
NOP	
J	L_UHB_Driver_GetData8
NOP	
L_UHB_Driver_GetData63:
; sPtr end address is: 20 (R5)
; i end address is: 16 (R4)
;UHB_Driver.c,284 :: 		return 1;                          //   Yes, return with all done.
ORI	R2, R0, 1
J	L_end_GetData
NOP	
L_UHB_Driver_GetData8:
;UHB_Driver.c,285 :: 		if (Buffer_Count() == Buffer_Size()) // Is data buffer full?
; i start address is: 16 (R4)
; sPtr start address is: 20 (R5)
LW	R3, Offset(_Buffer+16384)(GP)
LUI	R2, hi_addr(_Buffer+0)
ORI	R2, R2, lo_addr(_Buffer+0)
SUBU	R3, R3, R2
ORI	R2, R0, 16384
BEQ	R3, R2, L_UHB_Driver_GetData64
NOP	
J	L_UHB_Driver_GetData9
NOP	
L_UHB_Driver_GetData64:
; sPtr end address is: 20 (R5)
; i end address is: 16 (R4)
;UHB_Driver.c,286 :: 		return 1;                          //   Yes, return with buffer full.
ORI	R2, R0, 1
J	L_end_GetData
NOP	
L_UHB_Driver_GetData9:
;UHB_Driver.c,287 :: 		if (i == sizeof(HidReadBuff))        // End of received packet?
; i start address is: 16 (R4)
; sPtr start address is: 20 (R5)
ANDI	R3, R4, 255
ORI	R2, R0, 64
BEQ	R3, R2, L_UHB_Driver_GetData65
NOP	
J	L_UHB_Driver_GetData10
NOP	
L_UHB_Driver_GetData65:
; sPtr end address is: 20 (R5)
; i end address is: 16 (R4)
;UHB_Driver.c,288 :: 		return 0;                          //   Yes, return with more to get.
MOVZ	R2, R0, R0
J	L_end_GetData
NOP	
L_UHB_Driver_GetData10:
;UHB_Driver.c,289 :: 		Buffer_WriteByte(*sPtr++);           // Copy to buffer.
; i start address is: 16 (R4)
; sPtr start address is: 20 (R5)
LBU	R3, 0(R5)
LW	R2, Offset(_Buffer+16384)(GP)
SB	R3, 0(R2)
LW	R2, Offset(_Buffer+16384)(GP)
ADDIU	R2, R2, 1
SW	R2, Offset(_Buffer+16384)(GP)
ADDIU	R2, R5, 1
MOVZ	R5, R2, R0
;UHB_Driver.c,290 :: 		BytesToGet--;                        // Decrement data buffer counter.
LH	R2, Offset(_GPCounter+0)(GP)
ADDIU	R2, R2, -1
SH	R2, Offset(_GPCounter+0)(GP)
;UHB_Driver.c,291 :: 		i++;                                 // Increment HID read buffer byte counter
ADDIU	R2, R4, 1
ANDI	R4, R2, 255
;UHB_Driver.c,292 :: 		}
; sPtr end address is: 20 (R5)
; i end address is: 16 (R4)
J	L_UHB_Driver_GetData6
NOP	
;UHB_Driver.c,294 :: 		}
L_end_GetData:
JR	RA
NOP	
; end of UHB_Driver_GetData
UHB_Driver_SendACK:
;UHB_Driver.c,317 :: 		static void SendACK(enum TCmd cmd) {
ADDIU	SP, SP, -12
SW	RA, 0(SP)
;UHB_Driver.c,319 :: 		HidWriteBuff[0] = STX;       // Start of packet indetifier.
SW	R25, 4(SP)
SW	R26, 8(SP)
ORI	R2, R0, 15
SB	R2, Offset(_HidWriteBuff+0)(GP)
;UHB_Driver.c,320 :: 		HidWriteBuff[1] = cmd;       // Command code to acknowledge.
SB	R25, Offset(_HidWriteBuff+1)(GP)
;UHB_Driver.c,321 :: 		HID_Write(HidWriteBuff, 64); // Send acknowledgement packet.
ORI	R26, R0, 64
LUI	R25, hi_addr(_HidWriteBuff+0)
ORI	R25, R25, lo_addr(_HidWriteBuff+0)
JAL	_HID_Write+0
NOP	
;UHB_Driver.c,322 :: 		}
L_end_SendACK:
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 12
JR	RA
NOP	
; end of UHB_Driver_SendACK
_StartBootloader:
;UHB_Driver.c,345 :: 		void StartBootloader() {
ADDIU	SP, SP, -12
SW	RA, 0(SP)
;UHB_Driver.c,347 :: 		char writeData = 0;    // Write command execution flag.
SW	R25, 4(SP)
MOVZ	R30, R0, R0
SB	R30, 8(SP)
;UHB_Driver.c,349 :: 		Buffer_Reset();        // Reset data buffer.
LUI	R2, hi_addr(_Buffer+0)
ORI	R2, R2, lo_addr(_Buffer+0)
SW	R2, Offset(_Buffer+16384)(GP)
;UHB_Driver.c,352 :: 		while(1) {
L_StartBootloader11:
;UHB_Driver.c,353 :: 		USB_Polling_Proc();  // Check USB.
JAL	_USB_Polling_Proc+0
NOP	
;UHB_Driver.c,354 :: 		dataRx = HID_Read(); // Read received USB packet, if any.
JAL	_HID_Read+0
NOP	
;UHB_Driver.c,355 :: 		if (dataRx) {        // Do we have an incoming?
BNE	R2, R0, L__StartBootloader69
NOP	
J	L_StartBootloader13
NOP	
L__StartBootloader69:
;UHB_Driver.c,357 :: 		Check4Cmd();       // Check received packet for new command.
JAL	UHB_Driver_Check4Cmd+0
NOP	
;UHB_Driver.c,358 :: 		switch(CmdCode) {  // Process command.
J	L_StartBootloader14
NOP	
;UHB_Driver.c,359 :: 		case cmdWRITE: { // Cmd: Write data to flash.
L_StartBootloader16:
;UHB_Driver.c,360 :: 		if (writeData) {   // Are we already executing an write command?
LBU	R2, 8(SP)
BNE	R2, R0, L__StartBootloader71
NOP	
J	L_StartBootloader17
NOP	
L__StartBootloader71:
;UHB_Driver.c,361 :: 		if (GetData()) { // Yes, then do we have some data to write?
JAL	UHB_Driver_GetData+0
NOP	
BNE	R2, R0, L__StartBootloader73
NOP	
J	L_StartBootloader18
NOP	
L__StartBootloader73:
;UHB_Driver.c,365 :: 		(StartAddress <  MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY))) // Are we out of bootloader area?
LW	R3, Offset(_GPAddress+0)(GP)
LUI	R2, _BOOTLOADER_START_PHY+2
ORI	R2, R2, _BOOTLOADER_START_PHY
SLTU	R2, R3, R2
BEQ	R2, R0, L__StartBootloader74
NOP	
J	L__StartBootloader50
NOP	
L__StartBootloader74:
LW	R3, Offset(_GPAddress+0)(GP)
LUI	R2, _MCU_BOOT_FLASH_START_PHY+2
ORI	R2, R2, _MCU_BOOT_FLASH_START_PHY
SLTU	R2, R3, R2
BEQ	R2, R0, L__StartBootloader75
NOP	
J	L__StartBootloader49
NOP	
L__StartBootloader75:
LW	R3, Offset(_GPAddress+0)(GP)
LUI	R2, _MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY+2
ORI	R2, R2, _MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY
SLTU	R2, R3, R2
BNE	R2, R0, L__StartBootloader76
NOP	
J	L__StartBootloader48
NOP	
L__StartBootloader76:
J	L__StartBootloader46
NOP	
L__StartBootloader49:
L__StartBootloader48:
J	L_StartBootloader23
NOP	
L__StartBootloader46:
L__StartBootloader50:
;UHB_Driver.c,369 :: 		Buffer_SaveToFlash();
JAL	UHB_Driver__Buffer_SaveToFlash+0
NOP	
L_StartBootloader23:
;UHB_Driver.c,371 :: 		SendACK(CmdCode);                    // Acknowledge data write and ask for more if any.
LBU	R25, Offset(_CmdCode+0)(GP)
JAL	UHB_Driver_SendACK+0
NOP	
;UHB_Driver.c,372 :: 		Buffer_Reset();                      // Reset data buffer.
LUI	R2, hi_addr(_Buffer+0)
ORI	R2, R2, lo_addr(_Buffer+0)
SW	R2, Offset(_Buffer+16384)(GP)
;UHB_Driver.c,373 :: 		if (BytesToWrite == 0) {             // Are there more data to write?
LH	R2, Offset(_GPCounter+0)(GP)
BEQ	R2, R0, L__StartBootloader77
NOP	
J	L_StartBootloader24
NOP	
L__StartBootloader77:
;UHB_Driver.c,374 :: 		writeData = 0;                     //   No, reset executing write command flag.
SB	R0, 8(SP)
;UHB_Driver.c,375 :: 		CmdCode = cmdNON;                  //   Set 'Idle' command code.
SB	R0, Offset(_CmdCode+0)(GP)
;UHB_Driver.c,376 :: 		}
L_StartBootloader24:
;UHB_Driver.c,377 :: 		}
L_StartBootloader18:
;UHB_Driver.c,378 :: 		}
J	L_StartBootloader25
NOP	
L_StartBootloader17:
;UHB_Driver.c,380 :: 		writeData = 1; // Set executing write command flag.
ORI	R2, R0, 1
SB	R2, 8(SP)
;UHB_Driver.c,381 :: 		}
L_StartBootloader25:
;UHB_Driver.c,382 :: 		break;
J	L_StartBootloader15
NOP	
;UHB_Driver.c,384 :: 		case cmdERASE: { // Cmd: Erase flash.
L_StartBootloader26:
;UHB_Driver.c,385 :: 		while (BlocksToErase--) {                   // More to erase?
L_StartBootloader27:
LH	R3, Offset(_GPCounter+0)(GP)
LH	R2, Offset(_GPCounter+0)(GP)
ADDIU	R2, R2, -1
SH	R2, Offset(_GPCounter+0)(GP)
BNE	R3, R0, L__StartBootloader79
NOP	
J	L_StartBootloader28
NOP	
L__StartBootloader79:
;UHB_Driver.c,389 :: 		(StartAddress <  MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY))) // Are we out of bootloader area?
LW	R3, Offset(_GPAddress+0)(GP)
LUI	R2, _BOOTLOADER_START_PHY+2
ORI	R2, R2, _BOOTLOADER_START_PHY
SLTU	R2, R3, R2
BEQ	R2, R0, L__StartBootloader80
NOP	
J	L__StartBootloader53
NOP	
L__StartBootloader80:
LW	R3, Offset(_GPAddress+0)(GP)
LUI	R2, _MCU_BOOT_FLASH_START_PHY+2
ORI	R2, R2, _MCU_BOOT_FLASH_START_PHY
SLTU	R2, R3, R2
BEQ	R2, R0, L__StartBootloader81
NOP	
J	L__StartBootloader52
NOP	
L__StartBootloader81:
LW	R3, Offset(_GPAddress+0)(GP)
LUI	R2, _MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY+2
ORI	R2, R2, _MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY
SLTU	R2, R3, R2
BNE	R2, R0, L__StartBootloader82
NOP	
J	L__StartBootloader51
NOP	
L__StartBootloader82:
J	L__StartBootloader44
NOP	
L__StartBootloader52:
L__StartBootloader51:
J	L_StartBootloader33
NOP	
L__StartBootloader44:
L__StartBootloader53:
;UHB_Driver.c,393 :: 		FLASH_Erase(StartAddress);              //   Yes, erase flash block.
LW	R25, Offset(_GPAddress+0)(GP)
JAL	_Flash_Erase_Page+0
NOP	
L_StartBootloader33:
;UHB_Driver.c,397 :: 		StartAddress -= _FLASH_ERASE;           //   Increment flash address.
LW	R2, Offset(_GPAddress+0)(GP)
ADDIU	R2, R2, -16384
SW	R2, Offset(_GPAddress+0)(GP)
;UHB_Driver.c,399 :: 		}
J	L_StartBootloader27
NOP	
L_StartBootloader28:
;UHB_Driver.c,400 :: 		SendACK(CmdCode);                           // Acknowledge flash erase command.
LBU	R25, Offset(_CmdCode+0)(GP)
JAL	UHB_Driver_SendACK+0
NOP	
;UHB_Driver.c,401 :: 		CmdCode = cmdNON;                           // Set 'Idle' command code.
SB	R0, Offset(_CmdCode+0)(GP)
;UHB_Driver.c,402 :: 		break;
J	L_StartBootloader15
NOP	
;UHB_Driver.c,404 :: 		case cmdSYNC: { // Cmd: Synchronize bootloader and PC app.
L_StartBootloader34:
;UHB_Driver.c,405 :: 		SendACK(CmdCode); // Acknowledge SYNC command.
LBU	R25, Offset(_CmdCode+0)(GP)
JAL	UHB_Driver_SendACK+0
NOP	
;UHB_Driver.c,406 :: 		CmdCode = cmdNON; // Set 'Idle' command code.
SB	R0, Offset(_CmdCode+0)(GP)
;UHB_Driver.c,407 :: 		break;
J	L_StartBootloader15
NOP	
;UHB_Driver.c,409 :: 		case cmdREBOOT: { // Cmd: Reboot the MCU.
L_StartBootloader35:
;UHB_Driver.c,417 :: 		Reset();   // Reset MCU.
JAL	_Reset+0
NOP	
;UHB_Driver.c,419 :: 		CmdCode = cmdNON; // Set 'Idle' command code.
SB	R0, Offset(_CmdCode+0)(GP)
;UHB_Driver.c,420 :: 		break;
J	L_StartBootloader15
NOP	
;UHB_Driver.c,422 :: 		}
L_StartBootloader14:
LBU	R3, Offset(_CmdCode+0)(GP)
ORI	R2, R0, 11
BNE	R3, R2, L__StartBootloader84
NOP	
J	L_StartBootloader16
NOP	
L__StartBootloader84:
LBU	R3, Offset(_CmdCode+0)(GP)
ORI	R2, R0, 21
BNE	R3, R2, L__StartBootloader86
NOP	
J	L_StartBootloader26
NOP	
L__StartBootloader86:
LBU	R3, Offset(_CmdCode+0)(GP)
ORI	R2, R0, 1
BNE	R3, R2, L__StartBootloader88
NOP	
J	L_StartBootloader34
NOP	
L__StartBootloader88:
LBU	R3, Offset(_CmdCode+0)(GP)
ORI	R2, R0, 4
BNE	R3, R2, L__StartBootloader90
NOP	
J	L_StartBootloader35
NOP	
L__StartBootloader90:
L_StartBootloader15:
;UHB_Driver.c,423 :: 		}
L_StartBootloader13:
;UHB_Driver.c,424 :: 		}
J	L_StartBootloader11
NOP	
;UHB_Driver.c,425 :: 		}
L_end_StartBootloader:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 12
JR	RA
NOP	
; end of _StartBootloader
_EnterBootloaderMode:
;UHB_Driver.c,452 :: 		char EnterBootloaderMode() {
ADDIU	SP, SP, -12
SW	RA, 0(SP)
;UHB_Driver.c,454 :: 		unsigned long timer = 800000;
SW	R25, 4(SP)
LUI	R30, 12
ORI	R30, R30, 13568
SW	R30, 8(SP)
;UHB_Driver.c,457 :: 		while (1) {
L_EnterBootloaderMode36:
;UHB_Driver.c,458 :: 		USB_Polling_Proc();  // Check USB.
JAL	_USB_Polling_Proc+0
NOP	
;UHB_Driver.c,459 :: 		dataRx = HID_Read(); // Read received USB packet, if any.
JAL	_HID_Read+0
NOP	
;UHB_Driver.c,460 :: 		if (dataRx) {        // Do we have an incoming?
BNE	R2, R0, L__EnterBootloaderMode93
NOP	
J	L_EnterBootloaderMode38
NOP	
L__EnterBootloaderMode93:
;UHB_Driver.c,462 :: 		Check4Cmd();       // Check received packet for new command.
JAL	UHB_Driver_Check4Cmd+0
NOP	
;UHB_Driver.c,463 :: 		switch (CmdCode) { // Process command.
J	L_EnterBootloaderMode39
NOP	
;UHB_Driver.c,464 :: 		case cmdBOOT: {  // Cmd: Enter bootloader mode.
L_EnterBootloaderMode41:
;UHB_Driver.c,465 :: 		SendACK(CmdCode);   // Acknowledge enter bootloader mode command.
LBU	R25, Offset(_CmdCode+0)(GP)
JAL	UHB_Driver_SendACK+0
NOP	
;UHB_Driver.c,466 :: 		CmdCode = cmdNON;   // Set 'Idle' command code.
SB	R0, Offset(_CmdCode+0)(GP)
;UHB_Driver.c,467 :: 		Delay_50us();
JAL	_Delay_50us+0
NOP	
;UHB_Driver.c,468 :: 		return 1;           // Return with do bootloader code.
ORI	R2, R0, 1
J	L_end_EnterBootloaderMode
NOP	
;UHB_Driver.c,470 :: 		case cmdINFO: { // Cmd: Get bootloader info.
L_EnterBootloaderMode42:
;UHB_Driver.c,471 :: 		SendBootInfo();   // Send bootloader info record.
JAL	UHB_Driver_SendBootInfo+0
NOP	
;UHB_Driver.c,472 :: 		CmdCode = cmdNON; // Set 'Idle' command code.
SB	R0, Offset(_CmdCode+0)(GP)
;UHB_Driver.c,473 :: 		break;
J	L_EnterBootloaderMode40
NOP	
;UHB_Driver.c,475 :: 		}
L_EnterBootloaderMode39:
LBU	R3, Offset(_CmdCode+0)(GP)
ORI	R2, R0, 3
BNE	R3, R2, L__EnterBootloaderMode95
NOP	
J	L_EnterBootloaderMode41
NOP	
L__EnterBootloaderMode95:
LBU	R3, Offset(_CmdCode+0)(GP)
ORI	R2, R0, 2
BNE	R3, R2, L__EnterBootloaderMode97
NOP	
J	L_EnterBootloaderMode42
NOP	
L__EnterBootloaderMode97:
L_EnterBootloaderMode40:
;UHB_Driver.c,476 :: 		}
L_EnterBootloaderMode38:
;UHB_Driver.c,478 :: 		Delay_1us();
JAL	_Delay_1us+0
NOP	
;UHB_Driver.c,480 :: 		if (!(timer--)) // Do we have a timeout?
LW	R3, 8(SP)
LW	R2, 8(SP)
ADDIU	R2, R2, -1
SW	R2, 8(SP)
BEQ	R3, R0, L__EnterBootloaderMode98
NOP	
J	L_EnterBootloaderMode43
NOP	
L__EnterBootloaderMode98:
;UHB_Driver.c,481 :: 		return 0;     //   Yes, return with do application code.
MOVZ	R2, R0, R0
J	L_end_EnterBootloaderMode
NOP	
L_EnterBootloaderMode43:
;UHB_Driver.c,482 :: 		}
J	L_EnterBootloaderMode36
NOP	
;UHB_Driver.c,483 :: 		}
L_end_EnterBootloaderMode:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 12
JR	RA
NOP	
; end of _EnterBootloaderMode
_StartProgram:
;UHB_Driver.c,509 :: 		void StartProgram() {
;UHB_Driver.c,511 :: 		asm nop;
NOP	
;UHB_Driver.c,514 :: 		asm nop;
NOP	
;UHB_Driver.c,516 :: 		}
L_end_StartProgram:
JR	RA
NOP	
; end of _StartProgram
