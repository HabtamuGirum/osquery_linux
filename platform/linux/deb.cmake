#
# Copyright (c) 2014-present, The osquery authors
#
# This source code is licensed as defined by the LICENSE file found in the
# root directory of this source tree.
#
# SPDX-License-Identifier: (Apache-2.0 OR GPL-2.0-only)
#

set(CPACK_STRIP_FILES ON)
set(CPACK_DEBIAN_OSQUERY_PACKAGE_NAME "${CPACK_PACKAGE_NAME}")
set(CPACK_DEBIAN_PACKAGE_RELEASE "${OSQUERY_PACKAGE_RELEASE}")
set(CPACK_DEBIAN_OSQUERY_FILE_NAME "DEB-DEFAULT")
set(CPACK_DEBIAN_PACKAGE_PRIORITY "extra")
set(CPACK_DEBIAN_PACKAGE_SECTION "default")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6 (>=2.12), zlib1g")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "${CPACK_PACKAGE_HOMEPAGE_URL}")
set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${VISTAR_DATA_PATH}/osquery_linux/osquery_linux/workspace/package_data/control/deb/conffiles;${VISTAR_DATA_PATH}/osquery_linux/osquery_linux/workspace/package_data/control/postinst")


if(DEFINED OSQUERY_SOURCE_DIRECTORY_LIST)
  set(CPACK_DEB_COMPONENT_INSTALL ON)
  set(CPACK_DEBIAN_DEBUGINFO_PACKAGE ON)
endif()

install(
  FILES "${VISTAR_DATA_PATH}/Resources/vistar.png"
  DESTINATION "/usr/share/icons/hicolor/scalable/apps"
  COMPONENT osquery
)

install(
  FILES "${VISTAR_DATA_PATH}/osquery_linux/osquery_linux/workspace/package_data/control/deb/lib/systemd/system/osqueryd.service"
  DESTINATION "/usr/lib/systemd/system"
  COMPONENT osquery
)

install(
  FILES "${VISTAR_DATA_PATH}/osquery_linux/osquery_linux/workspace/package_data/control/deb/etc/init.d/osqueryd"
  DESTINATION "/etc/init.d"
  COMPONENT osquery

  PERMISSIONS
    OWNER_READ OWNER_WRITE OWNER_EXECUTE
    GROUP_READ             GROUP_EXECUTE
    WORLD_READ             WORLD_EXECUTE
)

install(
  FILES "${VISTAR_DATA_PATH}/osquery_linux/osquery_linux/workspace/package_data/control/deb/etc/default/osqueryd"
  DESTINATION "/etc/default"
  COMPONENT osquery
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
)

# Execute the script during installation
install(
    CODE "execute_process(COMMAND ${CMAKE_INSTALL_PREFIX}/bin/update_profile.sh)"
)

