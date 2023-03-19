
#
# Threads
#

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

#
# Sanitizers
#

find_package(Sanitizers)

#
# OpenCV
#

find_package(OpenCV  ${_QUIET} CONFIG)
if (OpenCV_FOUND)
    message(STATUS "OpenCV Version ......... ${OpenCV_VERSION}")
endif ()


#
# BZip2 (for bspatch)
#
find_package(BZip2 ${_QUIET} CONFIG REQUIRED
        PATHS ${STAGING_SYSROOT})
if (BZip2_FOUND)
    message(STATUS "BZip2 Version .......... ${BZip2_VERSION}")
endif ()

#
# FP16 for conversions
#
find_package(FP16 ${_QUIET} CONFIG REQUIRED
        PATHS ${STAGING_SYSROOT})
if (FP16_FOUND)
    message(STATUS "FP16 Version .,......... ${BZip2_VERSION}")
endif ()

#
# libarchive for firmware packages
#
find_package(archive_static ${_QUIET} CONFIG REQUIRED
        PATHS ${STAGING_SYSROOT})
if (archive_static_FOUND)
    message(STATUS "archive_static ......... ${archive_static_VERSION}")
endif ()

#
# ZLIB for compressing Apps
#
find_package(ZLIB ${_QUIET} CONFIG REQUIRED
        PATHS ${STAGING_SYSROOT})
if (ZLIB_FOUND)
    message(STATUS "ZLIB ................... ${ZLIB_VERSION}")
endif ()

#
# spdlog for library and device logging
#
find_package(spdlog ${_QUIET} CONFIG REQUIRED
        PATHS ${STAGING_SYSROOT})
if (spdlog_FOUND)
    message(STATUS "spdlog ................. ${spdlog_VERSION}")
endif ()

#
# Backward
#
if(DEPTHAI_ENABLE_BACKWARD)
    # Disable automatic check for additional stack unwinding libraries
    # Just use the default compiler one
    set(STACK_DETAILS_AUTO_DETECT FALSE CACHE BOOL "Auto detect backward's stack details dependencies")
    find_package(Backward ${_QUIET} CONFIG REQUIRED
            PATHS ${STAGING_SYSROOT})
    if (Backward_FOUND)
        message(STATUS "Backward ............... ${Backward_VERSION}")
    endif ()
    unset(STACK_DETAILS_AUTO_DETECT)
endif()

# Nlohmann JSON
find_package(nlohmann_json 3.6.0 ${_QUIET} CONFIG REQUIRED
        PATHS ${STAGING_SYSROOT})
if (nlohmann_json_FOUND)
    message(STATUS "nlohmann_json .......... ${nlohmann_json_VERSION}")
endif ()

# libnop for serialization
find_package(libnop ${_QUIET} CONFIG REQUIRED
        PATHS ${STAGING_SYSROOT})
if (libnop_FOUND)
    message(STATUS "libnop ................. ${libnop_VERSION}")
endif ()
