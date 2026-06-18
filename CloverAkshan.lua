-- struckture from series. used series luc logic for minion q

require "PremiumPrediction"
require "DamageLib"
require "2DGeometry"
require "MapPositionGOS"

local EnemyHeroes = {}
local AllyHeroes = {}

local Version = 1.00



local function IsNearEnemyTurret(pos, distance)
	--PrintChat("Checking Turrets")
    local turrets = _G.SDK.ObjectManager:GetTurrets(GetDistance(pos) + 1000)
    for i = 1, #turrets do
        local turret = turrets[i]
        if turret and GetDistance(turret.pos, pos) <= distance+915 and turret.team == 300-myHero.team then
        	--PrintChat("turret")
            return turret
        end
    end
end


function NearestEnemy(origin, range)
	local enemy = nil
	local distance = range
	for i = 1,LocalGameHeroCount()  do
		local hero = LocalGameHero(i)
		if hero and CanTarget(hero) then
			local d =  LocalGeometry:GetDistance(origin, hero.pos)
			if d < range  and d < distance  then
				distance = d
				enemy = hero
			end
		end
	end
	if distance < range then
		return enemy, distance
	end
end

local function IsUnderEnemyTurret(pos)
	--PrintChat("Checking Turrets")
    local turrets = _G.SDK.ObjectManager:GetTurrets(GetDistance(pos) + 1000)
    for i = 1, #turrets do
        local turret = turrets[i]
        if turret and GetDistance(turret.pos, pos) <= 915 and turret.team == 300-myHero.team then
        	--PrintChat("turret")
            return turret
        end
    end
end

function GetDistanceSqr(Pos1, Pos2)
	local Pos2 = Pos2 or myHero.pos
	local dx = Pos1.x - Pos2.x
	local dz = (Pos1.z or Pos1.y) - (Pos2.z or Pos2.y)
	return dx^2 + dz^2
end

function GetDistance(Pos1, Pos2)
	return math.sqrt(GetDistanceSqr(Pos1, Pos2))
end

function IsFacing(unit)
    local V = Vector((unit.pos - myHero.pos))
    local D = Vector(unit.dir)
    local Angle = 180 - math.deg(math.acos(V*D/(V:Len()*D:Len())))
    if math.abs(Angle) < 80 then 
        return true  
    end
    return false
end

function GetEnemyHeroes()
	for i = 1, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if Hero.isEnemy then
			table.insert(EnemyHeroes, Hero)
			PrintChat(Hero.name)
		end
	end
	--PrintChat("Got Enemy Heroes")
end

function GetAllyHeroes()
	for i = 1, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if Hero.isAlly then
			table.insert(AllyHeroes, Hero)
			PrintChat(Hero.name)
		end
	end
	--PrintChat("Got Enemy Heroes")
end

local function GetWaypoints(unit) -- get unit's waypoints
    local waypoints = {}
    local pathData = unit.pathing
    table.insert(waypoints, unit.pos) 
    local PathStart = pathData.pathIndex
    local PathEnd = pathData.pathCount
    if PathStart and PathEnd and PathStart >= 0 and PathEnd <= 20 and pathData.hasMovePath then
        for i = pathData.pathIndex, pathData.pathCount do
            table.insert(waypoints, unit:GetPath(i))
        end
    end
    return waypoints
end

local function GetUnitPositionNext(unit)
    local waypoints = GetWaypoints(unit)
    if #waypoints == 1 then
        return nil -- we have only 1 waypoint which means that unit is not moving, return his position
    end
    return waypoints[2] -- all segments have been checked, so the final result is the last waypoint
end

local function GetUnitPositionAfterTime(unit, time)
    local waypoints = GetWaypoints(unit)
    if #waypoints == 1 then
        return unit.pos -- we have only 1 waypoint which means that unit is not moving, return his position
    end
    local max = unit.ms * time -- calculate arrival distance
    for i = 1, #waypoints - 1 do
        local a, b = waypoints[i], waypoints[i + 1]
        local dist = GetDistance(a, b)
        if dist >= max then
            return Vector(a):Extended(b, dist) -- distance of segment is bigger or equal to maximum distance, so the result is point A extended by point B over calculated distance
        end
        max = max - dist -- reduce maximum distance and check next segments
    end
    return waypoints[#waypoints] -- all segments have been checked, so the final result is the last waypoint
end

function GetTarget(range)
	if _G.SDK then
		return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL);
	else
		return _G.GOS:GetTarget(range,"AD")
	end
end

function GotBuff(unit, buffname)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff.name == buffname and buff.count > 0 then 
			return buff.count
		end
	end
	return 0
end

function IsReady(spell)
	return myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 and myHero:GetSpellData(spell).mana <= myHero.mana and Game.CanUseSpell(spell) == 0
