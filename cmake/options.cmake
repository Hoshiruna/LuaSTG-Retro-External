set(LSTGEXT_BUILD "all" CACHE STRING "Dependency group to build: all, core, or lua")
set_property(CACHE LSTGEXT_BUILD PROPERTY STRINGS all core lua)
string(TOLOWER "${LSTGEXT_BUILD}" LSTGEXT_BUILD)

if(NOT LSTGEXT_BUILD MATCHES "^(all|core|lua)$")
    message(FATAL_ERROR "LSTGEXT_BUILD must be one of: all, core, lua")
endif()

set(LSTGEXT_BUILD_CORE OFF)
set(LSTGEXT_BUILD_LUA OFF)
if(LSTGEXT_BUILD STREQUAL "all" OR LSTGEXT_BUILD STREQUAL "core")
    set(LSTGEXT_BUILD_CORE ON)
endif()
if(LSTGEXT_BUILD STREQUAL "all" OR LSTGEXT_BUILD STREQUAL "lua")
    set(LSTGEXT_BUILD_LUA ON)
endif()

option(BUILD_SHARED_LIBS "Build dependencies as shared libraries when supported" OFF)
option(LSTGEXT_USE_LOCAL_SOURCES "Use a dependency copied into this repository when it is complete" ON)
option(LUASTG_STEAM_API_ENABLE "Build against a locally supplied Steamworks SDK" OFF)

set(LSTGEXT_DISCORD_RPC_REPOSITORY
    "https://github.com/Hoshiruna/discord-rpc.git"
    CACHE STRING "Git repository used for Discord RPC"
)
set(LSTGEXT_DISCORD_RPC_REVISION
    "963aa9f3e5ce81a4682c6ca3d136cddda614db33"
    CACHE STRING "Pinned Discord RPC revision"
)

if(MSVC)
    cmake_policy(SET CMP0091 NEW)
    set(CMAKE_MSVC_RUNTIME_LIBRARY
        "MultiThreaded$<$<CONFIG:Debug>:Debug>"
        CACHE STRING "MSVC runtime used by packaged dependencies"
    )
endif()

if(CMAKE_GENERATOR_PLATFORM MATCHES "^(Win32|x86)$")
    set(LUASTG_ARCH x86)
elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^(ARM64|arm64)$")
    set(LUASTG_ARCH arm64)
elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^(x64|AMD64|amd64)$")
    set(LUASTG_ARCH amd64)
elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
    set(LUASTG_ARCH x86)
else()
    set(LUASTG_ARCH amd64)
endif()

set(LUASTG_ARCH "${LUASTG_ARCH}" CACHE STRING "LuaSTG target architecture" FORCE)
set(LUAJIT_ARCH "${LUASTG_ARCH}" CACHE STRING "LuaJIT target architecture" FORCE)

set(LSTGEXT_INSTALL_SUBDIR
    "luastg-retro-external-${LUASTG_ARCH}"
    CACHE STRING "Directory name placed in the package archive"
)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX
        "${CMAKE_BINARY_DIR}/${LSTGEXT_INSTALL_SUBDIR}"
        CACHE PATH "LuaSTG Retro External install directory" FORCE
    )
endif()

message(STATUS "LuaSTG Retro External architecture: ${LUASTG_ARCH}")
message(STATUS "LuaSTG Retro External dependency group: ${LSTGEXT_BUILD}")
message(STATUS "LuaSTG Retro External install prefix: ${CMAKE_INSTALL_PREFIX}")
