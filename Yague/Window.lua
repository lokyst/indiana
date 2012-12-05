-- ***************************************************************************************************************************************************
-- * DataGrid.lua                                                                                                                                    *
-- ***************************************************************************************************************************************************
-- * Data display                                                                                                                                    *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.18 / Baanano: Rewritten                                                                                                         *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
local PublicInterface = _G[addonID]

local IMouse = Inspect.Mouse
local MMax = math.max
local MMin = math.min
local MHuge = math.huge
local UICreateFrame = UI.CreateFrame

local MIN_WIDTH = 400
local MIN_HEIGHT = 390

function PublicInterface.Window(name, parent)
	local bWindow = UICreateFrame("RiftWindow", name, parent)
	
	local closeButton = UICreateFrame("RiftButton", bWindow:GetName() .. ".CloseButton", bWindow)
	local dragFrame = UICreateFrame("Frame", bWindow:GetName() .. ".DragFrame", bWindow)
	local leftResizeFrame = UICreateFrame("Frame", bWindow:GetName() .. ".LeftResizeFrame", bWindow)
	local rightResizeFrame = UICreateFrame("Frame", bWindow:GetName() .. ".RightResizeFrame", bWindow)
	local bottomResizeFrame = UICreateFrame("Frame", bWindow:GetName() .. ".BottomResizeFrame", bWindow)
	local bottomLeftResizeFrame = UICreateFrame("Frame", bWindow:GetName() .. ".BottomLeftResizeFrame", bWindow)
	local bottomRightResizeFrame = UICreateFrame("Frame", bWindow:GetName() .. ".BottomRightResizeFrame", bWindow)

	local minWidth, minHeight, maxWidth, maxHeight = MIN_WIDTH, MIN_HEIGHT, nil, nil
	local originalSetWidth, originalSetHeight = bWindow.SetWidth, bWindow.SetHeight
	local closeable, draggable, resizable = false, false, false
	local dragInfo, resizeInfo = nil, nil
	
	closeButton:SetSkin("close")
	closeButton:SetPoint("TOPRIGHT", bWindow, "TOPRIGHT", -8, 15)
	closeButton:SetVisible(false)
	
	local left, top, right, bottom = bWindow:GetTrimDimensions()
	dragFrame:SetPoint("TOPLEFT", bWindow, "TOPLEFT", left, 17)
	dragFrame:SetPoint("BOTTOMRIGHT", bWindow,  "TOPRIGHT", -42, top - 17)
	dragFrame:SetAlpha(0)

	leftResizeFrame:SetPoint("TOPLEFT", bWindow, "TOPLEFT", 0, 17)
	leftResizeFrame:SetPoint("BOTTOMRIGHT", bWindow, "BOTTOMLEFT", left, -bottom)
	leftResizeFrame:SetAlpha(0)

	rightResizeFrame:SetPoint("TOPLEFT", bWindow, "TOPRIGHT", -right, 17)
	rightResizeFrame:SetPoint("BOTTOMRIGHT", bWindow, "BOTTOMRIGHT", 0, -bottom)
	rightResizeFrame:SetAlpha(0)

	bottomResizeFrame:SetPoint("TOPLEFT", bWindow, "BOTTOMLEFT", left, -bottom)
	bottomResizeFrame:SetPoint("BOTTOMRIGHT", bWindow, "BOTTOMRIGHT", -right, 0)
	bottomResizeFrame:SetAlpha(0)

	bottomLeftResizeFrame:SetPoint("TOPLEFT", bWindow, "BOTTOMLEFT", 0, -bottom)
	bottomLeftResizeFrame:SetPoint("BOTTOMRIGHT", bWindow, "BOTTOMLEFT", left, 0)
	bottomLeftResizeFrame:SetAlpha(0)

	bottomRightResizeFrame:SetPoint("TOPLEFT", bWindow, "BOTTOMRIGHT", -right, -bottom)
	bottomRightResizeFrame:SetPoint("BOTTOMRIGHT", bWindow, "BOTTOMRIGHT", 0, 0)
	bottomRightResizeFrame:SetAlpha(0)
	
	local function ResizeDown(self)
		if not resizable then return end
		
		local width, height, left, top = bWindow:GetWidth(), bWindow:GetHeight(), bWindow:GetLeft(), bWindow:GetTop()
		bWindow:ClearAll()
		bWindow:SetPoint("TOPLEFT", UIParent, "TOPLEFT", left, top)
		bWindow:SetWidth(width)
		bWindow:SetHeight(height)

		local mouse = IMouse()
		resizeInfo =
		{
			x = mouse.x, 
			y = mouse.y,
			left = left,
			top = top,
			width = width,
			height = height,
		}
	end
	
	local function ResizeUp(self)
		resizeInfo = nil
	end
	
	function closeButton.Event:LeftPress()
		bWindow:Close()
	end
	
	function dragFrame.Event:LeftDown()
		if not draggable then return end
	
		local width, height, left, top = bWindow:GetWidth(), bWindow:GetHeight(), bWindow:GetLeft(), bWindow:GetTop()
		bWindow:ClearAll()
		bWindow:SetPoint("TOPLEFT", UIParent, "TOPLEFT", left, top)
		bWindow:SetWidth(width)
		bWindow:SetHeight(height)

		dragInfo = IMouse()
		dragInfo.x = left - dragInfo.x
		dragInfo.y = top - dragInfo.y
	end
	
	function dragFrame.Event:LeftUp()
		dragInfo = nil
	end
	
	function dragFrame.Event:LeftUpoutside()
		dragInfo = nil
	end
	
	function dragFrame.Event:MouseMove(x, y)
		if not dragInfo then return end
		bWindow:SetPoint("TOPLEFT", UIParent, "TOPLEFT", dragInfo.x + x, dragInfo.y + y)
	end

	leftResizeFrame.Event.LeftDown = ResizeDown
	leftResizeFrame.Event.LeftUp = ResizeUp
	leftResizeFrame.Event.LeftUpoutside = ResizeUp
	function leftResizeFrame.Event:MouseMove(x, y)
		if not resizeInfo then return end
		
		local dx = MMin(x - resizeInfo.x, resizeInfo.width - minWidth)
		dx = maxWidth and MMax(dx, resizeInfo.width - maxWidth) or dx

		bWindow:SetPoint("TOPLEFT", UIParent, "TOPLEFT", resizeInfo.left + dx, resizeInfo.top)
		bWindow:SetWidth(resizeInfo.width - dx)
	end

	rightResizeFrame.Event.LeftDown = ResizeDown
	rightResizeFrame.Event.LeftUp = ResizeUp
	rightResizeFrame.Event.LeftUpoutside = ResizeUp
	function rightResizeFrame.Event:MouseMove(x, y)
		if not resizeInfo then return end

		local dx = MMax(x - resizeInfo.x, minWidth - resizeInfo.width)
		dx = maxWidth and MMin(dx, maxWidth - resizeInfo.width) or dx

		bWindow:SetWidth(resizeInfo.width + dx)
	end

	bottomResizeFrame.Event.LeftDown = ResizeDown
	bottomResizeFrame.Event.LeftUp = ResizeUp
	bottomResizeFrame.Event.LeftUpoutside = ResizeUp
	function bottomResizeFrame.Event:MouseMove(x, y)
		if not resizeInfo then return end

		local dy = MMax(y - resizeInfo.y, minHeight - resizeInfo.height)
		dy = maxHeight and MMin(dy, maxHeight - resizeInfo.height) or dy

		bWindow:SetHeight(resizeInfo.height + dy)
	end

	bottomLeftResizeFrame.Event.LeftDown = ResizeDown
	bottomLeftResizeFrame.Event.LeftUp = ResizeUp
	bottomLeftResizeFrame.Event.LeftUpoutside = ResizeUp
	function bottomLeftResizeFrame.Event:MouseMove(x, y)
		if not resizeInfo then return end

		local dx = MMin(x - resizeInfo.x, resizeInfo.width - minWidth)
		dx = maxWidth and MMax(dx, resizeInfo.width - maxWidth) or dx

		local dy = MMax(y - resizeInfo.y, minHeight - resizeInfo.height)
		dy = maxHeight and MMin(dy, maxHeight - resizeInfo.height) or dy

		bWindow:SetPoint("TOPLEFT", UIParent, "TOPLEFT", resizeInfo.left + dx, resizeInfo.top)
		bWindow:SetWidth(resizeInfo.width - dx)
		bWindow:SetHeight(resizeInfo.height + dy)
	end

	bottomRightResizeFrame.Event.LeftDown = ResizeDown
	bottomRightResizeFrame.Event.LeftUp = ResizeUp
	bottomRightResizeFrame.Event.LeftUpoutside = ResizeUp
	function bottomRightResizeFrame.Event:MouseMove(x, y)
		if not resizeInfo then return end

		local dx = MMax(x - resizeInfo.x, minWidth - resizeInfo.width)
		dx = maxWidth and MMin(dx, maxWidth - resizeInfo.width) or dx

		local dy = MMax(y - resizeInfo.y, minHeight - resizeInfo.height)
		dy = maxHeight and MMin(dy, maxHeight - resizeInfo.height) or dy
		
		bWindow:SetWidth(resizeInfo.width + dx)
		bWindow:SetHeight(resizeInfo.height + dy)
	end

	function bWindow:SetWidth(width)
		originalSetWidth(self, MMin(MMax(width, minWidth), maxWidth or MHuge))
	end
	
	function bWindow:SetHeight(height)
		originalSetHeight(self, MMin(MMax(height, minHeight), maxHeight or MHuge))
	end
	
	function bWindow:GetMinWidth()
		return minWidth
	end

	function bWindow:GetMaxWidth()
		return maxWidth
	end

	function bWindow:GetMinHeight()
		return minHeight
	end

	function bWindow:GetMaxHeight()
		return maxHeight
	end

	function bWindow:SetMinWidth(width)
		minWidth = MMax(MIN_WIDTH, width or MIN_WIDTH)
		if self:GetWidth() < minWidth then
			self:SetWidth(minWidth)
		end
	end

	function bWindow:SetMaxWidth(width)
		maxWidth = width and MMax(width, minWidth) or nil
		if maxWidth and self:GetWidth() > maxWidth then
			self:SetWidth(maxWidth)
		end
	end

	function bWindow:SetMinHeight(height)
		minHeight = MMax(MIN_HEIGHT, height or MIN_HEIGHT)
		if self:GetHeight() < minHeight then
			self:SetHeight(minHeight)
		end
	end

	function bWindow:SetMaxHeight(height)
		maxHeight = height and MMax(height, minHeight) or nil
		if maxHeight and self:GetHeight() > maxHeight then
			self:SetHeight(maxHeight)
		end
	end
	
	function bWindow:GetCloseable()
		return closeable
	end

	function bWindow:SetCloseable(isCloseable)
		if closeable == isCloseable then return end
		closeable = isCloseable
		closeButton:SetVisible(closeable)
	end

	function bWindow:Close()
		if closeable then
			self:SetVisible(false)
			if self.Event.Close then
				self.Event.Close(self)
			end
		end
	end

	function bWindow:GetDraggable()
		return draggable
	end

	function bWindow:SetDraggable(isDraggable)
		draggable = isDraggable
	end

	function bWindow:GetResizable(self)
		return resizable
	end

	function bWindow:SetResizable(isResizable)
		resizable = isResizable
	end
	
	PublicInterface.EventHandler(bWindow, { "Close" })

	return bWindow
end
