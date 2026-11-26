#include "MainMenu.h"

#include <cstdlib>
#include <filesystem>
#include <iostream>

int main(int, char *argv[]) {
    namespace fs = std::filesystem;

#ifdef TICKETCORE_INSTALLED
    (void)argv;
    const wchar_t* localAppData = _wgetenv(L"LOCALAPPDATA");
    if (!localAppData || !*localAppData) {
        std::cerr << "ERROR: LOCALAPPDATA is not set" << std::endl;
        return 1;
    }
    fs::path appDataPath = localAppData;
    fs::path ticketCoreDir = appDataPath / "TicketCore" / "output" / "data" / "Tickets";
    fs::create_directories(ticketCoreDir);
    fs::current_path(appDataPath / "TicketCore");
#else
    // Development mode: use relative path
    const fs::path executablePath = fs::absolute(argv[0]);
    fs::path projectPath = executablePath.parent_path();
    while (!projectPath.empty()) {
        if (fs::exists(projectPath / "CMakeLists.txt") || fs::exists(projectPath / ".git")) {
            break;
        }
        projectPath = projectPath.parent_path();
    }
    if (projectPath.empty()) {
        projectPath = executablePath.parent_path();
    }
    fs::current_path(projectPath);
    fs::create_directories("output/data/Tickets");
#endif

    MainMenu menu;
    menu.run();
    return 0;
}