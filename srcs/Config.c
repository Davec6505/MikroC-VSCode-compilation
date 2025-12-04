/******************************************************************************
 *                                                                            *
 *  Unit:         Config.c                                                    *
 *                                                                            *
 *  Copyright:    (c) Mikroelektronika, 2011.                                 *
 *                                                                            *
 *  Description:  Bootloader configuration constants, memory allocation       *
 *                directives and MCU configuration.                           *
 *                Double click to open flash memory layout pdf:               *
 *                ac:PIC32_USB_HID_BootLoader_Memory_Layout                   *
 *                                                                            *
 *  Requirements: PIC32 specific.                                             *
 *                                                                            *
 *  Migration:    Along with Config.h, this is the only file in this          *
 *                project that might need to be adjusted when migrating.      *
 *                Switching to another MCU within PIC32 family                *
 *                of microcontrollers, may require at most two constants      *
 *                to be changed:                                              *
 *                  1. DEVICE_NAME                                            *
 *                  2. BOOTLOADER_SIZE                                        *
 *                Target MCU may needs some additional initialization code.   *
 *                Place it in Config() routine.                               *
 *                If these are already set properly, we are all done :)       *
 *                                                                            *
 ****************************       CHANGE LOG       **************************
 * Version | ACTION                                           |  DATE  | SIG  *
 * --------|--------------------------------------------------|--------|----- *
 *         |                                                  |        |      *
 *    0.01 | - Initial release                                | 030511 |  ST  *
 *         |                                                  |        |      *
 ******************************************************************************/
#include <Main.h>
#include <Types.h>
#include <UHB_Driver.h>

/* Bootloader constantats */
const enum TMcuType MCU_TYPE = mtPIC32MZ;                  // Target MCU family.
                                                           // Use predefined family constants (TMcuType).

// Device name: Name of hardware product bootloader is set for (not MCU name).
// This name will be displayed in PC application name field once device is detected.
#define DEVICE_NAME "NO NAME"

const unsigned long BOOTLOADER_SIZE          = 39000;      // Bootloader (this) code size.
                                                           // Easiest way to set this field
                                                           //   is to enter a large value here
                                                           //   (i.e. half the MCU flash size),
                                                           //   then compile the project and
                                                           //   reset this value to the
                                                           //   'USED ROM' value given in Compiler messages.
                                                           // Recompile the project!

const unsigned int  BOOTLOADER_REVISION      = 0x1200;     // Version of bootlaoder firmware.

const unsigned long MCU_FLASH_START_PHY      = 0x1D000000; // Internal flash start address (physical, not virtual).
const unsigned long MCU_BOOT_FLASH_START_PHY = 0x1FC00000; // Internal bootl flash start address (physical, not virtual).
// MCU configuration words are located at the end of bootl flash memory.
// Configuraton flash block start equasion (physical, not virtual):
const unsigned long MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY = MCU_BOOT_FLASH_START_PHY + 0xFF00;

// Bootloader physical start address equasion:
const unsigned long BOOTLOADER_START_PHY   = MCU_FLASH_START_PHY+
                                             ((__FLASH_SIZE-BOOTLOADER_SIZE)/_FLASH_ERASE)*_FLASH_ERASE;
// Bootloader virtual start address equasion:
const unsigned long BOOTLOADER_START       = PA_TO_KVA1(BOOTLOADER_START_PHY);
const unsigned char RESET_VECTOR_SIZE      = 16;           // MCU reset vector size in bytes.

// Bootloader info record.
// It is used by PC application tool to identify device and get device
// specific information.
const TBootInfo BootInfo = { sizeof(TBootInfo),                   // This record's size in bytes.
                            {bifMCUTYPE,    MCU_TYPE},            // MCU family.
                            {bifMCUSIZE,    __FLASH_SIZE},        // MCU flash size.
                            {bifERASEBLOCK, _FLASH_ERASE},        // MCU Flash erase block size in bytes.
                            {bifWRITEBLOCK, _FLASH_WRITE_LATCH},  // MCU Flash write block size in bytes.
                            {bifBOOTREV,    BOOTLOADER_REVISION}, // Version of bootlaoder firmware.
                            {bifBOOTSTART,  BOOTLOADER_START},    // Bootloader code start address.
                            {bifDEVDSC,     DEVICE_NAME}          // Name of this device.
                           };
                           
