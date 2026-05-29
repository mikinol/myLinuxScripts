{
  stdenv,
  shellcheck,
  # Шеллы
  dash,
  bash,
  # additional_bashrc
  icu,
  gawk,
  fastfetch,
  # maccheck
  hwdata,
  # hyprland утилы
  cliphist,
  wofi,
  wl-clipboard,
  grim,
  slurp,
  zbar,
  libnotify,
  # Остальное
  clang,
  python3,
}:
stdenv.mkDerivation {
  pname = "my-linux-scripts";
  version = "1.0";

  # Указываем, что исходники лежат в этой же папке
  src = ./.;

  hardeningDisable = [ "all" ];

  dontUnpack = false; # Разрешаем Nix скопировать папку в билд-директорию

  nativeBuildInputs = [clang python3 shellcheck bash dash];

  buildPhase = ''
    mkdir -p build_stage/etc build_stage/bin build_stage/tools

    echo "Copying scripts..."

    cp additional_bashrc.sh build_stage/etc/additional_bashrc.sh
    substituteInPlace build_stage/etc/additional_bashrc.sh \
      --replace-fail "uconv" "${icu}/bin/uconv" \
      --replace-fail "fastfetch" "${fastfetch}/bin/fastfetch" \
      --replace-fail "awk" "${gawk}/bin/awk" \
      --replace-fail "python3" "${python3}/bin/python3"

    cp bin/maccheck bin/rm_neovim_config build_stage/bin/

    substituteInPlace build_stage/bin/maccheck \
      --replace-fail "#!/usr/bin/env bash" "#!${bash}/bin/bash" \
      --replace-fail "\$XDG_DATA_DIRS" "${hwdata}/share"

    substituteInPlace build_stage/bin/rm_neovim_config \
      --replace-fail "#!/bin/sh" "#!${dash}/bin/dash"

    cp tools/hyprland_active_window_listener tools/cliphistory tools/screenshot tools/qrread tools/tlp-set build_stage/tools/

    substituteInPlace build_stage/tools/hyprland_active_window_listener \
      --replace-fail "#!/usr/bin/env python3" "#!${python3}/bin/python3"

    substituteInPlace build_stage/tools/cliphistory \
      --replace-fail "#!/bin/sh" "#!${dash}/bin/dash" \
      --replace-fail "cliphist" "${cliphist}/bin/cliphist" \
      --replace-fail "wofi" "${wofi}/bin/wofi" \
      --replace-fail "wl-copy" "${wl-clipboard}/bin/wl-copy"

    substituteInPlace build_stage/tools/screenshot \
      --replace-fail "#!/bin/sh" "#!${dash}/bin/dash" \
      --replace-fail "grim" "${grim}/bin/grim" \
      --replace-fail "slurp" "${slurp}/bin/slurp" \
      --replace-fail "wl-copy" "${wl-clipboard}/bin/wl-copy"

    substituteInPlace build_stage/tools/qrread \
      --replace-fail "#!/usr/bin/env bash" "#!${bash}/bin/bash" \
      --replace-fail "grim" "${grim}/bin/grim" \
      --replace-fail "slurp" "${slurp}/bin/slurp" \
      --replace-fail "zbarimg" "${zbar}/bin/zbarimg" \
      --replace-fail "notify-send" "${libnotify}/bin/notify-send" \
      --replace-fail "wl-copy" "${wl-clipboard}/bin/wl-copy"

    substituteInPlace build_stage/tools/tlp-set \
      --replace-fail "#!/bin/sh" "#!${dash}/bin/dash" \
      --replace-fail "notify-send" "${libnotify}/bin/notify-send"

    echo "Compiling C tools..."

    clang -O3 -s -Wall src/discord_snowflake_parse.c -o build_stage/bin/discord_snowflake_parse
    clang -O3 -s -Wall -static -nostdlib -fno-builtin src/password_gen.c -o build_stage/bin/password_gen
  '';

  doCheck = true;
  checkPhase = ''
    echo "Running shellcheck on patched scripts..."

    shellcheck -s bash build_stage/etc/additional_bashrc.sh build_stage/bin/maccheck build_stage/tools/qrread

    shellcheck -s dash build_stage/bin/rm_neovim_config build_stage/tools/cliphistory build_stage/tools/screenshot

    python3 -m py_compile build_stage/tools/hyprland_active_window_listener
    rm -rf build_stage/tools/__pycache__

    echo "Checking C binaries..."
    build_stage/bin/password_gen 48 1 > /dev/null
    build_stage/bin/discord_snowflake_parse 1224763506717360311 > /dev/null
  '';

  installPhase = ''
    mkdir -p $out/tools $out/bin $out/etc
    cp build_stage/tools/* $out/tools
    cp build_stage/bin/* $out/bin
    cp build_stage/etc/* $out/etc
  '';
}
