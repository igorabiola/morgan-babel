require "physics"

local obj = require "object"

local u = {}
u.info = "modulo de unidade"



local function sheduleForNextRound( func )
	--todo: refatorar
	timer.performWithDelay(100, func)
end

local function handleVisionCollision( self, event )
	--print("inner vision collision", self.id, event.other.id)
end

local function handleCoreCollision( self, event )
	--print("inner core collision", self.id, event.other.id)
end

local function handleCorePreCollision( self, event )
	--print("inner core preCollision", self.id, event.other.id)
end

local function handleCorePostCollision( self, event )
	--print("inner core postCollision", self.id, event.other.id)
end

function u.createUnit (w, h, size)
	local unit = obj.createObj( "unit" )
	
	---------------- Váriaveis da unidade ------------------
	unit.shape = {}
	unit.velocity = 10
	unit.moveStatus = false
	unit.life = 100
	unit.type = "warrior"
	unit.damage = 10
	unit.defense = 5
	---------------- END: Váriaveis da unidade ------------------
	
	local circ = display.newCircle(w, h, size)
	circ:setFillColor(255,0,0)
	circ:setStrokeColor(0, 0, 255)
	circ.strokeWidth = 3

	circ.container = unit
	circ.type = "core"
	circ.id = circ.type.."_" .. unit.id


	circ.preCollision = handleCorePreCollision
	circ:addEventListener( "preCollision", circ)

	circ.collision = handleCoreCollision
	circ:addEventListener( "collision", circ)

	circ.postCollision = handleCorePostCollision
	circ:addEventListener( "postCollision", circ)

	
	local vision = display.newCircle(w, h, size * 2)
	vision:setFillColor(0, 0, 0, 0)
	vision:setStrokeColor(0, 0, 255)
	vision.strokeWidth = 3

	vision.container = unit
	vision.type = "vision"
	vision.id = vision.type .."_" .. unit.id

	--Tratamento de colisao com o campo de visao
	vision.collision = handleVisionCollision
	vision:addEventListener( "collision", vision)

	-- Forma da Figura
	table.insert(unit.shape, circ)
	table.insert(unit.shape, vision)

	physics.addBody( circ ,{ density=0.8, friction=0.3, bounce=0.3 , isSensor=false, radius = size } )
	physics.addBody( vision ,{ density=0.0, friction=0.0, bounce=0.0, isSensor=true , radius = size*2} )

	local joint = physics.newJoint("pivot", circ, vision, w,h)

	function unit._move(self, ...)
		local x,y,count, xf, yf, callback = ...
		self.moveStatus = true
		--self.shape:translate(x, y)
		self.shape[1]:setLinearVelocity( x*self.velocity, y*self.velocity )

		if (count == 0) then
			self.moveStatus = false
			if callback then callback() end
		else
			self:moveTo(xf,yf, callback)
		end
	end

	function unit.moveTo(self, x, y, callback)
		local xorigin = self.shape[1].xOrigin
		local yorigin = self.shape[1].yOrigin

		local xf = x - xorigin
		local yf = y - yorigin

		local modulo = math.sqrt((xf*xf) + (yf*yf))

		local n =  math.ceil(modulo / self.velocity)

		local tab = {( xf / modulo) * self.velocity, (yf / modulo) * self.velocity, n-1, x, y, callback }
		sheduleForNextRound(self:call(self._move, tab))
	end

	function unit.destroy (self)
		for k,v in ipairs(self.shape) do
			v:removeSelf()
		end
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
