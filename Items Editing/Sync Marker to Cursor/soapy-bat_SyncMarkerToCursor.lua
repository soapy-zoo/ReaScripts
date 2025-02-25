-- @description Sync Marker to Cursor ("Bat")
-- @version 0.1 
-- @author the soapy zoo
-- @about
--     # Info
--     These scripts let you create take markers called "SYNC" on all selected items at the edit cursor position using the script "soapy-bat_CreateSyncMarker.lua".
--     The script "soapy-bat_SyncMarkerToCursor.lua" moves the selected items containing sync markers so that the sync markers align with the edit cursor.
--     This functionality is inspired from Pro Tools' Sync Points.

---------------
-- variables --
---------------

local r = reaper
local markerLabel = "SYNC"

---------------
-- functions --
---------------

function AlignSyncMarkersWithEditCursor()

   local numSelectedItems = r.CountSelectedMediaItems(0)

    -- Iterate through selected items
    for i = 0, numSelectedItems - 1 do
        local selectedItem = r.GetSelectedMediaItem(0, i)
        local take = r.GetActiveTake(selectedItem)

        -- Get necessary locations
        local syncMarkerPos, markerName, _ = r.GetTakeMarker(take, 0)
        local itemPos = r.GetMediaItemInfo_Value(selectedItem, "D_POSITION")
        -- take markers are referenced from the item source media, not from the item edges:
        local itemEdgeOffset =  r.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS")
        local newMarkerPos = itemPos + syncMarkerPos - itemEdgeOffset

        -- Get the cursor position
        local cursorPos = r.GetCursorPosition()

        -- Calculate the offset to align the "SYNC_IN" marker with the cursor position
        local offset = cursorPos - newMarkerPos

        if markerName == markerLabel then
        
           -- Move the selected item by the calculated offset
          r.SetMediaItemInfo_Value(selectedItem, "D_POSITION", itemPos + offset)
          r.UpdateArrange()
        
        end
    end
end

---------------------------
-- execution starts here --
---------------------------
r.Undo_BeginBlock()
AlignSyncMarkersWithEditCursor()
r.Undo_EndBlock("Align Sync Markers With Edit Cursor", -1)
