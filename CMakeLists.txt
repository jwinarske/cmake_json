#
# Copyright (c) 2023 Joel Winarske
#

cmake_minimum_required(VERSION 3.18)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

project(cmake_json VERSION "0.1.0" LANGUAGES CXX C)

set(PROJECT_ROOT ${CMAKE_CURRENT_SOURCE_DIR})

include(general)
include(options)
include(configuration)
