local scenario = require ("scenario")
local unit = require ("unit")
local tower = require ("tower")

local w, h = display.contentWidth, display.contentHeight

print(scenario.info)
print(unit.info)
print(tower.info)

scenario.loadMap('testeMap')

local physics = require("physics")
physics.start()

local function testClick(self, event)
	local phase = event.phase
	
	for k,v in pairs(event) do
		print(k, v)
	end
	
	if (phase == "began") then
		local warrior = unit.createUnit(w/2, h, 20)

		warrior:moveTo(w/2,0, function()  warrior:destroy() end)
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

--Teste do modulo de unidade
local warrior = unit.createUnit(w/2, h, 20)

warrior:moveTo(w/2,0, function()  warrior:destroy() end)
-- Fim Teste

--Teste do modulo torre
local t1 = tower.createTower(50, 50)

t1:fire()
--Fim Teste
	
local upgradeButtonGroup = display.newGroup()

local upgradeButton = display.newRect(upgradeButtonGroup, 30,300,70,70)
upgradeButton:setFillColor(0,0,0,150)

upgradeButtonGroup.touch = upgradeButtonHandle
upgradeButtonGroup:addEventListener( "touch", upgradeButtonGroup )

--[[

physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector

--display.setStatusBar( display.HiddenStatusBar )

local w, h = display.contentWidth, display.contentHeight

-- Criando o cenário
--local rect = display.newRect(0,0,w,h)
local rect2 = display.newRect(0,0,w,20)
local rect3 = display.newRect(0,h,w,-20)

rect2:setFillColor(0,255,0)
rect3:setFillColor(255,0,0)


local function createAndMoveUp()
	local unit = createUnit(w/2, h, 20)
	rect2:toFront()
	rect3:toFront()
	unit:moveTo(w/2,0, function()  unit:destroy() end)
end

local function createAndMoveDown()
	local unit = createUnit(w/2, 0, 20)
	unit.shape:setFillColor(0,255,0)
	rect2:toFront()
	rect3:toFront()
	unit:moveTo(w/2,h, function()  unit:destroy() end)
end

local function fire()
	local unit = createUnit(w/2, 0, 20)
	unit.shape:setFillColor(0,255,0)
	rect2:toFront()
	rect3:toFront()
	unit:moveTo(w/2,h, function()  unit:destroy() end)
end

local function testClick(self, event)
	local phase = event.phase
	local circle = self[1]
	for k,v in pairs(event) do
		print(k, v)
	end

	if (phase == "began") then
		circle:setFillColor(255,0,255)
	end
end

local tower = createTower(100,100)

local button = display.newGroup()
local default = display.newCircle(200, 200, 100)
default:setFillColor(0,255,255)
button:insert( default, true )
button.touch = testClick
button:addEventListener( "touch", button )

timer.performWithDelay(1000, createAndMoveUp)
timer.performWithDelay(2000, createAndMoveUp)
timer.performWithDelay(1000, createAndMoveDown)
timer.performWithDelay(2000, createAndMoveDown)


timer.performWithDelay(2000, tower:call(tower.fire, {tower} ))
timer.performWithDelay(2500, tower:call(tower.fire, {tower} ))
timer.performWithDelay(3000, tower:call(tower.fire, {tower} ))

]]
