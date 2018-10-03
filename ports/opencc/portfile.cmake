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
    REPO "BYVoid/OpenCC"
    REF "ver.1.0.5"
    SHA512 3fbefbafe5c3c2491032158577ab97b5a3edf6ea98a03a7250deba082b72c3112ad4a3396d1a469936ec32e1d141f0a2236001c2891ac9c793add2b082596cc1
    PATCHES fix-noexcept-error.patch fix-export.patch fix-lib-install.patch
)

vcpkg_find_acquire_program(PYTHON2)
get_filename_component(PYTHON2_EXE_PATH ${PYTHON2} DIRECTORY)
set(ENV{PATH} "$ENV{PATH};${PYTHON2_EXE_PATH}")

if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    vcpkg_configure_cmake(
        SOURCE_PATH ${SOURCE_PATH}
        DISABLE_PARALLEL
        OPTIONS -DBUILD_SHARED_LIBS:BOOL=ON
    )
elseif (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    vcpkg_configure_cmake(
        SOURCE_PATH ${SOURCE_PATH}
        DISABLE_PARALLEL
        OPTIONS -DBUILD_SHARED_LIBS:BOOL=OFF
    )
endif()

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
file(INSTALL ${CURRENT_PACKAGES_DIR}/bin/opencc.exe ${CURRENT_PACKAGES_DIR}/bin/opencc_dict.exe ${CURRENT_PACKAGES_DIR}/bin/opencc_phrase_extract.exe
    DESTINATION ${CURRENT_PACKAGES_DIR}/tools/opencc)
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/opencc)

try_remove_recurse_wait(${CURRENT_PACKAGES_DIR}/bin/opencc.exe)
try_remove_recurse_wait(${CURRENT_PACKAGES_DIR}/bin/opencc_dict.exe)
try_remove_recurse_wait(${CURRENT_PACKAGES_DIR}/bin/opencc_phrase_extract.exe)
try_remove_recurse_wait(${CURRENT_PACKAGES_DIR}/debug/bin/opencc.exe)
try_remove_recurse_wait(${CURRENT_PACKAGES_DIR}/debug/bin/opencc_dict.exe)
try_remove_recurse_wait(${CURRENT_PACKAGES_DIR}/debug/bin/opencc_phrase_extract.exe)
try_remove_recurse_wait(${CURRENT_PACKAGES_DIR}/debug/include)
try_remove_recurse_wait(${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/opencc RENAME copyright)

# Post-build test for cmake libraries
# vcpkg_test_cmake(PACKAGE_NAME opencc)
