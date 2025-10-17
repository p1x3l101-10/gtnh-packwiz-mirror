#!/usr/bin/env bash

PACK_VERSION="2.8.0"

set -euo pipefail

if [[ -e ./build ]]; then
  rm -rf ./build
fi

git clone --recursive https://github.com/p1x3l101-10/gtnh-2-packwiz build

pushd ./build
which nix || cmake --workflow . --preset dev
popd

if which nix; then
  nix run ./build --  --pack-version="${PACK_VERSION}" --config=./config.toml "$@"
else
  exec ./build/build/gtnh-2-packwiz --pack-version="${PACK_VERSION}" --config=./config.toml "$@"
fi
