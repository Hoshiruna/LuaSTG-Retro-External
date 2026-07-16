set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

function(luastg_target_common_options target)
    set_target_properties(${target} PROPERTIES
        C_STANDARD 17
        C_STANDARD_REQUIRED ON
        CXX_STANDARD 20
        CXX_STANDARD_REQUIRED ON
    )
    target_compile_definitions(${target} PRIVATE _UNICODE UNICODE)
    if(MSVC)
        target_compile_options(${target} PRIVATE
            /MP
            /utf-8
            "$<$<CONFIG:Debug>:/ZI>"
        )
        if(CMAKE_SIZEOF_VOID_P EQUAL 4)
            target_compile_options(${target} PRIVATE /arch:SSE2)
            target_link_options(${target} PRIVATE "$<$<CONFIG:Debug>:/SAFESEH:NO>")
        endif()
    endif()
endfunction()

function(luastg_target_more_warning target)
    if(MSVC)
        target_compile_options(${target} PRIVATE /W4)
    endif()
endfunction()

function(lstgext_register_target target)
    if(TARGET ${target})
        set_property(GLOBAL APPEND PROPERTY LSTGEXT_BUILD_TARGETS ${target})
        get_target_property(target_type ${target} TYPE)
        if(NOT target_type STREQUAL "INTERFACE_LIBRARY")
            set_property(GLOBAL APPEND PROPERTY LSTGEXT_INSTALL_TARGETS ${target})
        endif()
    endif()
endfunction()
