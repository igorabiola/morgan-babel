local scenario = require ("scenario")
print(scenario.info)
scenario.loadMap('testeMap')

local physics = require("physics")
physics.start()

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


local function sheduleForNextRound( func )
	--todo: refatorar
	timer.performWithDelay(100, func)
end

local function createUnit (w, h, size)
	local unit = {}

	local circ = display.newCircle(w, h-size, size)
	circ:setFillColor(255,0,0)
	circ:setStrokeColor(0, 0, 255)
	circ.strokeWidth = 3

	-- Forma da Figura
	unit.shape = circ

	-- Velocidade da Figura
	unit.velocity = 20

	-- Status do movimento
	unit.moveStatus = false

	unit.life = 1000

	function unit._move(self, ...)
		local x,y,count, xf, yf, callback = ...
		self.moveStatus = true
		self.shape:translate(x, y)

		if (count == 0) then
			self.moveStatus = false
			if callback then callback() end
		else
			self:moveTo(xf,yf, callback)
		end
	end

	function unit.moveTo(self, x, y, callback)
		local xorigin = self.shape.xOrigin
		local yorigin = self.shape.yOrigin

		local xf = x - xorigin
		local yf = y - yorigin

		local modulo = math.sqrt((xf*xf) + (yf*yf))

		local n =  math.ceil(modulo / self.velocity)

		local tab = {( xf / modulo) * self.velocity, (yf / modulo) * self.velocity, n-1, x, y, callback }
		sheduleForNextRound(self:call(self._move, tab))
	end

	function unit.destroy (self)
		self.shape:removeSelf()
	end

	function unit.call( self, func, ...)
		local args	 = ...
		return function()
			func(self, unpack(args))
		end
	end

	return unit
end

local function createTower (x, y)
	local tower = {}

	local rect = display.newRect(x,y,50,50)
	rect:setFillColor(35,155,0)
	rect:setStrokeColor(0, 0, 255)
	rect.strokeWidth = 3

	-- Forma da Figura
	tower.shape = rect

	tower.damage = 100
	tower.detectArea = 200

	function tower.move (self)

	end

	function tower.fire (self)
		local unit = createUnit(self.shape.xOrigin, self.shape.xOrigin, 10)
		unit.shape:setFillColor(0,255,255)
		unit:moveTo(w/2,h, function()  unit:destroy() end)
	end

	function tower.call( self, func, ...)
		local args	 = ...
		return function()
			func(self, unpack(args))
		end
	end

	return tower
end


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
