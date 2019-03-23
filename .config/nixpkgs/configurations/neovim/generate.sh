#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

set -eu -o pipefail

rm -f node-env.nix
node2nix -8 -i node-packages.json -o node-packages.nix -c node-composition.nix
