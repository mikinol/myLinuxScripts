#!/bin/bash

sudo apt-get install openjdk-8-jdk
sudo apt-get install openjdk-17-jdk
sudo apt-get install openjdk-21-jdk
git clone https://github.com/jenv/jenv.git ~/.jenv

# Определяем, какая оболочка используется
if [ "$SHELL" = "usr/bin/zsh" ]; then
    shell="zsh"
    config_file="$HOME/.zshrc"
elif [ "$SHELL" = "usr/bin/bash" ]; then
    shell="bash"
    config_file="$HOME/.bashrc"
else
    echo "Неизвестная оболочка: $SHELL"
    exit 1
fi

echo "Используется $shell"
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> $config_file
echo 'eval "$(jenv init -)"' >> $config_file

jenv add /usr/lib/jvm/java-8-openjdk-amd64
jenv add /usr/lib/jvm/java-17-openjdk-amd64
jenv add /usr/lib/jvm/java-21-openjdk-amd64
jenv versions
jenv global 17.0
