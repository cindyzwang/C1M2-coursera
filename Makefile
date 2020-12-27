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
CFLAGS = -g -Wall # Compiler flags
CPPFLAGS = -std=c99 -D$(PLATFORM) -I $(INCLUDES) # C-Preprocessor flags

TARGET = c1m2

# Preprocess
%.i: %.c
	$(CC) $(CPPFLAGS) -E -o $@ $<

# Compile
%.asm: %.i
	$(CC) $(CFLAGS) -S -o $@ $<

# Assemble
%.o: %.c %.h
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

# Link
%.d: %.o
	$(CC) -M $(CPPFLAGS) $< > $@

# Compile all object files but do not link
.PHONY: compile-all
compile-all: $(SOURCES:.c=.o)

# Compile all object files and link into a final executable
.PHONY: build
build: $(SOURCES:.c=.o)
	$(CC) -g -o $(TARGET).exe $(SOURCES:.c=.o)

.PHONY: clean
clean:
	rm -f $(SOURCES:.c=.o) $(SOURCES:.c=.i) $(SOURCES:.c=.asm) $(SOURCES:.c=.out) $(SOURCES:.c=.d) $(TARGET).out $(TARGET).exe
