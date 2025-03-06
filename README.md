# Seahorse 🌊 Tools for REAPER
Multitrack Source-Destination editing using REAPER's Fixed Item Lanes.

## Introduction
https://github.com/user-attachments/assets/feb693ca-bd95-44a1-9e46-bb7ecf1d34b2

## 🔥 Features

- Three-point and four-point multitrack source-destination editing
- Fade auditioning and quick editing using single keystrokes
- Extensive user preferences editable via GUI

## ⚙️ Prerequisites
1. [SWS Extension](https://www.sws-extension.org/)
2. [ReaPack](https://reapack.com/)
3. [Reaper Toolkit (rtk)](https://reapertoolkit.dev/#1_reapack)
4. Head to _REAPER Preferences -> Editing Behavior_ and set  _Locked item ripple editing behavior: **Locked items are unaffected by ripple**_
5. For multitrack editing, set all relevant tracks' _grouping parameters_ to _**Media/Razor Edit Lead**_ as well as _**Media/Razor Edit Follow**_
6. Activate _Options -> **Offset overlapping items vertically**_ for better visibility
7. The scripts assume all source media / takes to reside in fixed item lanes. Comp Destination is the topmost lane.

## 🌟 How it works
### Make sure...
✔️ to read the **prerequisites** carefully.
<br> ✔️ your track groups' ```Razor Edit Lead / Follow``` parameters are set up as desired.
<br> ✔️ your source media is organized in **fixed item lanes** and there is at least **one empty lane** at the top. This will be your destination.

### ✂️ 3- and 4-Point Edit

1. **Place the source markers in the desired area of your source take.** 
<br> Select the source item (the lane does not have to be active). Place the edit cursor and run the scripts ```SetSrcIn``` or ```SetSrcOut``` respectively.
<br> Switch to 'fast mode' in preferences where you can place source markers simply by hovering over the item.

2. **Set one or two destination markers.** 
<br> Place the edit cursor and run the scripts ```SetDstIn``` or ```SetDstOut``` respectively.

3. **Perform the Edit!** 
<br> Keep the source item selected, then run one of the three scripts:
<br> - ```3pointNoRipple```
<br> - ```3pointRipple```
<br> - ```4point```

### 🎧 Fade Audition

Hover the mouse over any item. 
To hear the fade closest to the mouse pointer, run one of the scripts:
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - ```AuditionXFade``` : You will hear the crossfade.
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - ```AuditionXIn``` : You will hear material up to the fade.
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - ```AuditionXOut``` : You will hear material after the fade.
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - ```AuditionOIn``` : You will hear the _left_ side material _extended past_ the fade.
<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - ```AuditionOOut``` : You will hear the _right_ side material _extended before_ the fade.

Pre-roll and post-roll times are editable in the user preferences. More to come.

### 🎚️ Quick Fade Edit

You might want to turn on ripple mode **(and off, after you're done)**. :)
<br> Activate _Options -> **Offset overlapping items vertically**_ for better visibility. 
<br> Consider having a look at the Snail 🐌 Tools which might come in handy when ripple editing with media in fixed item lanes.

1. **Line up items at the cut.**
<br> To make the waveform visible, use the script ```ExtendItems```.
<br> Hover over any item near its edge and run the script in order to extend the items' ends incrementally in opposite directions.

2. **Perform the Fade!**
<br> Run the script ```QuickFade``` to place a quick standard fade at your mouse position. Sculpt the fade to taste.

Standard fade length and extension increments are editable in the user preferences.

### 💅 User Preferences

Find all preferences concerning the seahorse scripts by running ```soapy-seahorse_Preferences.lua```
<br> Switch through tabs on the top right.
<br> With text / number entries, don't forget to save using the _Apply_ buttons.

## ⚡ Known Limitations
- So far, the scripts only respect symmetrical crossfades. Asymmetrical crossfades have to be edited manually.
- Certain operations will cause muted items to be unmuted. This will be resolved shortly.
- Active development is in progress using REAPER 7.

# Snail 🐌 Tools for REAPER
Lock items in Fixed Item Lanes when ripple editing. Useful complementary scripts to the source-destination workflow presented above.

# Bat 🦇 Tools for REAPER
Quickly move items around using sync points.

# Install the Scripts via ReaPack
https://raw.githubusercontent.com/soapy-zoo/ReaScripts/refs/heads/master/index.xml

# Credits
Huge thanks to all people who contributed to the project. 🌈