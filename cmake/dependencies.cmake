function(lstgext_resolve_source output package local_directory marker repository revision)
    set(local_source "${CMAKE_SOURCE_DIR}/${local_directory}")
    if(LSTGEXT_USE_LOCAL_SOURCES AND EXISTS "${local_source}/${marker}")
        message(STATUS "Using local source for ${package}: ${local_source}")
        set(${output} "${local_source}" PARENT_SCOPE)
        return()
    endif()

    message(STATUS "Fetching pinned source for ${package}: ${revision}")
    CPMAddPackage(
        NAME ${package}
        GIT_REPOSITORY ${repository}
        GIT_TAG ${revision}
        DOWNLOAD_ONLY YES
    )
    set(${output} "${${package}_SOURCE_DIR}" PARENT_SCOPE)
endfunction()

if(LSTGEXT_BUILD_CORE)
    # beautiful-win32-api
    lstgext_resolve_source(BEAUTIFUL_WIN32_API_SOURCE lstgext_beautiful_win32_api
        beautiful-win32-api CMakeLists.txt
        https://github.com/Demonese/beautiful-win32-api.git
        b734d3bb5b05ca4c3859bb174b131139fc72bd4d
    )
    set(beautiful_win32_api_enable_tests OFF CACHE BOOL "" FORCE)
    add_subdirectory("${BEAUTIFUL_WIN32_API_SOURCE}" "${CMAKE_BINARY_DIR}/dependencies/beautiful-win32-api")
    set_target_properties(beautiful_win32_api PROPERTIES FOLDER external)
    lstgext_register_target(beautiful_win32_api)

    # xmath
    lstgext_resolve_source(XMATH_SOURCE lstgext_xmath
        xmath XMath.h
        https://github.com/Legacy-LuaSTG-Engine/lstgx_Math.git
        7f594caeaff8d14c8032bb246c5d435e0d40c65d
    )
    add_library(xmath STATIC)
    luastg_target_common_options(xmath)
    target_include_directories(xmath PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/xmath-patch>"
        "$<BUILD_INTERFACE:${XMATH_SOURCE}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/xmath>"
    )
    target_sources(xmath PRIVATE
        ${CMAKE_SOURCE_DIR}/xmath-patch/math/Vec2.h
        ${CMAKE_SOURCE_DIR}/xmath-patch/math/Vec2.cpp
        ${XMATH_SOURCE}/meow_fft.c
        ${XMATH_SOURCE}/meow_fft.h
        ${XMATH_SOURCE}/XCollision.cpp
        ${XMATH_SOURCE}/XCollision.h
        ${XMATH_SOURCE}/XComplex.cpp
        ${XMATH_SOURCE}/XComplex.h
        ${XMATH_SOURCE}/XConstant.h
        ${XMATH_SOURCE}/XDistance.cpp
        ${XMATH_SOURCE}/XDistance.h
        ${XMATH_SOURCE}/XEquation.cpp
        ${XMATH_SOURCE}/XEquation.h
        ${XMATH_SOURCE}/XFFT.cpp
        ${XMATH_SOURCE}/XFFT.h
        ${XMATH_SOURCE}/XIntersect.cpp
        ${XMATH_SOURCE}/XIntersect.h
        ${XMATH_SOURCE}/XMath.h
        ${XMATH_SOURCE}/XRandom.cpp
        ${XMATH_SOURCE}/XRandom.h
        ${XMATH_SOURCE}/XSpline.cpp
        ${XMATH_SOURCE}/XSpline.h
        ${XMATH_SOURCE}/XTween.cpp
        ${XMATH_SOURCE}/XTween.h
    )
    set_target_properties(xmath PROPERTIES FOLDER external)
    lstgext_register_target(xmath)

    # QOI and the LuaSTG D3D11 loader
    lstgext_resolve_source(QOI_SOURCE lstgext_qoi
        image.qoi qoi.h
        https://github.com/phoboslab/qoi.git
        97bacc86a9c4abf5a2d452102dc26546c4c670b9
    )
    add_library(libqoi STATIC)
    luastg_target_common_options(libqoi)
    target_compile_definitions(libqoi PRIVATE QOI_NO_STDIO QOI_IMPLEMENTATION)
    target_include_directories(libqoi PUBLIC
        "$<BUILD_INTERFACE:${QOI_SOURCE}>"
        "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/image.qoi-patch>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/qoi>"
    )
    target_sources(libqoi PRIVATE
        ${QOI_SOURCE}/qoi.h
        ${CMAKE_SOURCE_DIR}/image.qoi-patch/qoi.c
        ${CMAKE_SOURCE_DIR}/image.qoi-patch/QOITextureLoader11.h
        ${CMAKE_SOURCE_DIR}/image.qoi-patch/QOITextureLoader11.cpp
    )
    set_target_properties(libqoi PROPERTIES FOLDER external)
    lstgext_register_target(libqoi)

    # Discord RPC
    CPMAddPackage(
        NAME lstgext_discord_rpc
        GIT_REPOSITORY ${LSTGEXT_DISCORD_RPC_REPOSITORY}
        GIT_TAG ${LSTGEXT_DISCORD_RPC_REVISION}
        DOWNLOAD_ONLY YES
    )
    set(DISCORD_RPC_SOURCE "${lstgext_discord_rpc_SOURCE_DIR}")
    set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
    set(CLANG_FORMAT_CMD "" CACHE FILEPATH "" FORCE)
    add_subdirectory("${DISCORD_RPC_SOURCE}" "${CMAKE_BINARY_DIR}/dependencies/discord-rpc")
    set_target_properties(discord-rpc PROPERTIES FOLDER external)
    lstgext_register_target(discord-rpc)

    # miniaudio single-header audio library
    lstgext_resolve_source(MINIAUDIO_SOURCE lstgext_miniaudio
        miniaudio miniaudio.h
        https://github.com/mackron/miniaudio.git
        0.11.25
    )
    add_library(miniaudio INTERFACE)
    target_include_directories(miniaudio INTERFACE
        "$<BUILD_INTERFACE:${MINIAUDIO_SOURCE}>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/miniaudio>"
    )
    target_sources(miniaudio INTERFACE ${MINIAUDIO_SOURCE}/miniaudio.h)
    set_target_properties(miniaudio PROPERTIES FOLDER external)
    lstgext_register_target(miniaudio)

    # Tracy profiler and LuaSTG's public Tracy wrapper target.
    lstgext_resolve_source(TRACY_SOURCE lstgext_tracy
        tracy public/TracyClient.cpp
        https://github.com/wolfpld/tracy.git
        v0.14.0
    )
    add_library(tracy STATIC)
    luastg_target_common_options(tracy)
    target_include_directories(tracy PUBLIC
        "$<BUILD_INTERFACE:${TRACY_SOURCE}/public>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/tracy>"
    )
    target_sources(tracy PRIVATE
        ${TRACY_SOURCE}/public/tracy/Tracy.hpp
        ${TRACY_SOURCE}/public/tracy/TracyD3D11.hpp
        ${TRACY_SOURCE}/public/TracyClient.cpp
    )
    set_target_properties(tracy PROPERTIES FOLDER external)
    add_subdirectory(tracy-patch)
    lstgext_register_target(tracy)
