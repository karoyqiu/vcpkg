include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO karoyqiu/sentrypad
    REF 4a47bcc9da604c98bb2414dcc57c35bb5cc3a5ef
    SHA512 5c1cf9fc9ca9f34c62b8444f8a0cff9fc1709fafa983d8c4e4fc23c429e89bbae4ea6d1bc23fd4a49827b30ddaf9f9573de7a623a039b326fa4d0b5a95dd0269
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
