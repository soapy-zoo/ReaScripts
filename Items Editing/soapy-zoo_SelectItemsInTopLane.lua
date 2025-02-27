-- @description Select all items in topmost fixed lane
-- @version 0.1 
-- @author the soapy zoo

local r = reaper

function main()

  r.Undo_BeginBlock()
  -- DO NOT PREVENT THE UI FROM REFRESHING
  
  r.Main_OnCommand(40289, 0) -- Deselect all items
  
  r.Main_OnCommand(42790, 0) -- play only first lane
  r.Main_OnCommand(43098, 0) -- show/play only one lane
  
  r.Main_OnCommand(40421, 0) -- Item: Select all items in track
  r.Main_OnCommand(40034, 0) -- Item grouping: Select all items in groups
  
  r.Main_OnCommand(43099, 0) -- show/play all lanes
  
  r.UpdateArrange()
  r.Undo_EndBlock("Select Items in Top Lane", -1)

end

main()
