cmake_minimum_required(VERSION 3.31)

# CMake 4.x no longer enables compatibility below policy version 3.5. Some of
# the pinned third-party projects still declare older policy versions.
if(CMAKE_VERSION VERSION_GREATER_EQUAL "4.0")
    set(CMAKE_POLICY_VERSION_MINIMUM "3.5")
endif()

project(LuaSTGRetroExternal
    VERSION 1.0.0
    DESCRIPTION "Standalone dependency build and packaging system for LuaSTG Retro"
    HOMEPAGE_URL "https://github.com/Hoshiruna/LuaSTG-Retro-External"
    LANGUAGES C CXX
)

if(NOT WIN32)
    message(FATAL_ERROR "LuaSTG Retro External currently supports Windows toolchains only")
endif()

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_CXX_SCAN_FOR_MODULES OFF)

include(GNUInstallDirs)
include(cmake/options.cmake)
include(cmake/target-options.cmake)
include(cmake/cpm.cmake)
include(cmake/dependencies.cmake)
include(cmake/install.cmake)
