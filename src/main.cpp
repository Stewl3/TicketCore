#include "MainMenu.h"

#include <cstdlib>
#include <filesystem>
#include <iostream>

int main(int, char *argv[]) {
    namespace fs = std::filesystem;

#ifdef TICKETCORE_INSTALLED
    (void)argv;
    const wchar_t *localAppData = _wgetenv(L"LOCALAPPDATA");
    if (localAppData == nullptr || *localAppData == L'\0') {
        std::cerr << "LOCALAPPDATA is not set; TicketCore cannot locate its data directory.\n";
        return 1;
    }
    const fs::path projectPath = fs::path(localAppData) / L"TicketCore";
    fs::create_directories(projectPath);
#else
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
#endif
    fs::current_path(projectPath);

    fs::create_directories("output/data/Tickets");

    MainMenu menu;
    menu.run();
    return 0;
}