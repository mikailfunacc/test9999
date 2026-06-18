local Heroes = {"Vex"}

if not table.contains(Heroes, myHero.charName) then return end

require "DamageLib"
require "MapPositionGOS"
require "2DGeometry"



----------------------------------------------------
--|                    Checks                    |--
----------------------------------------------------

if not FileExist(COMMON_PATH .. "GamsteronPrediction.lua") then
	DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/GOS-EXT/master/Common/GamsteronPrediction.lua", COMMON_PATH .. "GamsteronPrediction.lua", function() end)
	print("gamsteronPred. installed Press 2x F6")
	return
end

if not FileExist(COMMON_PATH .. "PremiumPrediction.lua") then
	DownloadFileAsync("https://raw.githubusercontent.com/Ark223/GoS-Scripts/master/PremiumPrediction.lua", COMMON_PATH .. "PremiumPrediction.lua", function() end)
	print("PremiumPred. installed Press 2x F6")
	return
end

if not FileExist(COMMON_PATH .. "GGPrediction.lua") then
	DownloadFileAsync("https://raw.githubusercontent.com/gamsteron/GG/master/GGPrediction.lua", COMMON_PATH .. "GGPrediction.lua", function() end)
	print("GGPrediction installed Press 2x F6")
	return
end


-- [ AutoUpdate ]
do
    
    local Version = 2.00
    
    local Files = {
        Lua = {
            Path = SCRIPT_PATH,
            Name = "CloverVex.lua",
            Url = ""
        },
        Version = {
            Path = SCRIPT_PATH,
            Name = "CloverVex.version",
            Url = ""
        }
    }
    
    local function AutoUpdate()

        local function DownloadFile(url, path, fileName)
            DownloadFileAsync(url, path .. fileName, function() end)
            while not FileExist(path .. fileName) do end
        end
        
        local function ReadFile(path, fileName)
            local file = io.open(path .. fileName, "r")
            local result = file:read()
            file:close()
            return result
        end
        
        DownloadFile(Files.Version.Url, Files.Version.Path, Files.Version.Name)
        local textPos = myHero.pos:To2D()
        local NewVersion = tonumber(ReadFile(Files.Version.Path, Files.Version.Name))
        if NewVersion > Version then
            DownloadFile(Files.Lua.Url, Files.Lua.Path, Files.Lua.Name)
            print("New CloverVex Version Press 2x F6")
        else
            print("CloverVex loaded")
        end
    
    end
    
   --AutoUpdate()

end 

----------------------------------------------------
--|                    Utils                     |--
----------------------------------------------------

local heroes = false
local wClock = 0
local clock = os.clock
local Latency = Game.Latency
local ping = Latency() * 0.001
local foundAUnit = false
local _movementHistory = {}
local TEAM_ALLY = myHero.team
local TEAM_ENEMY = 300 - myHero.team
local TEAM_JUNGLE = 300
local wClock = 0
local _OnVision = {}
local sqrt = math.sqrt
local MathHuge = math.huge
local TableInsert = table.insert
local TableRemove = table.remove
local GameTimer = Game.Timer
local Allies, Enemies, Turrets, Units = {}, {}, {}, {}
local Orb
local DrawRect = Draw.Rect
local DrawCircle = Draw.Circle
local DrawColor = Draw.Color
local DrawText = Draw.Text
local ControlSetCursorPos = Control.SetCursorPos
local ControlKeyUp = Control.KeyUp
local ControlKeyDown = Control.KeyDown
local GameCanUseSpell = Game.CanUseSpell
local GameHeroCount = Game.HeroCount
local GameHero = Game.Hero
local GameMinionCount = Game.MinionCount
local GameMinion = Game.Minion
local GameTurretCount = Game.TurretCount
local GameTurret = Game.Turret
local GameIsChatOpen = Game.IsChatOpen
local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
_G.LATENCY = 0.05



local Rrecast = 0


function LoadUnits()
	for i = 1, GameHeroCount() do
		local unit = GameHero(i); Units[i] = {unit = unit, spell = nil}
		if unit.team ~= myHero.team then TableInsert(Enemies, unit)
		elseif unit.team == myHero.team and unit ~= myHero then TableInsert(Allies, unit) end
	end
	for i = 1, Game.TurretCount() do
		local turret = Game.Turret(i)
		if turret and turret.isEnemy then TableInsert(Turrets, turret) end
	end
end


local TargetSelector
local function GetTarget(unit)
	return TargetSelector:GetTarget(unit, 1)

end

TargetSelector = _G.SDK.TargetSelector


