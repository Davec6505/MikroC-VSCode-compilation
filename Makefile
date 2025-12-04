#===============================================================================#
# AUTHOR: David Coetzee                                               			#
# DATE: 16/08/2024                                                     			#
# EMAIL: davec6505@gmail.com                                           			#
#-------------------------------------------------------------------------------#
# NOTES:                                                               			#
# Makefile for mikroC PIC32 only. Uses PowerShell commands.        				#
#===============================================================================#
#																				#
#===========mikroC PRO for PIC32 Command Line Options===========================#
# Usage: mikroCPIC32.exe [-<opts> [-<opts>]] [<infile> [-<opts>]] [-<opts>]]	#
#        Infile can be of *.c, *.emcl and *.pld type. 							#
#-------------------------------------------------------------------------------#
# The following parameters are valid :											#
#																				#
# -P <devicename> : MCU for which compilation will be done. 					#
# -FO <oscillator> : Set oscillator [in MHz]. 									#
# -SP <directory> : Add directory to the search path list. 						#
# -N <filename> : Output files generated to file path specified by filename. 	#
# -B <directory> : Save compiled binary files (*.emcl) to 'directory'. 			#
# -O : Miscellaneous output options. 											#
# -DBG : Generate debug info. 													#
# -MSF : Short message format. 													#
# -Y : Dynamic link for string literals. 										#
# -RA : Rebuild all sources in project. 										#
# -L : Check and rebuild new libraries. 										#
# -DL : Build all files as libraries. 											#
# -LHF : Generate Long hex format. 												#
# -PF : Project file name. 														#
# -EH <filename> : Full EEPROM HEX file name with path. 						#
# -HEAP <size> : Heap size in bytes. 											#
# -STACK <size> : Stack size in bytes. 											#
# -GC : Generate COFF file. 													#
# -PF : Project file name. 														#
# -SSA : Enable SSA optimization. 												#
# -UICD : ICD build type. 														#
# -INTDEF : Interrupt settings. 												#	
# -EBASE : Exception base address.												#
#-------------------------------------------------------------------------------#
#  #Example:																	#
#  # mikroCPIC32.exe -MSF -DBG -p32MX460F512L -Y -DL -O11111114 -fo80 -N"C:\Lcd\Lcd.mcp32" -SP"C:\Program Files\Mikroelektronika\mikroC PRO for PIC32\Defs" 
#  #            -SP"C:\Program Files\Mikroelektronika\mikroC PRO for PIC32\Uses" -SP"C:\Lcd\" "Lcd.c" "__Lib_Math.emcl" "__Lib_MathDouble.emcl" 
#  #            "__Lib_System.emcl" "__Lib_Delays.emcl" "__Lib_LcdConsts.emcl" "__Lib_Lcd.emcl"
#-------------------------------------------------------------------------------#
# Parameters used in the example:												# 
#																				#
# -MSF : Short Message Format; used for internal purposes by IDE. 				#
# -DBG : Generate debug info. 													#	
# -p32MX460F512L : MCU PIC32MX460F512L selected. 								#
# -Y : Dynamic link for string literals enabled. 								#
# -DL : All files built as libraries. 											#
# -O11111114 : Miscellaneous output options : 									#
#			 1. Generate ASM file, valid values 0 or 1. 						#
#			 2. Include HEX opcodes, valid values 0 or 1. 						#
#			 3. Include ROM constants, valid values 0 or 1. 					#
#			 4. Include ROM addresses, valid values 0 or 1. 					#
#			 5. Generate LST file, valid values 0 or 1. 						#
#			 6. Include Debug Info, valid values 0 or 1. 						#
#			 7. Include Source Lines in Output Files, valid values 0 or 1. 		#
#			 8. The optimization level, valid values from 0 to 5. 				#
# -fo80 : Set oscillator frequency [in MHz]. 									#

# Set shell to PowerShell
SHELL := powershell.exe
.SHELLFLAGS := -NoProfile -Command

# ============================================================================
# SINGLE POINT OF CONFIGURATION - ALL BUILD SETTINGS HERE
# ============================================================================

# Force a PowerShell-friendly make invocation
MAKE := make.exe

# Device configuration
DEVICE           := 32MZ2048EFH144
MODULE           := USB HID Bootloader

# Memory configuration
HEAP_SIZE        := 131072      # 128KB heap for dynamic memory allocation
STACK_SIZE       := 131072      # 128KB stack
EBASE_ADDR       := 0x9FC01000  # Exception base address

# Build configuration: DEBUG or RELEASE
BUILD_CONFIG     := RELEASE

# Output options configuration
# -O<8 digits>: Each digit controls an output option (0=off, 1=on)
#   1. Generate ASM file (0 or 1)
#   2. Include HEX opcodes in ASM (0 or 1)
#   3. Include ROM constants in ASM (0 or 1)
#   4. Include ROM addresses in ASM (0 or 1)
#   5. Generate LST file (0 or 1)
#   6. Include Debug Info (0 or 1)
#   7. Include Source Lines in output files (0 or 1)
#   8. Optimization level (0-5)
# Generate assembly files (0 or 1)
GEN_ASM          := 1
# Include HEX opcodes in ASM (0 or 1)
INC_HEX_OPCODES  := 1
# Include ROM constants in ASM (0 or 1)
INC_ROM_CONST    := 1
# Include ROM addresses in ASM (0 or 1)
INC_ROM_ADDR     := 1
# Generate listing files (0 or 1)
GEN_LST          := 1
# Include debug info in outputs (0 or 1)
INC_DEBUG_INFO   := 1
# Include source lines in outputs (0 or 1)
INC_SOURCE_LINES := 1
# Optimization level (0-5)
OPT_LEVEL_VAL    := 4

