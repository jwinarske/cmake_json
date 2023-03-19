#
# Copyright (c) 2023 Joel Winarske
#

find_package(BZip2 CONFIG REQUIRED)

find_package(FP16 CONFIG REQUIRED)

find_package(archive_static CONFIG REQUIRED)

find_package(ZLIB CONFIG REQUIRED)

find_package(spdlog CONFIG REQUIRED)

if(PROJECT_ENABLE_BACKWARD)
    # Disable automatic check for additional stack unwinding libraries
    # Just use the default compiler one
    set(STACK_DETAILS_AUTO_DETECT FALSE CACHE BOOL "Auto detect backward's stack details dependencies")
    find_package(Backward CONFIG REQUIRED)
    unset(STACK_DETAILS_AUTO_DETECT)
endif()
