# Flycast for PS4

A port of [Flycast](https://github.com/flyinghead/flycast), the Sega Dreamcast,
Naomi and Atomiswave emulator, to the PS4. This repository holds the patches
against upstream Flycast, the package assets, and a script that builds the pkg.

## Download
Prebuilt pkgs are on the [releases](https://github.com/ps4-homebrew-dev/flycast/releases) page.

## Building
You need git, cmake, and the
[PS4 homebrew SDK](https://github.com/ps4-homebrew-dev/sdk) with the
[pacbrew](https://github.com/ps4-homebrew-dev/pacbrew) packages:

```sh
wget https://github.com/ps4-homebrew-dev/pacbrew/releases/latest/download/ps4-homebrew-dev.tar.gz
sudo tar xf ps4-homebrew-dev.tar.gz -C /
PS4_HOMEBREW_SDK=/opt/ps4-homebrew-sdk ./build.sh
```

The script fetches Flycast, applies the patches in `patches/`, and leaves the
pkg next to `build.sh`. Set `FLYCAST_VER` to build another Flycast revision.

## Notes
- Use the Vulkan renderer.
- On a PS4 Pro, Flycast runs in Pro mode.
- Settings and saves are stored in `/temp0/flycast`.
- Put your games on USB
