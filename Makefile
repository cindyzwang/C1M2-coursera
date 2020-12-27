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

TARGET = c1m2

# Platform Overrides
PLATFORM := $(PLATFORM)

# Architectures Specific Flags
LINKER_FILE = msp432p401r.lds
CPU = cortex-m4
INSTRUCTIONS = thumb
ARCH = armv7e-m
SPECS = nosys.specs
FLOAT = hard
FPU = fpv4-sp-d16

# Compiler Flags and Defines
LDFLAGS = -Wl,-Map=$(TARGET).map
CFLAGS = -g -Wall # Compiler flags

ifeq ($(PLATFORM), HOST)
	INCLUDES := -I $(firstword $(INCLUDES))
	CC = gcc
else
	INCLUDES := $(foreach inc, $(INCLUDES), -I $(inc))
	CC = arm-none-eabi-gcc
	LDFLAGS += -T$(LINKER_FILE)
	CFLAGS += -mcpu=$(CPU) -m$(INSTRUCTIONS) --specs=$(SPECS) -march=$(ARCH) -mfloat-abi=$(FLOAT) -mfpu=$(FPU)
endif
CPPFLAGS = -std=c99 -D$(PLATFORM) $(INCLUDES) -Werror # C-Preprocessor flags


# Preprocess
%.i: %.c
	$(CC) $(CPPFLAGS) -E -o $@ $<

# Compile
%.asm: %.i
	$(CC) $(CFLAGS) -S -o $@ $<

# Assemble
%.o: %.c %.h
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

# Dependencies
# Taken from GNU Manual https://www.gnu.org/software/make/manual/make.html#Pattern-Examples
%.d: %.c
	@set -e; rm -f $@; \
		$(CC) -M $(CPPFLAGS) $< > $@.$$$$; \
		sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
		rm -f $@.$$$$

# Compile all object files but do not link
.PHONY: compile-all
compile-all: $(SOURCES:.c=.d) $(SOURCES:.c=.o)

# Compile all object files and link into a final executable
.PHONY: link
link:
	$(CC) $(LDFLAGS) $(CFLAGS) -o $(TARGET).out $(SOURCES:.c=.o)

.PHONY: build
build: compile-all link $(SOURCES:.c=.o)
	size $(TARGET).out

.PHONY: clean
clean:
	rm -f $(SOURCES:.c=.o) $(SOURCES:.c=.i) $(SOURCES:.c=.asm) $(SOURCES:.c=.out) $(SOURCES:.c=.d) $(TARGET).out $(TARGET).map
