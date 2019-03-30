# - Config file for the Zlib package
# It defines the following variables
#  ZLIB_INCLUDE_DIRS - include directories for FooBar
#  ZLIB_LIBRARIES    - libraries to link against
#  ZLIB_LIBRARY_RELEASE - release lib
#  ZLIB_LIBRARY_DEBUG   - debug lib

# Compute paths
get_filename_component(ZLIB_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
string(TOUPPER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_UPPER)

if(WIN32)
    set(_ZLIB_STATIC_LIBNAME "zlibstat.lib")
    set(_ZLIB_STATIC_LIBNAME_DEBUG "zlibstat.lib")
    if (CMAKE_SIZEOF_VOID_P MATCHES "8")
        set(_ZLIB_UTIL_PLAT "x64")
    else()
        set(_ZLIB_UTIL_PLAT "Win32")
    endif()
    if(MSVC_VERSION LESS_EQUAL 1800)
        set(COMPILER "")
    elseif(MSVC_VERSION LESS_EQUAL 1900)
        set(COMPILER "_v140")
        set(_ZLIB_STATIC_LIBNAME "zlibstatic.lib")
        set(_ZLIB_STATIC_LIBNAME_DEBUG "zlibstaticd.lib")
    else()
        set(COMPILER "_v141")
        set(_ZLIB_STATIC_LIBNAME "zlibstatic.lib")
        set(_ZLIB_STATIC_LIBNAME_DEBUG "zlibstaticd.lib")
    endif()
    set(ZLIB_LIBRARY_RELEASE ${ZLIB_CMAKE_DIR}/Release/${_ZLIB_UTIL_PLAT}${COMPILER}/lib/${_ZLIB_STATIC_LIBNAME})
    set(ZLIB_LIBRARY_DEBUG   ${ZLIB_CMAKE_DIR}/Debug/${_ZLIB_UTIL_PLAT}${COMPILER}/lib/${_ZLIB_STATIC_LIBNAME_DEBUG})
else()
    if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
        if("${CMAKE_HOST_SYSTEM_PROCESSOR}" STREQUAL "x86_64")
            set(_ZLIB_UTIL_PLAT "i80386linux")
        endif()
    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "SunOS")
        if("${CMAKE_HOST_SYSTEM_PROCESSOR}" STREQUAL "i386")
            set(_ZLIB_UTIL_PLAT "intelsolaris")
        elseif("${CMAKE_HOST_SYSTEM_PROCESSOR}" STREQUAL "sparc")
            set(_ZLIB_UTIL_PLAT "sparcsolaris")
        endif()
    elseif(${CMAKE_SYSTEM_NAME} STREQUAL "AIX")
        set(_ZLIB_UTIL_PLAT "rs6000aix")
    endif()
    if(NOT APPLE)
        if (CMAKE_SIZEOF_VOID_P MATCHES "8")
            string(APPEND _ZLIB_UTIL_PLAT "_64")
        endif()
    else(NOT APPLE)
        if("${CMAKE_HOST_SYSTEM_PROCESSOR}" STREQUAL "x86_64")
            set(_ZLIB_UTIL_PLAT "Mac")
        else()
            set(_ZLIB_UTIL_PLAT "iPhone")
        endif()
    endif(NOT APPLE)
    set(ZLIB_LIBRARY_RELEASE ${ZLIB_CMAKE_DIR}/Release/${_ZLIB_UTIL_PLAT}/lib/libz.a)
    set(ZLIB_LIBRARY_DEBUG   ${ZLIB_CMAKE_DIR}/Debug/${_ZLIB_UTIL_PLAT}/lib/libz.a)
endif()

set(ZLIB_INCLUDE_DIRS "${ZLIB_CMAKE_DIR}/include")
set(ZLIB_LIBRARIES  ${ZLIB_LIBRARY_${CMAKE_BUILD_TYPE_UPPER}})
set(ZLIB_FOUND TRUE)

set(ZLIB_VERSION_MAJOR 1)
set(ZLIB_VERSION_MINOR 2)
set(ZLIB_VERSION_PATCH 11)
set(ZLIB_VERSION_STRING "${ZLIB_VERSION_MAJOR}.${ZLIB_VERSION_MINOR}.${ZLIB_VERSION_PATCH}")

if(NOT TARGET ZLIB::ZLIB)
    add_library(ZLIB::ZLIB UNKNOWN IMPORTED)
    set_target_properties(ZLIB::ZLIB PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIRS}")

    if(ZLIB_LIBRARY_RELEASE)
        set_property(TARGET ZLIB::ZLIB APPEND PROPERTY
            IMPORTED_CONFIGURATIONS RELEASE)
        set_target_properties(ZLIB::ZLIB PROPERTIES
            IMPORTED_LOCATION_RELEASE "${ZLIB_LIBRARY_RELEASE}")
    endif()

    if(ZLIB_LIBRARY_DEBUG)
        set_property(TARGET ZLIB::ZLIB APPEND PROPERTY
            IMPORTED_CONFIGURATIONS DEBUG)
        set_target_properties(ZLIB::ZLIB PROPERTIES
            IMPORTED_LOCATION_DEBUG "${ZLIB_LIBRARY_DEBUG}")
    endif()
endif()
unset(_ZLIB_UTIL_PLAT)
unset(_ZLIB_STATIC_LIBNAME)
unset(_ZLIB_STATIC_LIBNAME_DEBUG)
 