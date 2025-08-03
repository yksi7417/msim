cmake_minimum_required(VERSION 3.10)
project(fix8_fill_sim)

set(CMAKE_CXX_STANDARD 17)

# Suppress specific warnings as documented in doc/ignored_warnings.md
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    add_compile_options(
        -Wno-class-memaccess    # Safe memcpy usage on POD-like structures
        -Wno-unused-result      # Ignored std::string::empty() results in regex utils
        -Wno-overloaded-virtual # Fix8 Router virtual function hiding
        -Wno-deprecated-declarations # pthread_yield deprecation in Fix8
    )
endif()

find_package(Boost REQUIRED)
find_package(OpenSSL REQUIRED)

# Find Fix8 library
if(WIN32)
    # On Windows, look for Fix8 in the build directory first
    find_path(FIX8_INCLUDE_DIR NAMES fix8/f8config.hpp PATHS 
        ${CMAKE_SOURCE_DIR}/fix8/include 
        ${CMAKE_SOURCE_DIR}/fix8/src
        C:/fix8/include
        ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include)
    find_library(FIX8_LIBRARY NAMES fix8 libfix8 PATHS 
        ${CMAKE_SOURCE_DIR}/fix8/lib
        ${CMAKE_SOURCE_DIR}/fix8/Release
        ${CMAKE_SOURCE_DIR}/fix8/x64/Release
        C:/fix8/lib
        ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib)
else()
    # On Unix-like systems
    find_path(FIX8_INCLUDE_DIR NAMES fix8/f8config.hpp PATHS /usr/local/include /usr/include)
    find_library(FIX8_LIBRARY NAMES fix8 PATHS /usr/local/lib /usr/lib)
endif()

# Handle Fix8 availability
if(FIX8_INCLUDE_DIR AND FIX8_LIBRARY)
    message(STATUS "Fix8 found: ${FIX8_INCLUDE_DIR}, ${FIX8_LIBRARY}")
    add_definitions(-DFIX8_AVAILABLE)
    include_directories(${FIX8_INCLUDE_DIR})
    set(FIX8_LINK_LIBRARIES ${FIX8_LIBRARY})
else()
    if(WIN32)
        message(WARNING "Fix8 library not found. Using stub implementation for Windows development.")
        include_directories(${CMAKE_SOURCE_DIR}/include)
        set(FIX8_LINK_LIBRARIES "")  # No libraries to link
    else()
        message(FATAL_ERROR "Fix8 library not found. Please install Fix8 first.")
    endif()
endif()

include_directories(${Boost_INCLUDE_DIRS})
include_directories(${FIX8_INCLUDE_DIR})

add_executable(fill_sim src/fill_sim.cpp)
target_link_libraries(fill_sim ${FIX8_LINK_LIBRARIES})

add_executable(test_smoke tests/test_smoke.cpp)
target_link_libraries(test_smoke ${FIX8_LINK_LIBRARIES})
