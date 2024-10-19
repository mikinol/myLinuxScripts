#include <conio.h>
#include <cstdlib>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

// Структура для представления программ
struct Program {
  string name;
  string aptName;
  bool selected;
};

// Функция для отображения списка программ и получения выбора пользователя
void displayPrograms(vector<Program> &programs) {
  cout << "Выберите программы для установки (введите номера через пробел, "
          "затем Enter):\n";
  for (size_t i = 0; i < programs.size(); ++i) {
    cout << i + 1 << ". " << programs[i].name
         << (programs[i].selected ? " [X]" : " [ ]") << '\n';
  }

  // Разбор ввода
  while (true) {
    char c = getch();
    if (isdigit(c)) {
      int index = c - '1'; // Конвертируем символ в индекс (0-based)
      if (index >= 0 && index < programs.size()) {
        programs[index].selected =
            !programs[index].selected; // Инвертируем выбор
      }
    }
  }
}

// Функция для установки выбранных программ
void installPrograms(const vector<Program> &programs) {
  string command = "sudo apt install -y";
  bool anySelected = false;

  for (const auto &program : programs) {
    if (program.selected) {
      command += " " + program.aptName;
      anySelected = true;
    }
  }

  if (anySelected) {
    cout << "Устанавливаем выбранные программы...\n";
    int result = system(command.c_str());
    if (result != 0) {
      cerr << "Произошла ошибка при установке программ.\n";
    }
  } else {
    cout << "Никакие программы не были выбраны для установки.\n";
  }
}

int main() {
  // Список программ
  vector<Program> programs = {
      {"Vim", "vim", false},         {"Git", "git", false},
      {"Curl", "curl", false},       {"HTop", "htop", false},
      {"Python3", "python3", false}, {"GCC", "gcc", false}};

  // Вывод меню и получение выбора пользователя
  displayPrograms(programs);

  // Подтверждение выбора и установка программ
  char choice;
  cout << "Вы хотите установить выбранные программы? (y/n): ";
  cin >> choice;

  if (choice == 'y' || choice == 'Y') {
    installPrograms(programs);
  } else {
    cout << "Установка отменена.\n";
  }

  return 0;
}
