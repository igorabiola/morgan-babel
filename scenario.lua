local s = {}
s.info = "modulo de cenario"
local w, h = display.contentWidth, display.contentHeight

function s.loadMap(name)
	-- Descobrir um jeito melhor de carregar arquivo.
	local map = require ("maps/"..name)

	local background = display.newImageRect( map.backGround, w, h)
	background:translate(w/2, h/2)
	--background:setReferencePoint(display.TopLeftReferencePoint)

end


return s
