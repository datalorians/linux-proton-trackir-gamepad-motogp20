# 🏍️ MotoGP 20 Saitek X-55 Rhino Controller Adapter for Linux / Proton

Use a **Saitek X-55 Rhino** / **Mad Catz X-55 Rhino** joystick as an Xbox
360-style controller for **MotoGP 20** on Linux through Steam/Proton.

The joystick is required. TrackIR support is optional.

## 🎯 What This Does

This project creates a temporary virtual `Microsoft X-Box 360 pad` and maps the
Saitek X-55 Rhino stick into MotoGP 20's Xbox controller layout.

Default mapping:

| Saitek X-55 Rhino input | Virtual Xbox 360 input | MotoGP 20 behavior |
| --- | --- | --- |
| Stick left/right | Left stick X | Steer left/right |
| Stick forward | Right trigger | Accelerate |
| Stick backward | Left trigger | Front brake / reverse |
| Hat switch | D-pad | Electronics/menu-style directional input |
| Selected stick buttons | Xbox face/shoulder/start/select buttons | Basic controller buttons |

Optional TrackIR mapping:

| TrackIR input | Virtual Xbox 360 input | MotoGP 20 behavior |
| --- | --- | --- |
| Head yaw | Right stick X | View left/right |
| Head pitch | Right stick Y | View up/down |

MotoGP 20 does not need native TrackIR support for this. TrackIR is translated
into the same right-stick view controls shown in the game's default Xbox
controller layout.

## 🧠 Why This Exists

MotoGP 20 is built around gamepad-style controls. A flight stick can be more
comfortable for steering, but the game expects an Xbox controller pattern:

- steering on left stick left/right,
- acceleration on right trigger,
- front brake/reverse on left trigger,
- camera/view on right stick.

This adapter makes the Saitek X-55 Rhino stick look like that controller shape.

## ✅ Tested Setup

| Item | Value |
| --- | --- |
| Game | MotoGP 20 |
| Steam app ID | `1161490` |
| Installed game name | `MotoGP™20` |
| Required device | Saitek X-55 Rhino / Mad Catz X-55 Rhino stick |
| Optional device | TrackIR 5 through LinuxTrack |
| Virtual output | `Microsoft X-Box 360 pad` |

Default joystick path:

```text
/dev/input/by-id/usb-Madcatz_Saitek_Pro_Flight_X-55_Rhino_Stick_G0013831-event-joystick
```

People often search for `saitek x55`, `saitek x-55`, `x55 rhino`,
`Saitek X-55 Rhino joystick`, or `Mad Catz X-55 Rhino`; this is that device
family.

## 📦 Requirements

Required:

- Saitek X-55 Rhino stick
- Python 3
- `python3-evdev`
- Read access to the X-55 event device
- Write access to `/dev/uinput`

Optional for TrackIR view control:

- TrackIR camera configured through LinuxTrack
- `liblinuxtrack.so.0.0.0` available under `~/.local/opt/linuxtrack-trackir`

On Debian/Ubuntu-like systems:

```bash
sudo apt install python3-evdev
```

If the script cannot open the joystick or create the virtual gamepad, your user
may need udev permissions for the joystick and `/dev/uinput`.

## 🚀 Install

```bash
git clone https://github.com/datalorians/linux-proton-x55-trackir-motogp20.git
cd linux-proton-x55-trackir-motogp20
./scripts/install.sh
```

This installs:

```text
~/.local/bin/motogp20-x55-controller
~/.local/bin/motogp20-x55-controller-stop
```

## 🎮 Steam Launch Option

Use this launch option for MotoGP 20:

```bash
bash -lc '$HOME/.local/bin/motogp20-x55-controller & cleanup(){ $HOME/.local/bin/motogp20-x55-controller-stop; }; trap cleanup EXIT; "$@"; rc=$?; cleanup; exit $rc' -- %command%
```

That starts the virtual Xbox 360 controller, launches the game, and removes the
virtual controller when the game exits.

## 👀 Enable Optional TrackIR View Control

TrackIR is off by default. Enable it by prefixing the Steam launch option:

```bash
MOTOGP20_TRACKIR=1 bash -lc '$HOME/.local/bin/motogp20-x55-controller & cleanup(){ $HOME/.local/bin/motogp20-x55-controller-stop; }; trap cleanup EXIT; "$@"; rc=$?; cleanup; exit $rc' -- %command%
```

TrackIR tuning variables:

```bash
MOTOGP20_TRACKIR_YAW_DEG=45
MOTOGP20_TRACKIR_PITCH_DEG=30
MOTOGP20_TRACKIR_INVERT_YAW=0
MOTOGP20_TRACKIR_INVERT_PITCH=0
MOTOGP20_TRACKIR_PROFILE=
```

Larger `*_DEG` values make the view less sensitive. Smaller values make it more
sensitive.

## ⚙️ Joystick Tuning

Invert steering:

```bash
MOTOGP20_INVERT_STEER=1
```

Invert forward/back trigger behavior:

```bash
MOTOGP20_INVERT_THROTTLE=1
```

Adjust forward/back deadzone:

```bash
MOTOGP20_THROTTLE_DEADZONE=0.08
```

Use a different Saitek X-55 Rhino stick path:

```bash
MOTOGP20_X55_STICK=/dev/input/by-id/your-stick-event-joystick
```

Example combined launch option:

```bash
MOTOGP20_TRACKIR=1 MOTOGP20_THROTTLE_DEADZONE=0.08 bash -lc '$HOME/.local/bin/motogp20-x55-controller & cleanup(){ $HOME/.local/bin/motogp20-x55-controller-stop; }; trap cleanup EXIT; "$@"; rc=$?; cleanup; exit $rc' -- %command%
```

## 🧯 Troubleshooting

Start manually:

```bash
~/.local/bin/motogp20-x55-controller
```

Stop manually:

```bash
~/.local/bin/motogp20-x55-controller-stop
```

Check that the virtual controller exists:

```bash
rg -n -C 2 "Microsoft X-Box 360 pad" /proc/bus/input/devices
```

Find likely X-55 device paths:

```bash
ls -l /dev/input/by-id/*X-55* /dev/input/by-id/*Rhino* 2>/dev/null
```

If MotoGP 20 sees duplicate controllers, stop stale adapter processes and start
again:

```bash
~/.local/bin/motogp20-x55-controller-stop
```

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
