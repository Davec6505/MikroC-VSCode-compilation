#line 1 "C:/Users/davec/source/mikroC_makefile_test/srcs/Config.c"
#line 1 "c:/users/davec/source/mikroc_makefile_test/srcs/main.h"
#line 19 "c:/users/davec/source/mikroc_makefile_test/srcs/main.h"
void main(void);
#line 1 "c:/users/davec/source/mikroc_makefile_test/srcs/types.h"
#line 20 "c:/users/davec/source/mikroc_makefile_test/srcs/types.h"
enum TMcuType {mtPIC16 = 1, mtPIC18, mtPIC18FJ, mtPIC24, mtDSPIC = 10, mtPIC32 = 20, mtPIC32MZ = 21};


enum TBootInfoField {bifMCUTYPE=1,
 bifMCUID,
 bifERASEBLOCK,
 bifWRITEBLOCK,
 bifBOOTREV,
 bifBOOTSTART,
 bifDEVDSC,
 bifMCUSIZE
 };


enum TCmd {cmdNON=0,
 cmdSYNC,
 cmdINFO,
 cmdBOOT,
 cmdREBOOT,
 cmdWRITE=11,
 cmdERASE=21};




typedef struct {
 char fFieldType;
 char fValue;
} TCharField;


typedef struct {
 char fFieldType;
 union {
 unsigned int intVal;
 struct {
 char bLo;
 char bHi;
 };
 } fValue;
} TUIntField;


typedef struct {
 char fFieldType;
 unsigned long fValue;
} TULongField;



typedef struct {
 char fFieldType;
 char fValue[ 20 ];
} TStringField;


typedef struct {
 char bSize;
 TCharField bMcuType;
 TULongField ulMcuSize;
 TUIntField uiEraseBlock;
 TUIntField uiWriteBlock;
 TUIntField uiBootRev;
 TULongField ulBootStart;
 TStringField sDevDsc;
} TBootInfo;
#line 1 "c:/users/davec/source/mikroc_makefile_test/srcs/uhb_driver.h"
#line 19 "c:/users/davec/source/mikroc_makefile_test/srcs/uhb_driver.h"
void StartProgram();
void StartBootloader();
char EnterBootloaderMode();
#line 37 "C:/Users/davec/source/mikroC_makefile_test/srcs/Config.c"
const enum TMcuType MCU_TYPE = mtPIC32MZ;






const unsigned long BOOTLOADER_SIZE = 39000;








const unsigned int BOOTLOADER_REVISION = 0x1200;

const unsigned long MCU_FLASH_START_PHY = 0x1D000000;
const unsigned long MCU_BOOT_FLASH_START_PHY = 0x1FC00000;


const unsigned long MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY = MCU_BOOT_FLASH_START_PHY + 0xFF00;


const unsigned long BOOTLOADER_START_PHY = MCU_FLASH_START_PHY+
 ((__FLASH_SIZE-BOOTLOADER_SIZE)/_FLASH_ERASE)*_FLASH_ERASE;

const unsigned long BOOTLOADER_START = PA_TO_KVA1(BOOTLOADER_START_PHY);
const unsigned char RESET_VECTOR_SIZE = 16;




const TBootInfo BootInfo = { sizeof(TBootInfo),
 {bifMCUTYPE, MCU_TYPE},
 {bifMCUSIZE, __FLASH_SIZE},
 {bifERASEBLOCK, _FLASH_ERASE},
 {bifWRITEBLOCK, _FLASH_WRITE_LATCH},
 {bifBOOTREV, BOOTLOADER_REVISION},
 {bifBOOTSTART, BOOTLOADER_START},
 {bifDEVDSC,  "NO NAME" }
 };




unsigned char HidReadBuff[64] aligned(16);
unsigned char HidWriteBuff[64] aligned(16);
#line 110 "C:/Users/davec/source/mikroC_makefile_test/srcs/Config.c"
void BootResetVector() {
 R30 = BOOTLOADER_START;
 asm {
 JR R30
 NOP
 }
}
#line 171 "C:/Users/davec/source/mikroC_makefile_test/srcs/Config.c"
void Config() {
#pragma funcall main BootResetVector
#line 173 "C:/Users/davec/source/mikroC_makefile_test/srcs/Config.c"
  ; OrgAll(BOOTLOADER_START-RESET_VECTOR_SIZE); FuncOrg(StartProgram, BOOTLOADER_START-RESET_VECTOR_SIZE); FuncOrg(BootResetVector, 0xBFC00000); FuncOrg(__BootStartUp, BOOTLOADER_START); ;
}
