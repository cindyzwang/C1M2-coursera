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
PLATFORM = $(PLATFORM)

# Architectures Specific Flags
LINKER_FILE = ../msp432p401r.lds
CPU = cortex-m0plus
ARCH = thumb
SPECS = nosys.specs

# Compiler Flags and Defines
CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
LDFLAGS = -Wl,-Map=$(PLATFORM).map -T $(LINKER_FILE)
CFLAGS = -mcpu=$(CPU) -m$(ARCH) --specs=$(SPECS) -Wall -I $(INCLUDES)
CPPFLAGs = -mcpu=$(CPU) -m$(ARCH) --specs=$(SPECS) -Wall

TARGET = main
OBJS = $(SOURCES:.c=.o)

%.o : %.c
	$(CC) -c $< $(CFLAGS) -o $@

.PHONY: build
build: all

.PHONY: all
all: $(TARGET).out

$(TARGET).out: $(OBJS)
	$(CC) $(OBJS) $(CFLAGS) $(LDFLAGS) -o $@

.PHONY: clean
clean:
	rm -f $(OBJS) $(TARGET).out $(TARGET).map
