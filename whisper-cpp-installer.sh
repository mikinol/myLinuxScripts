MAIN_PATH="$HOME/projects/"

cd "$MAIN_PATH" || exit

git clone --depth 1 --single-branch -b master https://github.com/ggerganov/whisper.cpp

cd "whisper.cpp" || exit

# Определение флага Vulkan
export USING_VULKAN="${USING_VULKAN:-true}"

# Определение флагов для компиляции
CXXFLAGS="${CXXFLAGS:-"-O3 -march=native"}"

# Установка флагов Vulkan или без него
if [ "$USING_VULKAN" = "true" ]; then
    echo "Компиляция с Vulkan..."
    cmake -B build -DGGML_VULKAN=ON -DCMAKE_CXX_FLAGS="$CXXFLAGS"
    cmake --build build -j$(nproc) --config Release
else
    echo "Компиляция без Vulkan..."
    cmake -B build -DCMAKE_CXX_FLAGS="$CXXFLAGS"
    cmake --build build -j$(nproc) --config Release
fi
