#
# Copyright (c) 2023 Joel Winarske
#

cmake_policy(SET CMP0135 NEW)

include(FetchContent)
include(ExternalProject)

##########################
#
# Configuration
#
##########################

if (NOT CONFIGURATION_FILE)
    set(CONFIGURATION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/configuration.json")
endif ()

if (NOT EXISTS "${CONFIGURATION_FILE}")
    return()
endif ()

message(STATUS "Configuration .......... ${CONFIGURATION_FILE}")

file(READ ${CONFIGURATION_FILE} CONFIGURATION_RAW)

##########################
#
# Global
#
##########################

string(JSON DEPTHAI_BOOTLOADER_VERSION
       GET ${CONFIGURATION_RAW} "bootloader_version")
message(STATUS "Bootloader version ..... ${DEPTHAI_BOOTLOADER_VERSION}")

string(JSON DEPTHAI_DEVICE_SIDE_COMMIT
       GET ${CONFIGURATION_RAW} "device_side_commit")
message(STATUS "Device Side Commit ..... ${DEPTHAI_DEVICE_SIDE_COMMIT}")

string(JSON ARTIFACTORY_URL
       GET ${CONFIGURATION_RAW} "artifactory_url")

##########################
#
# Artifacts
#
##########################

string(JSON JSON_ARTIFACTS GET ${CONFIGURATION_RAW} "artifacts")

##########################
#
# Resource Artifacts
#
##########################

string(JSON JSON_RESOURCES GET ${JSON_ARTIFACTS} "resources")

set(RESOURCE_INDEX 0)
unset(RESOURCE_ERROR)
while(NOT RESOURCE_ERROR)
    string(JSON JSON_RESOURCE ERROR_VARIABLE RESOURCE_ERROR
           GET ${JSON_RESOURCES} ${RESOURCE_INDEX})

    if ("${JSON_RESOURCE}" STREQUAL "${RESOURCE_INDEX}-NOTFOUND")
        break()
    endif()
    math(EXPR RESOURCE_INDEX "${RESOURCE_INDEX}+1")

    string(JSON RESOURCE_NAME
       GET ${JSON_RESOURCE} "name")

    string(JSON RESOURCE_URL
        GET ${JSON_RESOURCE} "url")

    string(REPLACE "\$\{ARTIFACTORY_URL\}"
        "${ARTIFACTORY_URL}"
        RESOURCE_URL ${RESOURCE_URL})

    if (RESOURCE_URL MATCHES "^.*depthai-device-fwp.*$")
        string(REPLACE "\$\{DEPTHAI_DEVICE_SIDE_COMMIT\}"
            "${DEPTHAI_DEVICE_SIDE_COMMIT}"
            RESOURCE_URL ${RESOURCE_URL})
    endif ()

    if (RESOURCE_URL MATCHES "^.*depthai-bootloader-fwp.*$")
        string(REPLACE "\$\{DEPTHAI_BOOTLOADER_VERSION\}"
            "${DEPTHAI_BOOTLOADER_VERSION}"
            RESOURCE_URL ${RESOURCE_URL})
    endif ()

    get_filename_component(FWP_FILENAME ${RESOURCE_URL} NAME)

    string(JSON RESOURCE_SHA256SUM
        GET ${JSON_RESOURCE} "sha256sum")

    message(STATUS "name ................... ${RESOURCE_NAME}")
    message(STATUS "fwp_filename ........... ${FWP_FILENAME}")
    message(STATUS "url .................... ${RESOURCE_URL}")
    message(STATUS "sha256sum .............. ${RESOURCE_SHA256SUM}")

    FetchContent_Declare(
        ${RESOURCE_NAME}
        URL ${RESOURCE_URL}
        URL_HASH SHA256=${RESOURCE_SHA256SUM}
        DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/resources
        DOWNLOAD_NAME ${FWP_FILENAME}
        DOWNLOAD_NO_EXTRACT TRUE
    )
    FetchContent_GetProperties(${RESOURCE_NAME})
    if(NOT ${RESOURCE_NAME}_POPULATED)
        FetchContent_Populate(${RESOURCE_NAME})
    endif()

endwhile()

##########################
#
# Example Artifacts
#
##########################

string(JSON JSON_EXAMPLES GET ${JSON_ARTIFACTS} "examples")

set(EXAMPLE_INDEX 0)
unset(EXAMPLE_ERROR)
while(NOT EXAMPLE_ERROR)
    string(JSON JSON_EXAMPLE ERROR_VARIABLE EXAMPLE_ERROR
           GET ${JSON_EXAMPLES} ${EXAMPLE_INDEX})

    if ("${JSON_EXAMPLE}" STREQUAL "${EXAMPLE_INDEX}-NOTFOUND")
        break()
    endif()
    math(EXPR EXAMPLE_INDEX "${EXAMPLE_INDEX}+1")

    string(JSON EXAMPLE_URL
        GET ${JSON_EXAMPLE} "url")

    string(REPLACE "\$\{ARTIFACTORY_URL\}"
        "${ARTIFACTORY_URL}"
        EXAMPLE_URL ${EXAMPLE_URL})

    get_filename_component(EXAMPLE_NAME ${EXAMPLE_URL} NAME)

    string(JSON EXAMPLE_SHA256SUM
        GET ${JSON_EXAMPLE} "sha256sum")
    
    message(STATUS "name ................... ${EXAMPLE_NAME}")
    message(STATUS "url .................... ${EXAMPLE_URL}")
    message(STATUS "sha256sum .............. ${EXAMPLE_SHA256SUM}")

    FetchContent_Declare(
        ${EXAMPLE_NAME}
        URL ${EXAMPLE_URL}
        URL_HASH SHA256=${EXAMPLE_SHA256SUM}
        DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/examples
        DOWNLOAD_NAME ${EXAMPLE_NAME}
        DOWNLOAD_NO_EXTRACT TRUE
    )
    FetchContent_GetProperties(${EXAMPLE_NAME})
    if(NOT ${EXAMPLE_NAME}_POPULATED)
        FetchContent_Populate(${EXAMPLE_NAME})
    endif()

endwhile()

##########################
#
# Test Artifacts
#
##########################

string(JSON JSON_TESTS GET ${JSON_ARTIFACTS} "tests")

set(TEST_INDEX 0)
unset(TEST_ERROR)
while(NOT TEST_ERROR)
    string(JSON JSON_TEST ERROR_VARIABLE TEST_ERROR
           GET ${JSON_TESTS} ${TEST_INDEX})

    if ("${JSON_TEST}" STREQUAL "${TEST_INDEX}-NOTFOUND")
        break()
    endif()
    math(EXPR TEST_INDEX "${TEST_INDEX}+1")

    string(JSON TEST_URL
        GET ${JSON_TEST} "url")

    string(REPLACE "\$\{ARTIFACTORY_URL\}"
        "${ARTIFACTORY_URL}"
        TEST_URL ${TEST_URL})

    get_filename_component(TEST_NAME ${TEST_URL} NAME)

    string(JSON TEST_SHA256SUM
        GET ${JSON_TEST} "sha256sum")

    message(STATUS "name ................... ${TEST_NAME}")
    message(STATUS "url .................... ${TEST_URL}")
    message(STATUS "sha256sum .............. ${TEST_SHA256SUM}")

    FetchContent_Declare(
        ${TEST_NAME}
        URL ${TEST_URL}
        URL_HASH SHA256=${TEST_SHA256SUM}
        DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/tests
        DOWNLOAD_NAME ${TEST_NAME}
        DOWNLOAD_NO_EXTRACT TRUE
    )
    FetchContent_GetProperties(${TEST_NAME})
    if(NOT ${TEST_NAME}_POPULATED)
        FetchContent_Populate(${TEST_NAME})
    endif()

endwhile()

##########################
#
# Library Dependencies
#
##########################

string(JSON JSON_DEPS GET ${CONFIGURATION_RAW} "dependencies")

set(DEP_INDEX 0)
unset(DEP_ERROR)
while(NOT DEP_ERROR)
    string(JSON JSON_DEP ERROR_VARIABLE DEP_ERROR
           GET ${JSON_DEPS} ${DEP_INDEX})

    if ("${JSON_DEP}" STREQUAL "${DEP_INDEX}-NOTFOUND")
        break()
    endif()
    math(EXPR DEP_INDEX "${DEP_INDEX}+1")

    string(JSON DEP_NAME
       GET ${JSON_DEP} "name")

    string(JSON DEP_URL
        GET ${JSON_DEP} "url")

    string(JSON DEP_SHA1SUM
        GET ${JSON_DEP} "sha1sum")

    message(STATUS "name ................... ${DEP_NAME}")
    message(STATUS "url .................... ${DEP_URL}")
    message(STATUS "sha1sum ................ ${DEP_SHA1SUM}")

    unset(DEP_CMAKE_ARGS)
    unset(DEP_CMAKE_ARGS_SEP)
    unset(DEP_CMAKE_ARGS_ERR)
    string(JSON DEP_CMAKE_ARGS 
        ERROR_VARIABLE DEP_CMAKE_ARGS_ERR 
        GET ${JSON_DEP} "cmake_args")
    if(${DEP_CMAKE_ARGS} STREQUAL "cmake_args-NOTFOUND")
        unset(DEP_CMAKE_ARGS)
    else()
        string(REPLACE "\$\{CMAKE_CURRENT_BINARY_DIR\}"
            "${CMAKE_CURRENT_BINARY_DIR}"
            DEP_CMAKE_ARGS ${DEP_CMAKE_ARGS})
        string(REPLACE " -D" ";-D" DEP_CMAKE_ARGS_SEP ${DEP_CMAKE_ARGS})
        message(STATUS "cmake_args ............. ${DEP_CMAKE_ARGS_SEP}")
    endif()

    unset(DEP_DEPS)
    unset(DEP_DEPS_ERR)
    string(JSON DEP_DEPS 
        ERROR_VARIABLE DEP_DEPS_ERR 
        GET ${JSON_DEP} "dependencies")
    if(${DEP_DEPS} STREQUAL "dependencies-NOTFOUND")
        unset(DEP_DEPS)
    else()
        string(REPLACE "\$\{CMAKE_CURRENT_BINARY_DIR\}"
            "${CMAKE_CURRENT_BINARY_DIR}"
            DEP_DEPS ${DEP_DEPS})
        message(STATUS "dependencies ........... ${DEP_DEPS}")
    endif()

    ExternalProject_Add(${DEP_NAME}
        URL ${DEP_URL}
        URL_HASH SHA1=${DEP_SHA1SUM}
        CMAKE_ARGS
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
            -DCMAKE_VERBOSE_MAKEFILE=${CMAKE_VERBOSE_MAKEFILE}
            -DCMAKE_STAGING_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/staging/usr
            ${DEP_CMAKE_ARGS_SEP}
    )
    if (DEP_DEPS)
        add_dependencies(${DEP_NAME} ${DEP_DEPS})
    endif ()

endwhile()
