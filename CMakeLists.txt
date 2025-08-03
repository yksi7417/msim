cmake_minimum_required(VERSION 3.10)
project(fix8_fill_sim)

set(CMAKE_CXX_STANDARD 17)

find_package(Boost REQUIRED)
find_package(OpenSSL REQUIRED)

include_directories(${Boost_INCLUDE_DIRS})
include_directories(/usr/local/include)
link_directories(/usr/local/lib)

add_executable(fill_sim src/fill_sim.cpp)
target_link_libraries(fill_sim fix8)

add_executable(test_smoke tests/test_smoke.cpp)
target_link_libraries(test_smoke fix8)
