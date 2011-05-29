local physics = require("physics")
physics.start()

physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector

--display.setStatusBar( display.HiddenStatusBar )

local w, h = display.contentWidth, display.contentHeight

local rect2 = display.newRect(0,0,w,h)


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


local function createAndMoveUp()
	local unit = createUnit(w/2, h, 20)
	unit:moveTo(w/2,0, function()  unit:destroy() end)
end

local function createAndMoveDown()
	local unit = createUnit(w/2, 0, 20)
	unit.shape:setFillColor(0,255,0)
	unit:moveTo(w/2,h, function()  unit:destroy() end)
end


timer.performWithDelay(1000, createAndMoveUp)
timer.performWithDelay(2000, createAndMoveUp)
timer.performWithDelay(1000, createAndMoveDown)
timer.performWithDelay(2000, createAndMoveDown)


