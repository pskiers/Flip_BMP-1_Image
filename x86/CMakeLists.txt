cmake_minimum_required(VERSION 3.9)
project(flipdiagbmp1)
enable_language(ASM_NASM)

set(CMAKE_ASM_NASM_OBJECT_FORMAT elf)
set(CMAKE_ASM_NASM_COMPILE_OBJECT "<CMAKE_ASM_NASM_COMPILER> <INCLUDES> <FLAGS> -f ${CMAKE_ASM_NASM_OBJECT_FORMAT} -o <OBJECT> <SOURCE>")

set(CMAKE_C_COMPILER gcc)
set(CMAKE_C_FLAGS -m32)
set(CMAKE_CXX_COMPILER g++)
set(CMAKE_CXX_FLAGS -m32)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)

set_source_files_properties(flipdiagbmp1.asm PROPERTIES COMPILE_FLAGS "-g -Fdwarf")

add_executable(
    main
    main.c
    flipdiagbmp1.asm
)

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/.gdbinit DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/../images DESTINATION ${CMAKE_CURRENT_BINARY_DIR})