local function CheckWall(from, to, distance)
    local pos1 = to + (to - from):Normalized() * 50
    local pos2 = pos1 + (to - from):Normalized() * (distance - 50)
    local point1 = Point(pos1.x, pos1.z)
    local point2 = Point(pos2.x, pos2.z)
    if MapPosition:intersectsWall(LineSegment(point1, point2)) then
        return true
    end
    return false
end


local function EnemyHeroes()
    local _EnemyHeroes = {}
    for i = 1, GameHeroCount() do
        local unit = GameHero(i)
        if unit.isEnemy then
            TableInsert(_EnemyHeroes, unit)
        end
    end
    return _EnemyHeroes
end


local function IsValid(unit)
    if (unit and unit.valid and unit.isTargetable and unit.alive and unit.visible and unit.networkID and unit.pathing and unit.health > 0) then
        return true;
    end
    return false;
end

local function Ready(spell)
    return myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 and myHero:GetSpellData(spell).mana <= myHero.mana and GameCanUseSpell(spell) == 0
end

local function GetDistanceSqr(pos1, pos2)
	local pos2 = pos2 or myHero.pos
	local dx = pos1.x - pos2.x
	local dz = (pos1.z or pos1.y) - (pos2.z or pos2.y)
	return dx * dx + dz * dz
end

local function GetDistance(pos1, pos2)
	return sqrt(GetDistanceSqr(pos1, pos2))
end

function GetTarget(range) 
	if _G.SDK then
		if myHero.ap > myHero.totalDamage then
			return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL);
		else
			return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL);
		end
	elseif _G.PremiumOrbwalker then
		return _G.PremiumOrbwalker:GetTarget(range)
	end
end

function GetMode()   
    if _G.SDK then
        return 
		_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] and "Combo"
        or 
		_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] and "Harass"
        or 
		_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] and "LaneClear"
        or 
		_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR] and "LaneClear"
        or 
		_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] and "LastHit"
        or 
		_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_FLEE] and "Flee"
		or nil
    
	elseif _G.PremiumOrbwalker then
		return _G.PremiumOrbwalker:GetMode()
	end
	return nil
end

local function SetAttack(bool)
	if _G.EOWLoaded then
		EOW:SetAttacks(bool)
	elseif _G.SDK then                                                        
		_G.SDK.Orbwalker:SetAttack(bool)
	elseif _G.PremiumOrbwalker then
		_G.PremiumOrbwalker:SetAttack(bool)	
	else
		GOS.BlockAttack = not bool
	end

end

local function SetMovement(bool)
	if _G.EOWLoaded then
		EOW:SetMovements(bool)
	elseif _G.SDK then
		_G.SDK.Orbwalker:SetMovement(bool)
	elseif _G.PremiumOrbwalker then
		_G.PremiumOrbwalker:SetMovement(bool)	
	else
		GOS.BlockMovement = not bool
	end
end

local function CheckLoadedEnemyies()
	local count = 0
	for i, unit in ipairs(Enemies) do
        if unit and unit.isEnemy then
		count = count + 1
		end
	end
	return count
end

local function GetEnemyHeroes()
	return Enemies
end

local function GetEnemyTurrets()
	return Turrets
end

local function GetMinionCount(range, pos)
    local pos = pos.pos
	local count = 0
	for i = 1,GameMinionCount() do
	local hero = GameMinion(i)
	local Range = range * range
		if hero.team ~= TEAM_ALLY and hero.dead == false and GetDistanceSqr(pos, hero.pos) < Range then
		count = count + 1
		end
	end
	return count
end	

local function IsUnderTurret(unit)
	for i, turret in ipairs(GetEnemyTurrets()) do
        local range = (turret.boundingRadius + 750 + unit.boundingRadius / 2)
        if not turret.dead then 
            if turret.pos:DistanceTo(unit.pos) < range then
                return true
            end
        end
    end
    return false
end

local test = 1
local function HasBuff(unit, buffname)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)	

		if buff.name == buffname and buff.count > 0 then 
			return true
		end
	end
	return false
end

local function GetBuffData(unit, buffname)
	for i = 0, unit.buffCount do
    local buff = unit:GetBuff(i)
		if buff.name == buffname and buff.count > 0 then 
			return buff
		end
	end
	return {type = 0, name = "", startTime = 0, expireTime = 0, duration = 0, stacks = 0, count = 0}
end

local function IsRecalling(unit)
	local buff = GetBuffData(unit, "recall")
	if buff and buff.duration > 0 then
		return true, GameTimer() - buff.startTime
	end
    return false
end

local function GetBuffedEnemyCount(range, pos)
    local pos = pos.pos
	local count = 0
	for i, hero in ipairs(GetEnemyHeroes()) do
	local Range = range * range
		if GetDistanceSqr(pos, hero.pos) < Range and IsValid(hero) then
		count = count + 1
		end
	end
	return count
