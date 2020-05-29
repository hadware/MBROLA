cmake_minimum_required(VERSION 3.9)
project(MBROLA)

add_definitions(-DLITTLE_ENDIAN -DDEBUG -DSIGNAL)

add_executable(mbrola
        synth.c
        parser/fifo.c
        parser/input_fifo.c
        parser/input_file.c
        parser/parser_input.c
        parser/phonbuff.c
        parser/phone.c
        misc/audio.c
        misc/common.c
        misc/g711.c
        misc/mbralloc.c
        misc/vp_error.c
        engine/diphone.c
        engine/mbrola.c
        database/database.c
        database/database_old.c
        database/diphone_info.c
        database/hash_tab.c
        database/little_big.c
        database/zstring_list.c
        )

# including the stdlibs
target_link_libraries(mbrola m)

