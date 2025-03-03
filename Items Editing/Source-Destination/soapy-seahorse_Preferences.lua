-- @description Source-Destination Tools ("Seahorse")
-- @version 0.2.2 
-- @author the soapy zoo
-- @about
--   # Seahorse Source-Destination Tools 
--   documentation will follow _soon(TM)_
-- @provides
--    [main] *.lua
--    [nomain] soapy-seahorse_functions/*.lua
--    [nomain] *.md
--[[

source-destination: preferences

This file is part of the soapy-seahorse package.

(C) 2025 the soapy zoo

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
]]

local r = reaper

-- Set package path to find rtk installed via ReaPack
package.path = reaper.GetResourcePath() .. '/Scripts/rtk/1/?.lua'
-- Load the package
local rtk = require('rtk')
-- Set the module-local log variable for more convenient logging.
local log = rtk.log

local modulePath = ({r.get_action_context()})[2]:match("^.+[\\/]")
package.path = modulePath .. "soapy-seahorse_functions/?.lua"
local st = require("soapy-seahorse_Settings_Functions")

local sectionName = st.GetSectionName()

local tbl_Settings = {}

local b_ShowHoverWarnings,
f_xFadeLen,
b_AutoCrossfade,
b_MoveDstGateAfterEdit,
b_RemoveAllSourceGates,
b_EditTargetsItemUnderMouse,
b_KeepLaneSolo,
b_PreserveEditCursorPosition,
b_SelectRightItemAtCleanup,
b_AvoidCollision,
b_PreserveExistingCrossfade,
b_EditTargetsMouseInsteadOfCursor,
f_extensionAmount,
f_collisionPadding,
f_cursorBias_Extender,
f_cursorBias_QuickFade,
i_xFadeShape,
b_TransportAutoStop,
b_KeepCursorPosition,
b_RemoveFade,
b_GatesTargetItemUnderMouse,
b_GatesTargetMouseInsteadOfCursor,
s_markerLabel_SrcIn,
s_markerLabel_SrcOut,
s_markerLabel_DstIn,
s_markerLabel_DstOut,
i_markerIndex_DstIn,
i_markerIndex_DstOut,
c_markerColor_Src,
c_markerColor_Dst

----------------------------------------------------------------------------------------------------------

function GetSettings()

    tbl_Settings = st.GetSettings()

    b_ShowHoverWarnings = tbl_Settings.b_ShowHoverWarnings
    f_xFadeLen = tbl_Settings.f_xFadeLen
    b_AutoCrossfade = tbl_Settings.b_AutoCrossfade
    b_MoveDstGateAfterEdit = tbl_Settings.b_MoveDstGateAfterEdit
    b_RemoveAllSourceGates = tbl_Settings.b_RemoveAllSourceGates
    b_EditTargetsItemUnderMouse = tbl_Settings.b_EditTargetsItemUnderMouse
    b_KeepLaneSolo = tbl_Settings.b_KeepLaneSolo
    b_PreserveEditCursorPosition = tbl_Settings.b_PreserveEditCursorPosition
    b_SelectRightItemAtCleanup = tbl_Settings.b_SelectRightItemAtCleanup
    b_AvoidCollision = tbl_Settings.b_AvoidCollision
    b_PreserveExistingCrossfade = tbl_Settings.b_PreserveExistingCrossfade
    b_EditTargetsMouseInsteadOfCursor = tbl_Settings.b_EditTargetsMouseInsteadOfCursor
    f_extensionAmount = tbl_Settings.f_extensionAmount
    f_collisionPadding = tbl_Settings.f_collisionPadding
    f_cursorBias_Extender = tbl_Settings.f_cursorBias_Extender
    f_cursorBias_QuickFade = tbl_Settings.f_cursorBias_QuickFade
    i_xFadeShape = tbl_Settings.i_xFadeShape
    b_TransportAutoStop = tbl_Settings.b_TransportAutoStop
    b_KeepCursorPosition = tbl_Settings.b_KeepCursorPosition
    b_RemoveFade = tbl_Settings.b_RemoveFade
    b_GatesTargetItemUnderMouse = tbl_Settings.b_GatesTargetItemUnderMouse
    b_GatesTargetMouseInsteadOfCursor = tbl_Settings.b_GatesTargetMouseInsteadOfCursor
    s_markerLabel_SrcIn = tbl_Settings.s_markerLabel_SrcIn
    s_markerLabel_SrcOut = tbl_Settings.s_markerLabel_SrcOut
    s_markerLabel_DstIn = tbl_Settings.s_markerLabel_DstIn
    s_markerLabel_DstOut = tbl_Settings.s_markerLabel_DstOut
    i_markerIndex_DstIn = tbl_Settings.i_markerIndex_DstIn
    i_markerIndex_DstOut = tbl_Settings.i_markerIndex_DstOut
    c_markerColor_Src = tbl_Settings.c_markerColor_Src
    c_markerColor_Dst = tbl_Settings.c_markerColor_Dst

end

----------------------------------------------------------------------------------------------------------

function BoolToString(mybool)

    if mybool == true then
        mybool = 'true'
    elseif mybool == false or mybool == nil then
        mybool = 'false'
    end

    return mybool
end

----------------------------------------------------------------------------------------------------------

function Main()

    local window = rtk.Window{borderless=false, title='Seahorse Source-Destination Settings', minh=750}
    local spacer = rtk.Text{'\n'}

    ----------------------
    -- general settings --
    ----------------------

    local general = {
        init = function(app, screen)
            local pBox = rtk.VBox{margin=10, spacing=8}

            local childBox = rtk.FlowBox{margin=10, vspacing=4}
            local cb_ShowHoverWarnings = rtk.CheckBox{label='Show warning messages (this is helpful if you\'re using the scripts for the first time)', value=b_ShowHoverWarnings}

            local en_xFadeLen = rtk.Entry{placeholder='Default Crossfade Length', textwidth=3.1, value=f_xFadeLen}
            local tx_xFadeLen = rtk.Text{'Default Crossfade Length (seconds)'}

            childBox:add(cb_ShowHoverWarnings)

            childBox:add(spacer)

            local enBox = rtk.HBox{valign='center'}

            enBox:add(en_xFadeLen)
            enBox:add(tx_xFadeLen)
            childBox:add(enBox)

            pBox:add(rtk.Heading{'General'})
            pBox:add(childBox)

            screen.widget = pBox

            cb_ShowHoverWarnings.onchange = function()
                r.SetExtState(sectionName, 'b_ShowHoverWarnings', BoolToString(cb_ShowHoverWarnings.value), true)
            end
        end
    }

    ----------------------------
    -- edit & marker settings --
    ----------------------------

    local edit_markers = {

        init = function(app, screen)
            local pBox = rtk.VBox{margin=10, spacing=8}

            local childBox = rtk.FlowBox{margin=10, vspacing=4}
            local cb_autoCrossfade = rtk.CheckBox{label='Auto crossfade: Fade newly edited items', value=b_AutoCrossfade}
            local cb_moveDstGateAfterEdit = rtk.CheckBox{label='Move destination gate to end of newly pasted item (recommended)', value=b_MoveDstGateAfterEdit}
            local cb_removeAllSourceGates = rtk.CheckBox{label='Remove all source gates after edit', value=b_RemoveAllSourceGates}
            local cb_EditTargetsItemUnderMouse = rtk.CheckBox{label='Select item under mouse (no click to select required)', value=b_EditTargetsItemUnderMouse}
            local cb_KeepLaneSolo = rtk.CheckBox{label='Keep lane solo after edit, do not jump to comp lane', value=b_KeepLaneSolo}

            childBox:add(cb_autoCrossfade)
            childBox:add(cb_moveDstGateAfterEdit)
            childBox:add(cb_removeAllSourceGates)
            childBox:add(cb_EditTargetsItemUnderMouse)
            childBox:add(cb_KeepLaneSolo)

            local childBox2 = rtk.FlowBox{margin=10, vspacing=4}
            local cb_GatesTargetItemUnderMouse = rtk.CheckBox{label='Select item under mouse (no click to select required)', value=b_GatesTargetItemUnderMouse}
            local cb_GatesTargetMouseInsteadOfCursor = rtk.CheckBox{label='Place source gate at mouse position instead of edit cursor', value=b_GatesTargetMouseInsteadOfCursor}

            childBox2:add(cb_GatesTargetItemUnderMouse)
            childBox2:add(cb_GatesTargetMouseInsteadOfCursor)

            pBox:add(rtk.Heading{'3- & 4-point Edit'})
            pBox:add(childBox)
            pBox:add(rtk.Heading{'Source & Destination Gates'})
            pBox:add(childBox2)
            
            cb_autoCrossfade.onchange = function()
                r.SetExtState(sectionName, 'b_autoCrossfade', BoolToString(cb_autoCrossfade.value), true)
            end
            cb_moveDstGateAfterEdit.onchange = function()
                r.SetExtState(sectionName, 'b_moveDstGateAfterEdit', BoolToString(cb_moveDstGateAfterEdit.value), true)
            end
            cb_removeAllSourceGates.onchange = function()
                r.SetExtState(sectionName, 'b_removeAllSourceGates', BoolToString(cb_removeAllSourceGates.value), true)
            end
            cb_EditTargetsItemUnderMouse.onchange = function()
                r.SetExtState(sectionName, 'b_EditTargetsItemUnderMouse', BoolToString(cb_EditTargetsItemUnderMouse.value), true)
            end
            cb_KeepLaneSolo.onchange = function()
                r.SetExtState(sectionName, 'b_KeepLaneSolo', BoolToString(cb_KeepLaneSolo.value), true)
            end

            screen.widget = pBox

        end
    }

    ----------------------------
    -- extend & fade settings --
    ----------------------------

    local extend_fade = {

        init = function(app, screen)
            local pBox = rtk.VBox{margin=10, spacing=8}

            local childBox = rtk.FlowBox{margin=10, vspacing=4}
            local cb_PreserveEditCursorPosition = rtk.CheckBox{label='Preserve edit cursor position: If unchecked, cursor will jump to center between items', value=b_PreserveEditCursorPosition}
            local cb_SelectRightItemAtCleanup = rtk.CheckBox{label='Keep right item selected at cleanup', value=b_SelectRightItemAtCleanup}
            local cb_AvoidCollision = rtk.CheckBox{label='Avoid Collision (avoid overlap of more than 2 items)', value=b_AvoidCollision}
            local cb_PreserveExistingCrossfade = rtk.CheckBox{label='Preserve existing crossfade\'s length & shape', value=b_PreserveExistingCrossfade}
            local cb_EditTargetsMouseInsteadOfCursor = rtk.CheckBox{label='Set fade at mouse position. If unchecked, fade will be set at edit cursor position.', value = b_EditTargetsMouseInsteadOfCursor}
            local sl_cursorBias_Extender = rtk.Slider{placeholder='Cursor Bias Extender', color='purple', min=0.0, max=1.0, step=0.02, value=f_cursorBias_Extender}
            local sl_cursorBias_QuickFade = rtk.Slider{placeholder='Cursor Bias Quick Fade', color='purple', min=0.0, max=1.0, step=0.02, value=f_cursorBias_QuickFade}
            local en_extensionAmount = rtk.Entry{placeholder='extension Amount (seconds)', textwidth=3.1, value=f_extensionAmount}
            local tx_extensionAmount = rtk.Text{'Extension Amount (seconds)'}
            local en_collisionPadding = rtk.Entry{placeholder='Collision Padding (seconds)', textwidth=3.1, value=f_collisionPadding}
            local tx_collisionPadding = rtk.Text{'Collision Padding (seconds)'}

            childBox:add(cb_PreserveEditCursorPosition)
            childBox:add(cb_SelectRightItemAtCleanup)
            childBox:add(cb_AvoidCollision)
            childBox:add(cb_PreserveExistingCrossfade)
            childBox:add(cb_EditTargetsMouseInsteadOfCursor)

            childBox:add(spacer)

            local slBox11 = rtk.HBox{spacing=5, valign='center'}
            slBox11:add(rtk.Text{'Left'})
            slBox11:add(sl_cursorBias_Extender)
            slBox11:add(rtk.Text{'Right'})
            local slBox1 = rtk.VBox{}
            slBox1:add(rtk.Text{'Cursor Bias Item Extender:'})
            slBox1:add(slBox11)
            childBox:add(slBox1)

            local slBox22 = rtk.HBox{spacing=5, valign='center'}
            slBox22:add(rtk.Text{'Left'})
            slBox22:add(sl_cursorBias_QuickFade)
            slBox22:add(rtk.Text{'Right'})
            local slBox2 = rtk.VBox{}
            slBox2:add(rtk.Text{'Cursor Bias Quick Fade:'})
            slBox2:add(slBox22)
            childBox:add(slBox2)

            childBox:add(spacer)

            local enBox1 = rtk.HBox{valign='center'}
            enBox1:add(en_extensionAmount)
            enBox1:add(tx_extensionAmount)
            childBox:add(enBox1)

            local enBox2 = rtk.HBox{valign='center'}
            enBox2:add(en_collisionPadding)
            enBox2:add(tx_collisionPadding)
            childBox:add(enBox2)

            pBox:add(rtk.Heading{'Item Extender & Quick Fade'})
            pBox:add(childBox)

            screen.widget = pBox

            cb_PreserveEditCursorPosition.onchange = function()
                r.SetExtState(sectionName, 'b_PreserveEditCursorPosition', BoolToString(cb_PreserveEditCursorPosition.value), true)
            end
            cb_SelectRightItemAtCleanup.onchange = function()
                r.SetExtState(sectionName, 'b_SelectRightItemAtCleanup', BoolToString(cb_SelectRightItemAtCleanup.value), true)
            end
            cb_AvoidCollision.onchange = function()
                r.SetExtState(sectionName, 'b_AvoidCollision', BoolToString(cb_AvoidCollision.value), true)
            end
            cb_PreserveExistingCrossfade.onchange = function()
                r.SetExtState(sectionName, 'b_PreserveExistingCrossfade', BoolToString(cb_PreserveExistingCrossfade.value), true)
            end
            cb_EditTargetsMouseInsteadOfCursor.onchange = function()
                r.SetExtState(sectionName, 'b_EditTargetsMouseInsteadOfCursor', BoolToString(cb_EditTargetsMouseInsteadOfCursor.value), true)
            end

        end
    }

    -----------------------
    -- audition settings --
    -----------------------

    local audition = {

        init = function(app, screen)
            local pBox = rtk.VBox{margin=10, spacing=8}

            local childBox = rtk.FlowBox{margin=10, vspacing=4}
            local cb_TransportAutoStop = rtk.CheckBox{label='Stop transport automatically after auditioning', value=b_TransportAutoStop}
            local cb_KeepCursorPosition = rtk.CheckBox{label='Preserve edit cursor position: If unchecked, cursor will jump to center of the fade', value=b_KeepCursorPosition}
            local cb_RemoveFade = rtk.CheckBox{label='Audition without fade', value=b_RemoveFade}

            childBox:add(cb_TransportAutoStop)
            childBox:add(cb_KeepCursorPosition)
            childBox:add(cb_RemoveFade)

            pBox:add(rtk.Heading{'Fade Audition'})
            pBox:add(childBox)

            screen.widget = pBox

            cb_TransportAutoStop.onchange = function()
                r.SetExtState(sectionName, 'b_TransportAutoStop', BoolToString(cb_TransportAutoStop.value), true)
            end
            cb_KeepCursorPosition.onchange = function()
                r.SetExtState(sectionName, 'b_KeepCursorPosition', BoolToString(cb_KeepCursorPosition.value), true)
            end
            cb_RemoveFade.onchange = function()
                r.SetExtState(sectionName, 'b_RemoveFade', BoolToString(cb_RemoveFade.value), true)
            end
        end
    }

    -----------------------
    -- advanced settings --
    -----------------------

    local advanced = {

        init = function(app, screen)
            local pBox = rtk.VBox{margin=10, spacing=8}
            pBox:add(rtk.Heading{'Advanced'})
            pBox:add(rtk.Text{'coming soon (TM)'})
            screen.widget = pBox
        end
    }

    ---------------------
    -- rest of the app --
    ---------------------

    local app = window:add(rtk.Application())
    app.statusbar:hide()

    app:add_screen(general, 'general')
    app:add_screen(edit_markers, 'edit_markers')
    app:add_screen(extend_fade, 'extend_fade')
    app:add_screen(audition, 'audition')
    app:add_screen(advanced, 'advanced')

    local b1 = app.toolbar:add(rtk.Button{label='General', flat=true})
    local b2 = app.toolbar:add(rtk.Button{label='Edit & Gates', flat=true})
    local b3 = app.toolbar:add(rtk.Button{label='Extend & Fade', flat=true})
    local b4 = app.toolbar:add(rtk.Button{label='Audition', flat=true})
    local b5 = app.toolbar:add(rtk.Button{label='Advanced', flat=true})
    b1.onclick = function()
        app:push_screen('general')
        -- Mark as handled, for the same reason as described above.
        return true
    end
    b2.onclick = function()
        app:push_screen('edit_markers')
        -- Mark as handled, for the same reason as described above.
        return true
    end
    b3.onclick = function()
        app:push_screen('extend_fade')
        -- Mark as handled, for the same reason as described above.
        return true
    end
    b4.onclick = function()
        app:push_screen('audition')
        -- Mark as handled, for the same reason as described above.
        return true
    end
    b5.onclick = function()
        app:push_screen('advanced')
        -- Mark as handled, for the same reason as described above.
        return true
    end
    window:open()

end

GetSettings()
rtk.call(Main)