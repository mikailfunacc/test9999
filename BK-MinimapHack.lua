-- BK-MinimapHack by Brikovich
-- v0.1

local MHConfig = MenuElement({type = MENU, id="MHConfig", name = "Minimap Hack by Brikovich", leftIcon="https://github.com/4risto/GoS/blob/master/n59k0ZU.png"})

MHConfig:MenuElement({ id="enable", name="Enable", value=true })
MHConfig:MenuElement({ id="drawTimers", name="Draw timers", value=true })
MHConfig:MenuElement({ id="drawRecalls", name="Draw Recalls", value=true })
MHConfig:MenuElement({ id="drawCircles", name="Draw Circles", value=true })
MHConfig:MenuElement({id = "maxCircleRadius", name = "Maximum circle radius", value = 10000, min = 0, max = 30000})

local enemies = {}
local championsSprites = {}

local function getBasePos()
	if Game.mapID == SUMMONERS_RIFT then
		return { blue = Vector(696, 183, 562), red = Vector(14288, 8916015625, 14360)}
	elseif Game.mapID == TWISTED_TREELINE then
		return { blue = Vector(964, 152, 7203), red = Vector(14313, 152, 7235) }
	else
		return { blue = Vector(946, -131, 1070 ), red = Vector(11850, -132, 11596) }
	end
end

local function initialFill()
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero.isEnemy then
			table.insert( enemies, { hero = hero, circleRadius = nil, lastSeen = GetTickCount(), recall = {isRecalling = false, startTime = nil, totalTime = nil}, atBase = nil} )
			table.insert ( championsSprites, { name = hero.charName, sprite = Sprite("BKMinimapHack\\" .. hero.charName .. ".png")} )
		end
	end
end


local function getSpriteByName( charName )
	for i, v in pairs(championsSprites) do
		if v.name == charName then return v.sprite end
	end
	return nil
end

local function getEnemyIndex ( networkID )

	for i, enemy in pairs(enemies) do
		if enemy.hero.networkID == networkID then
			return i
		end
	end
	return nil
end

local function refreshEnemiesList()
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if getEnemyIndex(hero.networkID) ~= nil then
			enemies[getEnemyIndex(hero.networkID)].hero = hero
		end
	end
end

local function lastSeenFormat( lastSeen )

	local minutes = math.floor( (GetTickCount()-lastSeen)/1000/60 )
	local seconds = math.floor( (GetTickCount()-lastSeen)/1000 - minutes*60 )
	if minutes<10 then
		minutes = "0" .. minutes
	end
	if seconds<10 then
		seconds = "0" .. seconds
	end

	return minutes .. ":" .. seconds
end


function trackDead( hero, heroIndex )

	if hero.dead and heroIndex ~= nil then
		enemies[heroIndex].circleRadius = 0
		enemies[heroIndex].atBase = true
		enemies[heroIndex].lastSeen = GetTickCount()
		return true
	end

	return false
end

function OnDraw()

	if not MHConfig.enable:Value() then return end

	if #enemies < 1 then initialFill() end
	refreshEnemiesList()

	for heroIndex, enemy in pairs(enemies) do

		local isDead = trackDead(enemy.hero, heroIndex)

		if enemy.hero.visible then
			enemies[heroIndex].atBase = false
			enemies[heroIndex].circleRadius = 0
			enemies[heroIndex].lastSeen = GetTickCount()
		elseif not enemy.recall.isRecalling then
			enemies[heroIndex].circleRadius = (GetTickCount() - enemies[heroIndex].lastSeen) / 1000 * enemies[heroIndex].hero.ms
		end

		if enemy.atBase == nil then break end
		
		if not enemy.hero.visible and not isDead then
			local sprite = getSpriteByName(enemy.hero.charName)
			if sprite == nil then break end
			local pos;

			if enemies[heroIndex].atBase then
				if enemy.hero.team == 100 then
					pos = getBasePos().blue
				else
					pos = getBasePos().red
				end 
			else
				pos = enemy.hero.pos
			end

			local posMM = pos:ToMM()
			sprite:Draw( posMM.x - 12, posMM.y -12 )

			local circleColor = Draw.Color(100,255,255,255)

			if enemies[heroIndex].recall.isRecalling then
				circleColor = Draw.Color(100,16,235,209)
				if MHConfig.drawRecalls:Value() then
					local percent =  math.floor((GetTickCount()-enemies[heroIndex].recall.startTime)/enemies[heroIndex].recall.totalTime*100)
					Draw.Text("Recalling (" .. percent .. "%)", 12, posMM.x - 50, posMM.y + 7, Draw.Color(200,16,235,209))
				end
			elseif MHConfig.drawTimers:Value() then
				Draw.Text(  lastSeenFormat(enemies[heroIndex].lastSeen) , 12, posMM.x - 20, posMM.y + 7, Draw.Color(150,255,255,255))
			end
			if not MHConfig.drawCircles:Value() then break end
			if enemies[heroIndex].circleRadius < MHConfig.maxCircleRadius:Value() then
				Draw.CircleMinimap( pos, enemies[heroIndex].circleRadius, circleColor)
			elseif not enemy.isRecalling then
				Draw.CircleMinimap( pos, 900, Draw.Color(100,255,0,0))
			end

		end
	end

end

function OnProcessRecall(hero,recallProc)
	local heroIndex = getEnemyIndex(hero.networkID)
	if heroIndex ~= nil then
		if recallProc.isStart then
			enemies[heroIndex].recall.isRecalling = true
			enemies[heroIndex].recall.startTime = GetTickCount()
			enemies[heroIndex].recall.totalTime = recallProc.totalTime
		elseif recallProc.isFinish then
			enemies[heroIndex].recall.isRecalling = false
			enemies[heroIndex].atBase = true
			enemies[heroIndex].circleRadius = 0
			enemies[heroIndex].lastSeen = GetTickCount()
		elseif not recallProc.isFinish and not recallProc.isStart then
			enemies[heroIndex].recall.isRecalling = false
		end
	end
end