end

function Mode()
	if _G.SDK then
		if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
			return "Combo"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] or Orbwalker.Key.Harass:Value() then
			return "Harass"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] or Orbwalker.Key.Clear:Value() then
			return "LaneClear"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] or Orbwalker.Key.LastHit:Value() then
			return "LastHit"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_FLEE] then
			return "Flee"
		end
	else
		return GOS.GetMode()
	end
end

function SetMovement(bool)
	if _G.PremiumOrbwalker then
		_G.PremiumOrbwalker:SetAttack(bool)
		_G.PremiumOrbwalker:SetMovement(bool)		
	elseif _G.SDK then
		_G.SDK.Orbwalker:SetMovement(bool)
		_G.SDK.Orbwalker:SetAttack(bool)
	end
end
function SetMovement2(bool)
	if _G.PremiumOrbwalker then
		
		_G.PremiumOrbwalker:SetMovement(bool)		
	elseif _G.SDK then
		_G.SDK.Orbwalker:SetMovement(bool)
		
	end
end

function EnableMovement()
	SetMovement(true)
end

local function IsValid(unit)
    if (unit and unit.valid and unit.isTargetable and unit.alive and unit.visible and unit.networkID and unit.pathing and unit.health > 0) then
        return true;
    end
    return false;
end


local function ValidTarget(unit, range)
    if (unit and unit.valid and unit.isTargetable and unit.alive and unit.visible and unit.networkID and unit.pathing and unit.health > 0) then
    	if range then
    		if GetDistance(unit.pos) <= range then
        		return true;
        	end
        else
        	return true
        end
    end
    return false;
end



class "Manager"

function Manager:__init()
	if myHero.charName == "Akshan" then
		DelayAction(function() self:LoadAkshan() end, 1.05)
	end
end

function Manager:LoadAkshan()
	Akshan:Spells()
	Akshan:Menu()
	--
	--GetEnemyHeroes()
	Callback.Add("Tick", function() Akshan:Tick() end)
	Callback.Add("Draw", function() Akshan:Draw() end)
	if _G.SDK then
		_G.SDK.Orbwalker:OnPreAttack(function(...) Akshan:OnPreAttack(...) end)
		_G.SDK.Orbwalker:OnPostAttackTick(function(...) Akshan:OnPostAttackTick(...) end)
	end
end



class "Akshan"

local IS = {}
local EnemyLoaded = false
local QCastTime = Game:Timer()
local RCastTime = Game:Timer()
local Casted = 0
local QCasted = false
local AAData = 1
local UsedE = false
local CanQclick = true
local attackedfirst = 0
local WasInRange = false
local DoubleShot = false
local Direction = myHero.pos

function Akshan:Menu()
	self.Menu = MenuElement({type = MENU, id = "Akshan", name = "CloverAkshan"})
	self.Menu:MenuElement({id = "ComboMode", name = "Combo", type = MENU})
	self.Menu.ComboMode:MenuElement({id = "UseQ", name = "Use Q in Combo", value = true})
	
	self.Menu.ComboMode:MenuElement({id = "UseQMinionCombo", name = "Extend Q", value = true})
	self.Menu.ComboMode:MenuElement({id = "UseQMana", name = "Min Mana %", value = 10, min = 0, max = 100, step = 1})
	
	self.Menu:MenuElement({id = "HarassMode", name = "Harass", type = MENU})
	self.Menu.HarassMode:MenuElement({id = "UseQ", name = "Use Q in Harass", value = true})
	self.Menu.HarassMode:MenuElement({id = "UseQMana", name = "Min Mana %", value = 10, min = 0, max = 100, step = 1})


	self.Menu:MenuElement({id = "DoubleAttack", name = "Double", type = MENU})
	self.Menu.DoubleAttack:MenuElement({id = "Radius", name = "Min Range", value = 300, min = 100, max = 600 })
	

	self.Menu:MenuElement({id = "Draw", name = "Draw", type = MENU})	
	self.Menu.Draw:MenuElement({id = "Double", name = "Draw Double Attack Range", value = true})
	self.Menu.Draw:MenuElement({id = "Q", name = "Draw Q Range", value = true})
	self.Menu.Draw:MenuElement({id = "E", name = "Draw E Range", value = true})
	self.Menu.Draw:MenuElement({id = "R", name = "Draw R Range", value = true})


end

function Akshan:Spells()
	QSpellData = {speed = 1500, range = 850, delay = 0.25, radius = 60, collision = {}, type = "linear"}
	WSpellData = {speed = 1600, range = 900, delay = 0.25, radius = 40, collision = {}, type = "linear"}
	RSpellData = {speed = 2800, range = 1200, delay = 0, radius = 110, collision = {}, type = "linear"}
