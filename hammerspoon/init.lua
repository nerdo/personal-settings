-- Draws a border around a window
-- https://github.com/jwkvam/hammerspoon-config/blob/master/init.lua
global_border = nil

function redrawBorder()
	win = hs.window.focusedWindow()
	if win ~= nil then
		top_left = win:topLeft()
		size = win:size()
		if global_border ~= nil then
			global_border:delete()
		end
		global_border = hs.drawing.rectangle(hs.geometry.rect(top_left["x"], top_left["y"], size["w"], size["h"]))
		global_border:setStrokeColor({ ["red"] = 0,["blue"] = 0,["green"] = 1,["alpha"] = 0.8 })
		global_border:setFill(false)
		global_border:setStrokeWidth(8)
		global_border:show()
	end
end

redrawBorder()

allwindows = hs.window.filter.new(nil)
allwindows:subscribe(hs.window.filter.windowCreated, function()
	redrawBorder()
end)
allwindows:subscribe(hs.window.filter.windowFocused, function()
	redrawBorder()
end)
allwindows:subscribe(hs.window.filter.windowMoved, function()
	redrawBorder()
end)
allwindows:subscribe(hs.window.filter.windowUnfocused, function()
	redrawBorder()
end)
