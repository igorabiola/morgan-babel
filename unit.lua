local u = {}
u.info = "modulo de unidade"

local function sheduleForNextRound( func )
	--todo: refatorar
	timer.performWithDelay(100, func)
end

function u.createUnit (w, h, size)
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

return u
