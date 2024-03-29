#
# Copyright (c) 2014-present, The osquery authors
#
# This source code is licensed as defined by the LICENSE file found in the
# root directory of this source tree.
#
# SPDX-License-Identifier: (Apache-2.0 OR GPL-2.0-only)
#

set(OSQUERY_PACKAGE_RELEASE "1.linux")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}_${OSQUERY_PACKAGE_RELEASE}_${CMAKE_SYSTEM_PROCESSOR}")

set(OSQUERY_SOURCE_DIRECTORY_LIST "" CACHE PATH "osquery source and build folders")

if(NOT "${OSQUERY_SOURCE_DIRECTORY_LIST}" STREQUAL "")
  set(CPACK_BUILD_SOURCE_DIRS "${OSQUERY_SOURCE_DIRECTORY_LIST}")

  message(STATUS "OSQUERY_SOURCE_DIRECTORY_LIST was set, enabling debug packages")
else()
  message(STATUS "OSQUERY_SOURCE_DIRECTORY_LIST was not set, disabling debug packages")
endif()

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "/opt/osquery" CACHE PATH "" FORCE)
endif()

if(NOT CPACK_PACKAGING_INSTALL_PREFIX)
  set(CPACK_PACKAGING_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
endif()


install(
  FILES
    "${OSQUERY_DATA_PATH}/opt/osquery/bin/osqueryd"
    "${OSQUERY_DATA_PATH}/opt/osquery/bin/osqueryctl"
  
  DESTINATION
    "bin"

  COMPONENT
    osquery

  PERMISSIONS
    OWNER_READ OWNER_WRITE OWNER_EXECUTE
    GROUP_READ             GROUP_EXECUTE
    WORLD_READ             WORLD_EXECUTE 
)

install(
  FILES
    "${VISTAR_DATA_PATH}/vistar"
  DESTINATION
    "bin"
  COMPONENT
    osquery
  PERMISSIONS
    OWNER_READ OWNER_WRITE OWNER_EXECUTE
    GROUP_READ             GROUP_EXECUTE
    WORLD_READ             WORLD_EXECUTE 


)

install(
  FILES
    "${VISTAR_DATA_PATH}/Vistar.desktop"
  DESTINATION
    "/usr/share/applications"
  
  COMPONENT
    osquery

  PERMISSIONS
    OWNER_READ OWNER_WRITE OWNER_EXECUTE
    GROUP_READ             GROUP_EXECUTE
    WORLD_READ             WORLD_EXECUTE
)

execute_process(
  COMMAND "${CMAKE_COMMAND}" -E create_symlink "/opt/osquery/bin/osqueryd" osqueryi
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)

execute_process(
  COMMAND "${CMAKE_COMMAND}" -E create_symlink "/opt/osquery/bin/osqueryctl" osqueryctl
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)

execute_process(
  COMMAND "${CMAKE_COMMAND}" -E create_symlink "/opt/osquery/bin/osqueryd" osqueryd
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)
execute_process(
  COMMAND "${CMAKE_COMMAND}" -E create_symlink "/opt/osquery/bin/vistar" vistar
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)

install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/osqueryi"
    "${CMAKE_CURRENT_BINARY_DIR}/osqueryctl"
    "${CMAKE_CURRENT_BINARY_DIR}/osqueryd"
    "${CMAKE_CURRENT_BINARY_DIR}/vistar"

  
  DESTINATION
    "/usr/bin/"
  
  COMPONENT
    osquery
)



install(
  DIRECTORY "${OSQUERY_DATA_PATH}/opt/osquery/share/osquery"
  DESTINATION "share"
  COMPONENT osquery
)

install(
  DIRECTORY
  DESTINATION "/etc/osquery"
  COMPONENT osquery
)

install(
  DIRECTORY
  DESTINATION "/var/osquery"
  COMPONENT osquery
)

install(
  DIRECTORY
  DESTINATION "/var/log/osquery"
  COMPONENT osquery
)

add_custom_target(
    COMMAND /bin/sh ${VISTAR_DATA_PATH}/wrapper.sh 
)

################

# Define the installation path for the profile script
set(PROFILE_INSTALL_PATH "$ENV{HOME}/.profile")

# Define the environment variable to be added
set(ENV_VAR "QT_QPA_PLATFOR=waylan")

# Create a script to append the environment variable to ~/.profile
file(WRITE "${CMAKE_BINARY_DIR}/update_profile.sh" "#!/bin/bash\n")
file(APPEND "${CMAKE_BINARY_DIR}/update_profile.sh" "echo 'export ${ENV_VAR}' >> ${PROFILE_INSTALL_PATH}\n")

# Set execute permissions for the script
execute_process(COMMAND chmod +x "${CMAKE_BINARY_DIR}/update_profile.sh")

# Install the profile script
install(
    FILES "${CMAKE_BINARY_DIR}/update_profile.sh"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/bin"
    PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_EXECUTE GROUP_READ WORLD_EXECUTE WORLD_READ
    COMPONENT osquery
)

# Execute the script during installation
install(
    CODE "execute_process(COMMAND ${CMAKE_INSTALL_PREFIX}/bin/update_profile.sh)"
    COMPONENT osquery
)

