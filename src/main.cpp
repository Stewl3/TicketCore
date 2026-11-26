#include "MainMenu.h"

#include <filesystem>

int main(int, char *argv[]) {
    namespace fs = std::filesystem;

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

    MainMenu menu;
    menu.run();
    return 0;
}