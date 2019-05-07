include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO karoyqiu/sentrypad
    REF a8e4ad59ab8309c5a2f3311e991ce2cc76088d1e
    SHA512 37e57bbd2a621548e36e00fb70fb2564931d84723810e651909d13652e26a725927e1615d2394494fddfd55d2581fd043d6e2d5e3dff4305aa8659c67902d023
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
