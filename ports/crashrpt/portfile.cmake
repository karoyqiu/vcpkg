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
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/crashrpt-code-4616504670be5a425a525376648d912a72ce18f2)
vcpkg_download_distfile(ARCHIVE
    URLS "https://sourceforge.net/code-snapshots/git/c/cr/crashrpt/code.git/crashrpt-code-4616504670be5a425a525376648d912a72ce18f2.zip"
    FILENAME "crashrpt-code-4616504670be5a425a525376648d912a72ce18f2.zip"
    SHA512 5d6cfae10cbd4c58d0226d9de207be563fee9045813ecf464d6474bf91c75638be334f1160f877a4baf675a0b796d45ec8dde5b76f2c55f7f688de3ed798e0b1
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        # Make sure cppunit static lib uses static CRT linkage
        ${CMAKE_CURRENT_LIST_DIR}/no-demos.patch
)

if (VCPKG_CRT_LINKAGE STREQUAL dynamic)
    set(crt "-DCRASHRPT_LINK_CRT_AS_DLL:BOOL=ON")
elseif (VCPKG_CRT_LINKAGE STREQUAL static)
    set(crt "-DCRASHRPT_LINK_CRT_AS_DLL:BOOL=OFF")
endif()

if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(linkage "-DCRASHRPT_BUILD_SHARED_LIBS:BOOL=ON")
elseif (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    set(linkage "-DCRASHRPT_BUILD_SHARED_LIBS:BOOL=OFF")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS ${crt} ${linkage}
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_build_cmake()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/License.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/crashrpt RENAME copyright)

# Post-build test for cmake libraries
# vcpkg_test_cmake(PACKAGE_NAME crashrpt)
