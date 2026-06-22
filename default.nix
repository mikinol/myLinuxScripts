{
  stdenv,
  shellcheck,
  # Шеллы
  dash,
  # additional_bashrc
  icu,
  gawk,
  # hyprland утилы
  cliphist,
  wofi,
  wl-clipboard,
  grim,
  slurp,
  zbar,
  libnotify,
  # Для heatvideo и bitratemap
  ffmpeg,
  # Остальное
  python3,
}: let
  pythonClean = python3;

  pythonWithMatplotlib = python3.withPackages (ps: [
    (ps.matplotlib.override {
      enableTk = false;
    })
  ]);
in
  stdenv.mkDerivation {
    pname = "my-linux-scripts";
    version = "1.0";

    # Указываем, что исходники лежат в этой же папке
    src = ./.;

    hardeningDisable = ["all"];

    dontUnpack = false; # Разрешаем Nix скопировать папку в билд-директорию

    nativeBuildInputs = [shellcheck icu.dev];
    buildInputs = [pythonWithMatplotlib pythonClean dash icu.out gawk cliphist wofi wl-clipboard grim slurp zbar libnotify ffmpeg];

    buildPhase = ''
      mkdir -p build_stage/etc build_stage/bin build_stage/tools

      echo "Copying scripts..."

      cp ${icu.dev}/bin/uconv build_stage/bin/.uconv

      cp additional_bashrc.sh build_stage/etc/additional_bashrc.sh
      substituteInPlace build_stage/etc/additional_bashrc.sh \
        --replace-fail "uconv" "$out/bin/.uconv" \
        --replace-fail "awk" "${gawk}/bin/awk" \
        --replace-fail "python3" "${pythonClean}/bin/python3"

      cp bin/heatvideo bin/bitratemap build_stage/bin/

      substituteInPlace build_stage/bin/heatvideo \
        --replace-fail "#!/usr/bin/env python3" "#!${pythonClean}/bin/python3" \
        --replace-fail "\"ffmpeg\"" "\"${ffmpeg}/bin/ffmpeg\""

      substituteInPlace build_stage/bin/bitratemap \
        --replace-fail "#!/usr/bin/env python3" "#!${pythonWithMatplotlib}/bin/python3" \
        --replace-fail "'ffprobe'" "'${ffmpeg}/bin/ffprobe'"

      cp tools/hyprland_active_window_listener tools/cliphistory tools/screenshot tools/qrread tools/tlp-set build_stage/tools/

      substituteInPlace build_stage/tools/hyprland_active_window_listener \
        --replace-fail "#!/usr/bin/env python3" "#!${pythonClean}/bin/python3"

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
        --replace-fail "#!/bin/sh" "#!${dash}/bin/dash" \
        --replace-fail "grim" "${grim}/bin/grim" \
        --replace-fail "slurp" "${slurp}/bin/slurp" \
        --replace-fail "zbarimg" "${zbar}/bin/zbarimg" \
        --replace-fail "notify-send" "${libnotify}/bin/notify-send" \
        --replace-fail "wl-copy" "${wl-clipboard}/bin/wl-copy"

      substituteInPlace build_stage/tools/tlp-set \
        --replace-fail "#!/bin/sh" "#!${dash}/bin/dash" \
        --replace-fail "notify-send" "${libnotify}/bin/notify-send"

      echo "Compiling python..."
      ${pythonClean}/bin/python3 -m py_compile build_stage/tools/hyprland_active_window_listener
      ${pythonClean}/bin/python3 -m py_compile build_stage/bin/heatvideo
      ${pythonWithMatplotlib}/bin/python3 -m py_compile build_stage/bin/bitratemap
    '';

    doCheck = true;
    checkPhase = ''
      echo "Running shellcheck on patched scripts..."

      shellcheck -s bash build_stage/etc/additional_bashrc.sh
      shellcheck -s dash build_stage/tools/cliphistory build_stage/tools/screenshot build_stage/tools/qrread
    '';

    installPhase = ''
      mkdir -p $out/tools $out/bin $out/etc
      cp -r build_stage/tools/ $out/
      cp -r build_stage/bin/ $out/
      cp -r build_stage/etc/ $out/
    '';
  }
