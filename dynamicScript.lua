local heroes = false
local checkCount = 0 
local menu = 1
local Orb
local _OnWaypoint = {}
local _OnVision = {}
local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
local spellcast = {state = 1, mouse = mousePos}
local ItemHotKey = {[ITEM_1] = HK_ITEM_1, [ITEM_2] = HK_ITEM_2,[ITEM_3] = HK_ITEM_3, [ITEM_4] = HK_ITEM_4, [ITEM_5] = HK_ITEM_5, [ITEM_6] = HK_ITEM_6, [ITEM_7] = HK_ITEM_7,}
local barHeight, barWidth, barXOffset, barYOffset = 8, 103, 0, 0
local Allies, Enemies, Turrets, Units = {}, {}, {}, {}
local TEAM_ALLY = myHero.team
local TEAM_ENEMY = 300 - myHero.team
local TEAM_JUNGLE = 300
local charging = false
local wClock = 0
local clock = os.clock
local Latency = Game.Latency
local ping = Latency() * 0.001
local MyHeroRange = myHero.range + myHero.boundingRadius * 2
local DrawCircle = Draw.Circle
local DrawColor = Draw.Color
local DrawText = Draw.Text
local ControlCastSpell = Control.CastSpell
local GameCanUseSpell = Game.CanUseSpell
local GameTimer = Game.Timer
local GameHeroCount = Game.HeroCount
local GameHero = Game.Hero
local GameMinionCount = Game.MinionCount
local GameMinion = Game.Minion
local GameTurretCount = Game.TurretCount
local GameTurret = Game.Turret
local GameObjectCount = Game.ObjectCount
local GameObject = Game.Object
local GameParticleCount = Game.ParticleCount
local GameParticle = Game.Particle
local GameMissileCount = Game.MissileCount
local GameMissile = Game.Missile
local GameIsChatOpen = Game.IsChatOpen
local TEAM_ALLY = myHero.team
local TEAM_ENEMY = 300 - myHero.team
local TEAM_JUNGLE = 300
local MathSqrt = math.sqrt
local MathHuge = math.huge
local TableInsert = table.insert
local TableRemove = table.remove
_G.LATENCY = 0.05


function LoadUnits()
	for i = 1, GameHeroCount() do
		local unit = GameHero(i); Units[i] = {unit = unit, spell = nil}
		if unit.team ~= myHero.team then TableInsert(Enemies, unit)
		elseif unit.team == myHero.team and unit ~= myHero then TableInsert(Allies, unit) end
	end
	for i = 1, GameTurretCount() do
		local turret = GameTurret(i)
		if turret and turret.isEnemy then TableInsert(Turrets, turret) end
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
		
local function ConvertToHitChance(menuValue, hitChance)
    return menuValue == 1 and _G.PremiumPrediction.HitChance.High(hitChance)
    or menuValue == 2 and _G.PremiumPrediction.HitChance.VeryHigh(hitChance)
    or _G.PremiumPrediction.HitChance.Immobile(hitChance)
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

function GetMode()   
    if Orb == 1 then
        if combo == 1 then
            return 'Combo'
        elseif harass == 2 then
            return 'Harass'
        elseif lastHit == 3 then
            return 'Lasthit'
        elseif laneClear == 4 then
            return 'Clear'
        end
    elseif Orb == 2 then
		if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
			return "Combo"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
			return "Harass"	
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] or _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR] then
			return "Clear"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] then
			return "LastHit"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_FLEE] then
			return "Flee"
		end
    elseif Orb == 3 then
        return GOS:GetMode()
    elseif Orb == 4 then
        return _G.gsoSDK.Orbwalker:GetMode()
	elseif Orb == 5 then
	  return _G.PremiumOrbwalker:GetMode()
	end
	
    if _G.SDK then
        return 
		_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] and "Combo"
        or 
		_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] and "Harass"
        or 
		_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] and "Clear"
        or 
		_G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR] and "Clear"
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

function GetTarget(range) 
	if Orb == 1 then
		if myHero.ap > myHero.totalDamage then
			return EOW:GetTarget(range, EOW.ap_dec, myHero.pos)
		else
			return EOW:GetTarget(range, EOW.ad_dec, myHero.pos)
		end
	elseif Orb == 2 and TargetSelector then
		if myHero.ap > myHero.totalDamage then
			return TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL)
		else
			return TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		end
	elseif _G.GOS then
		if myHero.ap > myHero.totalDamage then
			return GOS:GetTarget(range, "AP")
		else
			return GOS:GetTarget(range, "AD")
        end
    elseif _G.gsoSDK then
		return _G.gsoSDK.TS:GetTarget()
	
	elseif _G.PremiumOrbwalker then
		return _G.PremiumOrbwalker:GetTarget(range)
	end	
	
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

