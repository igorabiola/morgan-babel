require "physics"

local obj = require "object"

local t = {}

t.info = "modulo torre"

local vision_radius = 100

local tower_width = 50
local tower_height = 50


local function handleVisionCollision( self, event )
	--print("inner vision collision", self.id, event.other.id)
	if event.phase == "began" and event.other.type == "core" then
		self.container:fire(event.other)
	end
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

local function fire (self, target)
	print(self.id, "fire at", target.id, target.x, target.y)
	--[[
		local circ = display.newCircle(self.shape[1].x, self.shape[1].y, 10)
		circ:setFillColor(0,255,255)
		physics.addBody( circ ,{ density=0.8, friction=0.3, bounce=0.3 , radius = 10 } )
		circ:setLinearVelocity(target.x*30, target.y*30)
	--]]
end

function t.createTower (x, y)
	local tower = obj.createObj("tower")


	local rect = display.newRect(x,y,tower_width,tower_height)
	rect:setFillColor(35,155,0)
	rect:setStrokeColor(0, 0, 255)
	rect.strokeWidth = 3

	rect.container = tower
	rect.type = "core"
	rect.id = rect.type .. "_" .. tower.id

	rect.preCollision = handleCorePreCollision
	rect:addEventListener( "preCollision", rect)

	rect.collision = handleCoreCollision
	rect:addEventListener( "collision", rect)

	rect.postCollision = handleCorePostCollision
	rect:addEventListener( "postCollision", rect)


	local vision = display.newCircle(x+(tower_width/2), y+(tower_height/2),vision_radius)
	vision:setFillColor(0, 0, 0, 0)
	vision:setStrokeColor(0, 0, 255)
	vision.strokeWidth = 3

	vision.container = tower
	vision.type = "vision"
	vision.id = vision.type .. "_" .. tower.id

	--Tratamento de colisao com o campo de visao
	vision.collision = handleVisionCollision
	vision:addEventListener( "collision", vision)


	-- Forma da Figura
	tower.shape = {}
	table.insert(tower.shape,rect)
	table.insert(tower.shape, vision)


	tower.damage = 100
	tower.detectArea = vision_radius

	physics.addBody( rect, "static" ,{ density=0.8, friction=0.3, bounce=0.3 , isSensor=false } )
	physics.addBody( vision ,{ density=0.0, friction=0.0, bounce=0.0, isSensor=true , radius = vision_radius} )

	local joint = physics.newJoint("pivot", rect, vision, x+(tower_width/2), y+(tower_height/2))


	tower.fire = fire

	function tower.call( self, func, ...)
		local args	 = ...
		return function()
			func(self, unpack(args))
		end
	end

	return tower
end

return t