endif()

if(LSTGEXT_BUILD_LUA)
    # LuaJIT
    lstgext_resolve_source(LUAJIT_SOURCE lstgext_luajit
        luajit2 .git
        https://github.com/Legacy-LuaSTG-Engine/LuaSTG-Sub-LuaJIT.git
        fff48de34357e8e86197a45f5b4bc2b1b28cce53
    )
    add_subdirectory("${LUAJIT_SOURCE}" "${CMAKE_BINARY_DIR}/dependencies/luajit2")
    foreach(target IN ITEMS minilua buildvm lua51_static lua51 luajit)
        if(TARGET ${target})
            set_target_properties(${target} PROPERTIES FOLDER luajit)
        endif()
    endforeach()
    lstgext_register_target(lua51_static)
    lstgext_register_target(lua51)
    lstgext_register_target(luajit)

    # Lua filesystem
    add_library(lua_filesystem STATIC)
    luastg_target_common_options(lua_filesystem)
    luastg_target_more_warning(lua_filesystem)
    target_include_directories(lua_filesystem PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/lua-filesystem-lite>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/lua-filesystem>"
    )
    target_sources(lua_filesystem PRIVATE
        ${CMAKE_SOURCE_DIR}/lua-filesystem-lite/lfs.h
        ${CMAKE_SOURCE_DIR}/lua-filesystem-lite/lfs.cpp
    )
    target_link_libraries(lua_filesystem PUBLIC lua51_static)
    set_target_properties(lua_filesystem PROPERTIES FOLDER lualib)
    lstgext_register_target(lua_filesystem)

    # Lua CJSON
    lstgext_resolve_source(LUA_CJSON_SOURCE lstgext_lua_cjson
        lua-cjson lua_cjson.c
        https://github.com/openresty/lua-cjson.git
        5ce46a80b10ef9d380a45c9e6cff9ecffbe71ebb
    )
    add_library(lua_cjson STATIC)
    luastg_target_common_options(lua_cjson)
    if(MSVC)
        target_compile_options(lua_cjson PRIVATE /wd4090)
    endif()
    target_compile_definitions(lua_cjson PRIVATE
        _CRT_SECURE_NO_WARNINGS
        DISABLE_INVALID_NUMBERS
        ENABLE_CJSON_GLOBAL
    )
    target_include_directories(lua_cjson PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/lua-cjson-patch>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/lua-cjson>"
    )
    target_include_directories(lua_cjson PRIVATE ${LUA_CJSON_SOURCE})
    target_sources(lua_cjson PRIVATE
        ${CMAKE_SOURCE_DIR}/lua-cjson-patch/lua_cjson.h
        ${LUA_CJSON_SOURCE}/lua_cjson.c
        ${LUA_CJSON_SOURCE}/strbuf.h
        ${LUA_CJSON_SOURCE}/strbuf.c
        ${LUA_CJSON_SOURCE}/fpconv.h
        ${LUA_CJSON_SOURCE}/fpconv.c
    )
    target_link_libraries(lua_cjson PUBLIC lua51_static)
    set_target_properties(lua_cjson PROPERTIES FOLDER lualib)
    lstgext_register_target(lua_cjson)

    # LuaSQL + bundled SQLite amalgamation
    add_subdirectory(luasql)
    lstgext_register_target(lua_luasql_sqlite3)

    # Steam binding. With the default option this builds the SDK-free stub.
    add_subdirectory(steam_api)
    lstgext_register_target(lua_steam_api)
endif()

get_property(LSTGEXT_BUILD_TARGETS GLOBAL PROPERTY LSTGEXT_BUILD_TARGETS)
if(NOT LSTGEXT_BUILD_TARGETS)
    message(FATAL_ERROR "No external targets were selected")
endif()

add_custom_target(external-build DEPENDS ${LSTGEXT_BUILD_TARGETS})
set_target_properties(external-build PROPERTIES FOLDER packaging)
