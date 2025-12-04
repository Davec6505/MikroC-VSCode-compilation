#line 1 "C:/Users/davec/source/mikroC_makefile_test/srcs/Main.c"
#line 1 "c:/users/davec/source/mikroc_makefile_test/srcs/config.h"
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
#line 29 "c:/users/davec/source/mikroc_makefile_test/srcs/config.h"
extern const unsigned long MCU_FLASH_START_PHY;
extern const unsigned long MCU_BOOT_FLASH_START_PHY;
extern const unsigned long MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY;


extern const unsigned long BOOTLOADER_SIZE;
extern const unsigned long BOOTLOADER_START;
extern const unsigned long BOOTLOADER_START_PHY;
extern const unsigned char RESET_VECTOR_SIZE;

extern const TBootInfo BootInfo;


extern unsigned char HidReadBuff[64];
extern unsigned char HidWriteBuff[64];










void Config();
#line 1 "c:/users/davec/source/mikroc_makefile_test/srcs/uhb_driver.h"
#line 19 "c:/users/davec/source/mikroc_makefile_test/srcs/uhb_driver.h"
void StartProgram();
void StartBootloader();
char EnterBootloaderMode();
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic32/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;
typedef signed long long int64_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;
typedef unsigned long long uint64_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;
typedef signed long long int_least64_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;
typedef unsigned long long uint_least64_t;



typedef signed long int int_fast8_t;
typedef signed long int int_fast16_t;
typedef signed long int int_fast32_t;
typedef signed long long int_fast64_t;


typedef unsigned long int uint_fast8_t;
typedef unsigned long int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long long uint_fast64_t;


typedef signed long int intptr_t;
typedef unsigned long int uintptr_t;


typedef signed long long intmax_t;
typedef unsigned long long uintmax_t;
#line 77 "C:/Users/davec/source/mikroC_makefile_test/srcs/Main.c"
void main(void) {

 NVMKEY = 0xAA996655;
 NVMKEY = 0x556699AA;
 NVMBWPCLR = 0x1F1F;

 Config();

 HID_Enable(HidReadBuff, HidWriteBuff);


 if (!EnterBootloaderMode()) {
 HID_Disable();
 Delay_10ms();

 StartProgram();
 }
 else
 StartBootloader();
}
