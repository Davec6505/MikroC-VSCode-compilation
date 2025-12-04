/******************************************************************************
 *                                                                            *
 *  Unit:         Config.h                                                    *
 *                                                                            *
 *  Copyright:    (c) Mikroelektronika, 2011.                                 *
 *                                                                            *
 *  Description:  Config.c declarations and some more.                        *
 *                                                                            *
 *  Requirements: PIC32 specific.                                             *
 *                                                                            *
 *  Migration:    Along with Config.c, this is the only file in this          *
 *                project that might need to be adjusted when migrating.      *
 *                Switching to another MCU within PIC24FJ family              *
 *                of microcontrollers, in most cases, will not require any    *
 *                change here :)                                              *
 *                                                                            *
 ****************************       CHANGE LOG       **************************
 * Version | ACTION                                           |  DATE  | SIG  *
 * --------|--------------------------------------------------|--------|----- *
 *         |                                                  |        |      *
 *    0.01 | - Initial release                                | 030511 |  ST  *
 *         |                                                  |        |      *
 ******************************************************************************/
#ifndef __CONFIG
#define __CONFIG

#include <Types.h>

extern const unsigned long MCU_FLASH_START_PHY;                   // Internal flash start address (physical).
extern const unsigned long MCU_BOOT_FLASH_START_PHY;              // Internal boot flash start address (physical).
extern const unsigned long MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY; // Boot flash row containing configuration words
                                                                  // start address (physical).

extern const unsigned long BOOTLOADER_SIZE;      // Bootloader size.
extern const unsigned long BOOTLOADER_START;     // Bootloader start virtual address.
extern const unsigned long BOOTLOADER_START_PHY; // Bootloader start physical address.
extern const unsigned char RESET_VECTOR_SIZE;    // MCU reset vector size.

extern const TBootInfo BootInfo;                 // Bootloader info record,
                                                 // containing device specific information.

extern unsigned char HidReadBuff[64];            // USB HID read buffer.
extern unsigned char HidWriteBuff[64];           // USB HID write buffer.

// Flash write and erase block sizes are MCU dependent.
// To reduce confusion and errors, these routines might not have
// uniform names between different MCUs/architectures.
// Consult library manager for target MCU's flash handling routine names.

#define FLASH_Write(addr, buff) Flash_Write_Row(addr, (unsigned long*)buff);

#define FLASH_Erase Flash_Erase_Page             // flash erase (16384 bytes)

void Config();                                   // multi purpose configuration routine
#endif