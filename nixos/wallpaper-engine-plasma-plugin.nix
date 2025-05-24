# /home/gonah/Documents/nix-config/nixos/wallpaper-engine-plasma-plugin.nix

# This file contains the definition of the wallpaper engine plugin package.
# It's a function that takes its dependencies as arguments.
{ lib, pkgs, # lib and pkgs are often passed automatically by callPackage
  stdenv, fetchFromGitHub, cmake, extra-cmake-modules, pkg-config, wrapQtAppsHook,
  kpackage, plasma-framework, mpv, qtwebsockets, websockets, qtwebchannel,
  qtdeclarative, qtx11extras, lz4,
  spirv-tools, wayland, wayland-protocols, libass,
  libsysprof-capture, fribidi,
  vulkan-tools, vulkan-headers, vulkan-loader,
  gst_all_1, python3,
  shaderc, ninja, kdePackages, qt6Packages # These are sets passed from the caller
  ,... }:

let
  # Local definition within the derivation
  glslang-submodule = stdenv.mkDerivation {
    name = "glslang";
    installPhase = ''
      mkdir -p $out
    '';
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "glslang";
      rev = "c34bb3b6c55f6ab084124ad964be95a699700d34";
      hash = "sha256-IMROcny+b5CpmzEfvKBYDB0QYYvqC5bq3n1S4EQ6sXc=";
    };
  };

in
stdenv.mkDerivation rec {
  pname = "wallpaper-engine-kde";
  version = "96230de92f1715d3ccc5b9d50906e6a73812a00a";
  src = fetchFromGitHub {
    owner = "Jelgnum";
    repo = "wallpaper-engine-kde-plugin";
    rev = version;
    hash = "sha256-vkWEGlDQpfJ3fAimJHZs+aX6dh/fLHSRy2tLEsgu/JU=";
    fetchSubmodules = true;
  };

  # Use the package names as defined in Nixpkgs
  nativeBuildInputs = [
    cmake
    extra-cmake-modules # Passed as argument from kdePackages.extra-cmake-modules
    glslang-submodule
    pkg-config
    gst_all_1.gst-libav # Passed as argument from gst_all_1.gst-libav
    shaderc
    ninja
    kpackage # Passed as argument from kdePackages.kpackage
  ];

  buildInputs = [
    mpv
    lz4
    vulkan-headers
    vulkan-tools
    vulkan-loader
    libplasma # Passed as argument from kdePackages.libplasma
  ]
  ++ (with qt6Packages; [ # Using the qt6Packages set passed as an argument
    qtbase
    full
    kdeclarative
    qtwebsockets
    qtwebengine
    qtwebchannel
    qtmultimedia
    qtdeclarative
  ])
  # Using the python3 package passed as an argument
  ++ [ (python3.withPackages (python-pkgs: [ python-pkgs.websockets ])) ];


  cmakeFlags = [ "-DUSE_PLASMAPKG=OFF" ];
  dontWrapQtApps = true;

  # Manual CMAKE_PREFIX_PATH adjustment (keep this if needed for ECM)
  NIX_CFLAGS_COMPILE = "-I${extra-cmake-modules}/include";
  NIX_LDFLAGS = "-L${extra-cmake-modules}/lib";
  CMAKE_PREFIX_PATH = "${extra-cmake-modules}${lib.makeSearchPathOutput "dev" "" buildInputs}:${lib.makeSearchPathOutput "dev" "" nativeBuildInputs}:$CMAKE_PREFIX_PATH";


  postPatch = ''
    rm -rf src/backend_scene/third_party/glslang
    ln -s ${glslang-submodule.src} src/backend_scene/third_party/glslang
  '';

  meta = with lib; {
    description = "Wallpaper Engine KDE plasma plugin";
    homepage = "https://github.com/Jelgnum/wallpaper-engine-kde-plugin";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    # maintainers = [ lib.maintainers.yourusername ];
  };
}