local function GetDistanceSqr(p1, p2)
	if not p1 then return MathHuge end
	p2 = p2 or myHero
	local dx = p1.x - p2.x
	local dz = (p1.z or p1.y) - (p2.z or p2.y)
	return dx*dx + dz*dz
end

local function GetDistance(p1, p2)
	p2 = p2 or myHero
	return MathSqrt(GetDistanceSqr(p1, p2))
end

local function GetDistance2D(p1,p2)
	return MathSqrt((p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y))
end

local function IsRecalling(unit)
	for i = 1, 63 do
	local buff = unit:GetBuff(i) 
		if buff.count > 0 and buff.name == "recall" and Game.Timer() < buff.expireTime then
			return true
		end
	end 
	return false
end 
	
local function MyHeroNotReady()
    return myHero.dead or GameIsChatOpen() or (_G.JustEvade and _G.JustEvade:Evading()) or (_G.ExtLibEvade and _G.ExtLibEvade.Evading) or IsRecalling(myHero)
end

--[[
local currSpell = myHero.activeSpell
if currSpell and currSpell.valid and myHero.isChanneling then
print ("Width:  "..myHero.activeSpell.width)
print ("Speed:  "..myHero.activeSpell.speed)
print ("Delay:  "..myHero.activeSpell.animation)
print ("range:  "..myHero.activeSpell.range)
print ("Name:  "..myHero.activeSpell.name)
end
]]
--[[
for i = 0, myHero.buffCount do
	local buff = myHero:GetBuff(i)
	if buff.name == "" then
	--print(buff.name)
		print("Typ:  "..buff.type)
		print("Name:  "..buff.name)
		print("Start:  "..buff.startTime)
		print("Expire:  "..buff.expireTime)
		print("Dura:  "..buff.duration)
		print("Stacks:  "..buff.stacks)
		print("Count:  "..buff.count)
		print("Id:  "..buff.sourcenID)
		print("SouceName:  "..buff.sourceName)	
	end
end
]]
local IsLoaded = false
Callback.Add("Tick", function()  
	if heroes == false then 
		local EnemyCount = CheckLoadedEnemyies()			
		if EnemyCount < 1 then
			LoadUnits()
		else
			heroes = true
		end
	else	
		if not IsLoaded then
			LoadScript()
			DelayAction(function()
				if not Menu.Pred then return end
				if Menu.Pred.Change:Value() == 1 then
					require('GamsteronPrediction')
				elseif Menu.Pred.Change:Value() == 2 then
					require('PremiumPrediction')
				else
					require('GGPrediction')
				end	
			end, 1)
			IsLoaded = true
		end	
	end	
end)

local DrawTime = false
Callback.Add("Draw", function() 
	if heroes == false then
		Draw.Text(myHero.charName.." is Loading !!", 24, myHero.pos2D.x - 50, myHero.pos2D.y + 195, Draw.Color(255, 255, 0, 0))
	else
		if not DrawTime then
			Draw.Text(myHero.charName.." is Ready !!", 24, myHero.pos2D.x - 50, myHero.pos2D.y + 195, Draw.Color(255, 0, 255, 0))
			DelayAction(function()
			DrawTime = true
			end, 4.0)
		end	
	end
end)
local function GetEnemyHeroes()
	local _EnemyHeroes = {}
	for i = 1, GameHeroCount() do
		local unit = GameHero(i)
		if unit.team ~= myHero.team then
			TableInsert(_EnemyHeroes, unit)
		end
	end
	return _EnemyHeroes
end

local function GetEnemyCount(range, pos)
    local pos = pos.pos
	local count = 0
	for i = 1, GameHeroCount() do 
	local hero = GameHero(i)
	local Range = range * range
		if hero.team ~= TEAM_ALLY and GetDistanceSqr(pos, hero.pos) < Range and IsValid(hero) then
		count = count + 1
		end
	end
	return count
end

