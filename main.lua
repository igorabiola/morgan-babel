local scenario = require ("scenario")
local unit = require ("unit")
local tower = require ("tower")
local physics = require("physics")
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
		--local warrior = unit.createUnit(w/2, h, 20)

		--warrior:moveTo(w/2,0, warrior:call(warrior.destroy))
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


--Teste do modulo torre
local t1 = tower.createTower(50, 50)

t1:fire()
--Fim Teste

local upgradeButtonGroup = display.newGroup()

backgroundGroup:insert(background)

local upgradeButton = display.newRect(upgradeButtonGroup, 30,300,70,70)
upgradeButton:setFillColor(0,0,0,150)

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

warrior:moveTo(gameMap.map.path[1][1], gameMap.map.path[1][2], rCallback)

--physics.addBody( warrior.shape ,{ density = 0, friction = 0, bounce = 0, isSensor=true } )
--physics.addBody( warrior_steady.shape  ,  { density = 0, friction = 0, bounce = 0 } )

local function onCollision( event )
	if ( event.phase == "began" ) then
		print( "began: " , event.object1 , event.object2 )
	elseif ( event.phase == "ended" ) then
		print( "ended: " , event.object1 , event.object2 )
	end
end

Runtime:addEventListener( "collision", onCollision )

-- Fim Teste
