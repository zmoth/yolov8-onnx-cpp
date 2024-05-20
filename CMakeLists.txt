CMAKE_MINIMUM_REQUIRED(VERSION 3.0.0)
project(YOLOv8CPP)

SET(CMAKE_CXX_STANDARD 17)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- Configure your project files ---
include_directories(include) # Include your header files directory

# Recursively collect all source files under 'src' directory
file(GLOB_RECURSE CURR_SOURCES src/*.cpp)

# Create the executable
add_executable(YOLOv8CPP ${CURR_SOURCES})

find_package(OpenCV REQUIRED)

if(NOT OpenCV_FOUND)
        message(FATAL_ERROR "[${PROJECT_NAME}] OpenCV found failed")
endif()

message(STATUS "[${PROJECT_NAME}] OpenCV_VERSION: ${OpenCV_VERSION}, OpenCV_DIR: ${OpenCV_DIR}")

include_directories(${OpenCV_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS})

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/fetch/onnx.cmake)