end

local function GetBuffedEnemyCount2(range, pos)
    local pos = pos.pos
	local count = 0
	for i, hero in ipairs(GetEnemyHeroes()) do
	local Range = range * range
		if GetDistanceSqr(pos, hero.pos) < Range and IsValid(hero) and HasBuff(hero, "vexR2mark") then
		print("mark")
		count = count + 1
		end
	end
	return count
end



local function CalcDmg(unit)
	local total = 0
	local level = myHero.levelData.lvl
	
	if Ready(_Q) then
		local QDmg = CalcMagicalDamage(myHero, unit, (15 + 15 * level) + (0.4 * myHero.ap))
		local TrueDmg = (15 + 15 * level) + (0.4 * myHero.ap)		
		total = total + (QDmg + TrueDmg)
	end

	if Ready(_W) then
		local WDmg = CalcMagicalDamage(myHero, unit, (165 + 45 * level) + (0.9 * myHero.ap))		
		total = total + WDmg 
	end

	if Ready(_E) then
		local EDmg = CalcMagicalDamage(myHero, unit, (50 + 20 * level) + (0.4 * myHero.ap))		
		total = total + EDmg 
	end

	if Ready(_R) then
		local RDmg = CalcMagicalDamage(myHero, unit, (50 + 50 * level) + (0.3 * myHero.ap))		
		total = total + RDmg 
	end	
	return total
end

local function ConvertToHitChance(menuValue, hitChance)
    return menuValue == 1 and _G.PremiumPrediction.HitChance.High(hitChance)
    or menuValue == 2 and _G.PremiumPrediction.HitChance.VeryHigh(hitChance)
    or _G.PremiumPrediction.HitChance.Immobile(hitChance)
end

local function MyHeroNotReady()
    return myHero.dead or Game.IsChatOpen() or (_G.JustEvade and _G.JustEvade:Evading()) or (_G.ExtLibEvade and _G.ExtLibEvade.Evading) or IsRecalling(myHero)
end

----------------------------------------------------
--|                Champion               		|--
----------------------------------------------------

class "Vex"


local QData = {Type = _G.SPELLTYPE_LINE, Delay = 0.15, Radius = 160, Range = 1200, Speed = 2500, Collision = false}
local QspellData = {speed = 2500, range = 1200, delay = 0.15, radius = 160, collision = {nil}, type = "linear"}


local EData = {Type = _G.SPELLTYPE_CIRCLE, Delay = 0.25, Radius = 150, Range = 800, Speed = 1300, Collision = false}
local EspellData = {speed = 1300, range = 800, delay = 0.25, radius = 150, collision = {nil}, type = "circular"}


local RData = {Type = _G.SPELLTYPE_LINE, Delay = 0.25, Radius = 130, Range = (1500+(500*myHero:GetSpellData(_R).level)), Speed = 1600, Collision = true, MaxCollision = 0, CollisionTypes = {2}}
local RspellData = {speed = 1600, range = (1500+(500*myHero:GetSpellData(_R).level)), delay = 0.25, radius = 130, collision = {"hero","windwall"}, type = "linear"}




function R1Dmg()
	local LvL = myHero:GetSpellData(_R).level
	local R1Dmg = (({75, 125, 175})[LvL] + 0.2 * myHero.ap)	
	return R1Dmg

end

function R2Dmg()
	local LvL = myHero:GetSpellData(_R).level
	local R2Dmg = (({150, 250, 350})[LvL] + 0.5 * myHero.ap)	
	return R2Dmg
end

function WDmg()
	local LvL = myHero:GetSpellData(_W).level
	local WDmg = (({80, 120, 160, 200, 240})[LvL] + 0.3 * myHero.ap)	
	return WDmg
end


local PredLoaded = false

function Vex:__init()
	self:LoadMenu()

	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)

	if PredLoaded == false then
		DelayAction(function()
			if self.Menu.Misc.Pred.Change:Value() == 1 then
				require('GamsteronPrediction')
				PredLoaded = true
			elseif self.Menu.Misc.Pred.Change:Value() == 2 then
				require('PremiumPrediction')
				PredLoaded = true
			else 
				require('GGPrediction')
				PredLoaded = true					
			end
		end, 1)	
	

		
	end
end

function Vex:LoadMenu()                     	
--MainMenu
self.Menu = MenuElement({type = MENU, id = "CloverVex", name = "CloverVex"})
self.Menu:MenuElement({name = " ", drop = {"Version 0.05"}})


