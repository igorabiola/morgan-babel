
local o = {}

o.info = "modulo de objetos"

local idCount = {}

local function createId( name )

	local count = ( idCount[name] or 0 ) + 1
	idCount[name] = count
	local id = name .. count
	return id
end

function o.createObj( typeName )
	local obj = {}
	obj.type = typeName

	obj.id = createId( typeName )

	return obj
end


return o
