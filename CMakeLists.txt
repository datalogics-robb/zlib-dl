cmake_minimum_required(VERSION 2.8)
project(conanzlib)

message(STATUS "Conan CMake Wrapper")
include(conanbuildinfo.cmake)
conan_basic_setup()

if(WIN32)
  # definitions based on modify-zlib-build.patch
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /EHsc")
  add_definitions(-DUNICODE -D_UNICODE)
endif()

include_directories(${CMAKE_SOURCE_DIR}/source_subfolder)
add_subdirectory("source_subfolder")
