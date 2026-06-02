#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$HOME/.local/bin"

install -m 0755 \
  "$repo_root/bin/motogp20-x55-controller" \
  "$repo_root/bin/motogp20-x55-controller-stop" \
  "$HOME/.local/bin/"

echo "Installed MotoGP 20 Saitek X-55 Rhino helper commands into $HOME/.local/bin"
