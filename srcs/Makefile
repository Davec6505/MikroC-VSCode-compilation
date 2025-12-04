#
# learning: .mcp32 must stay in srcs for linker; -B controls .emcl output

SHELL := powershell.exe
.SHELLFLAGS := -NoProfile -Command

# ============================================================================
# ALL CONFIGURATION COMES FROM ROOT MAKEFILE
# These are just fallback defaults if run standalone
# ============================================================================

DEVICE            ?= P32MZ2048EFH144
MODULE            ?= USB_HID_Bootloader
HEAP_SIZE         ?= 131072
STACK_SIZE        ?= 131072
EBASE_ADDR        ?= 0x9FC01000
BUILD_CONFIG      ?= RELEASE
OPT_LEVEL         ?= -O11111114

COMPILER_LOCATION ?= C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\mikroCPIC32.exe
DEFS_DIR          ?= C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\Defs
USES_DIR          ?= C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\Uses

ROOT_DIR          ?= C:\Users\davec\source\mikroC_makefile_test
OBJ_DIR           ?= $(ROOT_DIR)\objs
SRC_DIR           ?= $(ROOT_DIR)\srcs
OTHER_DIR         ?= $(ROOT_DIR)\other

# Build mikroC command flags (received from root or built here)
CFLAGS_COMMON     ?= -MSF -RA -DL -SSA -INTDEF MV_SRS7_IS32 -fo200

# If CFLAGS not provided by root, build it locally
ifndef CFLAGS
    CFLAGS := $(CFLAGS_COMMON) -pP$(DEVICE) -HEAP $(HEAP_SIZE) -EBASE $(EBASE_ADDR) $(OPT_LEVEL)
    ifeq ($(BUILD_CONFIG),DEBUG)
        CFLAGS := $(CFLAGS) -DBG
    endif
endif

# Derived paths
MCP_FILE := $(SRC_DIR)\$(MODULE).mcp32

# Source and library files
SOURCES := Main.c Config.c UHB_Driver.c USBdsc.c
LIBS    := __Lib_CP0.emcl __Lib_Math.emcl __Lib_MathDouble_MZ_EF.emcl __Lib_System_MZ_EF.emcl __Lib_SoftResetDma.emcl __Lib_Delays.emcl __Lib_FLASH_MZ.emcl __Lib_USB_MZ_HS.emcl

# Your original working ALL target (preserved)
ALL: 
	@Write-Host "Building all targets (original hardcoded example)..."
	@Write-Host ""
	& "C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\mikroCPIC32.exe" -MSF -DBG -pP32MZ2048EFH144 -RA -DL -SSA -EBASE 0x9FC01000 -INTDEF MV_SRS7_IS32 -O11111113 -fo200 -B"C:\Users\davec\source\mikroC_makefile_test\srcs\" -N"C:\Users\davec\source\mikroC_makefile_test\srcs\USB HID Bootloader.mcp32" -SP"C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\Defs\" -SP"C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\Uses\" -SP"C:\Users\davec\source\mikroC_makefile_test\srcs\" -IP"C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\Uses\" -IP"C:\Users\davec\source\mikroC_makefile_test\srcs\" "Main.c" "Config.c" "UHB_Driver.c" "USBdsc.c" "__Lib_CP0.emcl" "__Lib_Math.emcl" "__Lib_MathDouble_MZ_EF.emcl" "__Lib_System_MZ_EF.emcl" "__Lib_SoftResetDma.emcl" "__Lib_Delays.emcl" "__Lib_FLASH_MZ.emcl" "__Lib_USB_MZ_HS.emcl"

# Parameterized build - uses all settings from root Makefile
build:
	@Write-Host "Building $(MODULE) for $(DEVICE) ($(BUILD_CONFIG))..."
	@if (!(Test-Path "$(OBJ_DIR)")) { New-Item -ItemType Directory -Path "$(OBJ_DIR)" | Out-Null }
	@if (!(Test-Path "$(OTHER_DIR)")) { New-Item -ItemType Directory -Path "$(OTHER_DIR)" | Out-Null }
	& "$(COMPILER_LOCATION)" $(CFLAGS) -B"$(OBJ_DIR)\" -N"$(MCP_FILE)" -SP"$(DEFS_DIR)\" -SP"$(USES_DIR)\" -SP"$(SRC_DIR)\" -IP"$(USES_DIR)\" -IP"$(SRC_DIR)\" "Main.c" "Config.c" "UHB_Driver.c" "USBdsc.c" "__Lib_CP0.emcl" "__Lib_Math.emcl" "__Lib_MathDouble_MZ_EF.emcl" "__Lib_System_MZ_EF.emcl" "__Lib_SoftResetDma.emcl" "__Lib_Delays.emcl" "__Lib_FLASH_MZ.emcl" "__Lib_USB_MZ_HS.emcl"
	@Write-Host "Moving .asm, .lst, .log, and .cp files to $(OTHER_DIR)..."
	@Get-ChildItem "$(SRC_DIR)" -Filter *.asm | Move-Item -Destination "$(OTHER_DIR)" -Force -ErrorAction SilentlyContinue
	@Get-ChildItem "$(SRC_DIR)" -Filter *.lst | Move-Item -Destination "$(OTHER_DIR)" -Force -ErrorAction SilentlyContinue
	@Get-ChildItem "$(SRC_DIR)" -Filter *.log | Move-Item -Destination "$(OTHER_DIR)" -Force -ErrorAction SilentlyContinue
	@Get-ChildItem "$(SRC_DIR)" -Filter *.cp | Move-Item -Destination "$(OTHER_DIR)" -Force -ErrorAction SilentlyContinue
	@Write-Host "Build complete."

.PHONY: ALL build