local function IsAllyTurret(unit)
    for i = 1, GameTurretCount() do
        local turret = GameTurret(i)
        local range = (turret.boundingRadius + 650 + unit.boundingRadius / 2)
        if turret.isAlly and not turret.dead then
            if turret.pos:DistanceTo(unit.pos) < range then
				return true
            end
        end
    end
    return false
end

function LoadScript()
	
	Menu = MenuElement({type = MENU, id = "PussyAIO".. myHero.charName, name = myHero.charName})
	Menu:MenuElement({name = " ", drop = {"Version 0.04"}})	
	
	Menu:MenuElement({type = MENU, id = "Q", name = "Auto Q + E"})
	Menu.Q:MenuElement({name = " ", drop = {"Auto [Q] + [E] under Ally Tower"}})		
	Menu.Q:MenuElement({id = "UseQ", name = "Use Auto [Q] + [E]", value = true})		
	
	--ComboMenu  
	Menu:MenuElement({type = MENU, id = "Combo", name = "Combo"})
	Menu.Combo:MenuElement({id = "UseQ", name = "[Q]", value = true})
	Menu.Combo:MenuElement({id = "Qrange", name = "[Q] if range lower than -->", value = 1050, min = 0, max = 1150})
	Menu.Combo:MenuElement({id = "Qrange2", name = "[Q] if range bigger than -->", value = 400, min = 0, max = 1150})	
	Menu.Combo:MenuElement({id = "UseW", name = "[W] +attack speed in AA range ", value = true})
	Menu.Combo:MenuElement({id = "UseE", name = "[E]", value = true})	
	
	--UltSettings
	Menu.Combo:MenuElement({type = MENU, id = "Ult", name = "Ultimate Settings"})	
	Menu.Combo.Ult:MenuElement({id = "UseRcount", name = "Use[R] count targets", value = true})
	Menu.Combo.Ult:MenuElement({id = "Rcount", name = "Use[R] min Targets", value = 2, min = 1, max = 5}) 
	Menu.Combo.Ult:MenuElement({id = "UseR", name = "Use[R] single target [HP check]", value = true})
	Menu.Combo.Ult:MenuElement({id = "Rhp", name = " Is single target Hp lower than -->", value = 40, min = 0, max = 100, identifier = "%"}) 	

	--Prediction
	Menu:MenuElement({type = MENU, id = "Pred", name = "Prediction"})
	Menu.Pred:MenuElement({name = " ", drop = {"After change Pred.Typ reload 2x F6"}})	
	Menu.Pred:MenuElement({id = "Change", name = "Change Prediction Typ", value = 3, drop = {"Gamsteron Prediction", "Premium Prediction", "GGPrediction"}})	
	Menu.Pred:MenuElement({id = "PredQ", name = "Hitchance[Q]", value = 2, drop = {"Normal", "High", "Immobile"}})	

	--Drawing 
	Menu:MenuElement({type = MENU, id = "Drawing", name = "Drawings"})
	Menu.Drawing:MenuElement({id = "DrawQ", name = "Draw [Q] MaxRange", value = false})
	Menu.Drawing:MenuElement({id = "DrawQ2", name = "Draw [Q] MinRange", value = false})	
	Menu.Drawing:MenuElement({id = "DrawE", name = "Draw [E] Range", value = false})
	Menu.Drawing:MenuElement({id = "DrawR", name = "Draw [R] Range", value = false})	

	QData =
	{
	Type = _G.SPELLTYPE_LINE, Delay = 0.25, Radius = 35, Range = 1150, Speed = 1800, Collision = true, MaxCollision = 0, CollisionTypes = { _G.COLLISION_MINION }
	}
	
	QspellData = {speed = 1800, range = 1150, delay = 0.25, radius = 35, collision = {"minion"}, type = "linear"}	

  	                                           
	Callback.Add("Tick", function() Tick() end)
	
	Callback.Add("Draw", function()
		if Menu.Drawing.DrawR:Value() and Ready(_R) then
		DrawCircle(myHero, 600, 1, DrawColor(255, 225, 255, 10))
		end                                                 
		if Menu.Drawing.DrawQ:Value() and Ready(_Q) then
		DrawCircle(myHero, Menu.Combo.Qrange:Value(), 1, DrawColor(225, 225, 0, 10))
		end
		if Menu.Drawing.DrawQ2:Value() and Ready(_Q) then
		DrawCircle(myHero, Menu.Combo.Qrange2:Value(), 1, DrawColor(225, 225, 0, 10))
		end		
		if Menu.Drawing.DrawE:Value() and Ready(_E) then
		DrawCircle(myHero, 300, 1, DrawColor(225, 225, 125, 10))
		end		
	end)		
