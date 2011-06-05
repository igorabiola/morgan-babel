local t = {}

t.info = "modulo torre"

function t.createTower (x, y)
	local tower = {}

	local rect = display.newRect(x,y,50,50)
	rect:setFillColor(35,155,0)
	rect:setStrokeColor(0, 0, 255)
	rect.strokeWidth = 3

	local vision = display.newCircle(x+25, y+25,100)
	vision:setFillColor(0, 0, 0, 0)
	vision:setStrokeColor(0, 0, 255)
	vision.strokeWidth = 3

	-- Forma da Figura
	tower.shape = rect

	tower.damage = 100
	tower.detectArea = 200

	function tower.move (self)

	end

	function tower.fire (self)
		local circ = display.newCircle(self.shape.xOrigin, self.shape.yOrigin, 10)
		circ:setFillColor(0,255,255)
		--unit:moveTo(w/2,h, function()  unit:destroy() end)
	end

	function tower.call( self, func, ...)
		local args	 = ...
		return function()
			func(self, unpack(args))
		end
	end

	return tower
end

return t