self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
	
	--ComboMenu  

	self.Menu.Combo:MenuElement({id = "UseQ", name = "[Q]", value = true})
	self.Menu.Combo:MenuElement({id = "UseW",name = "[W]", value = true})
	self.Menu.Combo:MenuElement({id = "WCount", name = "W When Can Hit X Enemies ", value = 2, min = 1, max = 5, step = 1})	
	self.Menu.Combo:MenuElement({id = "UseE", name = "[E]", value = true})
	self.Menu.Combo:MenuElement({id = "UseR", name = "[R] if killable", value = true})	


self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})

	--HarassMenu  

	self.Menu.Harass:MenuElement({id = "UseQ", name = "[Q]", value = true})		
	self.Menu.Harass:MenuElement({id = "UseW", name = "[W]", value = true})
	self.Menu.Harass:MenuElement({id = "WCount", name = "W When Can Hit X Enemies ", value = 2, min = 1, max = 5, step = 1})
	self.Menu.Harass:MenuElement({id = "UseE", name = "[E]", value = true})	
	
self.Menu:MenuElement({type = MENU, id = "Auto", name = "Auto Settings"})


	
	self.Menu.Auto:MenuElement({type = MENU, id = "AutoW", name = "AutoW"})
	self.Menu.Auto.AutoW:MenuElement({id = "Count", name = "Hit X Enemies ", value = 2, min = 1, max = 6, step = 1})	

	self.Menu.Auto:MenuElement({id = "AutoR1", name = "AutoR1", value = false})
	self.Menu.Auto:MenuElement({id = "AutoR2", name = "AutoR2", value = false})
    	 
--[[
self.Menu:MenuElement({type = MENU, id = "Clear", name = "Clear Settings"})
	--LaneClear Menu
	self.Menu.Clear:MenuElement({id = "UseQ", name = "[Q]", value = true})
	self.Menu.Clear:MenuElement({id = "UseW", name = "[W]", value = true})	
	--JungleClear Menu
	self.Menu.JClear:MenuElement({id = "UseQ", name = "[Q]", value = true})	
	self.Menu.JClear:MenuElement({id = "UseW", name = "[W]", value = true})	
]]--	
	self.Menu:MenuElement({type = MENU, id = "Misc", name = "Misc Settings"})

						
	--Prediction
	self.Menu.Misc:MenuElement({type = MENU, id = "Pred", name = "Prediction Mode"})
	self.Menu.Misc.Pred:MenuElement({name = " ", drop = {"After change Prediction Typ press 2xF6"}})	
	self.Menu.Misc.Pred:MenuElement({id = "Change", name = "Change Prediction Typ", value = 2, drop = {"Gamsteron Prediction", "Premium Prediction", "GGPrediction"}})	
	self.Menu.Misc.Pred:MenuElement({id = "PredQ", name = "Hitchance[Q]", value = 1, drop = {"Normal", "High", "Immobile"}})	
	self.Menu.Misc.Pred:MenuElement({id = "PredE", name = "Hitchance[E]", value = 1, drop = {"Normal", "High", "Immobile"}})	
	self.Menu.Misc.Pred:MenuElement({id = "PredR", name = "Hitchance[R]", value = 1, drop = {"Normal", "High", "Immobile"}})



	--Drawing 
	self.Menu.Misc:MenuElement({type = MENU, id = "Drawing", name = "Drawings Mode"})
	self.Menu.Misc.Drawing:MenuElement({id = "DrawQ", name = "Draw [Q] Range", value = false})
	self.Menu.Misc.Drawing:MenuElement({id = "DrawR", name = "Draw [R] Range", value = false})
	self.Menu.Misc.Drawing:MenuElement({id = "DrawE", name = "Draw [E] Range", value = false})
	self.Menu.Misc.Drawing:MenuElement({id = "DrawW", name = "Draw [W] Range", value = false})	

	if _G.SDK then
		_G.SDK.Orbwalker:OnPreAttack(function(...) self:OnPreAttack(...) end)
	elseif _G.PremiumOrbwalker then
		_G.PremiumOrbwalker:OnPreAttack(function(...) self:OnPreAttack(...) end)
	end		
end	

local test2 = 1
local vexRbuff = nil

function Vex:Tick()	
	if heroes == false then 
		local EnemyCount = CheckLoadedEnemyies()			
		if EnemyCount < 1 then
			LoadUnits()
		else
			heroes = true
		end
		
	else	

	if MyHeroNotReady() then return end

	
	local Mode = GetMode()
		if Mode == "Combo" then
			self:Combo()
			--self:CountR()
			
		elseif Mode == "Harass" then
			self:Harass()
		elseif Mode == "LaneClear" then
			--self:JungleClear()
			--self:Clear()	
		end		
	end	
	

	self:AutoW()
	self:AutoR1()
	self:AutoR2()


	
	

end

function Vex:OnPreAttack(args)



end


