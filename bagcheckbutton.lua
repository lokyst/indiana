local context = UI.CreateContext("Indy_BagContext")

local bagButtonTexture2 = UI.CreateFrame("Texture", "Indy_BagButtonTexture2", context)
bagButtonTexture2:SetTexture("Indy", "textures/IndyIcon_Normal.png")
bagButtonTexture2:SetVisible(false)

function bagButtonTexture2.Event:MouseIn()
    bagButtonTexture2:SetTexture("Indy", "textures/IndyIcon_Over.png")
end

function bagButtonTexture2.Event.MouseOut()
    bagButtonTexture2:SetTexture("Indy", "textures/IndyIcon_Normal.png")
end

function bagButtonTexture2.Event.LeftDown()
    bagButtonTexture2:SetTexture("Indy", "textures/IndyIcon_Down.png")
end

function bagButtonTexture2.Event.LeftUp()
    bagButtonTexture2:SetTexture("Indy", "textures/IndyIcon_Over.png")
end

function bagButtonTexture2.Event.RightDown()
    bagButtonTexture2:SetTexture("Indy", "textures/IndyIcon_Down.png")
end

function bagButtonTexture2.Event.RightUp()
    bagButtonTexture2:SetTexture("Indy", "textures/IndyIcon_Over.png")
end

function bagButtonTexture2.Event.MouseOut()
    bagButtonTexture2:SetTexture("Indy", "textures/IndyIcon_Normal.png")
end

bagButtonTexture2.Event.LeftClick = function()
    Indy:CheckBagsForArtifacts()
end

bagButtonTexture2.Event.RightClick = function()
    Indy:ShowConfigWindow()
end

if MINIMAPDOCKER then
    MINIMAPDOCKER.Register("Indy", bagButtonTexture2)
end

if not MINIMAPDOCKER then
    bagButtonTexture2:SetPoint("BOTTOMRIGHT", UI.Native.Bag, "TOPLEFT", 15, 15)
end

local tt = UI.CreateFrame("SimpleTooltip", "Indy_BagTooltip", context)
local ttString = "Indiana\nLeft-click to scan bags for artifacts\nRight-click to show configuration window"
tt:InjectEvents(bagButtonTexture2, function() return ttString end)

function Indy:ShowBagCheckButton()
    if Indy.showBagCheckButton then
        bagButtonTexture2:SetVisible(true)
    else
        bagButtonTexture2:SetVisible(false)
    end
end
