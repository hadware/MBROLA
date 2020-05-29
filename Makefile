# BEGIN_COMM <- flags parenthesize what goes in the commercial Makefile (awk strips)
# BEGIN_WWW  <- flags parenthesize what goes in the Web Makefile (stripped by awk below)
# Mbrola Speech Synthesize Makefile ( tune the #define and type "make" )
VERSION=3.4-dev

# To test strict C ANSI compliance
CC = gcc -ansi -pedantic
LIB= -lm

# This allow you to write commands like "make PURE=purify demo1"
# or "make PURE=quantify lib2"
CCPURE = $(PURE) $(CC)

########################
# Machine specific #define, uncomment as needed
# If your OS is not here, may be it provides some __linux or __sunos
# that are used in misc/common.h If compiling fails see that file

#CFLAGS += -DTARGET_OS_DOS
#CFLAGS += -DTARGET_OS_SUN4
#CFLAGS += -DTARGET_OS_VMS
#CFLAGS += -DTARGET_OS_MAC

# See below for BEOS
# CFLAGS += -DTARGET_OS_BEOS

# If endianess of your machine is not automatically detected in misc/common.h
# you should manually specify here
CFLAGS += -DLITTLE_ENDIAN
#CFLAGS += -DBIG_ENDIAN

#######################
# GENERAL FLAGS FOR GCC

# Optimized code
CFLAGS += -O6

# Debug mode with gdb
#CFLAGS += -g 

# Print MANY debug information on stdout
CFLAGS += -DDEBUG

# For testing hash_table performances
#CFLAGS += -DDEBUG_HASH

#Include directories
CFLAGS += -IParser -IStandalone -IMisc -ILibOneChannel -ILibMultiChannel -IEngine -IDatabase

# Flags for GCC
CFLAGS += -Wall
# CFLAGS += -fhandle-exceptions

COMMONSRCS = Engine/mbrola.c Engine/diphone.c Parser/phone.c Parser/parser_input.c Parser/input_file.c Parser/phonbuff.c Misc/audio.c Misc/vp_error.c Misc/mbralloc.c Misc/common.c Database/database.c Database/database_old.c Database/diphone_info.c Database/little_big.c Database/hash_tab.c Database/zstring_list.c

COMMONCHDRS = Engine/mbrola.h Engine/diphone.h Parser/phone.h Parser/parser.h Parser/input_file.h Parser/input.h Parser/phonbuff.h Misc/incdll.h Misc/audio.h Misc/vp_error.h Misc/mbralloc.h Misc/common.h Database/database.h Database/database_old.h Database/diphone_info.h Database/little_big.h Database/hash_tab.h Database/phoname_list.h


######################################################
# ROM SECTION
#

# Uncomment if you want a pure rom access, that is NO FILE AT ALL
# Note that this mode is incompatible with ROMDATABASE_STORE as it
# requires files for this operation !
# CFLAGS += -DROMDATABASE_PURE

# Uncomment if you wish to save .rom images from regular diphone databases
#CFLAGS += -DROMDATABASE_STORE

# Uncomment if you wish to use init_ROM_Database(ROM_pointer)
#CFLAGS += -DROMDATABASE_INIT

# Uncomment to cope with ROMDATABASE_STORE or ROMDATABASE_INIT
COMMONSRCS += Database/rom_handling.c Database/rom_database.c


# Signal handling of the standalone version (Unix platforms)
CFLAGS += -DSIGNAL

# Add external cflags
CFLAGS += $(EXT_CFLAGS)

# BEGIN_COMM
BINSRCS = Standalone/synth.c $(COMMONSRCS)
BINHDRS = Standalone/synth.h $(COMMONHDRS)

LIBSRCS = Misc/g711.c Parser/input_fifo.c Parser/fifo.c $(COMMONSRCS)
LIBHDRS = Misc/g711.h Parser/input_fifo.h Parser/fifo.h $(COMMONHDRS)

MBRDIR = ./Bin
BINDIR = ./Bin/Standalone
LIBDIR = ./Bin/LibOneChannel

BINOBJS = $(BINSRCS:%.c=Bin/Standalone/%.o)

PROJ = mbrola

$(PROJ): install_dir  $(BINOBJS) 
	$(CCPURE) $(CFLAGS) -o $(MBRDIR)/$(PROJ) $(BINOBJS) $(LIB)	

clean:
	\rm -f $(MBRDIR)/$(PROJ) $(PROJ).a core demo* TAGS $(BIN)/lib*.o $(BINOBJS) 
	\rm -rf VisualC++/DLL/output VisualC++/DLL/mbroladl VisualC++/DLL/mbroladll.ncb VisualC++/DLL/mbroladll.opt VisualC++/DLL/*.plg .sb
	\rm -rf VisualC++/Standalone/output VisualC++/Standalone/mbroladl VisualC++/Standalone/mbrola.ncb VisualC++/Standalone/mbrola.opt VisualC++/Standalone/*.plg .sb
	\rm -rf  delexsend$(VERSION) send$(VERSION) mbr$(VERSION)
	\rm -rf doc.txt

spotless: clean net
	\rm -rf Bin

tags:
	etags */*{c,h}

net:
	\rm -f *~ */*~

$(BINDIR)/%.o: %.c
	$(CCPURE) $(CFLAGS) -o $@ -c $<

# to create the compilation directory, if necessary
install_dir: 
	if [ ! -d Bin/Standalone ]; then \
	mkdir Bin ; mkdir Bin/LibOneChannel; mkdir Bin/LibMultiChannel ; mkdir Bin/Standalone ; mkdir Bin/Standalone/Standalone ; mkdir Bin/Standalone/Parser ;	mkdir Bin/Standalone/Engine ;	mkdir Bin/Standalone/Database ;	mkdir Bin/Standalone/Misc; \
	fi