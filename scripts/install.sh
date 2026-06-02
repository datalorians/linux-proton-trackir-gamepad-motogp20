#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$HOME/.local/bin"

install -m 0755 \
  "$repo_root/bin/motogp20-trackir-gamepad" \
  "$repo_root/bin/motogp20-trackir-gamepad-stop" \
  "$HOME/.local/bin/"

echo "Installed MotoGP 20 TrackIR gamepad helper commands into $HOME/.local/bin"
