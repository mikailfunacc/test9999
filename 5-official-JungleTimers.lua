local JGLMenu = MenuElement({type = MENU, id = "JGLMenu", name = "Jungle Timers", leftIcon = "http://puu.sh/pSf9K/c7b0c7cea8.png"})
JGLMenu:MenuElement({id = "Enabled", name = "Enabled", value = true})
JGLMenu:MenuElement({type = MENU, id = "OnScreen", name = "On Screen", leftIcon = "http://puu.sh/rGpSj/e92234a9af.png"})
JGLMenu.OnScreen:MenuElement({id = "Enabled", name = "Enabled", value = true})
JGLMenu.OnScreen:MenuElement({id = "FontSize", name = "Text Size", value = 22, min = 10, max = 60})
JGLMenu:MenuElement({type = MENU, id = "OnMinimap", name = "On Minimap", leftIcon = "http://puu.sh/rGpKK/e60ba3daa3.png"})
JGLMenu.OnMinimap:MenuElement({id = "Enabled", name = "Enabled", value = true})
JGLMenu.OnMinimap:MenuElement({id = "FontSize", name = "Text Size", value = 10, min = 2, max = 36})


local mapID = Game.mapID;
local camps = {}
local scuttlerflip = {
	on = false,
	DragPos = {},
	BaronPos = {},
}

local TEAM_BLUE = 100;
local TEAM_RED = 200;


local function IntegerToMinSec(i)
	local m, s = math.floor(i/60), (i%60)
	return m..":"..(s < 10 and 0 or "")..s
end




function OnTick()
local currentTicks = GetTickCount();
for i = 1, Game.CampCount() do
local camp = Game.Camp(i);
if mapID == SUMMONERS_RIFT then
		if camp.isCampUp then
			if not camps[camp.chnd] then
				if camp.name == 'monsterCamp_1' then
					camps[camp.chnd] = {currentTicks, 300000, camp, TEAM_BLUE, "Blue", camp.isCampUp, Draw.Color(255,0,180,255)}
				elseif camp.name == 'monsterCamp_2' then
					camps[camp.chnd] = {currentTicks, 135000, camp, TEAM_BLUE, "Wolves", camp.isCampUp, Draw.Color(255,220,220,220)}
				elseif camp.name == 'monsterCamp_3' then
					camps[camp.chnd] = {currentTicks, 135000, camp, TEAM_BLUE, "Raptors", camp.isCampUp, Draw.Color(255,50,255,50)}
				elseif camp.name == 'monsterCamp_4' then
					camps[camp.chnd] = {currentTicks, 300000, camp, TEAM_BLUE, "Red", camp.isCampUp, Draw.Color(255,255,100,100)}
				elseif camp.name == 'monsterCamp_5' then
					camps[camp.chnd] = {currentTicks, 135000, camp, TEAM_BLUE, "Krugs", camp.isCampUp, Draw.Color(255,160,160,160)}
				elseif camp.name == 'monsterCamp_6' then
					camps[camp.chnd] = {currentTicks, 300000, camp, TEAM_BLUE, "Dragon", camp.isCampUp, Draw.Color(255,255,170,50)}
				elseif camp.name == 'monsterCamp_7' then
					camps[camp.chnd] = {currentTicks, 300000, camp, TEAM_RED, "Blue", camp.isCampUp, Draw.Color(255,0,180,255)}
				elseif camp.name == 'monsterCamp_8' then
					camps[camp.chnd] = {currentTicks, 135000, camp, TEAM_RED, "Wolves", camp.isCampUp, Draw.Color(255,220,220,220)}
				elseif camp.name == 'monsterCamp_9' then
					camps[camp.chnd] = {currentTicks, 135000, camp, TEAM_RED, "Raptors", camp.isCampUp, Draw.Color(255,50,255,50)}
				elseif camp.name == 'monsterCamp_10' then
					camps[camp.chnd] = {currentTicks, 300000, camp, TEAM_RED, "Red", camp.isCampUp, Draw.Color(255,255,100,100)}
				elseif camp.name == 'monsterCamp_11' then
					camps[camp.chnd] = {currentTicks, 135000, camp, TEAM_RED, "Krugs", camp.isCampUp, Draw.Color(255,160,160,160)}
				elseif camp.name == 'monsterCamp_12' then
					camps[camp.chnd] = {currentTicks, 360000, camp, TEAM_RED, "Baron", camp.isCampUp, Draw.Color(255,180,50,250)}
				elseif camp.name == 'monsterCamp_13' then
					camps[camp.chnd] = {currentTicks, 135000, camp, TEAM_BLUE, "Gromp", camp.isCampUp, Draw.Color(255,240,240,0)}
				elseif camp.name == 'monsterCamp_14' then
					camps[camp.chnd] = {currentTicks, 135000, camp, TEAM_RED, "Gromp", camp.isCampUp, Draw.Color(255,240,240,0)}
				elseif camp.name == 'monsterCamp_15' then
					camps[camp.chnd] = {currentTicks, 150000, camp, TEAM_BLUE, "Scuttler", camp.isCampUp, Draw.Color(255,255,170,50)} --dragon's
					scuttlerflip.DragPos = camp.pos2D
				elseif camp.name == 'monsterCamp_16' then
					camps[camp.chnd] = {currentTicks, 150000, camp, TEAM_RED, "Scuttler", camp.isCampUp, Draw.Color(255,180,50,250)} --baron's
					scuttlerflip.DragPos = camp.pos2D
				elseif camp.name == 'monsterCamp_17' then
					camps[camp.chnd] = {currentTicks, 360000, camp, TEAM_RED, "Herald", camp.isCampUp, Draw.Color(255,180,50,250)}
				end
			else -- the camp has been allocated once
				camps[camp.chnd][1] = currentTicks;
				camps[camp.chnd][6] = camp.isCampUp;
				camps[camp.chnd][3] = camp;
			end
		else --else the camp is not LIVE (up)
			if camps[camp.chnd] then
				camps[camp.chnd][6] = camp.isCampUp;
				camps[camp.chnd][3] = camp;
			end
		end