/* Bootloader memory allocation */

// USB HID read/write buffers
unsigned char HidReadBuff[64]  aligned(16);  // USB HID read buffer.
unsigned char HidWriteBuff[64] aligned(16);  // USB HID write buffer.

/******************************************************************************
 *                                                                            *
 *  Function:     void BootResetVector()                                      *
 *                                                                            *
 *  Description:  Overrides application reset vector and enables bootloader   *
 *                code to execute first.                                      *
 *                                                                            *
 *  Parameters:   None.                                                       *
 *                                                                            *
 *  Return Value: None.                                                       *
 *                                                                            *
 *  Requirements: None.                                                       *
 *                                                                            *
 *  Notes:        Must be allocated at the MCU's physical reset vector        *
 *                (0xBFC00000 address).                                       *
 *                                                                            *
 ****************************       CHANGE LOG       **************************
 * Version | ACTION                                           |  DATE  | SIG  *
 * --------|--------------------------------------------------|--------|----- *
 *         |                                                  |        |      *
 *    0.01 | - Initial release                                | 030511 |  ST  *
 *         |                                                  |        |      *
 ******************************************************************************/
void BootResetVector() {
  R30 = BOOTLOADER_START; // Load R30 with bootloader main address.
  asm {
      JR R30              // Perform indirect jump to bootloader application,
      NOP                 // thus changing the kseg as well.
  }
}

/******************************************************************************
 *                                                                            *
 *  Macro:        ConfigMem()                                                 *
 *                                                                            *
 *  Description:  Specific program allocation directives:                     *
 *                  1. all routines above                                     *
 *                     BOOTLOADER_START-RESET_VECTOR_SIZE address.            *
 *                  2. StartProgram routine at                                *
 *                     BOOTLOADER_START-RESET_VECTOR_SIZE address.            *
 *                  4. BootResetVector routine at 0xBFC00000.                 *
 *                  5. __BootStartUp at BOOTLOADER_START.                     *
 *                                                                            *
 *  Parameters:   None.                                                       *
 *                                                                            *
 *  Return Value: None.                                                       *
 *                                                                            *
 *  Requirements: None.                                                       *
 *                                                                            *
 *  Notes:        None.                                                       *
 *                                                                            *
 ****************************       CHANGE LOG       **************************
 * Version | ACTION                                           |  DATE  | SIG  *
 * --------|--------------------------------------------------|--------|----- *
 *         |                                                  |        |      *
 *    0.01 | - Initial release                                | 030511 |  ST  *
 *         |                                                  |        |      *
 ******************************************************************************/
#define ConfigMem(); OrgAll(BOOTLOADER_START-RESET_VECTOR_SIZE); \
                     FuncOrg(StartProgram, BOOTLOADER_START-RESET_VECTOR_SIZE); \
                     FuncOrg(BootResetVector, 0xBFC00000); \
                     FuncOrg(__BootStartUp, BOOTLOADER_START);

/******************************************************************************
 *                                                                            *
 *  Function:     void Config()                                               *
 *                                                                            *
 *  Description:  MCU configuration and memory allocation directives.         *
 *                                                                            *
 *  Parameters:   None.                                                       *
 *                                                                            *
 *  Return Value: None.                                                       *
 *                                                                            *
 *  Requirements: None.                                                       *
 *                                                                            *
 *  Notes:        None.                                                       *
 *                                                                            *
 ****************************       CHANGE LOG       **************************
 * Version | ACTION                                           |  DATE  | SIG  *
 * --------|--------------------------------------------------|--------|----- *
 *         |                                                  |        |      *
 *    0.01 | - Initial release                                | 030511 |  ST  *
 *         |                                                  |        |      *
 ******************************************************************************/
void Config() {
  #pragma funcall main BootResetVector  // force BootResetVector allocation
  ConfigMem(); // allocate memory
}