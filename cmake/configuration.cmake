#
# Copyright (c) 2023 Joel Winarske
#

if (PROJECT_USE_SYS_LIBS)
    message(STATUS "Using System Libraries")
else()
    include(get_configuration_json)
endif()
