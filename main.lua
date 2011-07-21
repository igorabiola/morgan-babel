local scenario = require ("scenario")
local unit = require ("unit")
local tower = require ("tower")
local physics = require("physics")
local pathfinding = require("pathfinding")
physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode( "hybrid" )

local w, h = display.contentWidth, display.contentHeight


local backgroundGroup = display.newGroup()


print(scenario.info)
print(unit.info)
print(tower.info)

local gameMap = scenario.loadMap('testeMap')
local background = gameMap.background



local function testClick(self, event)
	local phase = event.phase

	if (phase =="ended") then
		for k,v in pairs(event) do
			print(k, v)
		end
	end
	if (phase == "began") then
		local sx, sy = scenario.getSector(event.xStart,event.yStart)
		print(sx,sy)
		print(scenario.getPixel(sx,sy))
	end
end

local function upgradeUnit()
	local upgrade = display.newGroup()

	local rect = display.newRect(0,300,300,400)
	rect:setFillColor(0,0,0, 100)
	local warriorText = display.newText(upgrade, "Guerreiro", 100, 340, native.systemFont, 30)
	warriorText:setTextColor(255, 255, 255, 100)

	upgrade.touch = testClick
	upgrade:addEventListener( "touch", upgrade )
end

local function upgradeButtonHandle(self, event)
	local phase = event.phase
	local rect = self[1]

	if (phase == "began") then
		rect:removeSelf()
		upgradeUnit()
		rect:setFillColor(0,0,0,150)
	end
end



local upgradeButtonGroup = display.newGroup()

backgroundGroup:insert(background)

--[[

local upgradeButton = display.newRect(upgradeButtonGroup, 30,300,70,70)
upgradeButton:setFillColor(0,0,0,150)
--]]
backgroundGroup.touch = testClick
backgroundGroup:addEventListener( "touch", backgroundGroup )

upgradeButtonGroup.touch = upgradeButtonHandle
upgradeButtonGroup:addEventListener( "touch", upgradeButtonGroup )



--Teste do modulo de unidade
local warrior = unit.createUnit(w/2, h, 20)
local warrior_steady = unit.createUnit(w/2, h-100, 20)

local moveIndex = 1
local function rCallback()
	moveIndex = moveIndex + 1
	if moveIndex <= #gameMap.map.path then
		warrior:moveTo(gameMap.map.path[moveIndex][1], gameMap.map.path[moveIndex][2], rCallback)
	else
		warrior:destroy()
	end
end

local function drawBall(x,y)
	local circ = display.newCircle( (x * scenario.sector_width) + (scenario.sector_width/2), (y * scenario.sector_height) + (scenario.sector_height/2), 3)
	circ:setFillColor(255,0,0)
	circ:setStrokeColor(0, 0, 255)
	circ.strokeWidth = 3
end

warrior:moveTo(gameMap.map.path[1][1], gameMap.map.path[1][2], rCallback)

--O x é o y estão invertidos neste algoritmo.
path = CalcMoves(gameMap.sectors, 1, 11, 33, 11 )
real_path = CalcPath(path)

for k,v in pairs(real_path) do
	drawBall(v.y,v.x) 
end

--[[

local moveIndex = 1
local function rCallback()
	moveIndex = moveIndex + 1
	if moveIndex <= #gameMap.map.path then
		warrior:moveTo(gameMap.map.path[moveIndex][1], gameMap.map.path[moveIndex][2], rCallback)
	else
		warrior:destroy()
	end
end

for k,v in pairs(real_path[1]) do
	print(k,v) 
end
]]
--warrior:moveTo(scenario.real_path[1].y, real_path[1].x, rCallback)
-- Fim Teste
