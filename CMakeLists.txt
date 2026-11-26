cmake_minimum_required(VERSION 3.15)
project(TicketCore CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(TICKETCORE_INSTALLED "Store application data in the current user's local app data" OFF)

# Set the output directory for the executable
if(NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/output/bin")
endif()

# Add the executable
add_executable(ticketcore
    src/main.cpp
    src/Helpers.cpp
    src/MainMenu.cpp
    src/TicketCreator.cpp
    src/TicketViewer.cpp
    src/ExtraPartsTracker.cpp
)

# Include directories
target_include_directories(ticketcore PRIVATE "${CMAKE_SOURCE_DIR}/include")

# Platform-specific settings
if(WIN32)
    enable_language(RC)
    configure_file(src/ticketcore.rc.in "${CMAKE_CURRENT_BINARY_DIR}/ticketcore.rc" @ONLY)
    target_sources(ticketcore PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/ticketcore.rc")
    if(MSVC)
        target_compile_options(ticketcore PRIVATE /W4)
        target_compile_definitions(ticketcore PRIVATE _CRT_SECURE_NO_WARNINGS)
        set_property(TARGET ticketcore PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    else()
        target_compile_options(ticketcore PRIVATE -Wall -Wextra -Wpedantic)
    endif()
else()
    # Linux/Unix-specific settings
    target_compile_options(ticketcore PRIVATE -Wall -Wextra -Wpedantic)
    target_link_libraries(ticketcore PRIVATE m)
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 9)
    target_link_libraries(ticketcore PRIVATE stdc++fs)
endif()

if(TICKETCORE_INSTALLED)
    if(NOT WIN32)
        message(FATAL_ERROR "TICKETCORE_INSTALLED is only supported on Windows")
    endif()
    target_compile_definitions(ticketcore PRIVATE TICKETCORE_INSTALLED)
endif()

# Create output directory for data files
add_custom_command(TARGET ticketcore POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_FILE_DIR:ticketcore>/output"
)