end

function Akshan:Tick()
	

	if _G.JustEvade and _G.JustEvade:Evading() or (_G.ExtLibEvade and _G.ExtLibEvade.Evading) or Game.IsChatOpen() or myHero.dead then return end
	
	--PrintChat(myHero.activeSpell.name)
	
	--PrintChat(myHero.attackData.state)
	if myHero.activeSpell.name == "AkshanQ" then
		--PrintChat("Casting Q")
		QCasted = true
	else
		--PrintChat("Not Casting Q")
		if QCasted == true then
			--if target then
			--	Control.Attack(target)
			--end
		end
		QCasted = false
	end
	
	self:KS()
	self:Logic()
	--Echeck()
	double(self.Menu.DoubleAttack.Radius:Value())
	if myHero:GetSpellData(_R).toggleState == 1 or not target and myHero.activeSpell.name ~= "AkshanQ" then
		--_G.SDK.Orbwalker:SetMovement(true)
	end
	if EnemyLoaded == false then
		local CountEnemy = 0
		for i, enemy in pairs(EnemyHeroes) do
			CountEnemy = CountEnemy + 1
		end
		if CountEnemy < 1 then
			GetEnemyHeroes()
		else
			EnemyLoaded = true
			PrintChat("Enemy Loaded")
		end
	end
end
local i = 1
function double(range)
	target = GetTarget(1400)

	for i, enemy in pairs(EnemyHeroes) do
	
		if ValidTarget(enemy, 1000) then
			if IsDouble() and GetDistance(enemy.pos) > range then		
				SetMovement2(false)
			elseif myHero:GetSpellData(_E).name == "AkshanE2" or myHero:GetSpellData(_E).name == "AkshanE3" then
				SetMovement(false)
			else		
 				SetMovement(true)
			end
		end		
	end
end

function Echeck()	
	--[[
	if i == 1 then
		print("  ")
		print("  ")
		print("  ")
		print("  ")
		print("  ")
		print("  ")
		print("  ")		
		print("  ")
		print("  ")
		print("  ")
		print("  ")
		print("  ")
		print("  ")
		print("  ")
		print("  ")
		print("  ")
		print("  ")		
		print("  ")
		print("  ")
		print("  ")
		print("  ")		
		print("  ")
		print("  ")
		print("  ")
		print(myHero:GetSpellData(_E))
		i=i+1
	end
	]]--
	if myHero:GetSpellData(_E).name == "AkshanE2" or myHero:GetSpellData(_E).name == "AkshanE3" then	
						
		SetMovement(false)	
	else
 		SetMovement(true)
	end
	
end

function IsDouble()	
	--print(myHero.activeSpell.name)
	return myHero.activeSpell and myHero.activeSpell.valid and myHero.activeSpell.name == "AkshanBasicAttack" 
end

function Akshan:Draw()


	if self.Menu.Draw.Q:Value() then
		Draw.Circle(myHero.pos, 850, 1, Draw.Color(255, 0, 191, 255))
	end
	if self.Menu.Draw.E:Value() then
		Draw.Circle(myHero.pos, 800, 3, Draw.Color(255, 255, 191, 255))
	end
	if self.Menu.Draw.R:Value() then
		Draw.Circle(myHero.pos, 2500, 1, Draw.Color(255, 0, 191, 255))
	end	
	if self.Menu.Draw.Double:Value() then
		Draw.Circle(myHero.pos, self.Menu.DoubleAttack.Radius:Value(), 1, Draw.Color(255, 0, 191, 255))
	end	


end

function Akshan:KS()
	--PrintChat("ksing")
	for i, enemy in pairs(EnemyHeroes) do
		if enemy and not enemy.dead and ValidTarget(enemy, 1000) then
			if self:CanUse(_Q, "KS") and GetDistance(enemy.pos, myHero.pos) > 800 and GetDistance(enemy.pos, myHero.pos) < 1000 then
				--PrintChat("ksing 2")
				self:GetQMinion(enemy)
			end
		end
	end
end	

function Akshan:CanUse(spell, mode)
	if mode == nil then
		mode = Mode()
	end
	--PrintChat(Mode())
	if spell == _Q then
		if mode == "Combo" and IsReady(spell) and self.Menu.ComboMode.UseQ:Value() then
			return true
		end
		if mode == "Harass" and IsReady(spell) and self.Menu.HarassMode.UseQ:Value() then
			return true
		end
	
	
	end
	return false
end