elseif mapID == TWISTED_TREELINE then
	if camp.isCampUp then
			if not camps[camp.chnd] then
				if camp.name == 'monsterCamp_1' then
					camps[camp.chnd] = {currentTicks, 75000, camp, TEAM_BLUE, "Wraiths", camp.isCampUp, Draw.Color(255,255,100,100)}
				elseif camp.name == 'monsterCamp_2' then
					camps[camp.chnd] = {currentTicks, 75000, camp, TEAM_BLUE, "Golems", camp.isCampUp, Draw.Color(255,0,180,255)}
				elseif camp.name == 'monsterCamp_3' then
					camps[camp.chnd] = {currentTicks, 75000, camp, TEAM_BLUE, "Wolves", camp.isCampUp, Draw.Color(255,220,220,220)}
				elseif camp.name == 'monsterCamp_4' then
					camps[camp.chnd] = {currentTicks, 75000, camp, TEAM_RED, "Wraiths", camp.isCampUp, Draw.Color(255,255,100,100)}
				elseif camp.name == 'monsterCamp_5' then
					camps[camp.chnd] = {currentTicks, 75000, camp, TEAM_RED, "Golems", camp.isCampUp, Draw.Color(255,0,180,255)}
				elseif camp.name == 'monsterCamp_6' then
					camps[camp.chnd] = {currentTicks, 75000, camp, TEAM_RED, "Wolves", camp.isCampUp, Draw.Color(255,220,220,220)}
				elseif camp.name == 'monsterCamp_7' then
					camps[camp.chnd] = {currentTicks, 90000, camp, TEAM_BLUE, "Health", camp.isCampUp, Draw.Color(255,50,255,50)}
				elseif camp.name == 'monsterCamp_8' then
					camps[camp.chnd] = {currentTicks, 360000, camp, TEAM_RED, "Vilemaw", camp.isCampUp, Draw.Color(255,180,50,250)}
				end
			else -- the camp has been allocated once
				camps[camp.chnd][1] = currentTicks;
				camps[camp.chnd][6] = camp.isCampUp;
				camps[camp.chnd][3] = camp;
			end
		else --else the camp is not LIVE (up)
			if camps[camp.chnd] then
				camps[camp.chnd][6] = camp.isCampUp;
				camps[camp.chnd][3] = camp;
			end
		end
