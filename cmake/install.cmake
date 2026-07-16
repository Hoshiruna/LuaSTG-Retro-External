get_property(LSTGEXT_INSTALL_TARGETS GLOBAL PROPERTY LSTGEXT_INSTALL_TARGETS)

install(TARGETS ${LSTGEXT_INSTALL_TARGETS}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

if(LSTGEXT_BUILD_CORE)
    install(DIRECTORY "${BEAUTIFUL_WIN32_API_SOURCE}/headers/"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/beautiful-win32-api"
        FILES_MATCHING PATTERN "*.hpp"
    )
    install(DIRECTORY "${XMATH_SOURCE}/"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/xmath"
        FILES_MATCHING PATTERN "*.h"
    )
    install(DIRECTORY "${CMAKE_SOURCE_DIR}/xmath-patch/"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/xmath"
        FILES_MATCHING PATTERN "*.h"
    )
    install(FILES
        "${QOI_SOURCE}/qoi.h"
        "${CMAKE_SOURCE_DIR}/image.qoi-patch/QOITextureLoader11.h"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/qoi"
    )
    install(DIRECTORY "${DISCORD_RPC_SOURCE}/include/"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/discord-rpc"
        FILES_MATCHING PATTERN "*.h"
    )
    install(DIRECTORY "${TRACY_SOURCE}/public/"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/tracy"
        FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp"
    )
    install(FILES "${CMAKE_SOURCE_DIR}/tracy-patch/tracy/TracyAPI.hpp"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/tracy/tracy"
    )
    install(FILES "${BEAUTIFUL_WIN32_API_SOURCE}/LICENSE"
        DESTINATION share/luastg-retro-external/licenses/beautiful-win32-api
        OPTIONAL
    )
    install(FILES "${XMATH_SOURCE}/LICENSE"
        DESTINATION share/luastg-retro-external/licenses/xmath
        OPTIONAL
    )
    install(FILES "${QOI_SOURCE}/LICENSE"
        DESTINATION share/luastg-retro-external/licenses/qoi
        OPTIONAL
    )
    install(FILES "${DISCORD_RPC_SOURCE}/LICENSE"
        DESTINATION share/luastg-retro-external/licenses/discord-rpc
        OPTIONAL
    )
    install(FILES "${TRACY_SOURCE}/LICENSE"
        DESTINATION share/luastg-retro-external/licenses/tracy
        OPTIONAL
    )
endif()

if(LSTGEXT_BUILD_LUA)
    install(FILES "${CMAKE_SOURCE_DIR}/lua-filesystem-lite/lfs.h"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/lua-filesystem"
    )
    install(FILES "${CMAKE_SOURCE_DIR}/lua-cjson-patch/lua_cjson.h"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/lua-cjson"
    )
    install(FILES "${CMAKE_SOURCE_DIR}/steam_api/binding/lua_steam.h"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/steam-api"
    )
    install(FILES "${LUAJIT_SOURCE}/COPYRIGHT"
        DESTINATION share/luastg-retro-external/licenses/luajit
        OPTIONAL
    )
    install(FILES "${LUA_CJSON_SOURCE}/LICENSE"
        DESTINATION share/luastg-retro-external/licenses/lua-cjson
        OPTIONAL
    )
endif()

install(FILES
    "${CMAKE_SOURCE_DIR}/README.md"
    "${CMAKE_SOURCE_DIR}/LICENSE.md"
    "${CMAKE_SOURCE_DIR}/THIRD_PARTY.md"
    DESTINATION share/luastg-retro-external
)

add_custom_target(external-install
    COMMAND "${CMAKE_COMMAND}" --install "${CMAKE_BINARY_DIR}" --config "$<CONFIG>"
    DEPENDS external-build
    USES_TERMINAL
)
set_target_properties(external-install PROPERTIES FOLDER packaging)

set(LSTGEXT_ARCHIVE
    "${CMAKE_BINARY_DIR}/luastg-retro-external-${LUASTG_ARCH}-$<LOWER_CASE:$<CONFIG>>.zip"
)
add_custom_target(zip-install
    COMMAND "${CMAKE_COMMAND}" -E rm -f "${LSTGEXT_ARCHIVE}"
    COMMAND "${CMAKE_COMMAND}" -E tar cf "${LSTGEXT_ARCHIVE}" --format=zip "${LSTGEXT_INSTALL_SUBDIR}"
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    DEPENDS external-install
    USES_TERMINAL
)
set_target_properties(zip-install PROPERTIES FOLDER packaging)
