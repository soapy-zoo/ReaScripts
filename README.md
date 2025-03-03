# Seahorse 🌊 Tools for REAPER
Multitrack Source-Destination editing using REAPER's Fixed Item Lanes.

## Introduction
https://github.com/user-attachments/assets/feb693ca-bd95-44a1-9e46-bb7ecf1d34b2

## Prerequisites
1. [SWS Extension](https://www.sws-extension.org/)
2. [ReaPack](https://reapack.com/)
3. [Reaper Tookit (rtk)](https://reapertoolkit.dev/#1_reapack)
4. Set the following setting: _REAPER Preferences -> Editing Behavior -> Locked item ripple editing behavior: **Locked items are unaffected by ripple**_
5. The scripts assume all source media / takes to reside in fixed item lanes. Comp Destination is the topmost lane.
6. For multitrack editing, set all relevant tracks' _grouping parameters_ to _**Media/Razor Edit Lead**_ as well as _**Media/Razor Edit Follow**_
7. Activate _Options -> **Offset overlapping items vertically**_ for better visibility

## Known Limitations
- So far, the scripts only respect symmetrical crossfades. Asymmetrical crossfades have to be edited manually.
- Certain operations will cause muted items to be unmuted. This will be resolved shortly.

# Snail 🐌 Tools for REAPER
Lock items in Fixed Item Lanes when ripple editing.

# Bat 🦇 Tools for REAPER
Quickly move items around using sync points.

# Install the Scripts via ReaPack
https://raw.githubusercontent.com/soapy-zoo/ReaScripts/refs/heads/master/index.xml
