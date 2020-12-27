#******************************************************************************
# Copyright (C) 2017 by Alex Fosdick - University of Colorado
#
# Redistribution, modification or use of this software in source or binary
# forms is permitted as long as the files maintain this copyright. Users are 
# permitted to modify this and use it to learn about the field of embedded
# software. Alex Fosdick and the University of Colorado are not liable for any
# misuse of this material. 
#
#*****************************************************************************

#------------------------------------------------------------------------------
# <Put a Description Here>
#
# Use: make [TARGET] [PLATFORM-OVERRIDES]
#
# Build Targets:
#      <Put a description of the supported targets here>
#
# Platform Overrides:
#      <Put a description of the supported Overrides here
#
#------------------------------------------------------------------------------
include sources.mk

# Platform Overrides
PLATFORM := $(PLATFORM)

# Architectures Specific Flags
LINKER_FILE = ../msp432p401r.lds
CPU = cortex-m4
ARCH = thumb
SPECS = nosys.specs

# Compiler Flags and Defines
ifeq ($(PLATFORM), HOST)
	CC = gcc
	INCLUDES := $(firstword $(INCLUDES))
else
	CC = arm-none-eabi-ld
endif
LDFLAGS = -Wl,-Map=$(PLATFORM).map -T $(LINKER_FILE)  # Linker flags
CFLAGS = -std=c99  # C-programming flags for gcc
CPPFLAGS = -I $(INCLUDES) -D$(PLATFORM) # C-Preprocessor flags

OUTPUT = c1m2.out

%.i: %.c
	$(CC) $(CPPFLAGS) -E -o $@ $<

%.asm: %.c
	$(CC) $(CPPFLAGS) -S -o $@ $<

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

.PHONY: compile-all
compile-all:
	$(foreach var, $(SOURCES), $(CC) -c $(CFLAGS) $(CPPFLAGS) -o $(var:.c=.out) $(var);)

.PHONY: build
build:
	$(CC) $(CFLAGS) $(CPPFLAGS)-o $(OUTPUT) $(SOURCES) 

.PHONY: clean
clean:
	rm -f $(SOURCES:.c=.o) $(SOURCES:.c=.i) $(SOURCES:.c=.asm) $(SOURCES:.c=.out) $(OUTPUT)
