# 🏍️ MotoGP 20 TrackIR Gamepad Adapter for Linux / Proton

Add TrackIR-based view control to **MotoGP 20** while playing with an Xbox
controller on Linux through Steam/Proton.

MotoGP 20 already supports Xbox-style controller input. This adapter creates a
temporary virtual Xbox 360 controller, passes your real Xbox controller through
to it, and maps TrackIR head movement onto the virtual right stick view
controls.

## 🎯 What This Does

| Real input | Virtual Xbox 360 output | MotoGP 20 behavior |
| --- | --- | --- |
| Xbox left stick | Left stick | Steering / rider weight |
| Xbox triggers | Triggers | Brake / accelerate |
| Xbox buttons | Buttons | Normal gamepad controls |
| Xbox D-pad | D-pad | Electronics/menu directional controls |
| TrackIR yaw | Right stick X | View left/right |
| TrackIR pitch | Right stick Y | View up/down |

The game sees one controller: the virtual `Microsoft X-Box 360 pad`.

## 🧠 Why Not Use Two Controllers?

MotoGP 20 may not merge input from two separate controllers into one player.
If your real Xbox controller is one device and TrackIR is exposed as another
right-stick-only virtual controller, the game can ignore one of them or assign
them to different controller slots.

This adapter avoids that by merging everything into one virtual gamepad.

## ✅ Tested Setup

| Item | Value |
| --- | --- |
| Game | MotoGP 20 |
| Steam app ID | `1161490` |
| Installed game name | `MotoGP™20` |
| Controller tested | Microsoft Xbox Series S/X Controller |
| Virtual output | `Microsoft X-Box 360 pad` |
| Head tracking | TrackIR through LinuxTrack |

## 📦 Requirements

Required:

- Xbox-compatible controller visible through Linux evdev
- Python 3
- `python3-evdev`
- Read access to the controller event device
- Write access to `/dev/uinput`

Required for head tracking:

- TrackIR camera configured through LinuxTrack
- `liblinuxtrack.so.0.0.0` available under `~/.local/opt/linuxtrack-trackir`

On Debian/Ubuntu-like systems:

```bash
sudo apt install python3-evdev
```

If the script cannot open the controller or create the virtual gamepad, your
user may need udev permissions for the controller and `/dev/uinput`.

## 🚀 Install

```bash
git clone https://github.com/datalorians/linux-proton-trackir-gamepad-motogp20.git
cd linux-proton-trackir-gamepad-motogp20
./scripts/install.sh
```

This installs:

```text
~/.local/bin/motogp20-trackir-gamepad
~/.local/bin/motogp20-trackir-center
~/.local/bin/motogp20-trackir-toggle
~/.local/bin/motogp20-trackir-pause
~/.local/bin/motogp20-trackir-resume
~/.local/bin/motogp20-trackir-gamepad-stop
```

## 🎮 Steam Launch Option

Use this launch option for MotoGP 20:

```bash
bash -lc '$HOME/.local/bin/motogp20-trackir-gamepad & cleanup(){ $HOME/.local/bin/motogp20-trackir-gamepad-stop; }; trap cleanup EXIT; "$@"; rc=$?; cleanup; exit $rc' -- %command%
```

That starts the virtual controller, launches the game, and removes the virtual
controller when the game exits.

## ⚙️ Configuration

Use a specific controller event device:

```bash
MOTOGP20_GAMEPAD=/dev/input/event24
```

TrackIR is enabled by default. Disable it for controller passthrough only:

```bash
MOTOGP20_TRACKIR=0
```

Tune TrackIR sensitivity:

```bash
MOTOGP20_TRACKIR_YAW_DEG=45
MOTOGP20_TRACKIR_PITCH_DEG=30
```

Larger `*_DEG` values make head movement less sensitive. Smaller values make it
more sensitive.

Invert view axes:

```bash
MOTOGP20_TRACKIR_INVERT_YAW=0
MOTOGP20_TRACKIR_INVERT_PITCH=1
```

Trigger look-behind from a large head turn:

```bash
MOTOGP20_TRACKIR_LOOK_BACK_DEG=75
MOTOGP20_TRACKIR_LOOK_BACK_RELEASE_DEG=55
```

When head yaw passes `MOTOGP20_TRACKIR_LOOK_BACK_DEG`, the adapter presses the
virtual right-stick-click button. It releases after yaw returns below
`MOTOGP20_TRACKIR_LOOK_BACK_RELEASE_DEG`, which prevents flicker near the edge.

## 🎯 Recentering

The adapter automatically centers TrackIR on the first valid pose it reads.
Look straight ahead when launching the game for the cleanest startup center.

You can recenter while the adapter is running:

```bash
~/.local/bin/motogp20-trackir-center
```

Bind that command to `F9` if you want the familiar TrackIR-style recenter key:

```text
F9 -> ~/.local/bin/motogp20-trackir-center
```

The adapter watches for that request and uses the next valid TrackIR pose as
the new center.

Pause/resume while the adapter is running:

```bash
~/.local/bin/motogp20-trackir-toggle
```

Bind that command to `F10` for the familiar TrackIR-style pause/resume key:

```text
F10 -> ~/.local/bin/motogp20-trackir-toggle
```

Pause only stops TrackIR from moving the virtual right stick. Your Xbox
controller passthrough continues to work.

The adapter also watches the LinuxTrack/NPClient-style flag files used by many
desktop TrackIR hotkey setups:

```text
/tmp/linuxtrack_npclient_center
/tmp/linuxtrack_npclient_pause
```

If your existing `F9`/`F10` bindings already create those files, they should
work with this adapter too.

Example combined launch option:

```bash
MOTOGP20_GAMEPAD=/dev/input/event24 MOTOGP20_TRACKIR_YAW_DEG=35 bash -lc '$HOME/.local/bin/motogp20-trackir-gamepad & cleanup(){ $HOME/.local/bin/motogp20-trackir-gamepad-stop; }; trap cleanup EXIT; "$@"; rc=$?; cleanup; exit $rc' -- %command%
```

## 🧯 Troubleshooting

Start manually:

```bash
~/.local/bin/motogp20-trackir-gamepad
```

Stop manually:

```bash
~/.local/bin/motogp20-trackir-gamepad-stop
```

List controller event devices:

```bash
python3 - <<'PY'
from evdev import InputDevice, list_devices
for path in list_devices():
    dev = InputDevice(path)
    print(path, dev.name, dev.info)
PY
```

Check that the virtual controller exists:

```bash
rg -n -C 2 "Microsoft X-Box 360 pad" /proc/bus/input/devices
```

If the real controller and virtual controller both appear in MotoGP 20, the
adapter probably could not grab the real controller. Stop the game, stop the
adapter, and start again.

## 🤖 AI Disclosure

This package was developed with assistance from OpenAI's Codex/ChatGPT. The
scripts and documentation were reviewed and tested locally before publication,
but they are community-maintained and provided as-is.

AI disclosure is independent of licensing: the disclosure explains how the work
was produced.

## 📄 License

No license has been selected for this repository.

Unless a license is added, do not assume permission to reuse, redistribute,
sell, sublicense, or incorporate this code into another project. Public source
visibility is not the same thing as an open-source license.
