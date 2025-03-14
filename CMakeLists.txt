cmake_minimum_required(VERSION 3.10)
project(FileMonitor)

set(CMAKE_CXX_STANDARD 17)

find_package(google_cloud_cpp_storage REQUIRED)

add_executable(FileMonitor src/main.cpp)
target_link_libraries(FileMonitor PUBLIC google-cloud-cpp::storage)