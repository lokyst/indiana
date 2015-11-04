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
    if Indy.moveBagCheckButton then
        bagButtonTexture2.MouseDown = true
        local mouseData = Inspect.Mouse()
        bagButtonTexture2.sx  = mouseData.x - bagButtonTexture2:GetLeft()
        bagButtonTexture2.sy  = mouseData.y - bagButtonTexture2:GetTop()

        local nx, ny
        nx = mouseData.x - bagButtonTexture2.sx
        ny = mouseData.y - bagButtonTexture2.sy
        bagButtonTexture2:ClearAll()
        bagButtonTexture2:SetPoint("TOPLEFT", UIParent, "TOPLEFT", nx, ny)
    else
        bagButtonTexture2:SetTexture("Indy", "textures/IndyIcon_Down.png")
    end
end

function bagButtonTexture2.Event.MouseMove()
    if bagButtonTexture2.MouseDown then
        local nx, ny
        local mouseData = Inspect.Mouse()
        nx = mouseData.x - bagButtonTexture2.sx
        ny = mouseData.y - bagButtonTexture2.sy
        bagButtonTexture2:SetPoint("TOPLEFT", UIParent, "TOPLEFT", nx, ny)
    end
end

function bagButtonTexture2.Event.LeftUp()
    if Indy.moveBagCheckButton then
        if bagButtonTexture2.MouseDown then
            bagButtonTexture2.MouseDown = false
        end
        Indy.posX = bagButtonTexture2:GetLeft()
        Indy.posY = bagButtonTexture2:GetTop()
    else
        bagButtonTexture2:SetTexture("Indy", "textures/IndyIcon_Over.png")
    end
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

local tt = UI.CreateFrame("SimpleTooltip", "Indy_BagTooltip", context)
local ttString = "Indiana\nLeft-click to scan bags for artifacts\nRight-click to show configuration window"
tt:InjectEvents(bagButtonTexture2, function() return ttString end)

function Indy:ShowBagCheckButton()
    if not MINIMAPDOCKER then
        if Indy.posX == false or Indy.posY == false then
            bagButtonTexture2:SetPoint("BOTTOMRIGHT", UI.Native.Bag, "TOPLEFT", 15, 15)
        else
            bagButtonTexture2:SetPoint("TOPLEFT", UIParent, "TOPLEFT", Indy.posX, Indy.posY)
        end
    end

    if Indy.showBagCheckButton then
        bagButtonTexture2:SetVisible(true)
    else
        bagButtonTexture2:SetVisible(false)
    end
end