end

function Tick()
if MyHeroNotReady() then return end
local Mode = GetMode()
	if Mode == "Combo" then
		Combo()			
	end
	AutoQ()	
end

function AutoQ()
	for i, target in ipairs(GetEnemyHeroes()) do    	
	if myHero.pos:DistanceTo(target.pos) > 1200 then return end	
	
		if myHero.pos:DistanceTo(target.pos) <= 250 and IsValid(target) and Ready(_E) then
			Control.CastSpell(HK_E, target)
		end	
		
		if Ready(_Q) and Menu.Q.UseQ:Value() and IsValid(target) then
			local Tower = IsAllyTurret(myHero)
			if Tower and myHero.pos:DistanceTo(target.pos) <= Menu.Combo.Qrange:Value() then			
				if Menu.Pred.Change:Value() == 1 then
					local pred = GetGamsteronPrediction(target, QData, myHero)
					if pred.Hitchance >= Menu.Pred.PredQ:Value()+1 then
						SetMovement(false)
						Control.CastSpell(HK_Q, pred.CastPosition)
						SetMovement(true)						
					end
				elseif Menu.Pred.Change:Value() == 2 then
					local pred = _G.PremiumPrediction:GetPrediction(myHero, target, QspellData)
					if pred.CastPos and ConvertToHitChance(Menu.Pred.PredQ:Value(), pred.HitChance) then
						SetMovement(false)
						Control.CastSpell(HK_Q, pred.CastPos)
						SetMovement(true)						
					end	
				else
					CastGGPred(target)
				end
			end	
		end
	end	
end		

function Combo()
local target = GetTarget(1200)
if target == nil then return end
	if IsValid(target) then
	
		if myHero.pos:DistanceTo(target.pos) <= 250 and Menu.Combo.UseE:Value() and Ready(_E) then
			Control.CastSpell(HK_E, target)
		end		

		if myHero.pos:DistanceTo(target.pos) <= 250 and Menu.Combo.UseW:Value() and Ready(_W) then
			Control.CastSpell(HK_W, target)
		end		
		
		if myHero.pos:DistanceTo(target.pos) <= Menu.Combo.Qrange:Value() and myHero.pos:DistanceTo(target.pos) > Menu.Combo.Qrange2:Value() and Menu.Combo.UseQ:Value() and Ready(_Q) then
			if Menu.Pred.Change:Value() == 1 then
				local pred = GetGamsteronPrediction(target, QData, myHero)
				if pred.Hitchance >= Menu.Pred.PredQ:Value()+1 then				
					Control.CastSpell(HK_Q, pred.CastPosition)					
				end
			elseif Menu.Pred.Change:Value() == 2 then
				local pred = _G.PremiumPrediction:GetPrediction(myHero, target, QspellData)
				if pred.CastPos and ConvertToHitChance(Menu.Pred.PredQ:Value(), pred.HitChance) then			
					Control.CastSpell(HK_Q, pred.CastPos)					
				end
			else
				CastGGPred(target)
			end
		end
		
		if Ready(_R) and Menu.Combo.Ult.UseRcount:Value() then
			local count = GetEnemyCount(550, myHero)
			if count >= Menu.Combo.Ult.Rcount:Value() then
				Control.CastSpell(HK_R)
			end
		end
		
		if myHero.pos:DistanceTo(target.pos) <= 550 and Ready(_R) and Menu.Combo.Ult.UseR:Value() then
			if target.health/target.maxHealth <= Menu.Combo.Ult.Rhp:Value() / 100 then
				Control.CastSpell(HK_R)
			end
		end		
	end
end

function CastGGPred(unit)
	local QPrediction = GGPrediction:SpellPrediction({Type = GGPrediction.SPELLTYPE_LINE, Delay = 0.25, Radius = 35, Range = 1150, Speed = 1800, Collision = true, CollisionTypes = {GGPrediction.COLLISION_MINION}})
	QPrediction:GetPrediction(unit, myHero)
	if QPrediction:CanHit(Menu.Pred.PredQ:Value() + 1) then
		Control.CastSpell(HK_Q, QPrediction.CastPosition)
	end	
end
