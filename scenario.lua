local tower = require  "tower"

local s = {}
s.info = "modulo de cenario"
--largura e altura
local w, h = display.contentWidth, display.contentHeight
s.sectors = {}
s.towers = {}
s.sector_width = w / 24
s.sector_height = h / 40

local function loadTowers(map_towers)
	for k,v in ipairs(map_towers) do
		tower_border = 6
		local_tower = tower.createTower(v[1],v[2])
		table.insert(s.towers, local_tower)
	end
end

local function loadObstacles(obstacles)
	
	for k, obstacle in pairs(obstacles) do 	
		--Coloca os obstaculos nos setores.
		for i = obstacle[1], obstacle[1] + obstacle[3] do
			for j = obstacle[2], obstacle[2] + obstacle[4] do
				s.sectors[i][j] = 1
			end
		end
	end	
		
	--Mostra os obstaculos
	sector_width = w / 24
	sector_height = h / 40
	for i = 0, 24 do
		for j = 0, 40 do
			if (s.sectors[i][j] == 1) then
				local rect = display.newRect(i * sector_width , j * sector_height, sector_width, sector_height)
				rect:setFillColor(0,0,0,0)
				physics.addBody( rect, "static" ,{ density=0.8, friction=0.3, bounce=0.3 , isSensor=false } )
			end
		end
	end
	
	io.write("    ")
	for j = 0, 40 do
		if j < 10 then
			io.write(j,"  ")
		else
			io.write(j, " " )
		end
	end
	print()
	for i = 24, 0 , -1 do
		if (i<10) then io.write(i,"   ")
		else
			io.write(i,"  ")
		end
		for j = 0, 40 do
			io.write(s.sectors[i][j],"  ")
		end
		print()
	end
	
end

function loadSectors()

	--Zera todo os setores
	for i = 0, 24 do
		s.sectors[i] = {}
		for j = 0, 40 do
			s.sectors[i][j] = 0
		end
	end
	
	--Gera as linhas verticais dos setores
	sector_width = w / 24
	for i = 0, 24 do
		point = i * sector_width
		local line = display.newLine( point,0, point,h )
		line:setColor( 0, 0, 0, 100 )
		line.width = 3 
	end
	
	--Gera as linha horizontais.
	sector_height = h / 40
	for j = 0, 40 do
		point = j * sector_height
		local line = display.newLine( 0,point, w, point )
		line:setColor( 0, 0, 0, 100 )
		line.width = 3 
	end
end

function s.loadMap(name)
	-- Descobrir um jeito melhor de carregar arquivo.
	local map = require ("maps/"..name)

	local background = display.newImageRect( map.backGround, w, h)
	background:translate(w/2, h/2)
	background:setReferencePoint(display.TopLeftReferencePoint)

	loadSectors()
	loadTowers(map.towers)
	loadObstacles(map.obstacles)
	
	return { background = background, map = map, sectors = s.sectors }
end

return s
