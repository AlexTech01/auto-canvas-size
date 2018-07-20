local AutoCanvasSize = {}

		-- pass all the GuiObjects inside of the UIGridLayout-organized frame. (Direct children)
		local function GetHorizontalAmount(objs)
			local horizontal_amount = -1
			local absolutes = {}
			
			for i=1, #objs do -- loop thru all the frames
				local o = objs[i]
				local absolute_y = o.AbsolutePosition.Y
				if absolutes[absolute_y] then -- if this absolute y exists in the table, add this frame
					table.insert(absolutes[absolute_y], o) 
				else
					absolutes[absolute_y] = {} -- if it doesn't, create it.
					table.insert(absolutes[absolute_y], o)  -- then add this frame.
				end
			end
			for absolute_y, gui_objs in pairs(absolutes) do -- loop thru the absolutes
				if #gui_objs > horizontal_amount then -- if this absolute_y has more frames than the current horizontal_amount then, update the horizontal amount
					horizontal_amount = #gui_objs
				end
			end
			return horizontal_amount -- return the current horizontal amount.
		end
		
		local function GetVerticalAmount(objs)	
			local amount = -1
			local absolutes = {}
			
			for i=1, #objs do -- loop thru all the frames
				local o = objs[i]
				local absolute_x = o.AbsolutePosition.X
				if absolutes[absolute_x] then -- if this absolute y exists in the table, add this frame
					table.insert(absolutes[absolute_x], o) 
				else
					absolutes[absolute_x] = {} -- if it doesn't, create it.
					table.insert(absolutes[absolute_x], o)  -- then add this frame.
				end
			end
			for absolute_x, gui_objs in pairs(absolutes) do -- loop thru the absolutes
				if #gui_objs > amount then -- if this absolute_y has more frames than the current amount then, update the horizontal amount
					amount = #gui_objs
				end
			end
			return amount -- return the current horizontal amount.
		end

	function AutoCanvasSize.Init(scroller)
		local grid = scroller:WaitForChild("UIGridLayout")
		
		local function GetGuiObjects()
			local objs = {}
			local c = scroller:GetChildren()
			for i=1, #c do
				local o = c[i]
				if o:IsA("GuiObject") then
					table.insert(objs,o)
				end
			end
			return objs
		end
		
		-- updates the CanvasSize based on the amount of frames in the frame, along with
		local function Update()
			local cell_size = Vector2.new(grid.CellSize.X.Offset, grid.CellSize.Y.Offset)
			local gui_objs = GetGuiObjects()
			local y_amount = GetVerticalAmount(gui_objs)
			scroller.CanvasSize = UDim2.new(0,0,0, (cell_size.Y + grid.CellPadding.Y.Offset) * y_amount)
		end
		scroller.ChildAdded:Connect(function()
			spawn(Update) -- it appears the child does not get added until the connection returns (or something of that effect)
						  -- so, we spawn the Update so it is inclusive of the new child.
		end)
		scroller.ChildRemoved:Connect(Update)
	end
	
return AutoCanvasSize