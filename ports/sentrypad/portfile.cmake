include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO karoyqiu/sentrypad
    REF 5038a75bde498141a48ca916b9cd1128290c9158
    SHA512 1b82e7cc35f1097db7dfa6fa1f07cdf3a1019360e8d8dca6da0fae8504ce0cd8863e8865013c90b07d40dfaa9eea08340217b727398d819dac307e2c9a1e7aad
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
