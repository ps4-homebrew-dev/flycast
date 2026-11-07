#!/usr/bin/env bash

VER="${FLYCAST_VER:-7adbf3caef251b153e348df3f469a0f35878339d}"
URL="https://github.com/flyinghead/flycast.git"

SUBMODULES=(libchdr rcheevos asio xbyak libjuice websocketpp tinygettext
	    Vulkan-Headers VulkanMemoryAllocator glslang freetype)

SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
PATCHDIR="${SCRIPT_DIR}/patches"
ASSETDIR="${SCRIPT_DIR}/sce_sys"

if [[ -z "$PS4_HOMEBREW_SDK" ]]; then
    echo "error: PS4_HOMEBREW_SDK is not set"
    exit 1
fi

if ! compgen -G "${PATCHDIR}/*.patch" >/dev/null; then
    echo "error: no patches in ${PATCHDIR}"
    exit 1
fi

if [[ ! -d "${ASSETDIR}" ]]; then
    echo "error: ${ASSETDIR} not found"
    exit 1
fi

if ! command -v git >/dev/null; then
    echo "error: git is not installed"
    exit 1
fi

source "${PS4_HOMEBREW_SDK}/toolchain/orbis.sh" || exit 1

TEMPDIR=$(mktemp -d)
trap 'rm -rf -- "$TEMPDIR"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP

SRCDIR="${TEMPDIR}/flycast"
BUILDDIR="${TEMPDIR}/build"

mkdir "${SRCDIR}" || exit 1
cd "${SRCDIR}" || exit 1

# a tarball would not include the submodules, and a recursive clone would
# fetch a lot more of them than needed
git init -q . || exit 1
git remote add origin "${URL}" || exit 1
git fetch -q --depth 1 origin "${VER}" || exit 1
git checkout -q FETCH_HEAD || exit 1

for SUB in "${SUBMODULES[@]}"; do
    git submodule update -q --init --depth 1 "core/deps/${SUB}" || exit 1
done
git -C core/deps/tinygettext submodule update -q --init --depth 1 || exit 1

for P in "${PATCHDIR}"/*.patch; do
    git apply "${P}" || exit 1
done
cp -r "${ASSETDIR}" shell/orbis/ || exit 1

"${CMAKE}" -S "${SRCDIR}" -B "${BUILDDIR}" \
           -DCMAKE_BUILD_TYPE=Release \
           -DCMAKE_VERBOSE_MAKEFILE=OFF \
           -DUSE_VULKAN=ON \
           -DUSE_BREAKPAD=OFF \
           -DUSE_ALSA=OFF \
           -DUSE_LIBAO=OFF \
           -DUSE_PULSEAUDIO=OFF \
           -DUSE_OPENMP=ON \
           -DUSE_DISCORD=OFF \
           -DUSE_LUA=OFF || exit 1

"${CMAKE}" --build "${BUILDDIR}" -j "$(getconf _NPROCESSORS_ONLN)" || exit 1

mv -f "${BUILDDIR}"/shell/orbis/*.pkg "${SCRIPT_DIR}/" || exit 1
