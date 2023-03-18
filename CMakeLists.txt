#
# Copyright (c) 2023 Joel Winarske
#

cmake_minimum_required(VERSION 3.18)

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: Debug, Release, or MinSizeRel." FORCE)
    message(STATUS "CMAKE_BUILD_TYPE not set, defaulting to Release.")
endif ()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

project(cmake_json
        DESCRIPTION "cmake_json example"
        VERSION "0.1.0"
        LANGUAGES CXX C)

set(PROJECT_ROOT ${CMAKE_CURRENT_SOURCE_DIR})

message(STATUS "Project ................ ${PROJECT_NAME}")
message(STATUS "Version ................ ${PROJECT_VERSION}")
message(STATUS "Generator .............. ${CMAKE_GENERATOR}")
message(STATUS "Build Type ............. ${CMAKE_BUILD_TYPE}")

find_package(OpenCV CONFIG QUIET)
if (OpenCV_FOUND)
    message(STATUS "OpenCV Version ......... ${OpenCV_VERSION}")
endif ()

include(general)
include(options)
include(configuration)

if (NOT CMAKE_CROSSCOMPILING)
    include(packaging)
endif ()