function Akshan:Logic()
	if target == nil then return end
	if Mode() == "Combo" or Mode() == "Harass" and target then
		i = 1
		if self:CanUse(_Q, Mode()) and GetDistance(target.pos, myHero.pos) > 800 and GetDistance(target.pos, myHero.pos) < 1000 and self.Menu.ComboMode.UseQMinionCombo:Value() then
			self:GetQMinion(target)
			
		end


		local Qrange = 800 + myHero.boundingRadius + target.boundingRadius
		
		if self:CanUse(_Q, Mode()) and ValidTarget(target, Qrange) and not (myHero.pathing and myHero.pathing.isDashing) and not DoubleShot and myHero.activeSpell.name ~= "AkshanQ" and myHero.activeSpell.name ~= "AkshanE" and not _G.SDK.Attack:IsActive() then
			
				local pred = _G.PremiumPrediction:GetPrediction(myHero, target, QSpellData)
				if pred.CastPos and _G.PremiumPrediction.HitChance.Low(pred.HitChance) and myHero.pos:DistanceTo(pred.CastPos) < 800 then
					Control.CastSpell(HK_Q, target)
					
				end
				
			
		end
		
	
	end		
end

function Akshan:QClick()
	local NextSpot = GetUnitPositionNext(myHero)
	local spot = mousePos
	if NextSpot then
		local Direction = Vector((myHero.pos-NextSpot):Normalized())
		spot = myHero.pos - Direction*100
	else
		local Direction = Vector((myHero.pos-target.pos):Normalized())
		--spot = myHero.pos- Direction*100
		--spot = mousePos
		--PrintChat("using hero spot")
	end
	Draw.Circle(mousePos, 50, 1, Draw.Color(255, 0, 191, 255))
	--Control.RightClick(spot:To2D())
	if target then
		Control.Attack(target)
	end
	--DelayAction(function() 	Control.RightClick(target.pos:To2D()) end, 0.05)
end

function Akshan:GetQMinion(unit)
		--PrintChat("Getting Q minion")
		local minions = _G.SDK.ObjectManager:GetEnemyMinions(800)
		local mtarget = nil
		local mlocation = nil
		local manaper = myHero.mana / myHero.maxMana * 100
		if manaper > self.Menu.ComboMode.UseQMana:Value() then
	 		for i = 1, #minions do
	        	local minion = minions[i]
	    		--PrintChat(minion.team)
				if minion.team == 300 - myHero.team and IsValid(minion) then
					--PrintChat("minion")
					if GetDistance(minion.pos, myHero.pos) < 800 then
						if GetDistance(unit.pos, minion.pos) < GetDistance(unit.pos, myHero.pos) then
							CastDirection = Vector((minion.pos-myHero.pos):Normalized())
							enemydist = GetDistance(unit.pos, myHero.pos)
							EnemySpot = myHero.pos:Extended(minion.pos, enemydist)
							Location = EnemySpot
							--Draw.Circle(Location, 50, 1, Draw.Color(255, 0, 191, 255))
							--print(enemydist)
							if GetDistance(Location, unit.pos) < 200 then
								if mtarget == nil or GetDistance(Location, unit.pos) < GetDistance(mlocation, unit.pos) then 
									mtarget = minion
									mlocation = Location
								end
							end
						end
					end
				end
			end
		end
		if ValidTarget(mtarget, 800) then
			local pred = _G.PremiumPrediction:GetPrediction(myHero, mtarget, QSpellData)
			if pred.CastPos and _G.PremiumPrediction.HitChance.Low(pred.HitChance) and myHero.pos:DistanceTo(pred.CastPos) < 800 then
				Control.CastSpell(HK_Q, mtarget)
			end
		end
end

function Akshan:GetRDmg(unit, hits)
	local level = myHero:GetSpellData(_R).level
	local RDmg = getdmg("R", unit, myHero, myHero:GetSpellData(_R).level)
	if hits then
		return RDmg * hits
	else
		return  RDmg * (15 + 5*level)
	end
end


function Akshan:OnPreAttack(args)
end

function Akshan:OnPostAttackTick(args)
	attackedfirst = 1
	if target and Mode() == "Combo" then
		--PrintChat(target.boundingRadius)

	end
end



function Akshan:UseW(unit)
		local pred = _G.PremiumPrediction:GetPrediction(myHero, unit, WSpellData)
		if pred.CastPos and _G.PremiumPrediction.HitChance.Low(pred.HitChance) and myHero.pos:DistanceTo(pred.CastPos) < 900 then
		    	Control.CastSpell(HK_W, pred.CastPos)
		    	Casted = 1
		end 
end

function Akshan:UseR(unit)
		local pred = _G.PremiumPrediction:GetPrediction(myHero, unit, RSpellData)
		if pred.CastPos and _G.PremiumPrediction.HitChance.Medium(pred.HitChance) and myHero.pos:DistanceTo(pred.CastPos) < 1200  then
		    	Control.CastSpell(HK_R, pred.CastPos)
		end 
end





function OnLoad()
	Manager()
end



