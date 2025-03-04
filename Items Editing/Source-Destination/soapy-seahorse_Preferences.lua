-- @description Source-Destination Tools ("Seahorse")
-- @version 0.2.6
-- @author the soapy zoo
-- @about
--   # Seahorse Source-Destination Tools 
--   documentation will follow _soon(TM)_
-- @changelog
--    *audition pre & post roll accessible via preferences
--    *added button to trash all preferences
--    *minor usability improvements
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
f_preRoll,
f_postRoll,
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
    f_preRoll = tbl_Settings.f_preRoll
    f_postRoll = tbl_Settings.f_postRoll
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

function ErrMsgNumber()

    r.MB('Please make sure to enter a valid number.', 'Notice', 0)

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
            local cb_ShowHoverWarnings = rtk.CheckBox{label='Show warning messages \n(this is helpful if you\'re using the scripts for the first time)', value=b_ShowHoverWarnings}

            local en_xFadeLen = rtk.Entry{placeholder='Default Crossfade Length', textwidth=3.1, value=f_xFadeLen}
            local tx_xFadeLen = rtk.Text{'Default Crossfade Length (seconds)'}
            local bt_xFadeLen = rtk.Button{label='Apply', color='DimGrey'}

            childBox:add(cb_ShowHoverWarnings)

            childBox:add(spacer)

            local enBox = rtk.HBox{valign='center', spacing=8}
            enBox:add(en_xFadeLen)
            enBox:add(tx_xFadeLen)
            enBox:add(bt_xFadeLen)
            childBox:add(enBox)

            pBox:add(rtk.Heading{'General'})
            pBox:add(childBox)

            screen.widget = pBox

            cb_ShowHoverWarnings.onchange = function()
                r.SetExtState(sectionName, 'b_ShowHoverWarnings', BoolToString(cb_ShowHoverWarnings.value), true)
            end

            local en_xFadeLen_state = f_xFadeLen
            en_xFadeLen.onchange = function()
                en_xFadeLen_state = en_xFadeLen.value
                bt_xFadeLen:animate{'color', dst='crimson'}
            end
            bt_xFadeLen.onclick = function()
                if type(tonumber(en_xFadeLen_state)) == "number" and en_xFadeLen_state == en_xFadeLen_state then
                    bt_xFadeLen:animate{'color', dst='green'}
                    r.SetExtState(sectionName, 'f_xFadeLen', tostring(en_xFadeLen_state), true)
                else
                    ErrMsgNumber()
                end
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
            cb_GatesTargetItemUnderMouse.onchange = function()
                r.SetExtState(sectionName, 'b_GatesTargetItemUnderMouse', BoolToString(cb_GatesTargetItemUnderMouse.value), true)
            end
            cb_GatesTargetMouseInsteadOfCursor.onchange = function()
                r.SetExtState(sectionName, 'b_GatesTargetMouseInsteadOfCursor', BoolToString(cb_GatesTargetMouseInsteadOfCursor.value), true)
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
            local cb_PreserveEditCursorPosition = rtk.CheckBox{label='Preserve edit cursor position', value=b_PreserveEditCursorPosition}

            if b_PreserveEditCursorPosition then
                cb_PreserveEditCursorPosition:attr('label', 'Preserve edit cursor position\nEdit cursor stays where you left it')
            else
                cb_PreserveEditCursorPosition:attr('label', 'Preserve edit cursor position\nEdit cursor will jump to center between items')
            end
            local cb_SelectRightItemAtCleanup = rtk.CheckBox{label='Keep right item selected at cleanup', value=b_SelectRightItemAtCleanup}
            local cb_AvoidCollision = rtk.CheckBox{label='Avoid Collision (avoid overlap of more than 2 items)', value=b_AvoidCollision}
            local cb_PreserveExistingCrossfade = rtk.CheckBox{label='Preserve existing crossfade\'s length & shape', value=b_PreserveExistingCrossfade}
            local cb_EditTargetsMouseInsteadOfCursor = rtk.CheckBox{label='Set fade at mouse position', value = b_EditTargetsMouseInsteadOfCursor}
            if b_EditTargetsMouseInsteadOfCursor then
                cb_EditTargetsMouseInsteadOfCursor:attr('label', 'Set fade at mouse position\nFade is set at mouse position (fast mode - no click required)')
            else
                cb_EditTargetsMouseInsteadOfCursor:attr('label', 'Set fade at mouse position\nFade is set at edit cursor position')
            end

            local en_extensionAmount = rtk.Entry{placeholder='extension Amount (seconds)', textwidth=3.1, value=f_extensionAmount}
            local tx_extensionAmount = rtk.Text{'Extension Amount (seconds)'}
            local bt_extensionAmount = rtk.Button{label='Apply', color='DimGrey'}
            local en_collisionPadding = rtk.Entry{placeholder='Collision Padding (seconds)', textwidth=3.1, value=f_collisionPadding}
            local tx_collisionPadding = rtk.Text{'Collision Padding (seconds)'}
            local bt_collisionPadding = rtk.Button{label='Apply', color='DimGrey'}

            childBox:add(cb_PreserveEditCursorPosition)
            childBox:add(cb_SelectRightItemAtCleanup)
            childBox:add(cb_AvoidCollision)
            childBox:add(cb_PreserveExistingCrossfade)
            childBox:add(cb_EditTargetsMouseInsteadOfCursor)

            childBox:add(spacer)

            local enBox1 = rtk.HBox{valign='center', spacing=8}
            enBox1:add(en_extensionAmount)
            enBox1:add(tx_extensionAmount)
            enBox1:add(bt_extensionAmount)
            childBox:add(enBox1)

            local enBox2 = rtk.HBox{valign='center', spacing=8}
            enBox2:add(en_collisionPadding)
            enBox2:add(tx_collisionPadding)
            enBox2:add(bt_collisionPadding)
            childBox:add(enBox2)

            pBox:add(rtk.Heading{'Item Extender & Quick Fade'})
            pBox:add(childBox)

            screen.widget = pBox

            cb_PreserveEditCursorPosition.onchange = function()
                r.SetExtState(sectionName, 'b_PreserveEditCursorPosition', BoolToString(cb_PreserveEditCursorPosition.value), true)
                if cb_PreserveEditCursorPosition.value then
                    cb_PreserveEditCursorPosition:attr('label', 'Preserve edit cursor position\nEdit cursor stays where you left it')
                else
                    cb_PreserveEditCursorPosition:attr('label', 'Preserve edit cursor position\nEdit cursor will jump to center between items')
                end
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
                if cb_EditTargetsMouseInsteadOfCursor.value then
                    cb_EditTargetsMouseInsteadOfCursor:attr('label', 'Set fade at mouse position\nFade is set at mouse position (fast mode - no click required)')
                else
                    cb_EditTargetsMouseInsteadOfCursor:attr('label', 'Set fade at mouse position\nFade is set at edit cursor position')
                end
            end

            -- entry and button handling
            local en_extensionAmount_state, en_collisionPadding_state = f_extensionAmount, f_collisionPadding
            en_extensionAmount.onchange = function()
                en_extensionAmount_state = en_extensionAmount.value
                bt_extensionAmount:animate{'color', dst='crimson'}
            end
            bt_extensionAmount.onclick = function()
                if type(tonumber(en_extensionAmount_state)) == "number" and en_extensionAmount_state == en_extensionAmount_state then
                    bt_extensionAmount:animate{'color', dst='green'}
                    r.SetExtState(sectionName, 'f_extensionAmount', tostring(en_extensionAmount_state), true)
                else
                    ErrMsgNumber()
                end
            end

            en_collisionPadding.onchange = function()
                en_collisionPadding_state = en_collisionPadding.value
                bt_collisionPadding:animate{'color', dst='crimson'}
            end
            bt_collisionPadding.onclick = function()
                if type(tonumber(en_collisionPadding_state)) == "number" and en_collisionPadding_state == en_collisionPadding_state then
                    bt_collisionPadding:animate{'color', dst='green'}
                    r.SetExtState(sectionName, 'f_collisionPadding', en_collisionPadding_state, true)
                else
                    ErrMsgNumber()
                end
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
            local cb_TransportAutoStop = rtk.CheckBox{label='Auto stop transport after auditioning', value=b_TransportAutoStop}
            local cb_KeepCursorPosition = rtk.CheckBox{label='Preserve edit cursor position', value=b_KeepCursorPosition}
            if b_KeepCursorPosition then
                cb_KeepCursorPosition:attr('label', 'Preserve edit cursor position\nEdit cursor stays where you left it')
            else
                cb_KeepCursorPosition:attr('label', 'Preserve edit cursor position\nEdit cursor will jump to center of fade')
            end
            local cb_RemoveFade = rtk.CheckBox{label='Audition without fade', value=b_RemoveFade}
            if b_RemoveFade then
                cb_RemoveFade:attr('label', 'Audition without fade\nFade is temporarily removed for auditioning')
            else
                cb_RemoveFade:attr('label', 'Audition without fade\nAuditions the fade as-is')
            end

            local sl_preRoll = rtk.Slider{placeholder='Audition Pre Roll', color='MediumOrchid', min=0.0, max=8.0, step=0.02, value=f_preRoll}
            local en_preRoll = rtk.Entry{textwidth=3.1, value=f_preRoll}
            local bt_preRoll = rtk.Button{label='Apply', color='DimGrey'}

            local sl_postRoll = rtk.Slider{placeholder='Audition Post Roll', color='MediumOrchid', min=0.0, max=8.0, step=0.02, value=f_postRoll}
            local en_postRoll = rtk.Entry{textwidth=3.1, value=f_postRoll}
            local bt_postRoll = rtk.Button{label='Apply', color='DimGrey'}

            local slBox11 = rtk.HBox{spacing=5, valign='center'}
            slBox11:add(rtk.Text{'Short'})
            slBox11:add(sl_preRoll)
            slBox11:add(rtk.Text{'Long'})
            local slBox1 = rtk.VBox{}
            slBox1:add(rtk.Text{'Audition Pre Roll'})
            slBox1:add(slBox11)
            local slBox111 = rtk.HBox{spacing=5, valign='center'}
            slBox111:add(en_preRoll)
            slBox111:add(bt_preRoll)
            slBox1:add(slBox111)

            local slBox22 = rtk.HBox{spacing=5, valign='center'}
            slBox22:add(rtk.Text{'Short'})
            slBox22:add(sl_postRoll)
            slBox22:add(rtk.Text{'Long'})
            local slBox2 = rtk.VBox{}
            slBox2:add(rtk.Text{'Audition Post Roll'})
            slBox2:add(slBox22)
            local slBox222 = rtk.HBox{spacing=5, valign='center'}
            slBox222:add(en_postRoll)
            slBox222:add(bt_postRoll)
            slBox2:add(slBox222)

            childBox:add(cb_TransportAutoStop)
            childBox:add(cb_KeepCursorPosition)
            childBox:add(cb_RemoveFade)
            childBox:add(spacer)
            childBox:add(slBox1)
            childBox:add(spacer)
            childBox:add(slBox2)

            pBox:add(rtk.Heading{'Fade Audition'})
            pBox:add(childBox)

            screen.widget = pBox

            cb_TransportAutoStop.onchange = function()
                r.SetExtState(sectionName, 'b_TransportAutoStop', BoolToString(cb_TransportAutoStop.value), true)
            end
            cb_KeepCursorPosition.onchange = function()
                r.SetExtState(sectionName, 'b_KeepCursorPosition', BoolToString(cb_KeepCursorPosition.value), true)
                if cb_KeepCursorPosition.value then
                    cb_KeepCursorPosition:attr('label', 'Preserve edit cursor position\nEdit cursor stays where you left it')
                else
                    cb_KeepCursorPosition:attr('label', 'Preserve edit cursor position\nEdit cursor will jump to center of fade')
                end
            end
            cb_RemoveFade.onchange = function()
                r.SetExtState(sectionName, 'b_RemoveFade', BoolToString(cb_RemoveFade.value), true)
                if cb_RemoveFade.value then
                    cb_RemoveFade:attr('label', 'Audition without fade\nFade is temporarily removed for auditioning')
                else
                    cb_RemoveFade:attr('label', 'Audition without fade\nAuditions the fade as-is')
                end
            end

            local en_preRoll_state, en_postRoll_state = f_preRoll, f_postRoll
            sl_preRoll.onchange = function()
                en_preRoll_state = sl_preRoll.value
                en_preRoll:attr('value', tostring(en_preRoll_state))
                r.SetExtState(sectionName, 'f_preRoll', en_preRoll_state, true)
                bt_preRoll:animate{'color', dst='green'}
            end

            en_preRoll.onchange = function()
                en_preRoll_state = en_preRoll.value
                if type(tonumber(en_preRoll_state)) == "number" and en_preRoll_state == en_preRoll_state then
                    sl_preRoll:attr('value', en_preRoll.value)
                    bt_preRoll:animate{'color', dst='crimson'}
                else
                    ErrMsgNumber()
                    bt_preRoll:attr('color', 'crimson')
                end
            end

            bt_preRoll.onclick = function()
                if type(tonumber(en_preRoll_state)) == "number" and en_preRoll_state == en_preRoll_state then
                    r.SetExtState(sectionName, 'f_preRoll', en_preRoll_state, true)
                    bt_preRoll:attr('color', 'green')
                else
                    ErrMsgNumber()
                end
            end

            sl_postRoll.onchange = function()
                en_postRoll_state = sl_postRoll.value
                en_postRoll:attr('value', tostring(en_postRoll_state))
                r.SetExtState(sectionName, 'f_postRoll', en_postRoll_state, true)
                bt_postRoll:animate{'color', dst='green'}
            end

            en_postRoll.onchange = function()
                en_postRoll_state = en_postRoll.value
                if type(tonumber(en_postRoll_state)) == "number" and en_postRoll_state == en_postRoll_state then
                    sl_postRoll:attr('value', en_postRoll.value)
                    bt_postRoll:animate{'color', dst='crimson'}
                else
                    bt_postRoll:attr('color', 'crimson')
                    ErrMsgNumber()
                end
            end

            bt_postRoll.onclick = function()
                if type(tonumber(en_postRoll_state)) == "number" and en_postRoll_state == en_postRoll_state then
                    r.SetExtState(sectionName, 'f_postRoll', en_postRoll_state, true)
                    bt_postRoll:attr('color', 'green')
                else
                    ErrMsgNumber()
                end
            end
        end
    }

    -----------------------
    -- advanced settings --
    -----------------------

    local advanced = {

        init = function(app, screen)
            local pBox = rtk.VBox{margin=10, spacing=8}
            local bt_trashSettings = rtk.Button{label='Trash Settings', color='crimson'}
            pBox:add(rtk.Heading{'Advanced'})
            pBox:add(rtk.Text{'more features coming soon (TM)'})
            pBox:add(bt_trashSettings)
            screen.widget = pBox
            bt_trashSettings.onclick = function()
                st.DeleteAllSettings(true)
                bt_trashSettings:animate{'color', dst='green'}
            end
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

    local b1 = app.toolbar:add(rtk.Button{label='General', color='MediumOrchid'})
    local b2 = app.toolbar:add(rtk.Button{label='Edit & Gates', color='DimGrey'})
    local b3 = app.toolbar:add(rtk.Button{label='Extend & Fade', color='DimGrey'})
    local b4 = app.toolbar:add(rtk.Button{label='Audition', color='DimGrey'})
    local b5 = app.toolbar:add(rtk.Button{label='Advanced', color='DimGrey'})
    b1.onclick = function()
        app:push_screen('general')
        b1:animate{'color', dst='MediumOrchid'}
        b2:animate{'color', dst='DimGrey'}
        b3:animate{'color', dst='DimGrey'}
        b4:animate{'color', dst='DimGrey'}
        b5:animate{'color', dst='DimGrey'}
        -- Mark as handled, for the same reason as described above.
        return true
    end
    b2.onclick = function()
        app:push_screen('edit_markers')
        b1:animate{'color', dst='DimGrey'}
        b2:animate{'color', dst='MediumOrchid'}
        b3:animate{'color', dst='DimGrey'}
        b4:animate{'color', dst='DimGrey'}
        b5:animate{'color', dst='DimGrey'}
        -- Mark as handled, for the same reason as described above.
        return true
    end
    b3.onclick = function()
        app:push_screen('extend_fade')
        b1:animate{'color', dst='DimGrey'}
        b2:animate{'color', dst='DimGrey'}
        b3:animate{'color', dst='MediumOrchid'}
        b4:animate{'color', dst='DimGrey'}
        b5:animate{'color', dst='DimGrey'}
        -- Mark as handled, for the same reason as described above.
        return true
    end
    b4.onclick = function()
        app:push_screen('audition')
        b1:animate{'color', dst='DimGrey'}
        b2:animate{'color', dst='DimGrey'}
        b3:animate{'color', dst='DimGrey'}
        b4:animate{'color', dst='MediumOrchid'}
        b5:animate{'color', dst='DimGrey'}
        -- Mark as handled, for the same reason as described above.
        return true
    end
    b5.onclick = function()
        app:push_screen('advanced')
        b1:animate{'color', dst='DimGrey'}
        b2:animate{'color', dst='DimGrey'}
        b3:animate{'color', dst='DimGrey'}
        b4:animate{'color', dst='DimGrey'}
        b5:animate{'color', dst='MediumOrchid'}
        -- Mark as handled, for the same reason as described above.
        return true
    end
    window:open()

end

GetSettings()
rtk.call(Main)