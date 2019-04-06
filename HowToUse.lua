local AutoCanvasSize = require(script.Parent:WaitForChild("AutoCanvasSize"))

local ScrollingFrame = script.Parent

AutoCanvasSize.Connect(ScrollingFrame, Boolean only_y)
