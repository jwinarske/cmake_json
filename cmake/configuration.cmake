#
# Copyright (c) 2023 Joel Winarske
#

if (PROJECT_USE_SYS_LIBS)
    message(STATUS "System Libraries ....... TRUE")
    message(STATUS "Local Libraries ........ FALSE")
    include(get_configuration_system)
else()
    message(STATUS "System Libraries ....... FALSE")
    message(STATUS "Local Libraries ........ TRUE")
    include(get_configuration_json)
endif()