elseif mapID == HOWLING_ABYSS then
	if camp.isCampUp then
			if not camps[camp.chnd] then
				if camp.name == 'monsterCamp_1' then
					camps[camp.chnd] = {currentTicks, 90000, camp, TEAM_RED, "Health", camp.isCampUp, Draw.Color(255,50,255,50)}
				elseif camp.name == 'monsterCamp_2' then
					camps[camp.chnd] = {currentTicks, 90000, camp, TEAM_BLUE, "Health", camp.isCampUp, Draw.Color(255,50,255,50)}
				elseif camp.name == 'monsterCamp_3' then
					camps[camp.chnd] = {currentTicks, 90000, camp, TEAM_RED, "Health", camp.isCampUp, Draw.Color(255,50,255,50)}
				elseif camp.name == 'monsterCamp_4' then
					camps[camp.chnd] = {currentTicks, 90000, camp, TEAM_RED, "Health", camp.isCampUp, Draw.Color(255,50,255,50)}
				end
			else -- the camp has been allocated once
				camps[camp.chnd][1] = currentTicks;
				camps[camp.chnd][6] = camp.isCampUp;
				camps[camp.chnd][3] = camp;
			end
		else --else the camp is not LIVE (up)
			if camps[camp.chnd] then
				camps[camp.chnd][6] = camp.isCampUp;
				camps[camp.chnd][3] = camp;
			end
		end
elseif mapID == CRYSTAL_SCAR then --definetly not dominion and others
	if camp.isCampUp then
			if not camps[camp.chnd] then
				camps[camp.chnd] = {currentTicks, 31000, camp, TEAM_RED, "Health", camp.isCampUp, Draw.Color(255,50,255,50)}
			else -- the camp has been allocated once
				camps[camp.chnd][1] = currentTicks;
				camps[camp.chnd][6] = camp.isCampUp;
				camps[camp.chnd][3] = camp;
			end
		else --else the camp is not LIVE (up)
			if camps[camp.chnd] then
				camps[camp.chnd][6] = camp.isCampUp;
				camps[camp.chnd][3] = camp;
			end
		end
	end
end
end


function OnDraw()
if JGLMenu.Enabled:Value() == false then return end
local currentTicks = GetTickCount();
local count = 0;
for num, camp in pairs(camps) do
	if camp[6] == true then
		--do we even care when it's up?
		--[[ if camp[5] == 'Scuttler' then
			count = count + 1;
			if count < 2 then
			scuttlerflip.on = true;
			end
		end ]]
		else
		local timepassed = math.min(currentTicks - camp[1],camp[2])
		local timeleft = math.ceil((camp[2] - timepassed) / 1000);
		if timeleft <= 0 then return end
			if camp[5] == 'Scuttler' and scuttlerflip.on then
			--swap pos2D with other scuttler
	 		--[[if camp[4] == TEAM_BLUE then
				camp[3].pos2D = scuttlerflip.BaronPos
			elseif camp[4] == TEAM_RED then
				camp[3].pos2D = scuttlerflip.DragPos
			end
			Draw.Text(camp[3].name..' flip',JGLMenu.OnScreen.FontSize:Value(),myHero.pos2D.x,myHero.pos2D.y,camp[7]);
			]]
			end
			if JGLMenu.OnScreen.Enabled:Value() then
			Draw.Text(IntegerToMinSec(timeleft),JGLMenu.OnScreen.FontSize:Value(),camp[3].pos2D.x,camp[3].pos2D.y,camp[7]);
			end
			if JGLMenu.OnMinimap.Enabled:Value() then
			Draw.Text(IntegerToMinSec(timeleft),JGLMenu.OnMinimap.FontSize:Value(),camp[3].posMM.x,camp[3].posMM.y,camp[7]);
			end
		end
	end
end

--PrintChat("Jungle timers by Feretorix loaded.")