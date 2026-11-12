cmake_minimum_required(VERSION 3.10)
project(TicketCore CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add the executable
add_executable(ticketcore
    main.cpp
    Helpers.cpp
    MainMenu.cpp
    TicketCreator.cpp
    TicketViewer.cpp
    ExtraPartsTracker.cpp
)

# Platform-specific settings
if(WIN32)
    # Windows-specific settings
    target_compile_options(ticketcore PRIVATE /W4)
else()
    # Linux/Unix-specific settings
    target_compile_options(ticketcore PRIVATE -Wall -Wextra -Wpedantic)
    target_link_libraries(ticketcore PRIVATE m)
endif()

# Ensure the executable is linked against filesystem library if needed
target_link_libraries(ticketcore PRIVATE stdc++fs)

# Create output directory for data files
add_custom_command(TARGET ticketcore POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "$<TARGET_FILE_DIR:ticketcore>/output"
)
