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
find_path(FIX8_INCLUDE_DIR NAMES fix8/f8config.hpp PATHS /usr/local/include /usr/include)
find_library(FIX8_LIBRARY NAMES fix8 PATHS /usr/local/lib /usr/lib)

if(NOT FIX8_INCLUDE_DIR OR NOT FIX8_LIBRARY)
    message(FATAL_ERROR "Fix8 library not found. Please install Fix8 first.")
endif()

include_directories(${Boost_INCLUDE_DIRS})
include_directories(${FIX8_INCLUDE_DIR})

add_executable(fill_sim src/fill_sim.cpp)
target_link_libraries(fill_sim ${FIX8_LIBRARY})

add_executable(test_smoke tests/test_smoke.cpp)
target_link_libraries(test_smoke ${FIX8_LIBRARY})
