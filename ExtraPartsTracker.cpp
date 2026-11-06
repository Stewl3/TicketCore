#include "ExtraPartsTracker.h"
#include "Helpers.h"

#include <iostream>
#include <fstream>
#include <sstream>
#include <algorithm>
#include <filesystem>
#include <chrono>
#include <thread>

using namespace std;

void ExtraPartsTracker::run() {
    loadParts();

    while (true) {
        if (!displayMenu()) {
            break;  // ESC was pressed, return to main menu
        }
    }
}

bool ExtraPartsTracker::displayMenu() {
    Helpers::clearScreen();
    cout << "----------------------------------------------" << "\n";
    cout << "----------  Extra Parts Tracker  -----------" << "\n";
    cout << "----------------------------------------------" << "\n\n";

    cout << "Current Parts:\n"
         << "-------------------\n";
    if (parts.empty()) {
        cout << "No extra parts currently tracked.\n";
    } else {
        for (const auto &entry : parts) {
            cout << entry.first << ": " << entry.second << "\n";
        }
    }
    cout << "-------------------\n";
    cout << "\n";

    cout << "        Menu     \n"
         << "--------------------\n";

    cout << "1. Add Parts\n";
    cout << "2. Remove Parts\n";
    cout << "3. View Extra Parts\n";

    char sel;
    if (!Helpers::promptMenuChar("", sel)) {
        this_thread::sleep_for(chrono::milliseconds(500));
        return true;  // Continue the menu
    }
    if (sel == 27) {
        return false;  // ESC pressed, exit to main menu
    }

    switch (sel) {
        case '1': {
            addParts();
            break;
        }
        case '2': {
            removeParts();
            break;
        }
        case '3': {
            viewExtraParts();
            break;
        }
        default: {
            cout << "Invalid selection." << "\n";
            this_thread::sleep_for(chrono::milliseconds(500));
            break;
        }
    }

    cout << "\n";
    return true;  // Continue the menu
}

void ExtraPartsTracker::loadParts() {
    parts.clear();

    if (!filesystem::exists(partsFilePath)) {
        return;
    }

    ifstream file(partsFilePath);
    string line;

    while (getline(file, line)) {
        if (line.empty()) continue;

        size_t colonPos = line.find(':');
        if (colonPos == string::npos) continue;

        string partName = line.substr(0, colonPos);
        string quantityStr = line.substr(colonPos + 1);

        try {
            int quantity = stoi(quantityStr);
            parts[partName] = quantity;
        } catch (...) {
            continue;
        }
    }

    file.close();
}

void ExtraPartsTracker::saveParts() {
    // Create output directory if it doesn't exist
    if (!filesystem::exists("output")) {
        filesystem::create_directories("output");
    }

    ofstream file(partsFilePath);

    for (const auto &entry : parts) {
        file << entry.first << ":" << entry.second << "\n";
    }

    file.close();
}

void ExtraPartsTracker::addParts() {
    Helpers::clearScreen();
    cout << "----------------------------------------------" << "\n";
    cout << "----------  Extra Parts Tracker  -----------" << "\n";
    cout << "----------------------------------------------" << "\n\n";

    auto partsMap = Helpers::getPartsMap();

    Helpers::printPartsMenu();

    cout << "Current Extra Parts:\n"
         << "-------------------\n";
    if (parts.empty()) {
        cout << "None\n";
    } else {
        for (const auto &entry : parts) {
            cout << entry.first << ": " << entry.second << "\n";
        }
    }
    cout << "\n";

    string part_selection;
    if (!Helpers::promptLine("Enter part codes together (e.g., '123') or quantities (e.g., 'Ax10, Bx5'): ", part_selection)) {
        return;
    }

    if (part_selection.empty()) {
        cout << "No parts entered." << "\n";
        this_thread::sleep_for(chrono::milliseconds(500));
        return;
    }

    // Parse parts with quantities
    unordered_map<string, int> selectedParts = Helpers::parsePartsWithQuantities(part_selection, partsMap);

    if (selectedParts.empty()) {
        cout << "Invalid part codes. Please try again." << "\n";
        this_thread::sleep_for(chrono::milliseconds(500));
        return;
    }

    // Display what will be added
    cout << "\n" << "Parts to add:\n";
    cout << "-----------\n";
    for (const auto &entry : selectedParts) {
        auto existing = parts.find(entry.first);
        int current = existing != parts.end() ? existing->second : 0;
        cout << entry.first << ": " << current << " -> " << current + entry.second << "\n";
    }

    // Confirm before adding
    string confirmInput;
    if (!Helpers::promptLine("\nAdd these parts? (Y/N): ", confirmInput)) {
        return;
    }

    if (confirmInput.empty()) {
        confirmInput = "N";
    }

    char confirm = toupper(static_cast<unsigned char>(confirmInput[0]));
    if (confirm != 'Y') {
        cout << "Parts not added." << "\n";
        this_thread::sleep_for(chrono::milliseconds(500));
        return;
    }

    // Add parts to tracker
    for (const auto &entry : selectedParts) {
        if (parts.find(entry.first) != parts.end()) {
            parts[entry.first] += entry.second;
            cout << entry.first << " quantity updated to " << parts[entry.first] << "." << "\n";
        } else {
            parts[entry.first] = entry.second;
            cout << entry.first << " added with quantity " << entry.second << "." << "\n";
        }
    }

    saveParts();
    this_thread::sleep_for(chrono::milliseconds(500));
}