function Vex:test()

	for i, target in ipairs(GetEnemyHeroes()) do 		
		local CastRange = 1000
		if target and myHero.pos:DistanceTo(target.pos) <= CastRange and IsValid(target) then	
		
			local count = GetBuffedEnemyCount2(CastRange, myHero)
			if count == 1 then
				Control.CastSpell(HK_R)	
			end
		

		if HasBuff(target, "VexR3") then
			print("asfa")
		end
		end	
	end


end


function Vex:Combo()
local target = GetTarget(2000)     	
if target == nil then return end

	if IsValid(target) then



		if myHero.pos:DistanceTo(target.pos) <= 1200 and self.Menu.Combo.UseQ:Value() and Ready(_Q) then
			if myHero.pos:DistanceTo(target.pos) <= 800 and self.Menu.Combo.UseE:Value() and Ready(_E) then
				if self.Menu.Misc.Pred.Change:Value() == 1 then
					local pred = GetGamsteronPrediction(target, EData, myHero)
					if pred.Hitchance >= self.Menu.Misc.Pred.PredE:Value()+1 then
						Control.CastSpell(HK_E, pred.CastPosition)
					end
				elseif self.Menu.Misc.Pred.Change:Value() == 2 then
					local pred = _G.PremiumPrediction:GetPrediction(myHero, target, EspellData)
					if pred.CastPos and ConvertToHitChance(self.Menu.Misc.Pred.PredE:Value(), pred.HitChance) then
						Control.CastSpell(HK_E, pred.CastPos)
					end
				else
					local EPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.25, Radius = 150, Range = 800, Speed = 1300, Collision = false})
					EPrediction:GetPrediction(target, myHero)
					if EPrediction:CanHit(self.Menu.Misc.Pred.PredE:Value() + 1) then
						Control.CastSpell(HK_E, EPrediction.CastPosition)
					end
				end
				
			else
				if self.Menu.Misc.Pred.Change:Value() == 1 then
					local pred = GetGamsteronPrediction(target, QData, myHero)
					if pred.Hitchance >= self.Menu.Misc.Pred.PredQ:Value()+1 then
						Control.CastSpell(HK_Q, pred.CastPosition)
					end
				elseif self.Menu.Misc.Pred.Change:Value() == 2 then
					local pred = _G.PremiumPrediction:GetPrediction(myHero, target, QspellData)
					if pred.CastPos and ConvertToHitChance(self.Menu.Misc.Pred.PredQ:Value(), pred.HitChance) then
						Control.CastSpell(HK_Q, pred.CastPos)
					end
				else
					local QPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.15, Radius = 160, Range = 1200, Speed = 2500, Collision = false})
					QPrediction:GetPrediction(target, myHero)
					if QPrediction:CanHit(self.Menu.Misc.Pred.PredQ:Value() + 1) then
						Control.CastSpell(HK_Q, QPrediction.CastPosition)
					end				
				end	
			end
		
		end
		
		if myHero.pos:DistanceTo(target.pos) <= 800 and self.Menu.Combo.UseE:Value() and Ready(_E) then	
				if self.Menu.Misc.Pred.Change:Value() == 1 then
					local pred = GetGamsteronPrediction(target, EData, myHero)
					if pred.Hitchance >= self.Menu.Misc.Pred.PredE:Value()+1 then
						Control.CastSpell(HK_E, pred.CastPosition)
					end
				elseif self.Menu.Misc.Pred.Change:Value() == 2 then
					local pred = _G.PremiumPrediction:GetPrediction(myHero, target, EspellData)
					if pred.CastPos and ConvertToHitChance(self.Menu.Misc.Pred.PredE:Value(), pred.HitChance) then
						Control.CastSpell(HK_E, pred.CastPos)
					end
				else
					local EPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.25, Radius = 150, Range = 800, Speed = 1300, Collision = false})
					EPrediction:GetPrediction(target, myHero)
					if EPrediction:CanHit(self.Menu.Misc.Pred.PredE:Value() + 1) then
						Control.CastSpell(HK_E, EPrediction.CastPosition)
					end				
				end	
		
		end	

		if self.Menu.Combo.UseW:Value() and Ready(_W) then
				self:ComboW()
		end
		
		

		if myHero.pos:DistanceTo(target.pos) <= (1500+(500*myHero:GetSpellData(_R).level)) and self.Menu.Combo.UseR:Value() and Ready(_R) then
				local Rdmg = R1Dmg()+R2Dmg()+20
				local R2dmg = R2Dmg()
				local Rcast = clock()-Rrecast
				local vexRbuff = GetBuffData(myHero,"vexrresettimer")
				--print(vexRbuff.duration)
	
				if (myHero:GetSpellData(_R).name == "VexR" and Rdmg >= target.health) or (myHero:GetSpellData(_R).name == "VexR" and vexRbuff.duration<= 0.5 and HasBuff(myHero, "vexrresettimer"))then		
				
					if self.Menu.Misc.Pred.Change:Value() == 1 then
						local pred = GetGamsteronPrediction(target, RData, myHero)
						if pred.Hitchance >= self.Menu.Misc.Pred.PredR:Value()+1 then
							Control.CastSpell(HK_R, pred.CastPosition)
						end
					elseif self.Menu.Misc.Pred.Change:Value() == 2 then
						local pred = _G.PremiumPrediction:GetPrediction(myHero, target, RspellData)
						if pred.CastPos and ConvertToHitChance(self.Menu.Misc.Pred.PredR:Value(), pred.HitChance) then
							Control.CastSpell(HK_R, pred.CastPos)
						end
					else
						local RPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.25, Radius = 130, Range = (1500+(500*myHero:GetSpellData(_R).level)), Speed = 1600, Collision = true, CollisionTypes = {GGPrediction.COLLISION_ENEMYHERO}})    
						RPrediction:GetPrediction(target, myHero)
						if RPrediction:CanHit(self.Menu.Misc.Pred.PredR:Value() + 1) then
							Control.CastSpell(HK_R, RPrediction.CastPosition)
						end				
					end	
				
				

				elseif HasBuff(target, "VexRTarget") and myHero:GetSpellData(_R).name == "VexR2" and R2dmg >= target.health then
					Control.CastSpell(HK_R)
					Rrecast = clock()
				end

		end

		



	end
	

