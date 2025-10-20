#!/usr/bin/env bash
set -euo pipefail

PACK_VERSION="2.8.0"
BRANCH_NAME="$(git branch --show-current)"

if [[ ${BRANCH_NAME} != "main" ]]; then
  PACK_VERSION="${BRANCH_NAME}"
fi

if [[ ! -d ./build ]]; then
  if [[ -e ./build ]]; then
    rm -rf ./build
  fi
  git clone --recursive https://github.com/p1x3l101-10/gtnh-2-packwiz build
fi

cat ./config.toml > ./.config.assembled.toml
cat <<EOF >> ./.config.assembled.toml
targetURL = "https://raw.githubusercontent.com/p1x3l101-10/gtnh-packwiz-mirror/refs/heads/${BRANCH_NAME}/pack"
EOF

pushd ./build
git pull
which nix || cmake --workflow . --preset dev
popd

if which nix; then
  nix run ./build --  --pack-version="${PACK_VERSION}" --config=./.config.assembled.toml --color=on "$@"
else
  exec ./build/build/gtnh-2-packwiz --pack-version="${PACK_VERSION}" --config=./.config.assembled.toml --color=on "$@"
fi
