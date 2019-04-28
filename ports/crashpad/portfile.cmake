include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO karoyqiu/crashpad
    REF 0517e0a2709352de995767f35106b3c932094bc6
    SHA512 bb67922315663a7925dd212b58a94499e403fc0bd21c5cb40a34a5dfbd36f79d7b0c153390625bd2f4c4cbd0db19fc3ca1b3f053656bcb22e6ba56129020d6d1
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

file(REMOVE_RECURSE
    ${CURRENT_PACKAGES_DIR}/bin
    ${CURRENT_PACKAGES_DIR}/debug/bin
    ${CURRENT_PACKAGES_DIR}/debug/include
    ${CURRENT_PACKAGES_DIR}/include/util/net/testdata
)

file(INSTALL
    ${SOURCE_PATH}/LICENSE
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/crashpad RENAME copyright)

vcpkg_copy_pdbs()
