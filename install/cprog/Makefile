# Название исполняемого файла
TARGET = progs_install

# Компилятор и флаги
CXX = g++
CXXFLAGS = -std=c++23 -Wall -Wextra -O2

# Папка с исходниками
SRCDIR = src

# Папка для объектных файлов
OBJDIR = obj

# Папка для заголовочных файлов (если есть)
INCLUDES = -Iinclude

# Поиск всех .cpp файлов в папке src
SRC = $(wildcard $(SRCDIR)/*.cpp)

# Соответствующие объектные файлы в папке obj
OBJ = $(patsubst $(SRCDIR)/%.cpp, $(OBJDIR)/%.o, $(SRC))

# Правило для сборки целевого исполняемого файла
$(TARGET): $(OBJ)
	$(CXX) $(CXXFLAGS) $(OBJ) -o $(TARGET)

# Правило для сборки объектных файлов
$(OBJDIR)/%.o: $(SRCDIR)/%.cpp | $(OBJDIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Создание папки obj, если она не существует
$(OBJDIR):
	mkdir -p $(OBJDIR)

# Чистка проектных файлов
.PHONY: clean
clean:
	rm -rf $(OBJDIR) $(TARGET)

# Условие для перезапуска сборки, если Makefile изменен
.PHONY: all
all: $(TARGET)

