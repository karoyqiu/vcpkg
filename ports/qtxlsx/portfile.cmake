# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT_DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO "rbulygin/QtXlsxWriter"
    REF "v0.5"
    SHA512 "ae31ff5bbb9afbcb5d5c29e4eb1745b1f6c975fa51f3c6e5d20a725c28921dd384fad25c864b2db339ce7e108beb8f3ced210e03f7e0f4713d33f361593f540c"
    PATCHES "dont-install-cmake.patch" "fix-memory-leaks.patch"
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DBUILD_TESTING:BOOL=OFF -DBUILD_EXAMPLES:BOOL=OFF
)

# It appears that at this point the build hasn't actually finished. There is probably
# a process spawned by the build, therefore we need to wait a bit.

function(try_remove_recurse_wait PATH_TO_REMOVE)
    file(REMOVE_RECURSE ${PATH_TO_REMOVE})
    if (EXISTS "${PATH_TO_REMOVE}")
        execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 5)
        file(REMOVE_RECURSE ${PATH_TO_REMOVE})
    endif()
endfunction()

vcpkg_install_cmake()
try_remove_recurse_wait(${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/README.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/qtxlsx RENAME copyright)

# Post-build test for cmake libraries
# vcpkg_test_cmake(PACKAGE_NAME opencc)
