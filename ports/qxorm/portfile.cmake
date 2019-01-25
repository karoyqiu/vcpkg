include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO QxOrm/QxOrm
    REF 1.4.5
    SHA512 205f7ea5bdfb13920583156c345cc7fbd6b8aef0f2921dbd175279c63eaaa1c6af1e53f7603fd7dd12a59238f90a6b6c25b9e0c2a350286d640e0229a6f149ab
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -D_QX_UNITY_BUILD:BOOL=ON -D_QX_STATIC_BUILD:BOOL=ON -D_QX_USE_QSTRINGBUILDER:BOOL=ON
)
vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(INSTALL ${SOURCE_PATH}/license.gpl3.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/qxorm RENAME copyright)