end	

function Vex:Harass()
local target = GetTarget(2000)
if target == nil then return end

	if IsValid(target) then



		if myHero.pos:DistanceTo(target.pos) <= 1200 and self.Menu.Harass.UseQ:Value() and Ready(_Q) then
			if myHero.pos:DistanceTo(target.pos) <= 800 and self.Menu.Harass.UseE:Value() and Ready(_E) then
				if self.Menu.Misc.Pred.Change:Value() == 1 then
					local pred = GetGamsteronPrediction(target, EData, myHero)
					if pred.Hitchance >= self.Menu.Misc.Pred.PredE:Value()+1 then
						Control.CastSpell(HK_E, pred.CastPosition)
					end
				elseif self.Menu.Misc.Pred.Change:Value() == 2 then
					local pred = _G.PremiumPrediction:GetPrediction(myHero, target, EspellData)
					if pred.CastPos and ConvertToHitChance(self.Menu.Misc.Pred.PredE:Value(), pred.HitChance) then
						Control.CastSpell(HK_E, pred.CastPos)
					end
				else
					local EPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.25, Radius = 150, Range = 800, Speed = 1300, Collision = false})
					EPrediction:GetPrediction(target, myHero)
					if EPrediction:CanHit(self.Menu.Misc.Pred.PredE:Value() + 1) then
						Control.CastSpell(HK_E, EPrediction.CastPosition)
					end
				end
				
			else
				if self.Menu.Misc.Pred.Change:Value() == 1 then
					local pred = GetGamsteronPrediction(target, QData, myHero)
					if pred.Hitchance >= self.Menu.Misc.Pred.PredQ:Value()+1 then
						Control.CastSpell(HK_Q, pred.CastPosition)
					end
				elseif self.Menu.Misc.Pred.Change:Value() == 2 then
					local pred = _G.PremiumPrediction:GetPrediction(myHero, target, QspellData)
					if pred.CastPos and ConvertToHitChance(self.Menu.Misc.Pred.PredQ:Value(), pred.HitChance) then
						Control.CastSpell(HK_Q, pred.CastPos)
					end
				else
					local QPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.15, Radius = 160, Range = 1200, Speed = 2500, Collision = false})
					QPrediction:GetPrediction(target, myHero)
					if QPrediction:CanHit(self.Menu.Misc.Pred.PredQ:Value() + 1) then
						Control.CastSpell(HK_Q, QPrediction.CastPosition)
					end				
				end	
			end
			
		end

		if myHero.pos:DistanceTo(target.pos) <= 800 and self.Menu.Harass.UseE:Value() and Ready(_E) then
				if self.Menu.Misc.Pred.Change:Value() == 1 then
					local pred = GetGamsteronPrediction(target, EData, myHero)
					if pred.Hitchance >= self.Menu.Misc.Pred.PredE:Value()+1 then
						Control.CastSpell(HK_E, pred.CastPosition)
					end
				elseif self.Menu.Misc.Pred.Change:Value() == 2 then
					local pred = _G.PremiumPrediction:GetPrediction(myHero, target, EspellData)
					if pred.CastPos and ConvertToHitChance(self.Menu.Misc.Pred.PredE:Value(), pred.HitChance) then
						Control.CastSpell(HK_E, pred.CastPos)
					end
				else
					local EPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.25, Radius = 150, Range = 800, Speed = 1300, Collision = false})
					EPrediction:GetPrediction(target, myHero)
					if EPrediction:CanHit(self.Menu.Misc.Pred.PredE:Value() + 1) then
						Control.CastSpell(HK_E, EPrediction.CastPosition)
					end				
				end	
				
		end

		if self.Menu.Harass.UseW:Value() and Ready(_W) then
				self:HarassW()
		end


	end


