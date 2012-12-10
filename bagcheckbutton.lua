local context = UI.CreateContext("Indy_BagContext")

local bagButtonFrame = UI.CreateFrame("Frame", "Indy_BagButton", context)
bagButtonFrame:SetVisible(false)

local bagButtonTexture1 = UI.CreateFrame("Texture", "Indy_BagButtonTexture1", bagButtonFrame)
bagButtonTexture1:SetTexture("Indy", "textures/fuglybutton.png")
bagButtonTexture1:SetPoint("BOTTOMRIGHT", UI.Native.Bag, "TOPLEFT", 15, 15)

local bagButtonTexture2 = UI.CreateFrame("Texture", "Indy_BagButtonTexture2", bagButtonTexture1)
bagButtonTexture2:SetTexture("Indy", "textures/3x3_grid_icon&16.png")
bagButtonTexture2:SetPoint("CENTERCENTER",bagButtonTexture1, "CENTERCENTER")

bagButtonTexture2.Event.LeftClick = function()
    Indy:CheckBagsForArtifacts()
end

bagButtonTexture2.Event.RightClick = function()
    Indy:ShowConfigWindow()
end

local tt = UI.CreateFrame("SimpleTooltip", "Indy_BagTooltip", context)
local ttString = "Indiana\nLeft-click to scan bags for artifacts\nRight-click to show configuration window"
tt:InjectEvents(bagButtonTexture2, function() return ttString end)

function Indy:ShowBagCheckButton()
    if Indy.showBagCheckButton then
        bagButtonFrame:SetVisible(true)
    else
        bagButtonFrame:SetVisible(false)
    end
end
