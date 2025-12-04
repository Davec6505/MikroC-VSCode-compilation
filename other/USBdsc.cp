#line 1 "C:/Users/davec/source/mikroC_makefile_test/srcs/USBdsc.c"
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
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic32/include/stddef.h"



typedef long ptrdiff_t;
typedef unsigned long size_t;
typedef unsigned long wchar_t;
#line 4 "C:/Users/davec/source/mikroC_makefile_test/srcs/USBdsc.c"
const unsigned int USB_VENDOR_ID = 0x2DBC;
const unsigned int USB_PRODUCT_ID = 0x0001;
const char USB_SELF_POWER = 0x80;
const char USB_MAX_POWER = 50;
const char HID_INPUT_REPORT_BYTES = 64;
const char HID_OUTPUT_REPORT_BYTES = 64;
const char USB_TRANSFER_TYPE = 0x03;
const char EP_IN_INTERVAL = 1;
const char EP_OUT_INTERVAL = 1;

const char USB_INTERRUPT = 0;
const char USB_HID_EP = 1;
const char USB_HID_RPT_SIZE = 33;

typedef struct
{

 size_t hidReportDescriptorSize;


 void * hidReportDescriptor;


 size_t queueSizeReportSend;


 size_t queueSizeReportReceive;

} USB_DEVICE_HID_INIT;

const struct {
 char bLength;
 char bDescriptorType;
 unsigned int bcdUSB;
 char bDeviceClass;
 char bDeviceSubClass;
 char bDeviceProtocol;
 char bMaxPacketSize0;
 unsigned int idVendor;
 unsigned int idProduct;
 unsigned int bcdDevice;
 char iManufacturer;
 char iProduct;
 char iSerialNumber;
 char bNumConfigurations;
} device_dsc = {
 0x12,
 0x01,
 0x0200,
 0x00,
 0x00,
 0x00,
 64,
 USB_VENDOR_ID,
 USB_PRODUCT_ID,
 0x0001,
 0x01,
 0x02,
 0x00,
 0x01
 };

const uint8_t configDescriptor1[]=
{

 0x09,
 0x02,
 0x29,0x00,
 1,
 1,
 0,
 USB_SELF_POWER,
 USB_MAX_POWER,


 0x09,
 0x04,
 0,
 0,
 2,
 0x03,
 0,
 0,
 0,


 0x09,
 0x21,
 0x01,0x01,
 0x00,
 1,
 0x22,
 USB_HID_RPT_SIZE,0x00,


 0x07,
 0x05,
 USB_HID_EP | 0x80,
 USB_TRANSFER_TYPE,
 0x40,0x00,
 EP_IN_INTERVAL,


 0x07,
 0x05,
 USB_HID_EP,
 USB_TRANSFER_TYPE,
 0x40,0x00,
 EP_OUT_INTERVAL
};




const struct {
 char report[USB_HID_RPT_SIZE];
}hid_rpt_desc =
 {
 {
 0x06, 0x00, 0xFF,
 0x09, 0x01,
 0xA1, 0x01,

 0x19, 0x01,
 0x29, 0x40,
 0x15, 0x00,
 0x26, 0xFF, 0x00,
 0x75, 0x08,
 0x95, 64,
 0x81, 0x02,

 0x19, 0x01,
 0x29, 0x40,
 0x75, 0x08,
 0x95, 64,
 0x91, 0x02,
 0xC0
 }
 };





const struct
{
 uint8_t bLength;
 uint8_t bDscType;
 uint16_t string[1];
}
strd1 =
{
 4,
 0x03,
 {0x0409}
};
#line 163 "C:/Users/davec/source/mikroC_makefile_test/srcs/USBdsc.c"
const struct
{
 uint8_t bLength;
 uint8_t bDscType;
 uint16_t string[16];
}
strd2 =
{
 34,
 0x03,
 {'M','i','k','r','o','e','l','e','k','t','r','o','n','i','k','a'}
};


const struct{
 char bLength;
 char bDscType;
 unsigned int string[18];
}strd3={
 38,
 0x03,
 {'U','S','B',' ','H','I','D',' ','B','o','o','t','l','o','a','d','e','r'}
 };

const uint8_t *const stringDescriptors[3] =
{
 (const uint8_t *const)&strd1,
 (const uint8_t *const)&strd2,
 (const uint8_t *const)&strd3
};
#line 197 "C:/Users/davec/source/mikroC_makefile_test/srcs/USBdsc.c"
const USB_DEVICE_HID_INIT hidInit0 =
{
 USB_HID_RPT_SIZE,
 &hid_rpt_desc.report,
 1,
 1
};
