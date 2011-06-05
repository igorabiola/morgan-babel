local tower = require  "tower"

local s = {}
s.info = "modulo de cenario"
local w, h = display.contentWidth, display.contentHeight

local function loadTowers(towers)

	for k,v in ipairs(towers) do
		tower.createTower(v[1],v[2])
	end
end

function s.loadMap(name)
	-- Descobrir um jeito melhor de carregar arquivo.
	local map = require ("maps/"..name)

	local background = display.newImageRect( map.backGround, w, h)
	background:translate(w/2, h/2)
	background:setReferencePoint(display.TopLeftReferencePoint)

	loadTowers(map.towers)

	return { background = background, map = map }
end

return s