end	

	

function Vex:JungleClear()
	for i = 1, GameMinionCount() do
    local minion = GameMinion(i)

		if minion.team == TEAM_JUNGLE and IsValid(minion) then 			

			if myHero.pos:DistanceTo(minion.pos) <= 1200 and self.Menu.JClear.UseQ:Value() and Ready(_Q) and myHero.mana/myHero.maxMana >= self.Menu.JClear.Mana:Value() / 100 then
				Control.CastSpell(HK_Q)
			end	
        end
    end
end
			
function Vex:Clear()
	for i = 1, GameMinionCount() do
    local minion = GameMinion(i)

		if minion.team == TEAM_ENEMY and IsValid(minion) then
 		
			
			if myHero.pos:DistanceTo(minion.pos) <= 1125 and self.Menu.Clear.UseQ:Value() and Ready(_Q) and myHero.mana/myHero.maxMana >= self.Menu.Clear.Mana:Value() / 100 then
				local Count = GetMinionCount(1125, minion)
				if Count >= self.Menu.Clear.QCount:Value() then				
					Control.CastSpell(HK_Q)
				end	
			end
        end
    end
end




function Vex:ComboW()   
	for i, target in ipairs(GetEnemyHeroes()) do 
		if target and myHero.pos:DistanceTo(target.pos) <= 475 and IsValid(target) and Ready(_W) then	
			local count = GetBuffedEnemyCount(475, myHero)
			if count >= self.Menu.Combo.WCount:Value() then
				Control.CastSpell(HK_W)	
			end
		end	
	end	
end


function Vex:HarassW()   
	for i, target in ipairs(GetEnemyHeroes()) do 
		if target and myHero.pos:DistanceTo(target.pos) <= 475 and IsValid(target) and Ready(_W) then	
			local count = GetBuffedEnemyCount(475, myHero)
			if count >= self.Menu.Harass.WCount:Value() then
				Control.CastSpell(HK_W)	
			end
		end	
	end	
end




function Vex:AutoW()   
	for i, target in ipairs(GetEnemyHeroes()) do 
		if target and myHero.pos:DistanceTo(target.pos) <= 475 and IsValid(target) and self.Menu.Auto.AutoW.Count:Value() and Ready(_W) then	
			local count = GetBuffedEnemyCount(475, myHero)
			if count >= self.Menu.Auto.AutoW.Count:Value() then
				Control.CastSpell(HK_W)	
			end
		end	
	end	