# Build output option string from individual settings
OPT_LEVEL        := -O$(GEN_ASM)$(INC_HEX_OPCODES)$(INC_ROM_CONST)$(INC_ROM_ADDR)$(GEN_LST)$(INC_DEBUG_INFO)$(INC_SOURCE_LINES)$(OPT_LEVEL_VAL)

# Compiler flags
# -MSF: Short message format
# -DBG: Generate debug info (only in DEBUG mode)
# -pP: PIC32 device prefix
# -HEAP: Heap size in bytes
# -RA: Rebuild all sources
# -DL: Build all files as libraries (set to empty to disable)
# -SSA: Enable SSA optimization
# -EBASE: Exception base address
# -INTDEF: Interrupt settings
# -fo200: Oscillator frequency
# Set to -DL to build as libraries, or empty string to disable
# NOTE: When using -DL, .asm and .lst files will be empty - assembly is in .emcl files
BUILD_AS_LIBS    := -DL
CFLAGS_COMMON    := -MSF -RA $(BUILD_AS_LIBS) -SSA -INTDEF MV_SRS7_IS32 -fo200
ifeq ($(BUILD_CONFIG),DEBUG)
    CFLAGS := $(CFLAGS_COMMON) -DBG -pP$(DEVICE) -HEAP $(HEAP_SIZE) -EBASE $(EBASE_ADDR) $(OPT_LEVEL)
else
    CFLAGS := $(CFLAGS_COMMON) -pP$(DEVICE) -HEAP $(HEAP_SIZE) -EBASE $(EBASE_ADDR) $(OPT_LEVEL)
endif

# Compiler and library paths (mikroC installation)
COMPILER_LOCATION := C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\mikroCPIC32.exe
DEFS_DIR          := C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\Defs
USES_DIR          := C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\Uses

# Convert CURDIR from POSIX to Windows format for mikroC
# $(CURDIR) returns /c/Users/... in MSYS Make, need C:\Users\...
ROOT_DIR_POSIX := $(CURDIR)
ROOT_DIR_FIXED := $(patsubst /c/%,C:/%,$(ROOT_DIR_POSIX))
ROOT_DIR       := $(subst /,\,$(ROOT_DIR_FIXED))

# Project directory structure (absolute Windows paths)
BIN_DIR   := $(ROOT_DIR)\bins
OBJ_DIR   := $(ROOT_DIR)\objs
SRC_DIR   := $(ROOT_DIR)\srcs
INC_DIR   := $(ROOT_DIR)\incs
OTHER_DIR := $(ROOT_DIR)\other

# Export all configuration to srcs/Makefile
export DEVICE MODULE HEAP_SIZE STACK_SIZE EBASE_ADDR BUILD_CONFIG
export GEN_ASM INC_HEX_OPCODES INC_ROM_CONST INC_ROM_ADDR GEN_LST INC_DEBUG_INFO INC_SOURCE_LINES OPT_LEVEL_VAL
export OPT_LEVEL CFLAGS CFLAGS_COMMON BUILD_AS_LIBS
export COMPILER_LOCATION DEFS_DIR USES_DIR
export ROOT_DIR BIN_DIR OBJ_DIR SRC_DIR INC_DIR OTHER_DIR

# Default target
.DEFAULT_GOAL := build

# Setup - copy .mcp32 template if it doesn't exist
setup:
	@if (!(Test-Path "$(SRC_DIR)\$(MODULE).mcp32")) { Copy-Item "C:\Users\Public\Documents\Mikroelektronika\mikroC PRO for PIC32\Examples\Other\USB HID Bootloader MZ EF\Projects\PIC32\USB HID Bootloader.mcp32" -Destination "$(SRC_DIR)\" -Force ; Write-Host "Copied .mcp32 template" }

# Call the srcs Makefile 'build' target (prints only)
build: setup
	$(MAKE) -C srcs build

clean:
	@Write-Host "Cleaning build artifacts..."
	cd objs ; Remove-Item * -Recurse -Force ;
	@Write-Host "Clean complete."
	@Write-Host ""

# Clean + full rebuild
all: clean build
	@echo "######  FULL REBUILD COMPLETE  ########"


# make all the relevant directories
build_dir:
	@Write-Host "Creating build directories..."
	@if (!(Test-Path -Path "$(BIN_DIR)")) { New-Item -ItemType Directory -Path "$(BIN_DIR)" | Out-Null }
	@if (!(Test-Path -Path "$(OBJ_DIR)")) { New-Item -ItemType Directory -Path "$(OBJ_DIR)" | Out-Null }
	@if (!(Test-Path -Path "$(INC_DIR)")) { New-Item -ItemType Directory -Path "$(INC_DIR)" | Out-Null }
	@if (!(Test-Path -Path "$(SRC_DIR)")) { New-Item -ItemType Directory -Path "$(SRC_DIR)" | Out-Null }
	@if (!(Test-Path -Path "$(OTHER_DIR)")) { New-Item -ItemType Directory -Path "$(OTHER_DIR)" | Out-Null }
	@Write-Host "Build directories created."
	@Write-Host ""

