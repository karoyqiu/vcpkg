include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO getsentry/sentry-native
    REF 0.2.4
    SHA512 7f91ad54fbc56053462ecaec5b5305ddef62b56ebc40fe45dd7df70d7bd0c31dab0970c83e57503b2f96057a04375e248a0d1f2956783a54d4048194da50dc94
    HEAD_REF master
)

if(WIN32)
    vcpkg_download_distfile(
        CRASHPAD_ZIP
        URLS https://github.com/getsentry/crashpad/archive/4f3e36260fb7c97b717ad1fdc34ec0771328cc24.zip
        FILENAME crashpad-getsentry-4f3e36260fb7c97b717ad1fdc34ec0771328cc24.zip
        SHA512 e1e5b7653fb08a0447cc6ef6ab8440ae05eee8a35523fd6abf3981ed09b62334ec2e84354181ba33c63837439e0ee6cdd832439d99fa94b4b5a59babbace56d8
    )
    vcpkg_extract_source_archive("${CRASHPAD_ZIP}" "${SOURCE_PATH}/external")
    file(REMOVE_RECURSE "${SOURCE_PATH}/external/crashpad")
    file(RENAME "${SOURCE_PATH}/external/crashpad-4f3e36260fb7c97b717ad1fdc34ec0771328cc24" "${SOURCE_PATH}/external/crashpad")
    file(REMOVE "${SOURCE_PATH}/external/crashpad-getsentry-4f3e36260fb7c97b717ad1fdc34ec0771328cc24.zip.extracted")
    
    vcpkg_download_distfile(
        MINI_CHROMIUM_ZIP
        URLS https://github.com/chromium/mini_chromium/archive/641fcf9bbc1277e8153ac7e86d5b8f9340b1bfdd.zip
        FILENAME mini_chromium-641fcf9bbc1277e8153ac7e86d5b8f9340b1bfdd.zip
        SHA512 ef5ddc03465579ce5bcb71dc67e37507a611b24b240c20957bd81e7085e5707a11f9367603a4e8a7608fdf99fe0bf55a85d953c9d499f9551c9e169802b5ac62
    )
    vcpkg_extract_source_archive("${MINI_CHROMIUM_ZIP}" "${SOURCE_PATH}/external/crashpad/third_party/mini_chromium")
    file(REMOVE_RECURSE "${SOURCE_PATH}/external/crashpad/third_party/mini_chromium/mini_chromium")
    file(RENAME "${SOURCE_PATH}/external/crashpad/third_party/mini_chromium/mini_chromium-641fcf9bbc1277e8153ac7e86d5b8f9340b1bfdd" "${SOURCE_PATH}/external/crashpad/third_party/mini_chromium/mini_chromium")
    file(REMOVE "${SOURCE_PATH}/external/crashpad/third_party/mini_chromium/mini_chromium-641fcf9bbc1277e8153ac7e86d5b8f9340b1bfdd.zip.extracted")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DSENTRY_BUILD_TESTS=OFF -DSENTRY_BUILD_EXAMPLES=OFF -DCRASHPAD_ZLIB_SYSTEM=ON
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL
    ${SOURCE_PATH}/LICENSE
    DESTINATION ${CURRENT_PACKAGES_DIR}/share/sentry-native RENAME copyright)

vcpkg_copy_pdbs()