end

 
function Vex:AutoR1()   
local target = GetTarget(2000)
	if target == nil then return end

	if IsValid(target) then
		if myHero.pos:DistanceTo(target.pos) <= (1500+(500*myHero:GetSpellData(_R).level)) and self.Menu.Auto.AutoR1:Value() and Ready(_R) then
				local Rdmg = R1Dmg()+R2Dmg()+20
				local Fdmg = R1Dmg()+R2Dmg()+WDmg()+20
				local R2dmg = R2Dmg()
				local Rcast = clock()-Rrecast
				local vexRbuff = GetBuffData(myHero,"vexrresettimer")
				
				if (myHero:GetSpellData(_R).name == "VexR" and not Ready(_W) and Rdmg >= target.health)  or (myHero:GetSpellData(_R).name == "VexR" and vexRbuff.duration<= 0.5  and HasBuff(myHero, "vexrresettimer")) then	
					if self.Menu.Misc.Pred.Change:Value() == 1 then
						local pred = GetGamsteronPrediction(target, RData, myHero)
						if pred.Hitchance >= self.Menu.Misc.Pred.PredR:Value()+1 then
							Control.CastSpell(HK_R, pred.CastPosition)
						end
					elseif self.Menu.Misc.Pred.Change:Value() == 2 then
						local pred = _G.PremiumPrediction:GetPrediction(myHero, target, RspellData)
						if pred.CastPos and ConvertToHitChance(self.Menu.Misc.Pred.PredR:Value(), pred.HitChance) then
							Control.CastSpell(HK_R, pred.CastPos)
						end
					else
						local RPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.25, Radius = 130, Range = (1500+(500*myHero:GetSpellData(_R).level)), Speed = 1600, Collision = true, CollisionTypes = {GGPrediction.COLLISION_ENEMYHERO}})
						RPrediction:GetPrediction(target, myHero)
						if RPrediction:CanHit(self.Menu.Misc.Pred.PredR:Value() + 1) then
							Control.CastSpell(HK_R, RPrediction.CastPosition)
						end
					end	


				--end
			
				elseif (myHero:GetSpellData(_R).name == "VexR" and Ready(_W) and Fdmg >= target.health) or (myHero:GetSpellData(_R).name == "VexR" and vexRbuff.duration<= 0.5  and HasBuff(myHero, "vexrresettimer")) then
				
					if self.Menu.Misc.Pred.Change:Value() == 1 then
						local pred = GetGamsteronPrediction(target, RData, myHero)
						if pred.Hitchance >= self.Menu.Misc.Pred.PredR:Value()+1 then
							Control.CastSpell(HK_R, pred.CastPosition)
						end
					elseif self.Menu.Misc.Pred.Change:Value() == 2 then
						local pred = _G.PremiumPrediction:GetPrediction(myHero, target, RspellData)
						if pred.CastPos and ConvertToHitChance(self.Menu.Misc.Pred.PredR:Value(), pred.HitChance) then
							Control.CastSpell(HK_R, pred.CastPos)
						end
					else
						local RPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.25, Radius = 130, Range = (1500+(500*myHero:GetSpellData(_R).level)), Speed = 1600, Collision = true, CollisionTypes = {GGPrediction.COLLISION_ENEMYHERO}})
						RPrediction:GetPrediction(target, myHero)
						if RPrediction:CanHit(self.Menu.Misc.Pred.PredR:Value() + 1) then
							Control.CastSpell(HK_R, RPrediction.CastPosition)
						end
					end	
					
					if myHero.pos:DistanceTo(target.pos)<= 475 then
						Control.CastSpell(HK_W)
					end
				end	
				

		end
	end
	
end


function Vex:AutoR2()   
local target = GetTarget(2000)
	if target == nil then return end

	if IsValid(target) then
		if myHero.pos:DistanceTo(target.pos) <= (1500+(500*myHero:GetSpellData(_R).level)) and self.Menu.Auto.AutoR2:Value() and Ready(_R) then
				
				local R2dmg = R2Dmg()+20
				local F2dmg = R2Dmg()+WDmg()+20

				if HasBuff(target, "VexRTarget") and myHero:GetSpellData(_R).name == "VexR2" and R2dmg >= target.health then
					Control.CastSpell(HK_R)
					Rrecast = clock()
				elseif HasBuff(target, "VexRTarget") and myHero:GetSpellData(_R).name == "VexR2" and F2dmg >= target.health and Ready(_W) then
					Control.CastSpell(HK_R)
					Rrecast = clock()
					DelayAction(function()
					Control.CastSpell(HK_W)
					end, 0.25)					
				end
				
				
		end
	end
end


function Vex:Draw()
	
	if heroes == false then
		Draw.Text(myHero.charName.." is Loading (Search Enemys) !!", 24, myHero.pos2D.x - 50, myHero.pos2D.y + 195, Draw.Color(255, 255, 0, 0))
	else
		if DrawTime == false then
			Draw.Text(myHero.charName.." is Ready !!", 24, myHero.pos2D.x - 50, myHero.pos2D.y + 195, Draw.Color(255, 0, 255, 0))
			DelayAction(function()
			DrawTime = true
			end, 4.0)
		end	
	end

	if myHero.dead then return end
	local posX, posY
	local mePos = myHero.pos:To2D()	
	
		
                                                
	if self.Menu.Misc.Drawing.DrawQ:Value() and Ready(_Q) then
    		DrawCircle(myHero, 1200, 1, DrawColor(225, 225, 0, 10))
	end
	if self.Menu.Misc.Drawing.DrawW:Value() and Ready(_W) then
    		DrawCircle(myHero, 475, 1, DrawColor(225, 225, 125, 10))
	end
	if self.Menu.Misc.Drawing.DrawE:Value() and Ready(_E) then
    		DrawCircle(myHero, 800, 1, DrawColor(225, 225, 125, 10))
	end
		if self.Menu.Misc.Drawing.DrawR:Value() and Ready(_R) then
   		 DrawCircle(myHero, 1500+(500*myHero:GetSpellData(_R).level), 1, DrawColor(255, 225, 255, 10))
	end 
end
	
Callback.Add("Load", function()	
	if table.contains(Heroes, myHero.charName) then	
		_G[myHero.charName]()
		LoadUnits()	
	end	
end)
