cmake_minimum_required(VERSION 3.10)
project(fix8_fill_sim)

set(CMAKE_CXX_STANDARD 17)

# Suppress specific warnings as documented in doc/ignored_warnings.md
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    add_compile_options(
        -Wno-class-memaccess    # Safe memcpy usage on POD-like structures
        -Wno-unused-result      # Ignored std::string::empty() results in regex utils
    )
endif()

find_package(Boost REQUIRED)
find_package(OpenSSL REQUIRED)

include_directories(${Boost_INCLUDE_DIRS})
include_directories(/usr/local/include)
link_directories(/usr/local/lib)

add_executable(fill_sim src/fill_sim.cpp)
target_link_libraries(fill_sim fix8)

add_executable(test_smoke tests/test_smoke.cpp)
target_link_libraries(test_smoke fix8)