void ExtraPartsTracker::removeParts() {
    if (parts.empty()) {
        Helpers::clearScreen();
        cout << "----------------------------------------------" << "\n";
        cout << "----------  Extra Parts Tracker  -----------" << "\n";
        cout << "----------------------------------------------" << "\n\n";
        cout << "No parts available to remove." << "\n";
        this_thread::sleep_for(chrono::milliseconds(1000));
        return;
    }

    Helpers::clearScreen();
    cout << "----------------------------------------------" << "\n";
    cout << "----------  Extra Parts Tracker  -----------" << "\n";
    cout << "----------------------------------------------" << "\n\n";
         
         auto partsMap = Helpers::getPartsMap();
         
         cout << "\n";
         Helpers::printPartsMenu();
         
         cout << "Current Extra Parts:\n"
              << "-------------------\n";
         for (const auto &entry : parts) {
             cout << entry.first << ": " << entry.second << "\n";
         }
         string part_selection;
    if (!Helpers::promptLine("Enter part codes together (e.g., '123') or quantities (e.g., 'Ax10, Bx5'): ", part_selection)) {
        return;
    }

    if (part_selection.empty()) {
        cout << "No parts entered." << "\n";
        this_thread::sleep_for(chrono::milliseconds(500));
        return;
    }

    unordered_map<string, int> partsToRemove = Helpers::parsePartsWithQuantities(part_selection, partsMap);

    if (partsToRemove.empty()) {
        cout << "Invalid part codes. Please try again." << "\n";
        this_thread::sleep_for(chrono::milliseconds(500));
        return;
    }

    // Check if all parts exist
    bool allExist = true;
    for (const auto &entry : partsToRemove) {
        if (parts.find(entry.first) == parts.end()) {
            cout << "Part '" << entry.first << "' not found." << "\n";
            allExist = false;
        }
    }

    if (!allExist) {
        this_thread::sleep_for(chrono::milliseconds(500));
        return;
    }

    // Display what will be removed
    cout << "\nParts to remove:\n";
    cout << "---------------\n";
    for (const auto &entry : partsToRemove) {
        int remaining = max(0, parts[entry.first] - entry.second);
        cout << entry.first << ": " << parts[entry.first] << " -> " << remaining << "\n";
    }

    // Confirm before removing
    string confirmInput;
    if (!Helpers::promptLine("\nRemove these parts? (Y/N): ", confirmInput)) {
        return;
    }

    if (confirmInput.empty()) {
        confirmInput = "N";
    }

    char confirm = toupper(static_cast<unsigned char>(confirmInput[0]));
    if (confirm != 'Y') {
        cout << "Parts not removed." << "\n";
        this_thread::sleep_for(chrono::milliseconds(500));
        return;
    }

    // Remove parts
    for (const auto &entry : partsToRemove) {
        parts[entry.first] -= entry.second;
        if (parts[entry.first] <= 0) {
            parts.erase(entry.first);
        }
    }

    saveParts();
    cout << "Parts removed successfully." << "\n";
    this_thread::sleep_for(chrono::milliseconds(500));
}

void ExtraPartsTracker::viewExtraParts() {
    Helpers::clearScreen();
    cout << "----------------------------------------------" << "\n";
    cout << "----------  Extra Parts Tracker  -----------" << "\n";
    cout << "----------------------------------------------" << "\n\n";

    if (parts.empty()) {
        cout << "No extra parts currently tracked." << "\n";
        string continueInput;
        Helpers::promptLine("\nPress Enter to return to menu... ", continueInput);
        return;
    }

    cout << "Current Extra Parts:" << "\n"
         << "-------------------\n\n";

    int totalQuantity = 0;
    for (const auto &entry : parts) {
        cout << entry.first << ": " << entry.second << "\n";
        totalQuantity += entry.second;
    }

    cout << "\n-------------------\n";
    cout << "Total Quantity: " << totalQuantity << "\n";

    string continueInput;
    Helpers::promptLine("\nPress Enter to return to menu... ", continueInput);
}
