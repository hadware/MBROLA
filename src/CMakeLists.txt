cmake_minimum_required(VERSION 3.9)
project(MBROLA)

set(MBROLA_FLAGS -DBIG_ENDIAN -DROMDATABASE_PURE -DDEBUG)

add_executable(mbrola
        synth.c
        Parser/fifo.c
        Parser/input_fifo.c
        Parser/input_file.c
        Parser/parser_input.c
        Parser/phonbuff.c
        Parser/phone.c
        Misc/audio.c
        Misc/common.c
        Misc/g711.c
        Misc/mbralloc.c
        Misc/vp_error.c
        Engine/diphone.c
        Engine/mbrola.c
        Database/database.c
        Database/database_old.c
        Database/diphone_info.c
        Database/hash_tab.c
        Database/little_big.c
        Database/zstring_list.c
        )

# including the stdlibs
target_link_libraries(mbrola m)

#setting up compile flags
set_target_properties(mbrola PROPERTIES COMPILE_FLAGS ${MBROLA_FLAGS})

