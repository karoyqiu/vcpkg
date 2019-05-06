include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO karoyqiu/sentrypad
    REF 30f8724527a76a48a2464263c892a824483863b9
    SHA512 745edefd9199b65da06eb655d74da77994509b34ee4fe4d16e2fa511681d2180e49cbea7580668802eb897f8d9f640d52dac71f8b0e6e0c651e8ffbe29de28d4
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL
    ${SOURCE_PATH}/LICENSE
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/sentrypad RENAME copyright)

vcpkg_copy_pdbs()
