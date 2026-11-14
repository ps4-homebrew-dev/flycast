# Flycast for PS4

A port of [Flycast](https://github.com/flyinghead/flycast), the Sega Dreamcast,
Naomi and Atomiswave emulator, to the PS4. This repository holds the patches
against upstream Flycast, the package assets, and a script that builds the pkg.
Tested on PS4 Pro and PS5.

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
- Settings and saves are stored in `/download0` (`.config/flycast` and
  `.data/flycast`). Earlier versions used `/temp0`, which is not carried over.
- Put your games on USB

## License
The patches and scripts here are under the same license as Flycast, the
GNU General Public License version 2 or (at your option) any later version,
see [LICENSE](LICENSE).
