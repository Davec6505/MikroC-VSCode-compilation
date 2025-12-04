#line 1 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
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
#line 1 "c:/users/davec/source/mikroc_makefile_test/srcs/config.h"
#line 1 "c:/users/davec/source/mikroc_makefile_test/srcs/types.h"
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
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic32/include/built_in.h"
#line 102 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
const STX = 0x0F;
const ETX = 0x04;
const DLE = 0x05;

int GPCounter = 0;
int BytesToWrite at GPCounter;
int BytesToGet at GPCounter;
int BlocksToErase at GPCounter;

unsigned long GPAddress = 0;
unsigned long StartAddress at GPAddress;


struct {
 char fBuffer[_FLASH_ERASE];
 char *fRWPtr;
#line 129 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
} Buffer;

enum TCmd CmdCode = cmdNON;
#line 155 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
static void _Buffer_SaveToFlash() {
 int bCount;

 bCount =  Buffer.fRWPtr-Buffer.fBuffer ;
 Buffer.fRWPtr = Buffer.fBuffer;
 while (bCount > 0) {
  Flash_Write_Row(StartAddress, (unsigned long*)Buffer.fRWPtr); ;
 bCount -= _FLASH_WRITE_LATCH;
 Buffer.fRWPtr += _FLASH_WRITE_LATCH;



 StartAddress += _FLASH_WRITE_LATCH;

 }
}
#line 194 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
static void SendBootInfo() {
 typedef struct {
 char fArray[sizeof(TBootInfo)];
 } TBootInfoArray;



 *(TBootInfoArray *)(void *)HidWriteBuff = BootInfo;
 HID_Write(HidWriteBuff, 64);
}
#line 227 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
static void Check4Cmd() {
 if (CmdCode == cmdNON) {

 if (HidReadBuff[0] != STX)

 return ;


 CmdCode = HidReadBuff[1];
  ((char *)&GPAddress)[0]  = HidReadBuff[2];
  ((char *)&GPAddress)[1]  = HidReadBuff[3];
  ((char *)&GPAddress)[2]  = HidReadBuff[4];
  ((char *)&GPAddress)[3]  = HidReadBuff[5];
  ((char *)&GPCounter)[0]  = HidReadBuff[6];
  ((char *)&GPCounter)[1]  = HidReadBuff[7];
 }
 else {

 }
}
#line 275 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
static char GetData() {
 char i;
 char *sPtr;


 sPtr = HidReadBuff;
 i = 0;
 while (1) {
 if (!BytesToGet)
 return 1;
 if ( Buffer.fRWPtr-Buffer.fBuffer  ==  sizeof(Buffer.fBuffer) )
 return 1;
 if (i == sizeof(HidReadBuff))
 return 0;
  *Buffer.fRWPtr++ = *sPtr++ ;
 BytesToGet--;
 i++;
 }
 return 0;
}
#line 317 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
static void SendACK(enum TCmd cmd) {

 HidWriteBuff[0] = STX;
 HidWriteBuff[1] = cmd;
 HID_Write(HidWriteBuff, 64);
}
#line 345 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
void StartBootloader() {
 char dataRx;
 char writeData = 0;

  Buffer.fRWPtr = Buffer.fBuffer ;


 while(1) {
 USB_Polling_Proc();
 dataRx = HID_Read();
 if (dataRx) {
 dataRx = 0;
 Check4Cmd();
 switch(CmdCode) {
 case cmdWRITE: {
 if (writeData) {
 if (GetData()) {

 if ((StartAddress < BOOTLOADER_START_PHY) ||
 ((StartAddress >= MCU_BOOT_FLASH_START_PHY) &&
 (StartAddress < MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY)))
#line 369 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
  _Buffer_SaveToFlash() ;

 SendACK(CmdCode);
  Buffer.fRWPtr = Buffer.fBuffer ;
 if (BytesToWrite == 0) {
 writeData = 0;
 CmdCode = cmdNON;
 }
 }
 }
 else {
 writeData = 1;
 }
 break;
 }
 case cmdERASE: {
 while (BlocksToErase--) {

 if ((StartAddress < BOOTLOADER_START_PHY) ||
 ((StartAddress >= MCU_BOOT_FLASH_START_PHY) &&
 (StartAddress < MCU_BOOT_FLASH_CONFIG_BLOCK_START_PHY)))
#line 393 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
  Flash_Erase_Page (StartAddress);



 StartAddress -= _FLASH_ERASE;

 }
 SendACK(CmdCode);
 CmdCode = cmdNON;
 break;
 }
 case cmdSYNC: {
 SendACK(CmdCode);
 CmdCode = cmdNON;
 break;
 }
 case cmdREBOOT: {
#line 417 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
 Reset();

 CmdCode = cmdNON;
 break;
 }
 }
 }
 }
}
#line 452 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
char EnterBootloaderMode() {
char dataRx;
unsigned long timer = 800000;


 while (1) {
 USB_Polling_Proc();
 dataRx = HID_Read();
 if (dataRx) {
 dataRx = 0;
 Check4Cmd();
 switch (CmdCode) {
 case cmdBOOT: {
 SendACK(CmdCode);
 CmdCode = cmdNON;
 Delay_50us();
 return 1;
 }
 case cmdINFO: {
 SendBootInfo();
 CmdCode = cmdNON;
 break;
 }
 }
 }

 Delay_1us();

 if (!(timer--))
 return 0;
 }
}
#line 509 "C:/Users/davec/source/mikroC_makefile_test/srcs/UHB_Driver.c"
void StartProgram() {

 asm nop;


 asm nop;

}
