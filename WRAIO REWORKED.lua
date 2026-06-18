-- c:
if _G.WR_COMMON_LOADED then
    print("[WR] is already loaded, please unload other WR AIO script and try again !")
    return
end
--_G.WR_COMMON_LOADED = true

local LoadCallbacks = {}
local MENU_PRED = 1
local PredLoaded = false

--# Enable/Disable
local prtchat = false
local changelog = false
local modules = false
local loadedCallbacks = false

--
local myHero = myHero

local currentData = {
    Champions = {
        Ashe = {
            Version = 1.04,
            Changelog = "Improved Ashe AA Reset",
        },
        Blitzcrank = {
            Version = 1.03,
            Changelog = "Fixed bug on R KS",
        },
        Corki = {
            Version = 1.05,
            Changelog = "OnDash Typo Fix",
        },
        Darius = {
            Version = 1.04,
            Changelog = "Improved Dmg Calculation",
        },
        Draven = {
            Version = 1.03,
            Changelog = "Draven Initial Release",
        },
        Ezreal = {
            Version = 1.03,
            Changelog = "Ezreal LastHit Fix",
        },
        Jax = {
            Version = 1.02,
            Changelog = "Improved Jax AA Reset",
        },
        Jhin = {
            Version = 1.02,
            Changelog = "Jhin Initial Release",
        },
        Kalista = {
            Version = 1.02,
            Changelog = "Kalista Initial Release",
        },
        Lucian = {
            Version = 1.05,
            Changelog = "Improved Dmg Calculation",
        },
        Olaf = {
            Version = 1.01,
            Changelog = "Improved Dmg Calculation",
        },
        Riven = {
            Version = 1.05,
            Changelog = "Riven Dmg Calc Update",
        },
        Sion = {
            Version = 1.03,
            Changelog = "Sion Initial Release",
        },
        Syndra = {
            Version = 1.02,
            Changelog = "Improved Dmg Calculation",
        },
        Talon = {
            Version = 1.01,
            Changelog = "Talon Initial Release",
        },
        Teemo = {
            Version = 1.02,
            Changelog = "Crash fix and expanded Q and R Features",
        },
        Thresh = {
            Version = 1.00,
            Changelog = "Thresh Initial Release",
        },
        TwistedFate = {
            Version = 1.02,
            Changelog = "TF Initial Release",
        },
        Twitch = {
            Version = 1.04,
            Changelog = "Improved Dmg Calculation",
        },
        Varus = {
            Version = 1.01,
            Changelog = "Varus Initial Release",
        },
        Vayne = {
            Version = 1.04,
            Changelog = "Improved Vayne AA Reset",
        },
        Vladimir = {
            Version = 1.09,
            Changelog = "Rework of EW, Burst, Farming",
        },
        Xayah = {
            Version = 1.00,
            Changelog = "Xayah Initial Release",
        },
    },
    Loader = {
        Version = 1.05,
    },
    Dependencies = {
        commonLib = {
            Version = 1.15,
        },
        prediction = {
            Version = 1.04,
        },
        changelog = {
            Version = 1.02,
        },
        callbacks = {
            Version = 1.02,
        },
        menuLoad = {
            Version = 1.07,
        },
    },
    Utilities = {
        baseult = {
            Version = 0,
        },
        evade = {
            Version = 0,
        },
        tracker = {
            Version = 0,
        },
        orbwalker = {
            Version = 0,
        },
    },
    Core = {
        Version = 1.02,
        Changelog = "Welcome to Project WinRate - The Most Advanced Script Ever!\n\n"..
            "I try to ensure you're always up to date without any impact on your game, to have the maximum impact on your game!\n"..
            "Credits to RMAN! \n"..
            "Enjoy your Game! ",
    },
}

if currentData.Champions[myHero.charName] == nil then
    print("[ [WR] Error ]: " .. myHero.charName .. " is not supported !")
    return
end

--# Libs --
--require "debug"
require "MapPositionGOS"
require "DamageLib"
--DamageLib = require"DamageLib"
require "2DGeometry"

--
local huge = math.huge
local pi = math.pi
local floor = math.floor
--local ceil = math.ceil
local sqrt = math.sqrt
local max = math.max
local min = math.min
--
local abs = math.abs
local deg = math.deg
local cos = math.cos
local sin = math.sin
local acos = math.acos
--local atan = math.atan
--
local insert = table.insert
local remove = table.remove
local sort = table.sort
--
local TEAM_JUNGLE = 300
local TEAM_ALLY = myHero.team
local TEAM_ENEMY = TEAM_JUNGLE - TEAM_ALLY
--
local Vector = Vector
--
--local Control = Control
local KeyDown = Control.KeyDown
local KeyUp = Control.KeyUp
local IsKeyDown = Control.IsKeyDown
local SetCursorPos = Control.SetCursorPos
--
--local Game = Game
local GameCanUseSpell = Game.CanUseSpell
local Timer = Game.Timer
local TickCount = GetTickCount
local Latency = Game.Latency
local HeroCount = Game.HeroCount
local Hero = Game.Hero
--local MinionCount = Game.MinionCount
--local Minion = Game.Minion
--local TurretCount = Game.TurretCount
--local Turret = Game.Turret
--local WardCount = Game.WardCount
--local Ward = Game.Ward
local ObjectCount = Game.ObjectCount
local Object = Game.Object
local MissileCount = Game.MissileCount
local Missile = Game.Missile
local ParticleCount = Game.ParticleCount
local Particle = Game.Particle
--
--local Draw = Draw
local DrawCircle = Draw.Circle
local DrawLine = Draw.Line
local DrawColor = Draw.Color
local DrawMap = Draw.CircleMinimap
local DrawText = Draw.Text
--
--local Prediction, Spell, BuffExplorer, Animation, Vision, Path, Interrupter
-- Callbacks --
-- local ggMenu --
-- local ggColor --
-- local Action --
-- local BuffManager --
-- local ggDamage --
local Data
local ggSpell --
-- local SummonerSpell --
-- local ItemManager --
local ObjectManager
local TargetSelector
local HealthPrediction
-- local Cursor --
-- local Attack --
local Orbwalker
--
local GetMode, GetMinions, GetAllyMinions, GetEnemyMinions, GetMonsters, GetHeroes, GetAllyHeroes, GetEnemyHeroes, GetTurrets, GetAllyTurrets, GetEnemyTurrets, GetWards, GetAllyWards, GetEnemyWards, OnPreMovement, OnPreAttack, OnAttack, OnPostAttack, OnPostAttackTick, OnUnkillableMinion, IsHeroImmortal, SetMovement, SetAttack, GetTarget, ResetAutoAttack, IsAutoAttacking, Orbwalk, SetHoldRadius, SetMovementDelay, ForceTarget, ForceMovement, GetHealthPrediction, GetPriority
--
insert(LoadCallbacks, function()
    --ggMenu = _G.SDK.Menu
    --ggColor = _G.SDK.Color
    --Action = _G.SDK.Action
    --BuffManager = _G.SDK.BuffManager
    --ggDamage = _G.SDK.Damage
    Data = _G.SDK.Data
    ggSpell = _G.SDK.Spell
    --SummonerSpell = _G.SDK.SummonerSpell
    --ItemManager = _G.SDK.ItemManager
    ObjectManager = _G.SDK.ObjectManager
    TargetSelector = _G.SDK.TargetSelector
    HealthPrediction = _G.SDK.HealthPrediction
    --Cursor = _G.SDK.Cursor
    --Attack = _G.SDK.Attack
    Orbwalker = _G.SDK.Orbwalker

    GetMode = function()
        --1:Combo|2:Harass|3:LaneClear|4:JungleClear|5:LastHit|6:Flee
        local modes = Orbwalker.Modes
        for i = 0, #modes do
            if modes[i] then
                return i + 1
            end
        end
        return Orbwalker:GetModes() --nil
    end

    GetMinions = function(range)
        return ObjectManager:GetMinions(range)
    end

    GetAllyMinions = function(range)
        return ObjectManager:GetAllyMinions(range)
    end

    GetEnemyMinions = function(range)
        return ObjectManager:GetEnemyMinions(range)
    end

    GetMonsters = function(range)
        return ObjectManager:GetMonsters(range)
    end

    GetHeroes = function(range)
        return ObjectManager:GetHeroes(range)
    end

    GetAllyHeroes = function(range)
        return ObjectManager:GetAllyHeroes(range)
    end

    GetEnemyHeroes = function(range)
        return ObjectManager:GetEnemyHeroes(range)
    end

    GetTurrets = function(range)
        return ObjectManager:GetTurrets(range)
    end

    GetAllyTurrets = function(range)
        return ObjectManager:GetAllyTurrets(range)
    end

    GetEnemyTurrets = function(range)
        return ObjectManager:GetEnemyTurrets(range)
    end

    GetWards = function(range)
        return ObjectManager:GetOtherMinions(range)
    end

    GetAllyWards = function(range)
        return ObjectManager:GetOtherAllyMinions(range)
    end

    GetEnemyWards = function(range)
        return ObjectManager:GetOtherEnemyMinions(range)
    end

    OnPreMovement = function(fn)
        return Orbwalker:OnPreMovement(fn)
    end

    OnPreAttack = function(fn)
        return Orbwalker:OnPreAttack(fn)
    end

    OnAttack = function(fn)
        return Orbwalker:OnAttack(fn)
    end

    OnPostAttack = function(fn)
        return Orbwalker:OnPostAttack(fn)
    end

    OnPostAttackTick = function(fn)
        if Orbwalker.OnPostAttackTick then
            return Orbwalker:OnPostAttackTick(fn)
        else
            return Orbwalker:OnPostAttack(fn)
        end
    end

    OnUnkillableMinion = function(fn)
        if Orbwalker.OnUnkillableMinion then
            return Orbwalker:OnUnkillableMinion(fn)
        end
    end

    IsHeroImmortal = function(fn)
        if fn.isImmortal then
            return true
        end
        return ObjectManager:IsHeroImmortal(fn)
    end

    SetMovement = function(bool)
        return Orbwalker:SetMovement(bool)
    end

    SetAttack = function(bool)
        return Orbwalker:SetAttack(bool)
    end

    GetTarget = function(range, mode) --isAttack
        --0:Physical|1:Magical|2:True
        return TargetSelector:GetTarget(range or huge, mode or 0)
    end

    ResetAutoAttack = function()
        return Data:CanResetAttack()
    end

    IsAutoAttacking = function()
        return Orbwalker:IsAutoAttacking()
    end

    Orbwalk = function()
        return Orbwalker:Orbwalk()
    end

    SetHoldRadius = function(value)
        --Orbwalker.Menu.General.HoldRadius = value
        return Orbwalker.Menu.General.HoldRadius:Value(value)
    end

    SetMovementDelay = function(value) --Depreciated
        --return GGOrb.Movement.MoveTimer:Value(value) --Menu.Orbwalker.RandomHumanizer.Min:Value().Max:Value()
        return Orbwalker.Menu.General.MovementDelay:Value(value)
    end

    ForceTarget = function(unit)
        Orbwalker.ForceTarget = unit
    end

    ForceMovement = function(pos)
        Orbwalker.ForceMovement = pos
    end

    GetHealthPrediction = function(unit, delay)
        return HealthPrediction:GetPrediction(unit, delay)
    end

    GetPriority = function(unit)
        return TargetSelector:GetPriority(unit) or 1
    end

end)
--------------------------------------

--# Local Tables --
local Menu = {};
--local _SPELL_TABLE_PROCESS = {}
local _ANIMATION_TABLE = {}
local _VISION_TABLE = {}
--local _LEVEL_UP_TABLE = {}
--local _ITEM_TABLE = {}
local _PATH_TABLE = {}
local _IMMOBILE = {
    _STUN = 5,
    _TAUNT = 8,
    _SLOW = 11,
    _SNARE = 12,
    _FEAR = 22,
    _CHARM = 23,
    _SUPRESS = 25,
    _KNOCKUP = 30,
    _KNOCKBACK = 31,
    _Asleep = 35,
}
local Color = {
    Red = DrawColor(255, 255, 0, 0),
    Green = DrawColor(255, 0, 255, 0),
    Blue = DrawColor(255, 0, 0, 255),
    Yellow = DrawColor(255, 255, 255, 0),
    Aqua = DrawColor(255, 0, 255, 255),
    Fuchsia = DrawColor(255, 255, 0, 255),
    Teal = DrawColor(255, 0, 128, 128),
    Gray = DrawColor(128, 128, 128, 128),
    White = DrawColor(255, 255, 255, 255), --default/nil
    Black = DrawColor(255, 0, 0, 0),
}
local ItemID = DamageLib.ItemID
local wardItemIDs = {
    ItemID.StealthWard,
    ItemID.ControlWard,
    ItemID.FarsightAlteration,
    ItemID.ScarecrowEffigy,
    ItemID.StirringWardstone,
    ItemID.VigilantWardstone,
    ItemID.WatchfulWardstone,
    ItemID.BlackMistScythe,
    ItemID.HarrowingCrescent,
    ItemID.SpectralSickle,
    ItemID.PauldronsofWhiterock,
    ItemID.RunesteelSpaulders,
    ItemID.SteelShoulderguards,
    ItemID.BulwarkoftheMountain,
    ItemID.TargonsBuckler,
    ItemID.RelicShield,
    ItemID.ShardofTrueIce,
    ItemID.Frostfang,
    ItemID.SpellthiefsEdge,
}
local ItemHotKey = {
    [ITEM_1] = HK_ITEM_1,
    [ITEM_2] = HK_ITEM_2,
    [ITEM_3] = HK_ITEM_3,
    [ITEM_4] = HK_ITEM_4,
    [ITEM_5] = HK_ITEM_5,
    [ITEM_6] = HK_ITEM_6,
    [ITEM_7] = HK_ITEM_7,
}
local Emote = {
    Joke = HK_ITEM_1,
    Taunt = HK_ITEM_2,
    Dance = HK_ITEM_3,
    Mastery = HK_ITEM_5,
    Laugh = HK_ITEM_7,
    Casting = false
}

--# Local Functions --

local Class = function()
    local cls = {};
    cls.__index = cls
    return setmetatable(cls, { __call = function(c, ...)
        local instance = setmetatable({}, cls)
        if cls.__init then cls.__init(instance, ...) end
        return instance
    end })
end

local clamp = function(val, valmin, valmax)
    return min(max(val, valmin), valmax)
end

--[[ local shallow_copy = function(t)
    local t2 = {}
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
end ]]

--[[ local TextOnScreen = function(str)
    local res = Game.Resolution()
    Callback.Add("Draw", function()
        DrawText(str, 64, res.x / 2 - (#str * 10), res.y / 2, Color.Red)
    end)
end ]]

--[[ local Ready = function(spell)return{
    spell = spell,
    canuse = GameCanUseSpell(spell) == 0,
    isReady = function(self)
        return self.canuse
    end
}end ]]

local Ready = function(spell)
    return GameCanUseSpell(spell) == READY
end

local RotateAroundPoint = function(v1, v2, angle)
    local cos, sin = cos(angle), sin(angle)
    local x = ((v1.x - v2.x) * cos) - ((v1.z - v2.z) * sin) + v2.x
    local z = ((v1.z - v2.z) * cos) + ((v1.x - v2.x) * sin) + v2.z
    return Vector(x, v1.y, z or 0)
end

local GetDistanceSqr = function(p1, p2)
    local success, message = pcall(function()
        if p1 == nil then
            print(p1.x)
        end
    end)
    if not success then
        print(message)
    end
    p2 = p2 or myHero
    p1 = p1.pos or p1
    p2 = p2.pos or p2

    local dx, dz = p1.x - p2.x, p1.z - p2.z
    return dx * dx + dz * dz
end

local GetDistance = function(p1, p2)
    return sqrt(GetDistanceSqr(p1, p2))
end
--
local GetItemSlot = function(id) --returns Slot, HotKey
    for i = ITEM_1, ITEM_7 do
        if myHero:GetItemData(i).itemID == id then
            return i, ItemHotKey[i]
        end
    end
    return 0
end
--
local GetWardSlot = function() --returns Slot, HotKey
    for i = 1, #wardItemIDs do
        local ward, key = GetItemSlot(wardItemIDs[i])
        if ward ~= 0 then
            return ward, key
        end
    end
end
--
local DrawMark = function(pos, thickness, size, color)
    local rotateAngle = 0 --was outside

    rotateAngle = (rotateAngle + 2) % 720
    local hPos, thickness, color, size = pos or myHero.pos, thickness or 3, color or Color.Red, size * 2 or 150
    local offset, rotateAngle, mod = hPos + Vector(0, 0, size), rotateAngle / 360 * pi, 240 / 360 * pi
    local points = {
        hPos:To2D(),
        RotateAroundPoint(offset, hPos, rotateAngle):To2D(),
        RotateAroundPoint(offset, hPos, rotateAngle + mod):To2D(),
        RotateAroundPoint(offset, hPos, rotateAngle + 2 * mod):To2D(),
    }
    --
    for i = 1, #points do
        for j = 1, #points do
            local lambda = i ~= j and
                DrawLine(points[i].x - 3, points[i].y - 5, points[j].x - 3, points[j].y - 5, thickness, color) -- -3 and -5 are offsets (because ext)
        end
    end
end

--[[ local DrawRectOutline = function(vec1, vec2, width, color)
    local vec3, vec4 = vec2 - vec1, vec1 - vec2
    local A = (vec1 + (vec3:Perpendicular2():Normalized() * width)):To2D()
    local B = (vec1 + (vec3:Perpendicular():Normalized() * width)):To2D()
    local C = (vec2 + (vec4:Perpendicular2():Normalized() * width)):To2D()
    local D = (vec2 + (vec4:Perpendicular():Normalized() * width)):To2D()

    DrawLine(A, B, 3, color)
    DrawLine(B, C, 3, color)
    DrawLine(C, D, 3, color)
    DrawLine(D, A, 3, color)
end ]]

local VectorPointProjectionOnLineSegment = function(v1, v2, v)
    local cx, cy, ax, ay, bx, by = v.x, v.z, v1.x, v1.z, v2.x, v2.z
    local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) * (bx - ax) + (by - ay) * (by - ay))
    local pointLine = { x = ax + rL * (bx - ax), z = ay + rL * (by - ay) }
    local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
    local isOnSegment = rS == rL
    local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), z = ay + rS * (by - ay) }
    return pointSegment, pointLine, isOnSegment
end

local mCollision = function(pos1, pos2, spell, list) --returns a table with minions (use #table to get count)
    local result, speed, width, delay = {}, spell.Speed, spell.Width + 65, spell.Delay
    --
    if not list then
        list = GetEnemyMinions(max(GetDistance(pos1), GetDistance(pos2)) + spell.Range + 100)
    end
    --
    for i = 1, #list do
        local m = list[i]
        local pos3 = delay and m:GetPrediction(speed, delay) or m.pos
        if m and m.team ~= TEAM_ALLY and m.dead == false and m.isTargetable and
            GetDistanceSqr(pos1, pos2) > GetDistanceSqr(pos1, pos3) then
            local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(pos1, pos2, pos3)
            if isOnSegment and GetDistanceSqr(pointSegment, pos3) < width * width then
                result[#result + 1] = m
            end
        end
    end
    return result
end

local hCollision = function(pos1, pos2, spell, list) --returns a table with heroes (use #table to get count)
    local result, speed, width, delay = {}, spell.Speed, spell.Width + 65, spell.Delay
    if not list then
        list = GetEnemyHeroes(max(GetDistance(pos1), GetDistance(pos2)) + spell.Range + 100)
    end
    for i = 1, #list do
        local h = list[i]
        local pos3 = delay and h:GetPrediction(speed, delay) or h.pos
        if h and h.team ~= TEAM_ALLY and h.dead == false and h.isTargetable and
            GetDistanceSqr(pos1, pos2) > GetDistanceSqr(pos1, pos3) then
            local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(pos1, pos2, pos3)
            if isOnSegment and GetDistanceSqr(pointSegment, pos3) < width * width then
                insert(result, h)
            end
        end
    end
    return result
end

local HealthPercent = function(unit)
    return unit.maxHealth > 5 and unit.health / unit.maxHealth * 100 or 100
end

local ManaPercent = function(unit)
    return unit.maxMana > 0 and unit.mana / unit.maxMana * 100 or 100
end

--[[ local HasBuffOfType = function(unit, bufftype, delay)
    --returns bool and endtime , why not starting at buffCOunt and check back to 1 ?
    local delay = delay or 0
    local bool = false
    local endT = Timer()
    for i = 1, unit.buffCount do
        local buff = unit:GetBuff(i)
        if buff.type == bufftype and buff.expireTime >= Timer() and buff.duration > 0 then
            if buff.expireTime > endT then
                bool = true
                endT = buff.expireTime
            end
        end
    end
    return bool, endT
end ]]

local HasBuff = function(unit, buffname) --returns bool
    return GotBuff(unit, buffname) == 1
end

local GetBuffByName = function(unit, buffname) --returns buff
    return GetBuffData(unit, buffname)
end

--[[ local GetBuffByType = function(unit, bufftype)
    --returns buff
    for i = 1, unit.buffCount do
        local buff = unit:GetBuff(i)
        if buff.type == bufftype and buff.expireTime >= Timer() and buff.duration > 0 then
            return buff
        end
    end
    return nil
end
]]
--
--[[ local UndyingBuffs = {
    ["Aatrox"] = function(target, addHealthCheck)
        return HasBuff(target, "aatroxpassivedeath")
    end,
    ["Fiora"] = function(target, addHealthCheck)
        return HasBuff(target, "FioraW")
    end,
    ["Tryndamere"] = function(target, addHealthCheck)
        return HasBuff(target, "UndyingRage") and (not addHealthCheck or target.health <= 30)
    end,
    ["Vladimir"] = function(target, addHealthCheck)
        return HasBuff(target, "VladimirSanguinePool")
    end,
}

local HasUndyingBuff = function(target, addHealthCheck)
    --Self Casts Only
    local buffCheck = UndyingBuffs[target.charName]
    if buffCheck and buffCheck(target, addHealthCheck) then
        return true
    end
    --Can Be Casted On Others
    if HasBuff(target, "JudicatorIntervention") or ((not addHealthCheck or HealthPercent(target) <= 10) and (HasBuff(target, "kindredrnodeathbuff") or HasBuff(target, "ChronoShift") or HasBuff(target, "chronorevive"))) then
        return true
    end
    return target.isImmortal --or ObjectManager:IsHeroImmortal(target)
end
]]
--

local IsValidTarget = function(unit, range) -- the == false check is faster than using "not"
    return unit and unit.valid and unit.visible and not unit.dead and unit.isTargetableToTeam and
        (not range or GetDistance(unit) <= range) and (not unit.type == myHero.type or not IsHeroImmortal(unit, true))
end

local GetTrueAttackRange = function(unit, target)
    local extra = target and target.boundingRadius or 0
    return unit.range + unit.boundingRadius + extra
end

local HeroesAround = function(range, pos, team)
    pos = pos or myHero.pos
    local dist = GetDistance(pos) + range + 100
    local result = {}
    local heroes = (team == TEAM_ENEMY and GetEnemyHeroes(dist)) or
        (team == TEAM_ALLY and GetAllyHeroes(dist) or GetHeroes(dist))
    for i = 1, #heroes do
        local h = heroes[i]
        if GetDistance(pos, h.pos) <= range then
            result[#result + 1] = h
        end
    end
    return result
end

--[[ local IsMelee = function(unit)
    local IsHeroMelee = DamageLib.MeleeHeros[unit.charName][1]
    return DamageLib:IsMelee(unit) --IsHeroMelee
end
]]

local CountEnemiesAround = function(pos, range)
    return #HeroesAround(range, pos, TEAM_ENEMY)
end

local GetClosestEnemy = function(unit)
    local unit = unit or myHero
    local closest, list = nil, GetHeroes()
    for i = 1, #list do
        local enemy = list[i]
        if IsValidTarget(enemy) and enemy.team ~= unit.team and
            (not closest or GetDistance(enemy, unit) < GetDistance(closest, unit)) then
            closest = enemy
        end
    end
    return closest
end

--[[ local MinionsAround = function(range, pos, team)
    pos = pos or myHero.pos
    local dist = GetDistance(pos) + range + 100
    local result = {}
    local minions = (team == TEAM_ENEMY and GetEnemyMinions(dist)) or (team == TEAM_ALLY and GetAllyMinions(dist) or GetMinions(dist))
    for i = 1, #minions do
        local m = minions[i]
        if m and not m.dead and GetDistance(pos, m.pos) <= range + m.boundingRadius then
            result[#result + 1] = m
        end
    end
    return result
end
]]

local IsUnderTurret = function(pos, team)
    local turrets = GetTurrets(GetDistance(pos) + 1000)
    for i = 1, #turrets do
        local turret = turrets[i]
        if GetDistance(turret, pos) <= 915 and turret.team == team then
            return turret
        end
    end
end

local GetDanger = function(pos)
    local result = 0
    --
    local turret = IsUnderTurret(pos, TEAM_ENEMY)
    if turret then
        result = result + floor((915 - GetDistance(turret, pos)) / 17.3)
    end
    --
    local nearby = HeroesAround(700, pos, TEAM_ENEMY)
    for i = 1, #nearby do
        local enemy = nearby[i]
        local dist, mod = GetDistance(enemy, pos), enemy.range < 350 and 2 or 1
        result = result + (dist <= GetTrueAttackRange(enemy) and 5 or 0) * mod
    end
    --
    result = result + #HeroesAround(400, pos, TEAM_ENEMY) * 1
    return result
end

local IsImmobile = function(unit, delay)
    if unit.ms == 0 then
        return true, unit.pos, unit.pos
    end
    local delay = delay or 0
    local debuff, timeCheck = {}, Timer() + delay
    for i = 1, unit.buffCount do
        local buff = unit:GetBuff(i)
        if buff.expireTime >= timeCheck and buff.duration > 0 then
            debuff[buff.type] = true
        end
    end
    if debuff[_IMMOBILE._STUN] or debuff[_IMMOBILE._TAUNT] or debuff[_IMMOBILE._SNARE] or debuff[_IMMOBILE._Asleep] or
        debuff[_IMMOBILE._CHARM] or debuff[_IMMOBILE._SUPRESS] or debuff[_IMMOBILE._KNOCKUP] or
        debuff[_IMMOBILE._KNOCKBACK] or debuff[_IMMOBILE._FEAR] then
        return true
    end
end

local IsFacing = function(unit, p2)
    p2 = p2 or myHero
    p2 = p2.pos or p2
    local V = unit.pos - p2
    local D = unit.dir
    local Angle = 180 - deg(acos(V * D / (V:Len() * D:Len())))
    if abs(Angle) < 80 then
        return true
    end
end

local CheckHandle = function(tbl, handle)
    for i = 1, #tbl do
        local v = tbl[i]
        if handle == v.handle then
            return v
        end
    end
end

local GetTargetByHandle = function(handle)
    return CheckHandle(GetEnemyHeroes(1200), handle) or
        CheckHandle(GetMonsters(1200), handle) or
        CheckHandle(GetEnemyTurrets(1200), handle) or
        CheckHandle(GetEnemyMinions(1200), handle) or
        CheckHandle(GetEnemyWards(1200), handle)
end
--
local ShouldWait = function()
    return myHero.dead or HasBuff(myHero, "recall") or Game.IsChatOpen() or
        (_G.ExtLibEvade and _G.ExtLibEvade.Evading == true) or (_G.JustEvade and _G.JustEvade:Evading())
end
--------------------------------------
local CastEmote = function(emote)
    if not emote or Emote.Casting or myHero.attackData.state == STATE_WINDUP then
        return
    end
    --
    Emote.Casting = true
    KeyDown(HK_LUS)
    KeyDown(emote)
    DelayAction(function()
        KeyUp(emote)
        KeyUp(HK_LUS)
        Emote.Casting = false
    end, 0.01)
end
--------------------------------------

--# Farm Functions --
local ExcludeFurthest = function(average, lst, sTar)
    local removeID = 1
    for i = 2, #lst do
        if GetDistanceSqr(average, lst[i].pos) > GetDistanceSqr(average, lst[removeID].pos) then
            removeID = i
        end
    end

    local Newlst = {}
    for i = 1, #lst do
        if (sTar and lst[i].networkID == sTar.networkID) or i ~= removeID then
            Newlst[#Newlst + 1] = lst[i]
        end
    end
    return Newlst
end

local GetBestCircularCastPos; --for 'recursion' purposes
GetBestCircularCastPos = function(spell, sTar, lst) --local function GetBestCircularCastPos(spell, sTar, lst)
    local average = { x = 0, z = 0, count = 0 }
    local heroList = lst and lst[1] and (lst[1].type == myHero.type)
    local range = spell.Range or 2000
    local radius = spell.Radius or 50
    if sTar and (not lst or #lst == 0) then
        return Prediction:GetBestCastPosition(sTar, spell), 1
    end
    --
    for i = 1, #lst do
        if IsValidTarget(lst[i], range) then
            local org = heroList and Prediction:GetBestCastPosition(lst[i], spell) or lst[i].pos
            average.x = average.x + org.x
            average.z = average.z + org.z
            average.count = average.count + 1
        end

    end
    --
    if sTar and sTar.type ~= lst[1].type then
        local org = heroList and Prediction:GetBestCastPosition(sTar, spell) or lst[1].pos --or lst[i].pos
        average.x = average.x + org.x
        average.z = average.z + org.z
        average.count = average.count + 1
    end
    --
    average.x = average.x / average.count
    average.z = average.z / average.count
    --
    local inRange = 0
    for i = 1, #lst do
        local bR = lst[i].boundingRadius
        if GetDistanceSqr(average, lst[i].pos) - bR * bR < radius * radius then
            inRange = inRange + 1
        end
    end
    --
    local point = Vector(average.x, myHero.pos.y, average.z)
    --
    if inRange == #lst then
        return point, inRange
    else
        return GetBestCircularCastPos(spell, sTar, ExcludeFurthest(average, lst))
    end
end

local GetBestLinearCastPos = function(spell, sTar, list)
    local startPos = spell.From.pos or myHero.pos
    local isHero = list[1].type == myHero.type
    --
    local center = GetBestCircularCastPos(spell, sTar, list)
    local endPos = startPos + (center - startPos):Normalized() * spell.Range
    local MostHit = isHero and #hCollision(startPos, endPos, spell, list) or #mCollision(startPos, endPos, spell, list)
    return endPos, MostHit
end

local GetBestLinearFarmPos = function(spell)
    local minions = GetEnemyMinions(spell.Range + spell.Radius)
    if #minions == 0 then
        return nil, 0
    end
    return GetBestLinearCastPos(spell, nil, minions)
end

local GetBestCircularFarmPos = function(spell)
    local minions = GetEnemyMinions(spell.Range + spell.Radius)
    if #minions == 0 then
        return nil, 0
    end
    return GetBestCircularCastPos(spell, nil, minions)
end

local CircleCircleIntersection = function(c1, c2, r1, r2)
    local D = GetDistance(c1, c2)
    if D > r1 + r2 or D <= abs(r1 - r2) then
        return nil
    end
    local A = (r1 * r2 - r2 * r1 + D * D) / (2 * D)
    local H = sqrt(r1 * r1 - A * A)
    local Direction = (c2 - c1):Normalized()
    local PA = c1 + A * Direction
    local S1 = PA + H * Direction:Perpendicular()
    local S2 = PA - H * Direction:Perpendicular()
    return S1, S2
end
--------------------------------------

--# Damage calcs --
local Damage = {
    CalcDamage = function(self, source, target, DamageType, amount, IsAA)
        return CalcDamage(source, target, DamageType, amount, IsAA)
    end,

    GetAADamage = function(self, source, target, respectPassives)
        return GetAADamage(source, target, respectPassives)
    end,

    getdmg = function(self, spell, target, source, stage, level)
        return getdmg(spell, target, source, stage, level)
    end,

}

--# Spell --
local HITCHANCE_IMPOSSIBLE = 0
local HITCHANCE_COLLISION = 1
local HITCHANCE_NORMAL = 2
local HITCHANCE_HIGH = 3
local HITCHANCE_IMMOBILE = 4
local HITCHANCE_DASHING = 5
--
local SpellTypePress = "Press" and -2
local SpellTypeTargetted = "Targetted" and -1
local SpellTypeSkillShot = "SkillShot" and "linear" and 0
local SpellTypeAOE = "AOE" and "circular" and 1
local SpellTypeCone = "Cone" and "conic" and 2
--
local COLLISION_MINION = 0
local COLLISION_ALLYHERO = 1
local COLLISION_ENEMYHERO = 2
local COLLISION_YASUOWALL = 3

class "Spell"
--Spell = Class()
--[[Spell = function(SpellData)return{
    Slot = SpellData.Slot,
    Range = SpellData.Range or huge,
    Delay = SpellData.Delay or 0.25,
    Speed = SpellData.Speed or huge,
    Radius = SpellData.Radius or SpellData.Width or 0,
    Width = SpellData.Width or SpellData.Radius or 0,
    From = SpellData.From or myHero,
    Collision = SpellData.Collision or false,
    CollisionTypes = SpellData.CollisionTypes or nil,
    Type = SpellData.Type or SpellTypePress or 0,
    DmgType = SpellData.DmgType or "Physical" or 1,
    __init local= function(self)
        return self
    end
}end
]]

function Spell:__init(SpellData)
    self.Slot = SpellData.Slot
    self.Range = SpellData.Range or huge
    self.Delay = SpellData.Delay or 0.25
    self.Speed = SpellData.Speed or huge
    self.Radius = SpellData.Radius or SpellData.Width or 0
    self.Width = SpellData.Width or SpellData.Radius or 0
    self.From = SpellData.From or myHero
    self.Collision = SpellData.Collision or false
    self.CollisionTypes = SpellData.CollisionTypes or nil
    self.Type = SpellData.Type or SpellTypePress or 0
    self.DmgType = SpellData.DmgType or "Physical" or 1
    --
    return self
end

--
function Spell:IsReady()
    return ggSpell:IsReady(self.Slot)
end

function Spell:CanCast(unit, range, from)
    from = from or self.From.pos
    range = range or self.Range
    return unit and unit.valid and unit.visible and not unit.dead and (not range or GetDistance(from, unit) <= range)
end

--# Farm Stuff
function Spell:GetBestLinearCastPos(sTar, lst)
    return GetBestLinearCastPos(self, sTar, lst)
end

function Spell:GetBestCircularCastPos(sTar, lst)
    return GetBestCircularCastPos(self, sTar, lst)
end

function Spell:GetBestLinearFarmPos()
    return GetBestLinearFarmPos(self)
end

function Spell:GetBestCircularFarmPos()
    return GetBestCircularFarmPos(self)
end

--
function Spell:CalcDamage(target, stage)
    local stage = stage or 1
    local rawDmg = self:GetDamage(target, stage)
    if rawDmg <= 0 then
        return 0
    end
    local damage = rawDmg
    return damage
end

function Spell:GetDamage(target, stage)
    local slot = self:SlotToString()
    return getdmg(slot, target, self.From, stage or 1) -- self:IsReady() or 0 and false --self:IsReady() and getdmg(slot, target, self.From, stage or 1) or 0
end

--
function Spell:SlotToHK()
    return (
        { [_Q] = HK_Q, [_W] = HK_W, [_E] = HK_E, [_R] = HK_R, [SUMMONER_1] = HK_SUMMONER_1, [SUMMONER_2] = HK_SUMMONER_2 }
        )[self.Slot]
end

function Spell:SlotToString()
    return ({ [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R" })[self.Slot]
end

--
function Spell:GetPrediction(target, minHitchance)
    return Prediction:GetBestCastPosition(target, self, minHitchance)
end

function Spell:Cast(castOn)
    if not self:IsReady() or ShouldWait() then
        return
    end
    --
    local slot = self:SlotToHK()
    --print("cast ".." "..tostring(self:SlotToString()).." "..self.Type)

    if self.Type == SpellTypePress then
        KeyDown(slot)
        return KeyUp(slot)
    end
    --
    if castOn == nil then
        return
    end
    --if not _G.WR_PREDICTION_LOADED then return self:CastToPred(castOn) end --breaks AOE non-targeted
    --
    local pos = castOn.x and castOn
    local targ = castOn.health and castOn
    if self.Type == SpellTypeTargetted then
        return Control.CastSpell(slot, castOn)
    end
    if self.Type == SpellTypeAOE and pos then
        local bestPos, hC = self:GetBestCircularCastPos(targ, GetEnemyHeroes(self.Range + self.Radius))
        pos = hC >= HITCHANCE_NORMAL and bestPos or pos
    end
    --
    if (targ and not targ.pos:To2D().onScreen) then
        return
    elseif (pos and not pos:To2D().onScreen) then
        if self.Type == SpellTypeAOE then
            local mapPos = pos:ToMM()
            Control.CastSpell(slot, mapPos.x, mapPos.y)
        else
            pos = myHero.pos:Extended(pos, 200)
            if not pos:To2D().onScreen then
                return
            end
        end
    end
    --
    return Control.CastSpell(slot, targ or pos)
end

function Spell:CastToPred(target, minHitchance)
    if not self:IsReady() or ShouldWait() then
        return
    end
    local slot = self:SlotToHK()
    if self.Type == SpellTypePress then
        KeyDown(slot)
        return KeyUp(slot)
    end
    if target == nil then
        return
    end
    if self.Type == SpellTypeTargetted then
        return Control.CastSpell(slot, target)
    end
    --
    local unitPos, predPos, hC, hit, hitCount, timetoHit, pred = self:GetPrediction(target, minHitchance)
    if _G.WR_PREDICTION_LOADED then
        if predPos and hC >= minHitchance then
            return self:Cast(predPos)
        end
    end
    --
    if self.Type == SpellTypeAOE and pred then
        local bestDistance = self.Radius --or self.Width --or self.Range
        local minTargets = 2 --or clamp(hitCount or 2, 2, 5)
        local maxtimetoHit = 3
        local bestAoe = nil
        local bestCount = 0
        for i = 1, #pred do
            local aoe = pred[i]
            if aoe.HitChance >= minHitchance and aoe.TimeToHit <= maxtimetoHit and aoe.Count >= minTargets then
                if aoe.Count > bestCount or (aoe.Count == bestCount and aoe.Distance < bestDistance) then
                    bestDistance = aoe.Distance
                    bestCount = aoe.Count
                    bestAoe = aoe
                end
            end
        end
        if bestAoe then
            return Control.CastSpell(slot, bestAoe.CastPosition)
        end
    end
    if predPos and hit then
        return Control.CastSpell(slot, predPos)
    end
end

function Spell:OnImmobile(target)
    local TargetImmobile, ImmobilePos, ImmobileCastPosition = Prediction:IsImmobile(target, self)
    if self.Collision then
        local colStatus = #(mCollision(self.From.pos, target, self)) > 0
        if colStatus then
            return
        end
        return TargetImmobile, ImmobilePos, ImmobileCastPosition
    end
    return TargetImmobile, ImmobilePos, ImmobileCastPosition
end

--
function Spell:Draw(r, g, b)
    if not self.DrawColor then
        self.DrawColor = DrawColor(255, r, g, b)
        self.DrawColor2 = DrawColor(80, r, g, b)
    end
    if self.Range and self.Range ~= huge then
        if self:IsReady() then
            DrawCircle(self.From.pos, self.Range, 5, self.DrawColor)
        else
            DrawCircle(self.From.pos, self.Range, 5, self.DrawColor2)
        end
        return true
    end
end

function Spell:DrawMap(r, g, b)
    if not self.DrawColor then
        self.DrawColor = DrawColor(255, r, g, b)
        self.DrawColor2 = DrawColor(80, r, g, b)
    end
    if self.Range and self.Range ~= huge then
        if self:IsReady() then
            DrawMap(self.From.pos, self.Range, 5, self.DrawColor)
        else
            DrawMap(self.From.pos, self.Range, 5, self.DrawColor2)
        end
        return true
    end
end

if prtchat then
    print("[WR] Common Loaded")
end
--------------------------------------

--# Prediction --
class "Prediction"
--Prediction = Class()
--[[local C = function(balance)return{
    balance = balance,
    withdraw = function(self, amount)
        self.balance = self.balance - amount
    end
}end
]]

function Prediction:VectorMovementCollision(startPoint1, endPoint1, v1, startPoint2, v2, delay)
    local sP1x, sP1y, eP1x, eP1y, sP2x, sP2y = startPoint1.x, startPoint1.z, endPoint1.x, endPoint1.z, startPoint2.x,
        startPoint2.z
    local d, e = eP1x - sP1x, eP1y - sP1y
    local dist, t1, t2 = sqrt(d * d + e * e), nil, nil
    local S, K = dist ~= 0 and v1 * d / dist or 0, dist ~= 0 and v1 * e / dist or 0
    local function GetCollisionPoint(t)
        return t and { x = sP1x + S * t, y = sP1y + K * t } or nil
    end

    if delay and delay ~= 0 then
        sP1x, sP1y = sP1x + S * delay, sP1y + K * delay
    end
    local r, j = sP2x - sP1x, sP2y - sP1y
    local c = r * r + j * j
    if dist > 0 then
        if v1 == huge then
            local t = dist / v1
            t1 = v2 * t >= 0 and t or nil
        elseif v2 == huge then
            t1 = 0
        else
            local a, b = S * S + K * K - v2 * v2, -r * S - j * K
            if a == 0 then
                if b == 0 then
                    --c=0->t variable
                    t1 = c == 0 and 0 or nil
                else
                    --2*b*t+c=0
                    local t = -c / (2 * b)
                    t1 = v2 * t >= 0 and t or nil
                end
            else
                --a*t*t+2*b*t+c=0
                local sqr = b * b - a * c
                if sqr >= 0 then
                    local nom = sqrt(sqr)
                    local t = (-nom - b) / a
                    t1 = v2 * t >= 0 and t or nil
                    t = (nom - b) / a
                    t2 = v2 * t >= 0 and t or nil
                end
            end
        end
    elseif dist == 0 then
        t1 = 0
    end
    return t1, GetCollisionPoint(t1), t2, GetCollisionPoint(t2), dist
end

function Prediction:IsDashing(unit, spell)
    local delay, radius, speed, from = spell.Delay, spell.Radius, spell.Speed, spell.From.pos
    local OnDash, CanHit, Pos = false, false, nil
    local pathData = unit.pathing
    --
    if pathData.isDashing then
        local startPos = Vector(pathData.startPos)
        local endPos = Vector(pathData.endPos)
        local dashSpeed = pathData.dashSpeed
        local timer = Timer()
        local startT = timer - Latency() / 2000
        local dashDist = GetDistance(startPos, endPos)
        local endT = startT + (dashDist / dashSpeed)
        --
        if endT >= timer and startPos and endPos then
            OnDash = true
            --
            local t1, p1, t2, p2, dist = self:VectorMovementCollision(startPos, endPos, dashSpeed, from, speed,
                (timer - startT) + delay)
            t1, t2 = (t1 and 0 <= t1 and t1 <= (endT - timer - delay)) and t1 or nil,
                (t2 and 0 <= t2 and t2 <= (endT - timer - delay)) and t2 or nil
            local t = t1 and t2 and min(t1, t2) or t1 or t2
            --
            if t then
                Pos = t == t1 and Vector(p1.x, 0, p1.y) or Vector(p2.x, 0, p2.y)
                CanHit = true
            else
                Pos = Vector(endPos.x, 0, endPos.z)
                CanHit = (unit.ms * (delay + GetDistance(from, Pos) / speed - (endT - timer))) < radius
            end
        end
    end

    return OnDash, CanHit, Pos
end

function Prediction:IsImmobile(unit, spell)
    if unit.ms == 0 then
        return true, unit.pos, unit.pos
    end
    local delay, radius, speed, from = spell.Delay, spell.Radius, spell.Speed, spell.From.pos
    local debuff = {}
    for i = 1, unit.buffCount do
        local buff = unit:GetBuff(i)
        if buff.duration > 0 then
            local ExtraDelay = speed == huge and 0 or (GetDistance(from, unit.pos) / speed)
            if buff.expireTime + (radius / unit.ms) > Timer() + delay + ExtraDelay then
                debuff[buff.type] = true
            end
        end
    end
    if debuff[_IMMOBILE._STUN] or debuff[_IMMOBILE._TAUNT] or debuff[_IMMOBILE._SNARE] or debuff[_IMMOBILE._Asleep] or
        debuff[_IMMOBILE._CHARM] or debuff[_IMMOBILE._SUPRESS] or debuff[_IMMOBILE._KNOCKUP] or
        debuff[_IMMOBILE._KNOCKBACK] or debuff[_IMMOBILE._FEAR] then
        return true, unit.pos, unit.pos
    end
    return false, unit.pos, unit.pos
end

function Prediction:IsSlowed(unit, spell)
    local delay, speed, from = spell.Delay, spell.Speed, spell.From.pos
    for i = 1, unit.buffCount do
        local buff = unit:GetBuff(i)
        if buff.type == _SLOW and buff.expireTime >= Timer() and buff.duration > 0 then
            if buff.expireTime > Timer() + delay + GetDistance(unit.pos, from) / speed then
                return true
            end
        end
    end
    return false
end

function Prediction:CalculateTargetPosition(unit, spell, tempPos)
    local delay, radius, speed, from = spell.Delay, spell.Radius, spell.Speed, spell.From
    local calcPos = nil
    local pathData = unit.pathing
    local pathCount = pathData.pathCount
    local pathIndex = pathData.pathIndex
    local pathEndPos = Vector(pathData.endPos)
    local pathPos = tempPos and tempPos or unit.pos
    local pathPot = (unit.ms * ((GetDistance(pathPos) / speed) + delay))
    local unitBR = unit.boundingRadius
    --
    if pathCount < 2 then
        local extPos = unit.pos:Extended(pathEndPos, pathPot - unitBR)
        --
        if GetDistance(unit.pos, extPos) > 0 then
            if GetDistance(unit.pos, pathEndPos) >= GetDistance(unit.pos, extPos) then
                calcPos = extPos
            else
                calcPos = pathEndPos
            end
        else
            calcPos = pathEndPos
        end
    else
        for i = pathIndex, pathCount do
            if unit:GetPath(i) and unit:GetPath(i - 1) then
                local startPos = i == pathIndex and unit.pos or unit:GetPath(i - 1)
                local endPos = unit:GetPath(i)
                local pathDist = GetDistance(startPos, endPos)
                --
                if unit:GetPath(pathIndex - 1) then
                    if pathPot > pathDist then
                        pathPot = pathPot - pathDist
                    else
                        local extPos = startPos:Extended(endPos, pathPot - unitBR)

                        calcPos = extPos

                        if tempPos then
                            return calcPos, calcPos
                        else
                            return self:CalculateTargetPosition(unit, spell, calcPos)
                        end
                    end
                end
            end
        end
        --
        if GetDistance(unit.pos, pathEndPos) > unitBR then
            calcPos = pathEndPos
        else
            calcPos = unit.pos
        end
    end

    calcPos = calcPos and calcPos or unit.pos

    if tempPos then
        return calcPos, calcPos
    else
        return self:CalculateTargetPosition(unit, spell, calcPos)
    end
end

--[[function Prediction:GetBestCastPosition(unit, spell, minHitchance) --in Prediction:ChangePred
    print("default")
end
]]

function Prediction:ChangePred(newVal)
    if newVal == 1 then
        print("[GGPrediction] Loaded")

        Prediction.GetBestCastPosition = function(self, unit, s, minHitchance)
            if s.Type == SpellTypePress and not SpellTypeAOE then
                return
            end
            local spellData = {
                Delay = s.Delay + (0.07 + Latency() / 1000),
                Radius = s.Radius, --s.Radius == 0 and 1 or (s.Radius + unit.boundingRadius) - 4 --doesn't like this if AOE nontargeted
                Range = s.Range and s.Range - 30 or huge,
                Speed = s.Speed or huge,
                Collision = s.Collision or false,
                CollisionTypes = s.CollisionTypes,
                Type = s.Type,
            }
            --
            local pred = GGPrediction:SpellPrediction(spellData)
            pred:GetPrediction(unit, s.From)
            if s.Type == SpellTypeAOE then
                pred:GetAOEPrediction(s.From)
            end
            --pred
            local unitPos = pred.UnitPosition
            local predPos = pred.CastPosition
            local timetoHit = pred.TimeToHit
            --aoe
            local hitCount = pred.Count
            local preddistance = pred.Distance
            local predUnit = pred.Unit
            local hC = pred.HitChance
            --local timetoHit = pred.TimeToHit
            --local predPos = pred.CastPosition
            local hit = pred:CanHit(minHitchance or HITCHANCE_HIGH)
            if hit then
                --unitPos, predPos = Vector(pred.UnitPosition), Vector(pred.CastPosition)
                --hC = pred.HitChance
                --hitCount = pred.Count
                --timetoHit = pred.TimeToHit
                return unitPos, predPos, hC, hit, hitCount, timetoHit, pred
            end
        end
        PredLoaded = true
    elseif newVal == 2 then
        _G.WR_PREDICTION_LOADED = true
        print("[WR]Prediction Loaded")
        --class "Prediction"
        Prediction.GetBestCastPosition = function(self, unit, spell, minHitchance)
            local range = spell.Range and spell.Range - 30 or huge
            local radius = spell.Radius == 0 and 1 or (spell.Radius + unit.boundingRadius) - 4
            local speed = spell.Speed or huge
            local from = spell.From or myHero
            local delay = spell.Delay + (0.07 + Latency() / 1000)
            local collision = spell.Collision or false
            local collisiontypes = spell.CollisionTypes
            --
            local Position, CastPosition, HitChance = Vector(unit), Vector(unit), nil
            local TargetDashing, CanHitDashing, DashPosition = self:IsDashing(unit, spell)
            local TargetImmobile, ImmobilePos, ImmobileCastPosition = self:IsImmobile(unit, spell)

            if TargetDashing then
                if CanHitDashing then
                    HitChance = HITCHANCE_DASHING
                else
                    HitChance = HITCHANCE_IMPOSSIBLE
                end
                Position, CastPosition = DashPosition, DashPosition
            elseif TargetImmobile then
                Position, CastPosition = ImmobilePos, ImmobileCastPosition
                HitChance = HITCHANCE_IMMOBILE
            else
                Position, CastPosition = self:CalculateTargetPosition(unit, spell)

                if unit.activeSpell and unit.activeSpell.valid then
                    HitChance = HITCHANCE_NORMAL
                end

                if GetDistanceSqr(from.pos, CastPosition) < 250 then
                    HitChance = HITCHANCE_HIGH
                    local newSpell = { Range = range, Delay = delay * 0.5, Radius = radius, Width = radius,
                        Speed = speed * 2, From = from }
                    Position, CastPosition = self:CalculateTargetPosition(unit, newSpell)
                end

                local temp_angle = from.pos:AngleBetween(unit.pos, CastPosition)
                if temp_angle >= 60 then
                    HitChance = HITCHANCE_NORMAL
                elseif temp_angle <= 30 then
                    HitChance = HITCHANCE_HIGH
                end
            end
            if GetDistanceSqr(from.pos, CastPosition) >= range * range then
                HitChance = HITCHANCE_IMPOSSIBLE
            end
            if collision and HitChance > HITCHANCE_COLLISION then
                local newSpell = { Range = range, Delay = delay, Radius = radius * 2, Width = radius * 2,
                    Speed = speed * 2, From = from }
                if #(mCollision(from.pos, CastPosition, newSpell)) > 0 then
                    HitChance = HITCHANCE_COLLISION
                end
            end
            return Position, CastPosition, HitChance
        end
        PredLoaded = true
    elseif newVal == 3 then
        print("[PremiumPrediction] Loaded")

        local HitChance      = {
            Impossible = -2,
            Collision = -1,
            OutOfRange = 0,
            Low = 0,
            Medium = 0.25,
            High = 0.50,
            VeryHigh = 0.75,
            Dashing = 1,
            Immobile = 1,
        }
        HITCHANCE_IMPOSSIBLE = HitChance.Impossible
        HITCHANCE_COLLISION  = HitChance.Collision
        HITCHANCE_NORMAL     = clamp(HitChance.High, 0.50, 0.74) --function(val, valmin, valmax) return min(max(val,  0.50), 0.74) end
        HITCHANCE_HIGH       = clamp(HitChance.VeryHigh, 0.75, 0.99)
        HITCHANCE_IMMOBILE   = HitChance.Immobile
        HITCHANCE_DASHING    = HitChance.Dashing

        COLLISION_MINION = "minion"
        COLLISION_ALLYHERO = "hero" --doesn't have allyhero
        COLLISION_ENEMYHERO = "hero"
        COLLISION_YASUOWALL = "windwall"

        Prediction.GetBestCastPosition = function(self, unit, s, minHitchance)
            if s.Type == SpellTypePress and not SpellTypeAOE then
                return
            end
            local spellData = {
                delay = s.Delay + (0.07 + Latency() / 1000),
                radius = s.Radius, --s.Radius == 0 and 1 or (s.Radius + unit.boundingRadius) - 4, --doesn't like this if AOE nontargeted
                range = s.Range and s.Range - 30 or huge,
                speed = s.Speed or huge,
                collision = s.CollisionTypes,
                type = s.Type,
            }
            --
            local pred = PremiumPrediction:GetPrediction(s.From, unit, spellData)
            if s.Type == SpellTypeAOE then
                pred = PremiumPrediction:GetAOEPrediction(s.From, unit, spellData)
            end
            local unitPos = pred.PredPos
            local predPos = pred.CastPos
            local hC = pred.HitChance
            local hitCount = pred.HitCount
            local timetoHit = pred.TimeToHit
            local hit = _G.PremiumPrediction.HitChance.High(hC) --or minHitchance or
            if hit then
                unitPos, predPos = Vector(pred.PredPos), Vector(pred.CastPos)
                --hC = pred.HitChance
                --hitCount = pred.HitCount
                --timetoHit = pred.TimeToHit
                return unitPos, predPos, hC, hit, hitCount, timetoHit, pred
            end
        end
        PredLoaded = true
    end
end

--------------------------------------
--Bench
--[[ class "Benchmark"
--Benchmark = Class()

TEST lua functions:
function A()end
_G.B = function()end
local function C()end
local D = function()end
local E = function()return{
}end


do
    func_bench:new('func', function()
        A()
    end)
    func_bench:new('_G.func', function()
        B()
    end)
    func_bench:new('local func', function()
        C()
    end)
    func_bench:new('local x = func', function()
        D()
    end)
    func_bench:new('local x = func()return{}', function()
        D()
    end)
end


function Benchmark:runBench()
    if not Menu.Bench.EnableBench:Value() then return end
    local bench = require("Bench")
    local func_bench = bench(144)
    --local hero = myHero.charName
    --print("Running benchmarks")
    --print(loadedCallbacks)
    if not loadedCallbacks then return end

    do
        func_bench:new('GetEnemyHeroes', function()
            GetEnemyHeroes(1500)
        end)

        func_bench:new('GetTarget', function()
            GetTarget(1500)
        end)

        --func_bench:new('GetMode', function()
        --    GetMode()
        --end)
        func_bench:new('ShouldWait', function()
            ShouldWait()
        end)
        --func_bench:new('Tick', function()
        --    --Kalista:Tick()
        --end)
        --func_bench:new('Anim', function()
        --    Animation()
        --end)
        --func_bench:new('Path', function()
        --    Path()
        --end)
        --func_bench:new('Interrupter', function()
        --    Interrupter()
        --end)
        func_bench:new('Spell:IsReady', function()
            Spell:IsReady()
        end)
    end
    func_bench:start()
    --func_bench:start_recursion()
    --print("Finished benchmarks")
end ]]

--
--[[ class "Profiler"
local profile
function Profiler:Start()
    print("[Profiler] Starting")
    profile = require("profile")
    profile.start()
end

function Profiler:Stop()
    if not profile then return end
    profile.stop()
    print("[Profiler] Stopped")
end

function Profiler:Result(x)
    x = x or 10
    if not profile then return end
    print(profile.report(x))
end ]]

--# Menus --
local charName = myHero.charName
local url = "https://raw.githubusercontent.com/Impulsx/LoL-Icons/master/"
local HeroIcon = { url .. charName .. ".png" }
local HeroSprites = {
    url .. charName .. "Q.png",
    url .. charName .. 'W.png',
    url .. charName .. 'E.png',
    url .. charName .. "R.png",
    url .. charName .. "R2.png",
    url .. charName .. "P.png",
}
local icons = {
    Hero = HeroIcon[1],
    Q = HeroSprites[1],
    W = HeroSprites[2],
    E = HeroSprites[3],
    R = HeroSprites[4],
    R2 = HeroSprites[5],
    P = HeroSprites[6],
}
Menu = MenuElement({ id = charName, name = "[WR] | " .. charName, type = MENU, leftIcon = icons.Hero })
Menu:MenuElement({ name = " ", drop = { "Spell Settings" } })
Menu:MenuElement({ id = "Q", name = "Q Settings", type = MENU, leftIcon = icons.Q })
local extendedQsettings = charName == "Lucian" and Menu:MenuElement({ id = "Q2", name = "Q2 Settings", type = MENU, leftIcon = icons.Q, tooltip = "Extended Q Settings" })
Menu:MenuElement({ id = "W", name = "W Settings", type = MENU, leftIcon = icons.W })
Menu:MenuElement({ id = "E", name = "E Settings", type = MENU, leftIcon = icons.E })
Menu:MenuElement({ id = "R", name = "R Settings", type = MENU, leftIcon = icons.R })
-- Draw
Menu:MenuElement({ name = " ", drop = { "Global Settings" } })
Menu:MenuElement({ id = "Draw", name = "Draw Settings", type = MENU })
Menu.Draw:MenuElement({ id = "ON", name = "Enable Drawings", value = true })
Menu.Draw:MenuElement({ id = "TS", name = "Draw Selected Target", value = true, leftIcon = icons.Hero })
Menu.Draw:MenuElement({ id = "Dmg", name = "Draw Damage On HP", value = true, leftIcon = icons.Hero })
local extendedDrawsettings = charName == "Kalista" and Menu.Draw:MenuElement({ id = "drawEdmg", name = "Draw E Damage", value = true, leftIcon = icons.Hero })
Menu.Draw:MenuElement({ id = "Q", name = "Q", value = false, leftIcon = icons.Q })
Menu.Draw:MenuElement({ id = "W", name = "W", value = false, leftIcon = icons.W })
Menu.Draw:MenuElement({ id = "E", name = "E", value = false, leftIcon = icons.E })
Menu.Draw:MenuElement({ id = "R", name = "R", value = false, leftIcon = icons.R })
--[[ Bench
Menu:MenuElement({ id = "Bench", name = "Bench", type = MENU })
Menu.Bench:MenuElement({ id = "EnableBench", name = "Enable for Benchmarks", value = false })
Menu.Bench:MenuElement({ id = "ON", name = "Click for Benchmarks", type = SPACE, onclick = function() Benchmark:runBench() end, })
Menu.Bench:MenuElement({ id = "ON2", name = "Press for Benchmarks", key = 0x70, callback = function() Benchmark:runBench() end, })
]]
--
--[[ Profiler
Menu:MenuElement({ id = "Profiler", name = "Profiler", type = MENU })
Menu.Profiler:MenuElement({ id = "ON", name = "Click for Profiler", value = false, })
Menu.Profiler:MenuElement({ id = "PROF", name = "Press [] to Start Profiler", key = 0x71, callback = function() Profiler:Start() end, })
Menu.Profiler:MenuElement({ id = "STOP", name = "Press [] to stop Profiler", key = 0x72, callback = function() Profiler:Stop() end, })
Menu.Profiler:MenuElement({ id = "TOPX", name = "Top x Profiles", value = 10, min = 1, max = 69, step = 1})
Menu.Profiler:MenuElement({ id = "RESULT", name = "Press [] for Profiles", key = 0x73, callback = function() Profiler:Result(Menu.Bench.TOPX:Value()) end, })
]]
--------------------------------------

--[[ Pred Menu ]]
local CheckPred = function(newVal)
    local pred = ({ "GGPrediction", "[WR]Prediction", "PremiumPrediction", })[newVal]
    if newVal == 1 then
        if not _G.GGPrediction and FileExist(COMMON_PATH .. "GGPrediction.lua") then
            require('GGPrediction')
        end
        if _G.GGPrediction and Prediction.ChangePred then
            print("[ Loading ]: " .. pred)
            return Prediction:ChangePred(newVal)
        end
    elseif newVal == 2 then
        if _G.WR_COMMON_LOADED and (not _G.WR_PREDICTION_LOADED) and Prediction.ChangePred then
            print("[ Loading ]: " .. pred)
            return Prediction:ChangePred(newVal)
        end
    elseif newVal == 3 then
        if not _G.PremiumPrediction and FileExist(COMMON_PATH .. "PremiumPrediction.lua") then
            require('PremiumPrediction')
        end
        if _G.PremiumPrediction and Prediction.ChangePred then
            print("[ Loading ]: " .. pred)
            return Prediction:ChangePred(newVal)
        end
    end
    if PredLoaded then
        --local pred = ({ "GGPrediction", "[WR]Prediction", "PremiumPrediction", })[newVal]
        print("[ Prediction Loaded ]: " .. pred)
    end
end
Menu:MenuElement({ id = "Pred", name = "Choose Pred", value = MENU_PRED, drop = { "GGPrediction", "[WR]Prediction", "PremiumPrediction" }, callback = function(x) MENU_PRED = x; CheckPred(x); end })

if not PredLoaded then
    --DelayAction(function()
    local newVal = Menu.Pred:Value()
    if newVal == 1 then
        --require('GGPrediction')
        CheckPred(newVal)
        --PredLoaded = true
    end
    if newVal == 2 then
        CheckPred(newVal)
        --PredLoaded = true
    end
    if newVal == 3 then
        --require('PremiumPrediction')
        CheckPred(newVal)
        --PredLoaded = true
    end
    --end, 0.1)
end

--# Draw --
local DrawDmg = function(hero, damage)
    local barHeight = 8
    local DmgColor = DrawColor(255, 235, 103, 25)
    local barWidth = 103
    local barXOffset = 18
    local barYOffset = 10
    local screenPos = hero.pos:To2D()
    local barPos = { x = screenPos.x - 50, y = screenPos.y - 150, onScreen = screenPos.onScreen }
    if barPos.onScreen then
        local percentHealthAfterDamage = max(0, hero.health - damage) / hero.maxHealth
        local xPosEnd = barPos.x + barXOffset + barWidth * hero.health / hero.maxHealth
        local xPosStart = barPos.x + barXOffset + percentHealthAfterDamage * 100
        DrawLine(xPosStart, barPos.y + barYOffset, xPosEnd, barPos.y + barYOffset, 10, DmgColor)
    end
end

local DrawSpells = function(instance, extrafn)
    local drawSettings = Menu.Draw
    if drawSettings.ON:Value() then
        local qLambda = drawSettings.Q:Value() and instance.Q and instance.Q:Draw(66, 244, 113)
        local wLambda = drawSettings.W:Value() and instance.W and instance.W:Draw(66, 229, 244)
        local eLambda = drawSettings.E:Value() and instance.E and instance.E:Draw(244, 238, 66)
        local rLambda = drawSettings.R:Value() and instance.R and instance.R:Draw(244, 66, 104)
        local tLambda = drawSettings.TS:Value() and instance.target and
            DrawMark(instance.target.pos, 3, instance.target.boundingRadius, Color.Red)
        if instance.enemies and drawSettings.Dmg:Value() then
            for i = 1, #instance.enemies do
                local enemy = instance.enemies[i]
                local qDmg, wDmg, eDmg, rDmg = instance.Q and instance.Q:CalcDamage(enemy) or 0,
                    instance.W and instance.W:CalcDamage(enemy) or 0, instance.E and instance.E:CalcDamage(enemy) or 0,
                    instance.R and instance.R:CalcDamage(enemy) or 0

                DrawDmg(enemy, qDmg + wDmg + eDmg + rDmg)
                if extrafn then
                    extrafn(enemy)
                end
            end
        end
    end
end
--

if prtchat then
    print("[WR] Prediction Loaded")
end
--------------------------------------

--# BuffExplorer

--------------------------------------

--# Animation
class "Animation"
--Animation = Class()
--[[ local C = function(balance)return{
    balance = balance,
    withdraw = function(self, amount)
        self.balance = self.balance - amount
    end
}end
]]

function Animation:__init()
    if modules then return end

    _G._ANIMATION_STARTED = true
    self.OnAnimationCallback = {}
    Callback.Add("Tick", function()
        self:Tick()
    end)
end

function Animation:Tick()
    if modules then return end
    if self.OnAnimationCallback ~= {} then
        for i = 1, HeroCount() do
            local hero = Hero(i)
            local netID = hero.networkID
            if hero.activeSpellSlot then
                if not _ANIMATION_TABLE[netID] and hero.charName ~= "" then
                    _ANIMATION_TABLE[netID] = { animation = "" }
                end
                local _animation = hero.attackData.animationTime
                if _ANIMATION_TABLE[netID] and _ANIMATION_TABLE[netID].animation ~= _animation then
                    for _, Emit in pairs(self.OnAnimationCallback) do
                        Emit(hero, hero.attackData.animationTime)
                    end
                    _ANIMATION_TABLE[netID].animation = _animation
                end
            end
        end
    end
end

--------------------------------------

--# Vision
class "Vision"
--Vision = Class()

function Vision:__init()
    --if modules then return end
    self.GainVisionCallback = {}
    self.LoseVisionCallback = {}
    _G._VISION_STARTED = true
    Callback.Add("Tick", function()
        self:Tick()
    end)
end

function Vision:Tick()
    --if modules then return end

    local heroCount = HeroCount()
    --if heroCount <= 0 then return end
    for i = 1, heroCount do
        local hero = Hero(i)
        if hero then
            local netID = hero.networkID
            if not _VISION_TABLE[netID] then
                _VISION_TABLE[netID] = { visible = hero.visible }
            end
            if self.LoseVisionCallback ~= {} then
                if hero.visible == false and _VISION_TABLE[netID] and _VISION_TABLE[netID].visible == true then
                    _VISION_TABLE[netID] = { visible = hero.visible }
                    for _, Emit in pairs(self.LoseVisionCallback) do
                        Emit(hero)
                    end
                end
            end
            if self.GainVisionCallback ~= {} then
                if hero.visible == true and _VISION_TABLE[netID] and _VISION_TABLE[netID].visible == false then
                    _VISION_TABLE[netID] = { visible = hero.visible }
                    for _, Emit in pairs(self.GainVisionCallback) do
                        Emit(hero)
                    end
                end
            end
        end
    end
end

--------------------------------------

--# Path
class "Path"
--Path = Class()

function Path:__init()
    if modules then return end

    self.OnNewPathCallback = {}
    self.OnDashCallback = {}
    _G._PATH_STARTED = true
    Callback.Add("Tick", function()
        self:Tick()
    end)
end

function Path:Tick()
    if modules then return end

    if self.OnNewPathCallback ~= {} or self.OnDashCallback ~= {} then
        for i = 1, HeroCount() do
            local hero = Hero(i)
            self:OnPath(hero)
        end
    end
end

function Path:OnPath(unit)
    if modules then return end

    if not _PATH_TABLE[unit.networkID] then
        _PATH_TABLE[unit.networkID] = {
            pos = unit.posTo,
            speed = unit.ms,
            time = Timer()
        }
    end

    if _PATH_TABLE[unit.networkID].pos ~= unit.posTo then
        local path = unit.pathing
        local isDash = path.isDashing
        local dashSpeed = path.dashSpeed
        local dashGravity = path.dashGravity
        local dashDistance = GetDistance(unit.pos, unit.posTo)
        --
        _PATH_TABLE[unit.networkID] = {
            startPos = unit.pos,
            pos = unit.posTo,
            speed = unit.ms,
            time = Timer()
        }
        --
        for k, cb in pairs(self.OnNewPathCallback) do
            cb(unit, unit.pos, unit.posTo, isDash, dashSpeed, dashGravity, dashDistance)
        end
        --
        if isDash then
            for k, cb in pairs(self.OnDashCallback) do
                cb(unit, unit.pos, unit.posTo, dashSpeed, dashGravity, dashDistance)
            end
        end
    end
end

--------------------------------------

--# Interrupter
class "Interrupter"
--Interrupter = Class()

function Interrupter:__init()
    if modules then return end

    _G._INTERRUPTER_START = true
    self.InterruptCallback = {}
    self.spells = { --ty Deftsu
        ["CaitlynAceintheHole"] = { Name = "Caitlyn", displayname = "R | Ace in the Hole", spellname = "CaitlynAceintheHole" },
        ["Crowstorm"] = { Name = "FiddleSticks", displayname = "R | Crowstorm", spellname = "Crowstorm" },
        ["DrainChannel"] = { Name = "FiddleSticks", displayname = "W | Drain", spellname = "DrainChannel" },
        ["GalioIdolOfDurand"] = { Name = "Galio", displayname = "R | Idol of Durand", spellname = "GalioIdolOfDurand" },
        ["ReapTheWhirlwind"] = { Name = "Janna", displayname = "R | Monsoon", spellname = "ReapTheWhirlwind" },
        ["KarthusFallenOne"] = { Name = "Karthus", displayname = "R | Requiem", spellname = "KarthusFallenOne" },
        ["KatarinaR"] = { Name = "Katarina", displayname = "R | Death Lotus", spellname = "KatarinaR" },
        ["LucianR"] = { Name = "Lucian", displayname = "R | The Culling", spellname = "LucianR" },
        ["AlZaharNetherGrasp"] = { Name = "Malzahar", displayname = "R | Nether Grasp", spellname = "AlZaharNetherGrasp" },
        ["Meditate"] = { Name = "MasterYi", displayname = "W | Meditate", spellname = "Meditate" },
        ["MissFortuneBulletTime"] = { Name = "MissFortune", displayname = "R | Bullet Time", spellname = "MissFortuneBulletTime" },
        ["AbsoluteZero"] = { Name = "Nunu", displayname = "R | Absoulte Zero", spellname = "AbsoluteZero" },
        ["PantheonRJump"] = { Name = "Pantheon", displayname = "R | Jump", spellname = "PantheonRJump" },
        ["PantheonRFall"] = { Name = "Pantheon", displayname = "R | Fall", spellname = "PantheonRFall" },
        ["ShenStandUnited"] = { Name = "Shen", displayname = "R | Stand United", spellname = "ShenStandUnited" },
        ["Destiny"] = { Name = "TwistedFate", displayname = "R | Destiny", spellname = "Destiny" },
        ["UrgotSwap2"] = { Name = "Urgot", displayname = "R | Hyper-Kinetic Position Reverser", spellname = "UrgotSwap2" },
        ["VarusQ"] = { Name = "Varus", displayname = "Q | Piercing Arrow", spellname = "VarusQ" },
        ["VelkozR"] = { Name = "Velkoz", displayname = "R | Lifeform Disintegration Ray", spellname = "VelkozR" },
        ["InfiniteDuress"] = { Name = "Warwick", displayname = "R | Infinite Duress", spellname = "InfiniteDuress" },
        ["XerathLocusOfPower2"] = { Name = "Xerath", displayname = "R | Rite of the Arcane", spellname = "XerathLocusOfPower2" },
    }
    Callback.Add("Tick", function()
        self:Tick()
    end)
end

function Interrupter:AddToMenu(unit, menu)
    if modules then return end
    self.menu = menu
    if unit then
        for k, spells in pairs(self.spells) do
            if spells.Name == unit.charName then
                self.menu:MenuElement({ id = spells.spellname, name = spells.Name .. " | " .. spells.displayname,
                    value = true })
            end
        end
    end
end

function Interrupter:Tick()
    if modules then return end

    local enemies = GetEnemyHeroes(3000)
    for i = 1, #(enemies) do
        local enemy = enemies[i]
        if enemy and enemy.activeSpell and enemy.activeSpell.valid then
            local spell = enemy.activeSpell
            if self.spells[spell.name] and self.menu and self.menu[spell.name] and self.menu[spell.name]:Value() and
                spell.isChanneling and spell.castEndTime - Timer() > 0 then
                for i, Emit in pairs(self.InterruptCallback) do
                    Emit(enemy, spell)
                end
            end
        end
    end
end

--------------------------------------

--# Custom Callbacks --
local function OnInterruptable(fn)
    if not _INTERRUPTER_START then
        _G.Interrupter = Interrupter()
        if prtchat then
            print("[WR] Callbacks | OnInterruptable Loaded.")
        end
    end
    insert(Interrupter.InterruptCallback, fn)
end

--[[ local function OnNewPath(fn)
    if not _PATH_STARTED then
        _G.Path = Path()
        if prtchat then
        print("[WR] Callbacks | OnNewPath Loaded.")
        end
    end
    insert(Path.OnNewPathCallback, fn)
end
]]

local function OnDash(fn)
    if not _PATH_STARTED then
        _G.Path = Path()
        if prtchat then
            print("[WR] Callbacks | OnDash Loaded.")
        end
    end
    insert(Path.OnDashCallback, fn)
end

--[[ local function OnGainVision(fn)
    if not _VISION_STARTED then
        _G.Vision = Vision()
        if prtchat then
        print("[WR] Callbacks | OnGainVision Loaded.")
        end
    end
    insert(Vision.GainVisionCallback, fn)
end
]]

local function OnLoseVision(fn)
    if not _VISION_STARTED then
        _G.Vision = Vision()
        if prtchat then
            print("[WR] Callbacks | OnLoseVision Loaded.")
        end
    end
    insert(Vision.LoseVisionCallback, fn)
end

--[[ local function OnAnimation(fn)
    if not _ANIMATION_STARTED then
        _G.Animation = Animation()
        if prtchat then
        print("[WR] Callbacks | OnAnimation Loaded.")
    end
    end
    insert(Animation.OnAnimationCallback, fn)
end
]]

--[[ -- BuffManager callbacks
local function OnUpdateBuff(cb)
    if not _BuffExplorer_STARTED then
        _G.BuffExplorer = BuffExplorer()
        if prtchat then
        print("[WR] Callbacks | OnUpdateBuff Loaded.")
        end
    end
    insert(BuffExplorer.UpdateBuffCallback, cb)
end

local function OnRemoveBuff(cb)
    if not _BuffExplorer_STARTED then
        _G.BuffExplorer = BuffExplorer()
        if prtchat then
        print("[WR] Callbacks | OnRemoveBuff Loaded.")
        end
    end
    insert(BuffExplorer.RemoveBuffCallback, cb)
end
]]
--------------------------------------

--# Champ Scripts --

if myHero.charName == "Ashe" then

    class 'Ashe'
    --Ashe = Class()

    function Ashe:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttackTick(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnLoseVision(function(unit)
            self:OnLoseVision(unit)
        end)
        OnInterruptable(function(unit, spell)
            self:OnInterruptable(unit, spell)
        end)
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Ashe:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = GetTrueAttackRange(myHero),
            Delay = 0.85,
            Speed = huge,
            Radius = 0,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.W = Spell({
            Slot = 1,
            Range = 1200,
            Delay = 0.25,
            Speed = 1500,
            Radius = 100,
            Collision = true,
            CollisionTypes = { COLLISION_MINION, COLLISION_ENEMYHERO, COLLISION_YASUOWALL },
            From = myHero,
            Type = SpellTypeCone
        })
        self.E = Spell({
            Slot = 2,
            Range = huge,
            Delay = 0.25,
            Speed = 1400,
            Width = 10,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
        self.R = Spell({
            Slot = 3,
            Range = huge,
            Delay = 0.25,
            Speed = 1600,
            Width = 260,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.Q.LastReset = Timer()
    end

    function Ashe:Menu()
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.Q:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.Q:MenuElement({ id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 6, step = 1 })
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "Auto", name = "Auto AA Reset Mode", value = 2,
            drop = { "Heroes Only", "Heroes + Jungle", "Always", "Never" } })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.W:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Duel", name = "Use On Duel", value = true })
        Menu.R:MenuElement({ id = "Heroes", name = "Duel Targets", type = MENU })
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana %", value = 0, min = 0, max = 100, step = 1 })
        Menu.R:MenuElement({ name = " ", drop = { "Automatic Usage" } })
        Menu.R:MenuElement({ id = "Gapcloser", name = "Auto Use On Gapcloser", value = true })
        Menu.R:MenuElement({ id = "Hit", name = "Use When X Enemies Hit", type = MENU })
        Menu.R.Hit:MenuElement({ id = "Enabled", name = "Enabled", value = false })
        Menu.R.Hit:MenuElement({ id = "Min", name = "Number Of Enemies", value = 3, min = 1, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "Interrupter", name = "Use To Interrupt", value = false })
        Menu.R:MenuElement({ id = "Interrupt", name = "Interrupt Targets", type = MENU })
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        ObjectManager:OnEnemyHeroLoad(function(args)
            local hero = args.unit
            Interrupter:AddToMenu(hero, Menu.R.Interrupt)
            Menu.R.Heroes:MenuElement({ id = args.charName, name = args.charName, value = false })
        end)
    end

    function Ashe:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.W.Range)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.lastTarget = self.target or self.lastTarget
        self.mode = GetMode()
        --
        self:ResetAA()
        if myHero.isChanneling then
            return
        end
        self:Auto()
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 6 and self:Flee()
    end

    function Ashe:ResetAA()
        if Timer() > self.Q.LastReset + 5 and HasBuff(myHero, "AsheQAttack") then
            ResetAutoAttack()
            self.Q.LastReset = Timer()
        end
    end

    function Ashe:OnPreMovement(args)
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Ashe:OnPreAttack(args)
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Ashe:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        if ShouldWait() or not IsValidTarget(target) then
            return
        end
        self.target = target
        --
        local tType = target.type
        local mode = Menu.Q.Auto:Value()
        --
        if self.Q:IsReady() then
            local qCombo, qHarass = self.mode == 1 and Menu.Q.Combo:Value() and
                ManaPercent(myHero) >= Menu.Q.Mana:Value(),
                not qCombo and self.mode == 2 and Menu.Q.Harass:Value() and
                ManaPercent(myHero) >= Menu.Q.ManaHarass:Value()
            local qClear = not (qCombo or qHarass) and
                ((self.mode == 3 and Menu.Q.Clear:Value()) or self.mode == 4 and Menu.Q.Jungle:Value()) and
                ManaPercent(myHero) >= Menu.Q.ManaClear:Value() and #GetEnemyMinions(500) >= Menu.Q.Min:Value()
            if qClear or mode == 3 or (tType == Obj_AI_Hero and (mode ~= 4 or qCombo or qHarass)) or
                (mode == 2 and tType == Obj_AI_Minion and target.team == 300) or (tType == Obj_AI_Turret and mode ~= 4) then
                self.Q:Cast()
            end
        end
        if self.W:IsReady() and not HasBuff(myHero, "AsheQAttack") and tType == Obj_AI_Hero then
            local wCombo, wHarass = self.mode == 1 and Menu.W.Combo:Value() and
                ManaPercent(myHero) >= Menu.W.Mana:Value(),
                not wCombo and self.mode == 2 and Menu.W.Harass:Value() and
                ManaPercent(myHero) >= Menu.W.ManaHarass:Value()
            if wCombo or wHarass then
                self.W:CastToPred(target, HITCHANCE_NORMAL)
            end
        end
    end

    function Ashe:OnLoseVision(unit)
        if self.E:IsReady() and self.lastTarget and unit.valid and not unit.dead and
            unit.networkID == self.lastTarget.networkID then
            if (Menu.E.Combo:Value() and self.mode == 1 and ManaPercent(myHero) >= Menu.E.Mana:Value()) or
                (Menu.E.Harass:Value() and self.mode == 2 and ManaPercent(myHero) >= Menu.E.ManaHarass:Value()) then
                self.E:Cast(unit.pos)
            end
        end
    end

    function Ashe:OnInterruptable(unit, spell)
        if ShouldWait() or not (Menu.R.Interrupter:Value() and self.R:IsReady()) then
            return
        end
        if Menu.R.Interrupt[spell.name]:Value() and IsValidTarget(enemy, 1500) then
            self.R:CastToPred(unit, HITCHANCE_NORMAL)
        end
    end

    function Ashe:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() or not (Menu.R.Gapcloser:Value() and self.R:IsReady()) then
            return
        end
        --
        if IsValidTarget(unit, 600) and unit.team == TEAM_ENEMY and IsFacing(unit, myHero) then
            --Gapcloser
            self.R:CastToPred(unit, HITCHANCE_DASHING) --was 3
        end
    end

    function Ashe:Auto()
        if not self.enemies then
            return
        end
        --
        local minHit = Menu.R.Hit.Min:Value()
        if Menu.R.Hit.Enabled:Value() and #self.enemies >= minHit and self.R:IsReady() then
            local targ, count1 = nil, 0
            for i = 1, #(self.enemies) do
                local enemy = self.enemies[i]
                targ, count1 = enemy, 1
                local count2 = CountEnemiesAround(enemy.pos, 175)
                if count2 > count1 then
                    targ = enemy
                    count1 = count2
                end
            end
            if targ and count1 >= minHit then
                self.R:CastToPred(targ, HITCHANCE_NORMAL)
            end
        end
    end

    function Ashe:Combo()
        local wTarget = GetTarget(self.W.Range, 0)
        local rTarget = self.lastTarget
        --
        if wTarget and GetDistance(wTarget) > GetTrueAttackRange(myHero) and Menu.W.Combo:Value() and self.W:IsReady()
            and ManaPercent(myHero) >= Menu.W.Mana:Value() then
            self.W:CastToPred(wTarget, 2)
        end
        if Menu.R.Duel:Value() and self.R:IsReady() and IsValidTarget(rTarget, 1500) and
            Menu.R.Heroes[rTarget.charName]:Value() and ManaPercent(myHero) >= Menu.R.Mana:Value() then
            if rTarget.health >= 200 and
                (
                self.R:GetDamage(rTarget) * 4 > GetHealthPrediction(rTarget, GetDistance(rTarget) / self.R.Speed) or
                    HealthPercent(myHero) <= 40) then
                self.R:CastToPred(rTarget, HITCHANCE_NORMAL)
            end
        end
    end

    function Ashe:Harass()
        local wTarget = GetTarget(self.W.Range, 0)
        --
        if wTarget and GetDistance(wTarget) > GetTrueAttackRange(myHero) and Menu.W.Harass:Value() and self.W:IsReady()
            and ManaPercent(myHero) >= Menu.W.ManaHarass:Value() then
            self.W:CastToPred(wTarget, HITCHANCE_NORMAL)
        end
    end

    function Ashe:Flee()
        if self.enemies and Menu.W.Flee:Value() and self.W:IsReady() then
            for i = 1, #self.enemies do
                local wTarget = self.enemies[i]
                if IsValidTarget(wTarget, 700) then
                    if self.W:CastToPred(wTarget, HITCHANCE_NORMAL) then
                        break
                    end
                end
            end
        end
    end

    function Ashe:KillSteal()
        if self.enemies and Menu.W.KS:Value() and self.W:IsReady() then
            for i = 1, #self.enemies do
                local wTarget = self.enemies[i]
                if IsValidTarget(wTarget) then
                    local dmg, health = self.W:GetDamage(wTarget), wTarget.health
                    if health >= 100 and dmg >= health then
                        if self.W:CastToPred(wTarget, 1) then
                            break
                        end
                    end
                end
            end
        end
    end

    function Ashe:OnDraw()
        DrawSpells(self)
    end

    insert(LoadCallbacks, function()
        Ashe()
    end)

elseif myHero.charName == "Blitzcrank" then

    class 'Blitzcrank'
    --Blitzcrank = Class()

    function Blitzcrank:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnInterruptable(function(unit, spell)
            self:OnInterruptable(unit, spell)
        end)
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Blitzcrank:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 1150,
            Delay = 0.25,
            Speed = 1750,
            Radius = 60,
            Collision = true,
            CollisionTypes = { COLLISION_MINION, COLLISION_ENEMYHERO, COLLISION_YASUOWALL },
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.W = Spell({
            Slot = 1,
            From = myHero,
            Type = SpellTypePress
        })
        self.E = Spell({
            Slot = 2,
            Range = GetTrueAttackRange(myHero),
            From = myHero,
            Type = SpellTypePress
        })
        self.R = Spell({
            Slot = 3,
            Range = 600,
            Delay = 0.25,
            Speed = huge,
            Radius = 600,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
    end

    function Blitzcrank:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Blacklist", name = "Blacklist", type = MENU })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "MinRange", name = "Min Range", value = 250, min = 0, max = 950, step = 10 })
        Menu.Q:MenuElement({ id = "MaxRange", name = "Max Range", value = 950, min = 0, max = 950, step = 10 })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "BlacklistHarass", name = "Blacklist", type = MENU })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "MinRangeHarass", name = "Min Range", value = 250, min = 0, max = 950, step = 10 })
        Menu.Q:MenuElement({ id = "MaxRangeHarass", name = "Max Range", value = 950, min = 0, max = 950, step = 10 })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "Interrupt", name = "Auto Use To Interrupt", value = true })
        Menu.Q:MenuElement({ id = "InterruptList", name = "Whitelist", type = MENU })
        Menu.Q:MenuElement({ id = "Gapcloser", name = "Auto Use On Dash", value = true })
        Menu.Q:MenuElement({ id = "GapList", name = "Whitelist", type = MENU })
        Menu.Q:MenuElement({ id = "Auto", name = "Auto Use On Immobile", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.R:MenuElement({ id = "Heroes", name = "Combo Targets", type = MENU })
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana %", value = 0, min = 0, max = 100, step = 1 })
        Menu.R:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.R:MenuElement({ id = "Count", name = "Auto Use When X Enemies", value = 3, min = 0, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "KS", name = "Use To KS", value = true })
        Menu.R:MenuElement({ id = "Interrupt", name = "Auto Use To Interrupt", value = true })
        Menu.R:MenuElement({ id = "InterruptList", name = "Whitelist", type = MENU })

        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })

        ObjectManager:OnEnemyHeroLoad(function(args)
            local hero = args.unit
            local charName = args.charName
            local priority = GetPriority(hero)
            Interrupter:AddToMenu(hero, Menu.Q.InterruptList)
            Interrupter:AddToMenu(hero, Menu.R.InterruptList)
            Menu.Q.GapList:MenuElement({ id = charName, name = charName, value = false })
            Menu.Q.Blacklist:MenuElement({ id = charName, name = charName, value = priority <= 2 })
            Menu.Q.BlacklistHarass:MenuElement({ id = charName, name = charName, value = priority <= 3 })
            Menu.R.Heroes:MenuElement({ id = charName, name = charName, value = priority >= 3 })
        end)
    end

    function Blitzcrank:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.Q.Range)
        self.target = GetTarget(self.Q.Range, 1)
        self.mode = GetMode()
        --
        self:Auto()
        self:KillSteal()
        --
        if not (self.mode and self.target) then
            return
        end
        local executeMode = self.mode == 1 and self:Combo(self.target) or
            self.mode == 2 and self:Harass(self.target) or
            self.mode == 6 and self:Flee()
    end

    function Blitzcrank:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Blitzcrank:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Blitzcrank:OnInterruptable(unit, spell)
        if unit.team ~= TEAM_ENEMY or ShouldWait() or not IsValidTarget(unit, self.Q.Range) then
            return
        end
        if Menu.R.InterruptList[spell.name]:Value() and GetDistace(unit) <= self.R.Range and self.R:IsReady() then
            self.R:Cast()
        elseif Menu.Q.InterruptList[spell.name]:Value() and self.Q:IsReady() then
            self.Q:CastToPred(unit, HITCHANCE_NORMAL)
        end
    end

    function Blitzcrank:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if unit.team ~= TEAM_ENEMY or ShouldWait() or not IsValidTarget(unit, self.Q.Range) then
            return
        end
        if Menu.Q.GapList[unit.charName]:Value() and self.Q:IsReady() then
            self.Q:CastToPred(unit, HITCHANCE_DASHING)
        end
    end

    function Blitzcrank:Auto()
        local minCount = Menu.R.Count:Value()
        if self.R:IsReady() and minCount ~= 0 and #GetEnemyHeroes(self.R.Range) >= minCount then
            self.R:Cast()
            return
        end
        --
        local qCheck, rCheck = self.Q:IsReady() and Menu.Q.Auto:Value(),
            self.R:IsReady() and Menu.R.Combo:Value() and ManaPercent(myHero) >= Menu.R.Mana:Value()
        if qCheck or rCheck then
            for i = 1, #self.enemies do
                local enemy = self.enemies[i]
                if qCheck and IsImmobile(enemy, 0.5) then
                    self.Q:Cast(enemy)
                elseif self.mode == 1 and rCheck and GetDistance(enemy) <= 500 and myHero:GetSpellData(_E).currentCd > 0
                    and Menu.R.Heroes[enemy.charName]:Value() then
                    self.R:Cast()
                end
            end
        end
    end

    function Blitzcrank:Combo(target)
        local dist = GetDistance(target)
        if self.Q:IsReady() and dist >= Menu.Q.MinRange:Value() and dist <= Menu.Q.MaxRange:Value() and
            Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() and
            not Menu.Q.Blacklist[target.charName]:Value() then
            if self.Q:CastToPred(target, HITCHANCE_NORMAL) then
                return
            end
        end
        if self.E:IsReady() and Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value() then
            self.E.Range = (myHero.range + target.boundingRadius + myHero.boundingRadius)
            if self:IsBeingGrabbed(target) or dist <= self.E.Range then
                self.E:Cast()
                ResetAutoAttack()
                return
            end
        end
    end

    function Blitzcrank:Harass(target)
        local dist = GetDistance(target)
        if self.Q:IsReady() and dist >= Menu.Q.MinRangeHarass:Value() and dist <= Menu.Q.MaxRangeHarass:Value() and
            Menu.Q.Harass:Value() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() and
            not Menu.Q.BlacklistHarass[target.charName]:Value() then
            if self.Q:CastToPred(target, HITCHANCE_NORMAL) then
                return
            end
        end
        if self.E:IsReady() and Menu.E.Harass:Value() and ManaPercent(myHero) >= Menu.E.ManaHarass:Value() then
            self.E.Range = (myHero.range + target.boundingRadius + myHero.boundingRadius)
            if self:IsBeingGrabbed(target) or dist <= self.E.Range then
                self.E:Cast()
                ResetAutoAttack()
            end
        end
    end

    function Blitzcrank:Flee()
        if self.W:IsReady() then
            self.W:Cast()
        end
    end

    function Blitzcrank:KillSteal()
        if Menu.R.KS:Value() and self.R:IsReady() then
            for i = 1, #self.enemies do
                local targ = self.enemies[i]
                if GetDistance(targ) <= self.R.Range and self.R:GetDamage(targ) >= targ.health + targ.shieldAP then
                    self.R:Cast()
                end
            end
        end
    end

    function Blitzcrank:OnDraw()
        DrawSpells(self)
    end

    function Blitzcrank:IsBeingGrabbed(unit)
        return HasBuff(unit, "rocketgrab2")
    end

    insert(LoadCallbacks, function()
        Blitzcrank()
    end)

elseif myHero.charName == "Corki" then

    class 'Corki'

    function Corki:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttack(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Corki:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 825,
            Delay = 0.25,
            Speed = 1000,
            Radius = 250,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
        self.W = Spell({
            Slot = 1,
            Range = 600,
            Delay = 0.3,
            Speed = 650 + myHero.ms,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.E = Spell({
            Slot = 2,
            Range = 600,
            Delay = 0.3,
            Speed = huge,
            Radius = 80,
            Collision = false,
            From = myHero,
            Type = SpellTypeCone --SpellTypePress
        })
        self.R = Spell({
            Slot = 3,
            Range = 1300,
            Delay = 0.25,
            Speed = 2000,
            Radius = 50,
            Collision = true,
            CollisionTypes = { COLLISION_MINION, COLLISION_ENEMYHERO, COLLISION_YASUOWALL },
            From = myHero,
            Type = SpellTypeSkillShot
        })
    end

    function Corki:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.Q:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.Q:MenuElement({ id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 6, step = 1 })
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.Q:MenuElement({ id = "Auto", name = "Auto Use on Immobile", value = false })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "Gapcloser", name = "Anti Gapcloser W", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 20, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 20, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.E:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.E:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.E:MenuElement({ id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 6, step = 1 })
        Menu.E:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 20, min = 0, max = 100, step = 1 })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Combo", name = "Use in Combo", value = true })
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.R:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.R:MenuElement({ id = "Harass", name = "Use in Harass", value = false })
        Menu.R:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.R:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.R:MenuElement({ id = "Jungle", name = "Use in JungleClear", value = false })
        Menu.R:MenuElement({ id = "LastHit", name = "Use in LastHit", value = false })
        Menu.R:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.R:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.R:MenuElement({ id = "KS", name = "Use in KS", value = true })
        Menu.R:MenuElement({ id = "Auto", name = "Auto Use on Immobile", value = true })
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
    end

    function Corki:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.R.Range)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.mode = GetMode()
        --
        if myHero.isChanneling then
            return
        end
        self:Auto()
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 3 and self:Clear() or
            self.mode == 5 and self:LastHit()
    end

    function Corki:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Corki:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Corki:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        if ShouldWait() or not IsValidTarget(target) then
            return
        end
        self.target = target
        --
        local tType = target.type
        if tType == Obj_AI_Hero then
            if self.Q:IsReady() and
                (
                (self.mode == 1 and Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value()) or
                    (self.mode == 2 and Menu.Q.Harass:Value() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value())) then
                self.Q:CastToPred(target, HITCHANCE_NORMAL)
            end
            if self.E:IsReady() and
                (
                (self.mode == 1 and Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value()) or
                    (self.mode == 2 and Menu.E.Harass:Value() and ManaPercent(myHero) >= Menu.E.ManaHarass:Value())) then
                self.E:Cast()
            end
        elseif (tType == Obj_AI_Minion and target.team == 300 and (self.mode == 4 or self.mode == 3)) then
            self:JungleClear(target)
        end
    end

    function Corki:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if self:HasPackage() or ShouldWait() then
            return
        end
        if IsValidTarget(unit) and GetDistance(unitPosTo) < 500 and unit.team == TEAM_ENEMY and IsFacing(unit, myHero) then
            local posTo = myHero.pos:Extended(unitPosTo, -self.W.Range)
            if not self:IsDangerousPosition(posTo) then
                self.W:Cast(posTo)
            end
        end
    end

    function Corki:Auto()
        local checkQ, checkR = Menu.Q.Auto:Value(), Menu.R.Auto:Value()
        if not (checkQ or checkR) then
            return
        end
        --
        for i = 1, #(self.enemies) do
            local enemy = self.enemies[i]
            if IsImmobile(enemy) then
                local health = enemy.health
                if self.Q:IsReady() and checkQ then
                    self.Q:CastToPred(enemy, HITCHANCE_IMMOBILE)
                elseif self.R:IsReady() and checkR then
                    self.R:CastToPred(enemy, HITCHANCE_IMMOBILE)
                end
            end
        end
    end

    function Corki:Combo()
        local target = GetTarget(self.R.Range, 0)
        if not target then
            return
        end
        --
        if self.R:IsReady() and Menu.R.Combo:Value() and ManaPercent(myHero) >= Menu.R.Mana:Value() then
            self.R:CastToPred(target, HITCHANCE_NORMAL)
        elseif self.Q:IsReady() and Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            self.Q:CastToPred(target, HITCHANCE_NORMAL)
        end
    end

    function Corki:Harass()
        local target = GetTarget(self.R.Range, 0)
        if not target then
            return
        end
        --
        if self.R:IsReady() and Menu.R.Harass:Value() and ManaPercent(myHero) >= Menu.R.ManaHarass:Value() then
            self.R:CastToPred(target, HITCHANCE_NORMAL)
        elseif self.Q:IsReady() and Menu.Q.Harass:Value() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() then
            self.Q:CastToPred(target, HITCHANCE_NORMAL)
        end
    end

    function Corki:JungleClear(target)
        if self.R:IsReady() and Menu.R.Jungle:Value() and ManaPercent(myHero) >= Menu.R.ManaClear:Value() then
            self.R:Cast(target.pos)
        elseif self.Q:IsReady() and Menu.Q.Jungle:Value() and ManaPercent(myHero) >= Menu.Q.ManaClear:Value() then
            self.Q:Cast(target.pos)
        elseif self.E:IsReady() and Menu.E.Jungle:Value() and ManaPercent(myHero) >= Menu.E.ManaClear:Value() then
            self.E:Cast()
        end
    end

    function Corki:Clear()
        if self.Q:IsReady() and Menu.Q.Clear:Value() and ManaPercent(myHero) >= Menu.Q.ManaClear:Value() then
            local bestPos, count = self.Q:GetBestCircularFarmPos()
            if bestPos and count >= Menu.Q.Min:Value() then
                self.Q:Cast(bestPos)
            end
        end
        --
        if self.E:IsReady() and Menu.E.Clear:Value() and ManaPercent(myHero) >= Menu.E.ManaClear:Value() then
            if #(GetEnemyMinions(self.E.Range)) >= Menu.E.Min:Value() then
                self.E:Cast()
            end
        end
    end

    function Corki:LastHit()
        if self.R:IsReady() and Menu.R.LastHit:Value() and ManaPercent(myHero) >= Menu.R.ManaClear:Value() then
            local minions = GetEnemyMinions(self.R.Range)
            if #minions == 0 then
                return
            end
            --
            local check1, range = myHero.attackData.state == STATE_WINDDOWN, GetTrueAttackRange(myHero)
            for i = 1, #minions do
                local minion = minions[i]
                if self:GetMissileDamage(minion) >= minion.health and (check1 or minion.distance > range) and
                    #mCollision(myHero.pos, minion.pos, self.R, minions) == 0 and
                    GetHealthPrediction(minion, GetDistance(minion) / self.R.Speed) > 50 then
                    self.R:Cast(minion.pos)
                    return
                end
            end
        end
    end

    function Corki:KillSteal()
        for i = 1, #(self.enemies) do
            local enemy = self.enemies[i]
            local health = enemy.health
            if self.R:IsReady() and Menu.R.KS:Value() and health >= 100 and self:GetMissileDamage(enemy) >= health then
                self.R:CastToPred(enemy, HITCHANCE_NORMAL)
            elseif self.Q:IsReady() and Menu.Q.KS:Value() and IsValidTarget(enemy, self.Q.Range) and
                self.Q:GetDamage(enemy) >= health then
                self.Q:CastToPred(enemy, HITCHANCE_NORMAL)
            end
        end
    end

    function Corki:OnDraw()
        DrawSpells(self)
    end

    function Corki:IsDangerousPosition(pos)
        if IsUnderTurret(pos, TEAM_ENEMY) then
            return true
        end
        for i = 1, HeroCount() do
            local hero = Hero(i)
            if IsValidTarget(hero) and GetTrueAttackRange(hero) < 400 and hero.pos:DistanceTo(pos) < 350 then
                return true
            end
        end
    end

    function Corki:HasPackage()
        return HasBuff(myHero, "corkiloaded")
    end

    function Corki:HasBigOne()
        return HasBuff(myHero, "mbcheck2")
    end

    function Corki:GetMissileDamage(unit)
        return self:HasBigOne() and self.R:GetDamage(unit, 2) or self.R:GetDamage(unit)
    end

    insert(LoadCallbacks, function()
        Corki()
    end)

elseif myHero.charName == "Darius" then

    class 'Darius'
    --Darius = Class()

    function Darius:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        --Callback.Add("Load",          function() self:OnLoad()    end) --Just Use OnLoad()
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttack(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnInterruptable(function(unit, spell)
            self:OnInterruptable(unit, spell)
        end)
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Darius:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 460,
            Delay = 0.75,
            Speed = huge,
            Radius = 240,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.W = Spell({
            Slot = 1,
            Range = 300,
            Delay = 0.25,
            Speed = 1450,
            Radius = huge,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.E = Spell({
            Slot = 2,
            Range = 535,
            Delay = 0.3,
            Speed = huge,
            Radius = huge,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
        self.R = Spell({
            Slot = 3,
            Range = 475,
            Delay = 0.3667,
            Speed = huge,
            Radius = huge,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted,
            DmgType = "True"
        })
        self.W.LastReset = 0
        self.W.LastCast = 0
        --
        --[[         self.R.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local rLvl = myHero:GetSpellData(_R).level
            --
            return (100 * rLvl + 0.75 * myHero.bonusDamage)
        end ]]
    end

    function Darius:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "Auto", name = "Positioning Helper", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Combo Mode", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Harass Mode", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Combo Mode", value = true })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "Auto", name = "Auto Use on Escaping Enemies", value = true })
        Menu.E:MenuElement({ id = "Interrupt", name = "Interrupt Targets", type = MENU })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana %", value = 0, min = 0, max = 100, step = 1 })
        Menu.R:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.R:MenuElement({ id = "Auto", name = "Auto Use on Killable", value = true })
        Menu.R:MenuElement({ id = "Tweak", name = "Damage Mod +[%]", value = 0, min = -50, max = 50, step = 5 })
        --Items--
        Menu:MenuElement({ id = "Items", name = "Items Settings", type = MENU })
        Menu.Items:MenuElement({ id = "Tiamat", name = "Use Tiamat", value = true })
        Menu.Items:MenuElement({ id = "TitanicHydra", name = "Use Titanic Hydra", value = true })
        Menu.Items:MenuElement({ id = "Hydra", name = "Use Ravenous Hydra", value = true })
        Menu.Items:MenuElement({ id = "Youmuu", name = "Use Youmuu's", value = true })
        --Misc--
        Menu.Draw:MenuElement({ id = "Helper", name = "Draw Q Helper Pos", value = true, leftIcon = icons.WR })
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
        ObjectManager:OnEnemyHeroLoad(function(args)
            Interrupter:AddToMenu(args.unit, Menu.E.Interrupt)
        end)
    end

    function Darius:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(500)
        self.target = GetTarget(self.Q.Range, 0)
        self.mode = GetMode()
        --
        self:UpdateItems()
        self:ResetAA()
        if myHero.isChanneling then
            return
        end
        self:Auto()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass()
    end

    function Darius:ResetAA()
        if Timer() > self.W.LastReset + 1 and HasBuff(myHero, "DariusNoxianTacticsONH") then
            ResetAutoAttack()
            self.W.LastReset = Timer()
        end
    end

    function Darius:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
        --Q Helper logic
        if self.moveTo then
            if GetDistance(self.moveTo) < 20 then
                args.Process = false
            elseif not MapPosition:inWall(self.moveTo) then
                args.Target = self.moveTo
            end
        end
    end

    function Darius:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Darius:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        if ShouldWait() or not IsValidTarget(target) then
            return
        end
        if target.type == Obj_AI_Hero then
            if self.W:IsReady() and
                ((self.mode == 1 and Menu.W.Combo:Value()) or (self.mode == 2 and Menu.W.Harass:Value())) and
                ManaPercent(myHero) >= Menu.W.Mana:Value() then
                self.W:Cast()
                self.W.LastCast = Timer()
            elseif self.mode == 1 then
                self:UseItems(target)
            end
        end
    end

    function Darius:OnInterruptable(unit, spell)
        if ShouldWait() then
            return
        end
        if Menu.E.Interrupt[spell.name]:Value() and IsValidTarget(enemy, self.E.Range) and self.E:IsReady() then
            self.E:Cast(unit)
        end
    end

    function Darius:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() then
            return
        end
        if Menu.E.Auto:Value() and IsValidTarget(unit, self.E.Range) and GetDistance(unitPosTo) > 300 and
            unit.team == TEAM_ENEMY and not IsFacing(unit, myHero) then
            self.E:CastToPred(unit, HITCHANCE_DASHING)
        end
    end

    function Darius:Auto()
        if self.enemies and (Menu.R.Auto:Value() or (Menu.R.Combo:Value() and self.mode == 1)) and self.R:IsReady() then
            for i = 1, #(self.enemies) do
                local enemy = self.enemies[i]
                if self.R:CalcDamage(enemy) * self:GetUltMultiplier(enemy) >= enemy.health + enemy.shieldAD then
                    self.R:Cast(enemy)
                    break
                end
            end
        end
    end

    function Darius:Combo()
        for i = 1, #(self.enemies) do
            local enemy = self.enemies[i]
            self:Youmuu(enemy)
            local distance = GetDistance(enemy)
            if self.E:IsReady() and Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value() and
                distance >= 350 and distance <= self.E.Range and not IsFacing(enemy, myHero) then
                self.E:Cast(enemy)
            end
        end
        if self.Q:IsReady() and not IsAutoAttacking() and Menu.Q.Combo:Value() and self.target and
            ((not self.W:IsReady() and Timer() - self.W.LastCast > 1) or GetDistance(self.target) > 300) and
            ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            self.Q:Cast()
        end
    end

    function Darius:Harass()
        if self.target and self.Q:IsReady() and not IsAutoAttacking() and Menu.Q.Harass:Value() and
            ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            self.Q:Cast()
        end
    end

    function Darius:OnDraw()
        if Menu.Q.Auto:Value() and HasBuff(myHero, "dariusqcast") and self.target then
            self.moveTo = self.target:GetPrediction(huge, 0.2):Extended(myHero.pos, ((self.Q.Radius + self.Q.Range) / 2))
        else
            self.moveTo = nil
        end
        DrawSpells(self)
    end

    function Darius:GetStacks(target)
        local buff = GetBuffByName(target, "DariusHemo")
        return buff and buff.count or 0
    end

    function Darius:GetUltMultiplier(target)
        return (1 + 0.2 * self:GetStacks(target) + Menu.R.Tweak:Value() / 100)
    end

    function Darius:UpdateItems()
        --[[
                Youmuu = 3142
                Tiamat = 3077
                Hidra = 3074
                Titanic = 3748
            ]]
        for i = ITEM_1, ITEM_7 do
            local id = myHero:GetItemData(i).itemID
            --[[In Case They Sell Items]]
            if self.Youmuus and i == self.Youmuus.Index and id ~= 3142 then
                self.Youmuus = nil
            elseif self.Tiamat and i == self.Tiamat.Index and id ~= 3077 then
                self.Tiamat = nil
            elseif self.Hidra and i == self.Hidra.Index and id ~= 3074 then
                self.Hidra = nil
            elseif self.Titanic and i == self.Titanic.Index and id ~= 3748 then
                self.Titanic = nil
            end
            ---
            if id == 3142 then
                self.Youmuus = { Index = i, Key = ItemHotKey[i] }
            elseif id == 3077 then
                self.Tiamat = { Index = i, Key = ItemHotKey[i] }
            elseif id == 3074 then
                self.Hidra = { Index = i, Key = ItemHotKey[i] }
            elseif id == 3748 then
                self.Titanic = { Index = i, Key = ItemHotKey[i] }
            end
        end
    end

    function Darius:UseItems(target)
        if self.Tiamat or self.Hidra then
            self:Hydra(target)
        elseif self.Titanic then
            self:TitanicHydra(target)
        end
    end

    function Darius:UseItem(key, reset)
        KeyDown(key)
        KeyUp(key)
        return reset and ResetAutoAttack()
    end

    function Darius:Youmuu(target)
        if self.Youmuus and Menu.Items.Youmuu:Value() and myHero:GetSpellData(self.Youmuus.Index).currentCd == 0 and
            IsValidTarget(target, 600) then
            self:UseItem(self.Youmuus.Key, false)
        end
    end

    function Darius:TitanicHydra(target)
        if self.Titanic and Menu.Items.TitanicHydra:Value() and myHero:GetSpellData(self.Titanic.Index).currentCd == 0
            and IsValidTarget(target, 380) then
            self:UseItem(self.Titanic.Key, true)
        end
    end

    function Darius:Hydra(target)
        if self.Hidra and Menu.Items.Hydra:Value() and myHero:GetSpellData(self.Hidra.Index).currentCd == 0 and
            IsValidTarget(target, 380) then
            self:UseItem(self.Hidra.Key, true)
        elseif self.Tiamat and Menu.Items.Tiamat:Value() and myHero:GetSpellData(self.Tiamat.Index).currentCd == 0 and
            IsValidTarget(target, 380) then
            self:UseItem(self.Tiamat.Key, true)
        end
    end

    insert(LoadCallbacks, function()
        Darius()
    end)

elseif myHero.charName == "Draven" then

    class 'Draven'
    --Draven = Class()

    function Draven:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies, self.AxeList = {}, {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        self.moveTo = nil
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttack(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnInterruptable(function(unit, spell)
            self:OnInterruptable(unit, spell)
        end)
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Draven:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = nil,
            Delay = 0.25,
            Speed = nil,
            Radius = nil,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.W = Spell({
            Slot = 1,
            Range = nil,
            Delay = 0.25,
            Speed = nil,
            Radius = nil,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.E = Spell({
            Slot = 2,
            Range = 950,
            Delay = 0.25,
            Speed = 1400,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeCone or SpellTypeSkillShot
        })
        self.R = Spell({
            Slot = 3,
            Range = 1500 or huge, --huge
            Delay = 0.4,
            Speed = 2000,
            Radius = 160,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })
    end

    function Draven:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "LastHit", name = "Use on LastHit", value = false })
        Menu.Q:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.Q:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "Catch", name = "Auto Catch Axes", value = true })
        Menu.Q:MenuElement({ id = "Max", name = "Max Axes To Have", value = 2, min = 1, max = 3 })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "Catch", name = "Use to Catch Axes", value = true })
        Menu.W:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        Menu.E:MenuElement({ id = "Gapcloser", name = "Auto Use on Gapcloser", value = true })
        Menu.E:MenuElement({ id = "Interrupt", name = "Interrupt Targets", type = MENU })
        --R--
        Menu.R:MenuElement({ id = "Heroes", name = "Duel Settings", type = MENU })
        Menu.R.Heroes:MenuElement({ id = "Combo", name = "Enabled", value = true })
        Menu.R:MenuElement({ id = "Count", name = "Auto Use When X Enemies", value = 2, min = 0, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana % ", value = 0, min = 0, max = 100, step = 1 })
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
        ObjectManager:OnEnemyHeroLoad(function(args)
            local hero = args.unit
            local charName = args.charName
            Interrupter:AddToMenu(hero, Menu.E.Interrupt)
            Menu.R.Heroes:MenuElement({ id = charName, name = charName, value = false })
        end)
    end

    function Draven:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.R.Range)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.mode = GetMode()
        --
        if myHero.isChanneling then
            return
        end
        self:ShouldCatch()
        self:Auto()
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 6 and self:Flee()
    end

    function Draven:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
        if self.moveTo then
            if GetDistance(self.moveTo) < 20 then
                args.Process = false
            else
                args.Target = self.moveTo
            end
        end
    end

    function Draven:OnPreAttack(args)
        --args.Process|args.Target
        if Orbwalker.Menu.General.HoldRadius:Value() < 50 then
            SetHoldRadius(50) --Leave this or it wont catch close axes
        --SetMovementDelay(100)
        local targ = args.Target
        if ShouldWait() or
            (
            self.moveTo and
                (
                (GetDistance(self.moveTo) / myHero.ms) + myHero.attackData.animationTime * 1.5 >=
                    self.AxeList[1].endTime - Timer() and myHero.posTo:DistanceTo(self.moveTo) > 30)) then
            if Menu.W.Catch:Value() and self.W:IsReady() and not HasBuff(myHero, "DravenFury") then
        end
            self.W:Cast()
            end
            args.Process = false
            return
        end
        if self:GetAxeCount() < Menu.Q.Max:Value() and IsValidTarget(targ, GetTrueAttackRange(myHero)) and
            self.Q:IsReady() then
            if (Menu.Q.Combo:Value() and self.mode == 1 and ManaPercent(myHero) >= Menu.Q.Mana:Value()) or
                (Menu.Q.Harass:Value() and self.mode == 2 and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value()) or
                (
                Menu.Q.Clear:Value() and self.mode == 3 and ManaPercent(myHero) >= Menu.Q.ManaClear:Value() and
                    targ.team ~= TEAM_JUNGLE) or
                (
                Menu.Q.Jungle:Value() and (self.mode == 4 or self.mode == 3) and
                    ManaPercent(myHero) >= Menu.Q.ManaClear:Value() and targ.team == TEAM_JUNGLE) or
                (Menu.Q.LastHit:Value() and self.mode == 5 and ManaPercent(myHero) >= Menu.Q.ManaClear:Value()) then
                self.Q:Cast()
            end
        end
    end

    function Draven:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        --if not IsValidTarget(target) then return end
        local delay = (target and GetDistance(target) / myHero.attackData.projectileSpeed)
        if delay then
            DelayAction(function()
                self:UpdateAxes()
            end, delay + Game.Latency() / 1000)
        else
            --myHero.attackData.target is broken and fere probably wont fix it zzzzz
            self:UpdateAxes()
            for i = 0, 1, (1 / 3) do
                DelayAction(function()
                    self:UpdateAxes()
                end, i)
            end
        end
    end

    function Draven:OnInterruptable(unit, spell)
        if not ShouldWait() and Menu.E.Interrupt[spell.name]:Value() and IsValidTarget(enemy, self.E.Range) and
            self.E:IsReady() then
            self.E:Cast(unit.pos)
        end
    end

    function Draven:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() or not (Menu.E.Gapcloser:Value() and self.E:IsReady()) then
            return
        end
        if IsValidTarget(unit) and GetDistance(unitPosTo) < 500 and unit.team == TEAM_ENEMY and IsFacing(unit, myHero) then
            --Gapcloser
            self.E:CastToPred(unit, HITCHANCE_NORMAL)
        end
    end

    function Draven:Auto()
        if self.enemies and #self.enemies ~= 0 and Menu.R.Count:Value() ~= 0 and self.R:IsReady() then
            local bestPos, hit = GetBestLinearCastPos(self.R, nil, self.enemies)
            if bestPos and hit >= Menu.R.Count:Value() then
                self.R:Cast(bestPos)
            end
        end
    end

    function Draven:Combo()
        local eTarget = GetTarget(self.E.Range, 0)
        local runningAway = (
            IsFacing(myHero, eTarget) and not IsFacing(eTarget, myHero) and
                GetDistance(eTarget) > GetTrueAttackRange(myHero))
        if self.W:IsReady() and Menu.W.Combo:Value() and ManaPercent(myHero) >= Menu.W.Mana:Value() and
            not HasBuff(myHero, "DravenFury") then
            if eTarget and (eTarget.ms > myHero.ms or runningAway) then
                self.W:Cast()
            end
        end
        if self.E:IsReady() and Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value() then
            local eTarget = GetTarget(self.E.Range, 0)
            if IsValidTarget(eTarget) and (HealthPercent(myHero) <= 40 or runningAway) then
                self.E:CastToPred(eTarget, HITCHANCE_NORMAL)
            end
        end
        if self.R:IsReady() and Menu.R.Heroes.Combo:Value() and ManaPercent(myHero) >= Menu.R.Mana:Value() then
            local rTarget = GetTarget(1500, 0)
            if IsValidTarget(rTarget) and Menu.R.Heroes[rTarget.charName]:Value() and rTarget.health >= 200 and
                (
                self.R:GetDamage(rTarget) * 4 > GetHealthPrediction(rTarget, GetDistance(rTarget) / self.R.Speed) or
                    HealthPercent(myHero) <= 40) then
                if self.R:CastToPred(rTarget, HITCHANCE_NORMAL) then
                    self:CallUltBack(rTarget)
                end
            end
        end
    end

    function Draven:Harass()
        if self.E:IsReady() and Menu.E.Harass:Value() and ManaPercent(myHero) >= Menu.E.ManaHarass:Value() then
            local eTarget = GetTarget(self.E.Range, 0)
            if IsValidTarget(eTarget) and
                (
                HealthPercent(myHero) <= 40 or
                    (
                    IsFacing(myHero, eTarget) and not IsFacing(eTarget, myHero) and
                        GetDistance(eTarget) > GetTrueAttackRange(myHero))) then
                self.E:CastToPred(eTarget, HITCHANCE_NORMAL)
            end
        end
    end

    function Draven:Flee()
        local nearby = GetEnemyHeroes(600)
        if Menu.E.Flee:Value() and self.E:IsReady() then
            for i = 1, #nearby do
                local enemy = nearby[i]
                local range = GetTrueAttackRange(enemy)
                if range <= 500 and GetDistance(enemy) <= range then
                    self.E:CastToPred(enemy, HITCHANCE_NORMAL);
                    break
                end
            end
        end
        if Menu.W.Flee:Value() and self.W:IsReady() and #nearby >= 1 then
            self.W:Cast()
        end
    end

    function Draven:KillSteal()
        if self.enemies and Menu.R.KS:Value() and self.R:IsReady() then
            for i = 1, #(self.enemies) do
                local enemy = self.enemies[i]
                local hp = enemy.health + enemy.shieldAD
                if self.R:GetDamage(enemy) * 2 >= hp and (hp >= 100 or HeroesAround(600, enemy.pos, TEAM_ALLY) == 0) then
                    if self.R:CastToPred(enemy, HITCHANCE_NORMAL) then
                        self:CallUltBack(enemy)
                        break
                    end
                end
            end
        end
    end

    function Draven:OnDraw()
        self:Auto()
        if Menu.Q.Catch:Value() then
            self:UpdateAxeCatching()
            self.moveTo = #self.AxeList >= 1 and self.AxeList[1].pos --axeNumber >= 2 and self.AxeList[1].pos + (self.AxeList[2].pos-self.AxeList[1].pos):Normalized() * 30 or axeNumber == 1 and
        else
            self.moveTo = nil
        end

        DrawSpells(self)
    end

    function Draven:UpdateAxeCatching()
        sort(self.AxeList, function(a, b)
            return GetDistance(a) < GetDistance(b)
        end)
        for i = 1, #self.AxeList do
            local object = self.AxeList[i]
            if object and (object.endTime - Timer() >= 0 and GetDistance(object.obj.pos, object.pos) > 10) then
                DrawText(i, 48, object.pos:ToScreen(), Color.Green)
            else
                remove(self.AxeList, i)
            end
        end
    end

    function Draven:CheckAxe(obj)
        for i = 1, #self.AxeList do
            if self.AxeList[i].ID == obj.handle then
                return true
            end
        end
    end

    function Draven:UpdateAxes()
        local count = MissileCount()
        for i = count, 1, -1 do
            local missile = Missile(i)
            local data = missile.missileData
            if data and data.owner == myHero.handle and data.name == "DravenSpinningReturn" and
                not self:CheckAxe(missile) then
                insert(self.AxeList,
                    { endTime = Timer() + 1.1, ID = missile.handle, pos = Vector(missile.missileData.endPos),
                        obj = missile }) --its always 1.1 seconds (missile speed changes based on distance)
                return true
            end
        end
    end

    function Draven:CallUltBack(enemy)
        DelayAction(function()
            KeyDown(HK_R)
            KeyUp(HK_R)
        end, abs(GetDistance(enemy) - 500) / 2000)
    end

    function Draven:ShouldCatch()
        if Menu.Q.Catch:Value() and self.moveTo and not myHero.pathing.hasMovePath and self.mode then
            Orbwalk()
        end
    end

    function Draven:GetAxeCount()
        local axesOnHand = (HasBuff(myHero, "dravenspinningleft") and 2) or (HasBuff(myHero, "dravenspinning") and 1) or
            0
        return #self.AxeList + axesOnHand
    end

    insert(LoadCallbacks, function()
        Draven()
    end)

elseif myHero.charName == "Ezreal" then

    class 'Ezreal'
    --Ezreal = Class()

    function Ezreal:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.lastAttacked = myHero
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttack(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Ezreal:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 1200,
            Delay = 0.25,
            Speed = 2000,
            Width = 120,
            Collision = true,
            CollisionTypes = { COLLISION_MINION, COLLISION_ENEMYHERO, COLLISION_YASUOWALL },
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.W = Spell({
            Slot = 1,
            Range = 1200,
            Delay = 0.25,
            Speed = 1700,
            Radius = 80,
            Collision = true, --was false
            CollisionTypes = { COLLISION_ENEMYHERO, COLLISION_YASUOWALL }, --
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.E = Spell({
            Slot = 2,
            Range = 475,
            Delay = 0.25,
            Speed = 2000,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.R = Spell({
            Slot = 3,
            Range = 2000 or huge, --reduced on purpose
            Delay = 1,
            Speed = 2000,
            Width = 320,
            Collision = true, --was false
            CollisionTypes = { COLLISION_YASUOWALL }, --
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.Escape = Spell({
            Slot = nil,
            Range = 2000, --reduced on purpose
            Delay = 1,
            Speed = 2000,
            Radius = 2000,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
    end

    function Ezreal:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Pred", name = "Prediction Mode", value = 2,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "PredHarass", name = "Prediction Mode", value = 3,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "LastHit", name = "Use to LastHit", value = false })
        Menu.Q:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.Q:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "KS", name = "Use to KS", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "KS", name = "Use to KS", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Mode", name = "Combo Mode", value = 2, drop = { "Never", "Aggressive", "Peel" } })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "Gapcloser", name = "Use on Gapcloser", value = true })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Combo", name = "Use When X Enemies", value = 2, min = 0, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana % ", value = 0, min = 0, max = 100, step = 1 })
        Menu.R:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.R:MenuElement({ id = "KS", name = "Use to KS", value = true })

        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
    end

    function Ezreal:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.Escape.Range)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.mode = GetMode()
        --
        if myHero.isChanneling then
            return
        end
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        self:Auto()
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 3 and self:Clear() or
            self.mode == 4 and self:Clear() or
            self.mode == 5 and self:LastHit()
    end

    function Ezreal:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Ezreal:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
        self.lastAttacked = args.Target
    end

    function Ezreal:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        if ShouldWait() or not IsValidTarget(target) or not (self.Q:IsReady() or self.W:IsReady()) then
            return
        end
        --
        local isMob, isHero = target.type == Obj_AI_Minion, target.type == myHero.type
        local modeCheck, manaCheck, spell
        --
        if isMob then
            local laneClear, jungleClear = self.mode == 3, self.mode == 4
            modeCheck = laneClear or jungleClear
            local castCheck = target.team == TEAM_JUNGLE and Menu.Q.Jungle:Value() or
                target.team == TEAM_ENEMY and Menu.Q.Clear:Value()
            manaCheck = ManaPercent(myHero) >= Menu.Q.ManaClear:Value()
            if modeCheck and castCheck and manaCheck then
                self.Q:Cast(target.pos)
            end
        elseif isHero then
            local spell = (self.Q:IsReady() and "Q") or "W"
            local combo, harass = self.mode == 1, self.mode == 2
            modeCheck = (combo or harass)
            local castCheck = combo and Menu[spell].Combo:Value() or harass and Menu[spell].Harass:Value()
            manaCheck = combo and ManaPercent(myHero) >= Menu[spell].Mana:Value() or
                harass and ManaPercent(myHero) >= Menu[spell].ManaHarass:Value()
            if modeCheck and castCheck and manaCheck then
                self[spell]:CastToPred(target, 2)
            end
        end
    end

    function Ezreal:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() or not Menu.E.Gapcloser:Value() then
            return
        end
        if IsValidTarget(unit) and GetDistance(unitPosTo) < 200 and unit.team == TEAM_ENEMY and IsFacing(unit, myHero) then
            --Gapcloser
            local bestPos = self:GetBestPos()
            if bestPos then
                self.E:Cast(bestPos)
            end
        end
    end

    function Ezreal:Auto()
        local eMode = Menu.E.Mode:Value()
        if self.mode ~= 1 or eMode == 1 then
            return
        end
        --
        if eMode == 2 then
            local eTarget = GetTarget(self.E.Range + self.Q.Range, 0)
            if eTarget and #GetEnemyHeroes(600) == 0 then
                self.E:Cast(eTarget)
            end
        elseif eMode == 3 then
            local eTarget = GetTarget(self.E.Range, 0)
            if eTarget and GetDanger(myHero.pos) > 0 then
                local temp = self:GetBestPos()
                if temp then
                    self.E:Cast(temp)
                end
            end
        end
    end

    function Ezreal:Combo()
        if self.enemies and #self.enemies ~= 0 and Menu.R.Combo:Value() ~= 0 and self.R:IsReady() and
            ManaPercent(myHero) >= Menu.R.Mana:Value() then
            local bestPos, hit = GetBestLinearCastPos(self.R, nil, self.enemies)
            if bestPos and hit >= Menu.R.Combo:Value() then

                self.R:Cast(bestPos)
            end
        end
        --
        local qTarget, qPred = GetTarget(self.Q.Range, 0), Menu.Q.Pred:Value()
        if IsValidTarget(qTarget) and GetDistance(qTarget) >= GetTrueAttackRange(myHero) then
            if Menu.W.Combo:Value() and self.W:IsReady() and ManaPercent(myHero) >= Menu.W.Mana:Value() and
                GetDistance(qTarget) <= self.W.Range then
                self.W:CastToPred(qTarget, 2)
            elseif Menu.Q.Combo:Value() and self.Q:IsReady() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
                self.Q:CastToPred(qTarget, qPred)
            end
        end
    end

    function Ezreal:Harass()
        local qTarget, qPred = GetTarget(self.Q.Range, 0), Menu.Q.PredHarass:Value()
        if IsValidTarget(qTarget) and GetDistance(qTarget) >= GetTrueAttackRange(myHero) then
            if Menu.Q.Harass:Value() and self.Q:IsReady() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() then
                self.Q:CastToPred(qTarget, qPred)
            elseif Menu.W.Harass:Value() and self.W:IsReady() and ManaPercent(myHero) >= Menu.W.ManaHarass:Value() and
                GetDistance(qTarget) <= self.W.Range then
                self.W:CastToPred(qTarget, 2)
            end
        end
    end

    function Ezreal:Clear()
    end

    function Ezreal:LastHit()
        if Menu.Q.LastHit:Value() and self.Q:IsReady() then
            local busy = myHero.attackData.state == STATE_WINDDOWN
            local minions = GetEnemyMinions(self.Q.Range)
            for i = 1, #minions do
                local minion = minions[i]
                local hp = GetHealthPrediction(minion, self.Q.Delay + GetDistance(minion) / self.Q.Speed)
                if (minion.networkID ~= self.lastAttacked.networkID) and
                    (busy or GetDistance(minion) >= GetTrueAttackRange(myHero)) and hp >= 20 and
                    self.Q:GetDamage(minion) >= hp and #mCollision(myHero.pos, minion.pos, self.Q, minions) == 0 then
                    self.Q:Cast(minion);
                    return
                end
            end
        end
    end

    function Ezreal:KillSteal()
        local ksQ, ksW, ksR = Menu.Q.KS:Value() and self.Q:IsReady(), Menu.W.KS:Value() and self.W:IsReady(),
            Menu.R.KS:Value() and self.R:IsReady()
        if ksQ or ksW or ksR then
            for i = 1, #self.enemies do
                local targ = self.enemies[i]
                local hp, dist = targ.health, GetDistance(targ)
                if (ksW and self.W:GetDamage(targ) >= hp) then
                    if self.W:CastToPred(targ, 2) then
                        return
                    end
                elseif (ksQ and self.Q:GetDamage(targ) >= hp) then
                    if self.Q:CastToPred(targ, 2) then
                        return
                    end
                elseif (
                    ksR and self.R:GetDamage(targ) >= hp and (hp >= 200 or HeroesAround(600, targ.pos, TEAM_ALLY) == 0)) then
                    if self.R:CastToPred(targ, 3) then
                        return
                    end
                end
            end
        end
    end

    function Ezreal:OnDraw()
        DrawSpells(self)
    end

    --function Ezreal:GetBestPos()
    --    local nearby = GetEnemyHeroes(2000)
    --    for k, v in pairs(GetEnemyTurrets(2000)) do nearby[#nearby+1] = v end
    --    local mostDangerous = GetBestCircularCastPos(self.Escape, nil, nearby)
    --    local pos = (myHero.pos):Extended(mostDangerous, -self.E.Range) --farthest possible from most dangerous
    --    if GetDanger(myHero.pos) > GetDanger(pos) + 5 then
    --        DrawCircle(pos, 10)
    --        return pos
    --    end
    --end

    function Ezreal:GetBestPos()
        local rotateAngle = 0 --was outside

        local hPos, result = myHero.pos, {}
        local offset, rotateAngle = hPos + Vector(0, 0, self.E.Range), rotateAngle / 360 * pi
        --
        for i = 0, 360, 40 do
            local pos = RotateAroundPoint(offset, hPos, i * pi / 180)
            result[#result + 1] = { pos, GetDanger(pos) }
        end
        sort(result, function(a, b)
            if MapPosition:inWall(a[1]) then
                return false
            end
            if a[2] ~= b[2] then
                return a[2] < b[2]
            else
                return GetDistance(a[1], mousePos) < GetDistance(b[1], mousePos)
            end
        end)
        return result[1][2] == 0 and result[1][1]
    end

    insert(LoadCallbacks, function()
        Ezreal()
    end)

elseif myHero.charName == "Jax" then

    class 'Jax'
    --Jax = Class()

    function Jax:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        Callback.Add("WndMsg", function(...)
            self:OnWndMsg(...)
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttack(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
    end

    function Jax:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 700,
            Delay = 0.85,
            Speed = huge,
            Radius = 150,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted
        })
        self.W = Spell({
            Slot = 1,
            Range = 925,
            Delay = 0.25,
            Speed = 1450,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.E = Spell({
            Slot = 2,
            Range = 300,
            Delay = 0.25,
            Speed = 2500,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.R = Spell({
            Slot = 3,
            Range = 800,
            Delay = 0.85,
            Speed = huge,
            Radius = 150,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.W.LastReset = Timer()
    end

    function Jax:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "LastHit", name = "Use to LastHit", value = false })
        Menu.Q:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.Q:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        Menu.Q:MenuElement({ id = "Jump", name = "WardJump Settings", type = MENU })
        Menu.Q.Jump:MenuElement({ id = "Flee", name = "Ward On Flee", value = true })
        Menu.Q.Jump:MenuElement({ id = "Key", name = "WardJump Key", key = string.byte("Z") })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.W:MenuElement({ id = "LastHit", name = "Use to LastHit", value = false })
        Menu.W:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.W:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.W:MenuElement({ id = "ManaClear", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.R:MenuElement({ id = "Count", name = " When X Enemies", value = 2, min = 1, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "Heroes", name = " Duel Targets", type = MENU })
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana % ", value = 0, min = 0, max = 100, step = 1 })
        --Jump--

        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })

        ObjectManager:OnEnemyHeroLoad(function(args)
            Menu.R.Heroes:MenuElement({ id = args.charName, name = args.charName, value = false })
        end)
    end

    function Jax:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.Q.Range)
        self.target = GetTarget(self.Q.Range, 0)
        self.mode = GetMode()
        --
        self:ResetAA()
        if myHero.isChanneling then
            return
        end
        self:Auto()
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 3 and self:Clear() or
            self.mode == 4 and self:Clear() or
            self.mode == 5 and self:LastHit() or
            self.mode == 6 and self:Flee()
    end

    function Jax:ResetAA()
        if Timer() > self.W.LastReset + 1 and HasBuff(myHero, "JaxEmpowerTwo") then
            ResetAutoAttack()
            self.W.LastReset = Timer()
        end
    end

    function Jax:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Jax:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Jax:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        if ShouldWait() or not IsValidTarget(target) or not self.W:IsReady() then
            return
        end
        local wMenu, isMob, isHero = Menu.W, target.type == Obj_AI_Minion, target.type == myHero.type
        local modeCheck, manaCheck
        --
        if isMob then
            local laneClear, jungleClear = self.mode == 3, self.mode == 4
            modeCheck = laneClear or jungleClear
            local castCheck = target.team == TEAM_JUNGLE and wMenu.Jungle:Value() or
                target.team == TEAM_ENEMY and wMenu.Clear:Value()
            manaCheck = ManaPercent(myHero) >= Menu.W.ManaClear:Value()
        elseif isHero then
            local combo, harass = self.mode == 1, self.mode == 2
            modeCheck = (combo or harass)
            local castCheck = combo and wMenu.Combo:Value() or harass and wMenu.Harass:Value()
            manaCheck = combo and ManaPercent(myHero) >= Menu.W.Mana:Value() or
                harass and ManaPercent(myHero) >= Menu.W.ManaHarass:Value()
        end
        --
        if modeCheck and castCheck and manaCheck then
            self.W:Cast()
        end
    end

    function Jax:OnWndMsg(key, param)
        if param == Menu.Q.Jump.Key.__key then
            self:Jump(true)
        end
    end

    function Jax:Auto()
        if not self:IsDeflecting() then
            return
        end
        --
        local eRange = self.E.Range
        local enemies = GetEnemyHeroes(eRange + 300)
        local willHit, entering, leaving = 0, 0, 0
        --
        for i = 1, #enemies do
            local target = enemies[i]
            local tP, tP2, pP2 = target.pos, target:GetPrediction(huge, 0.2), myHero:GetPrediction(huge, 0.2)
            --
            if GetDistance(tP) <= eRange then
                --if inside(might go out)
                willHit = willHit + 1
                if GetDistance(tP2, pP2) > eRange then
                    leaving = leaving + 1
                end
            elseif GetDistance(tP2, pP2) < eRange then
                --if outside(might come in)
                entering = entering + 1
            end
        end
        if entering <= leaving and (willHit > 0 or entering == 0) then
            if leaving > 0 and self.E:IsReady() then
                self.E:Cast()
            end
        end
    end

    function Jax:Combo()
        local targ = self.target
        if not IsValidTarget(targ) then
            return
        end
        local dist = GetDistance(targ)
        --
        if Menu.E.Combo:Value() and dist < GetTrueAttackRange(targ) and self.E:IsReady() and not self:IsDeflecting() and
            ManaPercent(myHero) >= Menu.E.Mana:Value() then
            self.E:Cast()
        elseif Menu.Q.Combo:Value() and dist <= self.Q.Range and self.Q:IsReady() and
            (dist >= GetTrueAttackRange(myHero) or self.Q:GetDamage(targ) > targ.health) and
            ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            self.Q:Cast(targ)
        elseif Menu.R.Combo:Value() and self.R:IsReady() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            if #self.enemies >= Menu.R.Count:Value() or
                (Menu.R.Heroes[targ.charName] and Menu.R.Heroes[targ.charName]:Value()) then
                self.R:Cast()
            end
        end
    end

    function Jax:Harass()
        local targ = self.target
        if not IsValidTarget(targ) then
            return
        end
        local dist = GetDistance(targ)
        --
        if self.E:IsReady() and Menu.E.Harass:Value() and dist < GetTrueAttackRange(targ) and not self:IsDeflecting() and
            ManaPercent(myHero) >= Menu.E.ManaHarass:Value() then
            self.E:Cast()
        elseif self.Q:IsReady() and Menu.Q.Harass:Value() and dist <= self.Q.Range and
            (dist >= GetTrueAttackRange(myHero) or self.Q:GetDamage(targ) > targ.health) and
            ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() then
            self.Q:Cast(targ)
        end
    end

    function Jax:Clear()
        if Menu.Q.Clear:Value() and self.Q:IsReady() and ManaPercent(myHero) > Menu.Q.ManaClear:Value() then
            local minions = GetEnemyMinions(self.Q.Range)
            local aaRange, aaCooldown = GetTrueAttackRange(myHero), myHero.attackData.state == STATE_WINDDOWN
            --
            for i = 1, #minions do
                local minion = minions[i]
                if minion.health >= 20 and self.Q:GetDamage(minion) > minion.health and
                    ((GetDistance(minion) > aaRange or aaCooldown)) then
                    return self.Q:Cast(minion)
                end
            end
        end
    end

    function Jax:LastHit()
        if myHero.attackData.state == STATE_WINDDOWN and Menu.W.LastHit:Value() and self.W:IsReady() and
            ManaPercent(myHero) > Menu.W.ManaClear:Value() then
            local aaRange = GetTrueAttackRange(myHero)
            local minions = GetEnemyMinions(aaRange)
            --
            for i = 1, #minions do
                local minion = minions[i]
                if minion.health >= 20 and self.W:GetDamage(minion) > minion.health then
                    self.W:Cast()
                    return
                end
            end
        elseif Menu.Q.LastHit:Value() and self.Q:IsReady() and ManaPercent(myHero) > Menu.Q.ManaClear:Value() then
            local minions = GetEnemyMinions(self.Q.Range)
            local aaRange, aaCooldown = GetTrueAttackRange(myHero), myHero.attackData.state == STATE_WINDDOWN
            --
            for i = 1, #minions do
                local minion = minions[i]
                if minion.health >= 20 and (GetDistance(minion) > aaRange or aaCooldown) and
                    self.Q:GetDamage(minion) > minion.health then
                    self.Q:Cast(minion)
                    return
                end
            end
        end
    end

    function Jax:Flee()
        if Menu.Q.Flee:Value() then
            self:Jump(Menu.Q.Jump.Flee:Value())
        end
        if Menu.E.Flee:Value() and self.E:IsReady() then
            if #GetEnemyHeroes(400) >= 1 then
                self.E:Cast()
            end
        end
    end

    function Jax:KillSteal()
        if Menu.Q.KS:Value() and self.Q:IsReady() then
            for i = 1, #self.enemies do
                local targ = self.enemies[i]
                local qReady, wReady = self.Q:IsReady(), self.W:IsReady()
                local qDmg, wDmg = (qReady and self.Q:GetDamage(targ) or 0), (wReady and self.W:GetDamage(targ) or 0)
                if qDmg + wDmg >= targ.health then
                    if qDmg < targ.health then
                        self.W:Cast()
                    end
                    self.Q:Cast(targ)
                end
            end
        end
    end

    function Jax:OnDraw()
        DrawSpells(self)
    end

    function Jax:IsDeflecting()
        return HasBuff(myHero, "JaxCounterStrike")
    end

    function Jax:Jump(canWard)
        if not self.Q:IsReady() then
            return
        end
        local jumpPos = myHero.pos:Extended(mousePos, self.Q.Range) --always jump at max range
        local jumpObject = self:GetJumpObject(jumpPos)
        --
        if jumpObject then
            self.Q:Cast(jumpObject)
            return
        elseif canWard then
            local pos, wardKey = mousePos, self:GetWard()
            jumpPos = mousePos
            if GetDistance(mousePos) > 600 then
                jumpPos = myHero.pos:Extended(mousePos, 600)
            end
            if wardKey then
                Control.CastSpell(wardKey, jumpPos)
                DelayAction(function()
                    self.Q:Cast(jumpPos)
                end, 0.2)
            end
        end
    end

    function Jax:GetJumpObject(pos)
        local range, distance, result = GetDistance(pos) + 200, 10000, nil
        --
        local bases = GetMinions(range)
        --
        local heroes = GetHeroes(range)
        for i = 1, #heroes do
            bases[#bases + 1] = heroes[i]
        end
        local wards = GetWards(range)
        for i = 1, #wards do
            bases[#bases + 1] = wards[i]
        end

        local monsters = GetMonsters(range)
        for i = 1, #monsters do
            bases[#bases + 1] = monsters[i]
        end

        for i = 1, #bases do
            local obj = bases[i]
            local dist = GetDistance(obj, pos)
            if dist <= 200 and dist <= distance and IsValidTarget(obj) then
                distance = dist
                result = obj
            end
        end
        return result
    end

    function Jax:GetWard()
        for i = ITEM_1, ITEM_7 do
            local id = myHero:GetItemData(i).itemID
            local spell = myHero:GetSpellData(i)
            if id and wardItemIDs[tostring(id)] and spell.currentCd == 0 and spell.ammo >= 1 then
                return ItemHotKey[i]
            end
        end
    end

    insert(LoadCallbacks, function()
        Jax()
    end)

elseif myHero.charName == "Jhin" then
    class 'Jhin'
    --Jhin = Class()

    function Jhin:__init()
        --// Data Initialization //--
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"

        self:Spells()
        self:Menu()

        --// Callbacks //--

        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttack(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
    end

    function Jhin:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 550,
            Type = SpellTypeTargetted
        })

        self.W = Spell({
            Slot = 1,
            Range = 3000,
            Delay = 0.75,
            Speed = 10000,
            Radius = 20,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })

        self.E = Spell({
            Slot = 2,
            Range = 750,
            Delay = 1,
            Speed = 1600,
            Radius = 60,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })

        self.E.LastCastT = 0

        self.R = Spell({
            Slot = 3,
            Range = 3500,
            Delay = 1,
            Speed = 5000,
            Radius = 40,
            Collision = true, -- was false
            CollisionTypes = { COLLISION_ENEMYHERO, COLLISION_YASUOWALL }, --
            From = myHero,
            Type = SpellTypeSkillShot
        })

        self.R.Angle = 60
        self.R.IsCasting = false
        self.R.IsChanneling = false
        self.R.CastPos = nil
    end

    function Jhin:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        -- Q SETTINGS
        Menu.Q:MenuElement({ name = " ", drop = { "Modes" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Combo", value = true })
        Menu.Q:MenuElement({ id = "Harass", name = "Harass", value = true })
        Menu.Q:MenuElement({ id = "KS", name = "KillSteal", value = true })
        Menu.Q:MenuElement({ name = " ", drop = { "Mana Manager" } })
        Menu.Q:MenuElement({ id = "ComboMana", name = "Combo - Min. Mana( % )", value = 0, min = 0, max = 100 })
        Menu.Q:MenuElement({ id = "HarassMana", name = "Harass - Min. Mana( % )", value = 50, min = 0, max = 100 })
        Menu.Q:MenuElement({ name = " ", drop = { "Customization" } })
        Menu.Q:MenuElement({ type = MENU, name = "Cast Settings", id = "CS" })
        Menu.Q.CS:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q.CS:MenuElement({ name = "Cast Mode", id = "ComboMode", value = 2, drop = { "Normal", "After Attack" } })
        Menu.Q.CS:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q.CS:MenuElement({ name = "Cast Mode", id = "HarassMode", value = 1, drop = { "Normal", "After Attack" } })
        Menu.Q:MenuElement({ type = MENU, name = "Harass White List", id = "HarassWhiteList" })
        Menu.Q:MenuElement({ type = MENU, name = "KillSteal White List", id = "KSWhiteList" })

        -- W SETTINGS
        Menu.W:MenuElement({ name = " ", drop = { "Modes" } })
        Menu.W:MenuElement({ id = "Combo", name = "Combo", value = true })
        Menu.W:MenuElement({ name = " ", drop = { "Mana Manager" } })
        Menu.W:MenuElement({ id = "ComboMana", name = "Combo - Min. Mana( % )", value = 0, min = 0, max = 100 })
        Menu.W:MenuElement({ name = " ", drop = { "Customization" } })
        Menu.W:MenuElement({ id = "OnImmobile", name = "On Immobile", value = true,
            tooltip = "Will use W on immobile enemy" })
        Menu.W:MenuElement({ type = MENU, name = "On Immobile White List", id = "OnImmobileWhiteList" })
        Menu.W:MenuElement({ type = MENU, name = "HitChance Settings", id = "HitChance" })
        Menu.W.HitChance:MenuElement({ id = "info", name = "HitChance Info [?]", drop = { " " },
            tooltip = " 0 - Out of range / Collision / No valid waypoints\\n" ..
                " 1 - Collision hitchance\\n" ..
                " 2 - Normal hitchance\\n" ..
                " 3 - High hitchance (Slowed, Casted spell or AA)\\n" ..
                " 4 - Very High / Target immobile\\n" ..
                " 5 - Target dashing" })
        Menu.W.HitChance:MenuElement({ id = "Combo", name = "Combo - HitChance", value = 2, min = 1, max = 5 })
        Menu.W.HitChance:MenuElement({ id = "Harass", name = "Harass - HitChance", value = 2, min = 1, max = 5 })

        -- E SETTINGS
        Menu.E:MenuElement({ name = " ", drop = { "Modes" } })
        Menu.E:MenuElement({ id = "Combo", name = "Combo", value = true })
        Menu.E:MenuElement({ name = " ", drop = { "Mana Manager" } })
        Menu.E:MenuElement({ id = "ComboMana", name = "Combo - Min. Mana( % )", value = 0, min = 0, max = 100 })
        Menu.E:MenuElement({ name = " ", drop = { "Customization" } })
        Menu.E:MenuElement({ id = "OnImmobile", name = "On Immobile", value = true,
            tooltip = "Will use E on immobile enemy" })
        Menu.E:MenuElement({ type = MENU, name = "On Immobile White List", id = "OnImmobileWhiteList" })

        -- R SETTINGS
        Menu.R:MenuElement({ name = " ", drop = { "Modes" } })
        Menu.R:MenuElement({ id = "Combo", name = "Combo", value = true })

        -- OTHER
        Menu:MenuElement({ name = myHero.charName .. " Script version: ", drop = { self.scriptVersion } })

        ObjectManager:OnEnemyHeroLoad(function(args)
            local charName = args.charName
            Menu.Q.HarassWhiteList:MenuElement({ name = charName, id = charName, value = true })
            Menu.Q.KSWhiteList:MenuElement({ name = charName, id = charName, value = true })
            Menu.W.OnImmobileWhiteList:MenuElement({ name = charName, id = charName, value = true })
            Menu.E.OnImmobileWhiteList:MenuElement({ name = charName, id = charName, value = true })
        end)
    end

    function Jhin:EnoughMana(value)
        return ManaPercent(myHero) >= value
    end

    function Jhin:WhiteListValue(menu, target)
        return menu and menu[target.charName] and menu[target.charName]:Value()
    end

    function Jhin:CrossProduct(p1, p2)
        return (p2.z * p1.x - p2.x * p1.z)
    end

    function Jhin:Rotated(v, angle)
        local c = cos(angle)
        local s = sin(angle)
        return Vector(v.x * c - v.z * s, 0, v.z * c + v.x * s)
    end

    function Jhin:InCone(targetPos)
        if not self.R.CastPos then
            return false
        end

        local endPos = self.R.CastPos
        local range = self.R.Range
        local angle = self.R.Angle * pi / 180
        local v1 = self:Rotated(endPos - myHero.pos, -angle / 2)
        local v2 = self:Rotated(v1, angle)
        local v3 = targetPos - myHero.pos

        if GetDistanceSqr(v3, Vector()) < range * range and self:CrossProduct(v1, v3) > 0 and
            self:CrossProduct(v3, v2) > 0 then
            return true
        end

        return false
    end

    function Jhin:Update()
        local spell = myHero.activeSpell

        if spell and spell.valid and spell.name == "JhinR" then
            self.R.IsCasting = true
            self.R.CastPos = Vector(spell.placementPos)

            if spell.isChanneling then
                self.R.IsChanneling = true
            end

            SetAttack(false)
            SetMovement(false)
        else
            self.R.IsCasting = false
            self.R.CastPos = nil
            self.R.IsChanneling = false

            SetAttack(true)
            SetMovement(true)
        end
    end

    function Jhin:CastQ(target)
        if self.Q:IsReady() and self.Q:CanCast(target) then
            self.Q:Cast(target)
        end
    end

    function Jhin:CastW(target, hitChance)
        if self.W:IsReady() and self.W:CanCast(target) then
            self.W:CastToPred(target, hitChance)
        end
    end

    function Jhin:CastE(target, hitChance)
        if self.E:IsReady() and self.E:CanCast(target) then
            self.E:CastToPred(target, hitChance)
            self.E.LastCastT = Game.Timer()
        end
    end

    function Jhin:CastR(target, hitChance)
        if self.R:IsReady() and self.R:CanCast(target) and self.R.IsChanneling then
            self.R:CastToPred(target, hitChance)
        end
    end

    function Jhin:Combo()
        local target = self.target
        if not target then
            return
        end

        if self.R.IsCasting then
            local useR = Menu.R.Combo:Value()
            if useR then
                self:CastR(target, 1)
            end

            return
        end

        local reload = GotBuff(myHero, "JhinPassiveReload") > 0
        local useQ = Menu.Q.Combo:Value()
        local modeQ = Menu.Q.CS.ComboMode:Value()
        local manaQ = Menu.Q.ComboMana:Value()
        if useQ and (modeQ == 1 or reload) and self:EnoughMana(manaQ) then
            self:CastQ(target)
        end

        local useW = Menu.W.Combo:Value()
        local manaW = Menu.W.ComboMana:Value()
        local hitChanceW = Menu.W.HitChance.Combo:Value()
        local marked = GotBuff(target, "jhinespotteddebuff") > 0
        if useW and self:EnoughMana(manaW) and marked then
            self:CastW(target, hitChanceW)
        end

        local timer = Game.Timer()
        local useE = Menu.E.Combo:Value()
        local manaE = Menu.E.ComboMana:Value()
        if useE and self:EnoughMana(manaE) and reload and self.E.LastCastT + 2 < timer then
            self:CastE(target, HITCHANCE_NORMAL)
        end
    end

    function Jhin:ComboR()
        local target = self.target
        if not target then
            return
        end

        if self.mode == 1 then
            if self.R.IsCasting then
                local useR = Menu.R.Combo:Value()
                if useR then
                    self:CastR(target, 1)
                end

                return
            end
        end
    end

    function Jhin:Harass()
        local target = self.target
        if not target then
            return
        end
        if self.R.IsCasting then
            return
        end

        local reload = GotBuff(myHero, "JhinPassiveReload") > 0
        local useQ = Menu.Q.Harass:Value()
        local modeQ = Menu.Q.CS.HarassMode:Value()
        local manaQ = Menu.Q.HarassMana:Value()
        if useQ and (modeQ == 1 or reload) and self:EnoughMana(manaQ) and
            self:WhiteListValue(Menu.Q.HarassWhiteList, target) then
            self:CastQ(target)
        end
    end

    function Jhin:Immobile()
        for i = 1, #(self.enemies) do
            local unit = self.enemies[i]

            local timer = Game.Timer()
            local marked = GotBuff(unit, "jhinespotteddebuff") > 0
            local useW = Menu.W.OnImmobile:Value()
            if useW and self:WhiteListValue(Menu.W.OnImmobileWhiteList, unit) then
                local target, unitPosition, castPosition = self.W:OnImmobile(unit)

                if target and unitPosition and marked then
                    self:CastW(unit, 1)
                end
            end

            local useE = Menu.E.OnImmobile:Value()
            if useE and self:WhiteListValue(Menu.E.OnImmobileWhiteList, unit) then
                local target, unitPosition, castPosition = self.E:OnImmobile(unit)

                if target and unitPosition and self.E.LastCastT + 1 < timer then
                    self:CastE(unit, 1)
                end
            end
        end
    end

    function Jhin:KillSteal()
        for i = 1, #(self.enemies) do
            local unit = self.enemies[i]
            local health = unit.health
            local shield = unit.shieldAD

            local useQ = Menu.Q.KS:Value()
            if self.Q:IsReady() and self.Q:CanCast(unit) and useQ and self:WhiteListValue(Menu.Q.KSWhiteList, unit) then
                local damage = self.Q:GetDamage(unit)

                if health + shield < damage then
                    self.Q:Cast(unit)
                end
            end
        end
    end

    function Jhin:Tick()
        self:Update()

        if ShouldWait() then
            return
        end

        self.mode = GetMode()
        self.target = GetTarget(self.R.Range, 0)
        self.enemies = GetEnemyHeroes(self.R.Range)

        self:ComboR()

        if myHero.isChanneling then
            return
        end

        self:Immobile()
        self:KillSteal()

        if not self.mode then
            return
        end

        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass()
    end

    function Jhin:OnDraw()
        DrawSpells(self)
    end

    function Jhin:OnPreMovement(args)
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Jhin:OnPreAttack(args)
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Jhin:OnPostAttack()
        local handle = myHero.attackData.target
        local target = handle ~= 0 and GetTargetByHandle(handle) or self.target
        if target == nil then
            return
        end
        local target_type = target.type

        if target_type == Obj_AI_Hero then
            if self.mode == 1 then
                local useQ = Menu.Q.Combo:Value()
                local modeQ = Menu.Q.CS.ComboMode:Value()
                local manaQ = Menu.Q.ComboMana:Value()
                if useQ and modeQ == 2 and self:EnoughMana(manaQ) then
                    self:CastQ(target)
                end
            elseif self.mode == 2 then
                local useQ = Menu.Q.Harass:Value()
                local modeQ = Menu.Q.CS.HarassMode:Value()
                local manaQ = Menu.Q.HarassMana:Value()
                if useQ and modeQ == 2 and self:EnoughMana(manaQ) and self:WhiteListValue(Menu.Q.HarassWhiteList, target) then
                    self:CastQ(target)
                end
            end
        end
    end

    insert(LoadCallbacks, function()
        Jhin()
    end)

elseif myHero.charName == "Kalista" then

    class 'Kalista'
    --Kalista = Class()

    function Kalista:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.recentTargets = {}
        self.rendDmgpercent = {}
        self.rendDmg = {}
        self.Color1 = DrawColor(255, 35, 219, 81)
        self.Color2 = DrawColor(255, 216, 121, 26)
        self.SentinelSpots = {
            Baron = { obj = false, pos = Vector(4956, 0, 10444) },
            Dragon = { obj = false, pos = Vector(9866, 0, 4414) },
            Mid = { obj = false, pos = Vector(8428, 0, 6465) },
            Blue = { obj = false, pos = Vector(3871, 0, 7901) },
            Red = { obj = false, pos = Vector(7862, 0, 4111) },
            Mid2 = { obj = false, pos = Vector(6545, 0, 8361) },
            Blue2 = { obj = false, pos = Vector(10931, 0, 6990) },
            Red2 = { obj = false, pos = Vector(7016, 0, 10775) },
        }
        self.supportedAllies = {
            ["Blitzcrank"] = "rocketgrab2",
            ["Skarner"] = "SkarnerImpale",
            ["TahmKench"] = "tahmkenchwdevoured"
        }
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        Callback.Add("WndMsg", function(msg, param)
            self:OnWndMsg(msg, param)
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnAttack(function(...)
            self:OnAttack(...)
        end)
        --[[ OnUnkillableMinion(function(...)
            self:OnUnkillable(...)
        end) ]] --wait for ggorb update
        --[[Custom Callbacks]]
        OnLoseVision(function(unit)
            self:OnLoseVision(unit)
        end)
    end

    function Kalista:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 1175,
            Delay = 0.25,
            Speed = 2400,
            Radius = 40,
            Collision = true,
            CollisionTypes = { COLLISION_MINION, COLLISION_ENEMYHERO, COLLISION_YASUOWALL },
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.W = Spell({
            Slot = 1,
            Range = 5000,
            Delay = 0.50,
            Speed = 450,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
        self.E = Spell({
            Slot = 2,
            Range = 1100,
            Delay = 0.25,
            Speed = huge,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.R = Spell({
            Slot = 3,
            Range = 1200,
            Delay = 0.00,
            Speed = huge,
            Radius = 150,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.W.LastCast = Timer()
        self.W.LastSpot = nil
        --
        --[[             self.W.GetDamage = function(spellInstance, enemy, stage)
                local wLvl = myHero:GetSpellData(_W).level
                local baseDmg = (({14,15,16,17,18})[wLvl]/100) * enemy.maxHealth
                --
                if HasBuff(enemy, "kalistacoopstrikeally") then
                    if enemy.type == Obj_AI_Minion then
                        if enemy.health <= 125 then
                        return enemy.health end
                    return max(min(baseDmg, 75), ({100,125,150,175,200})[wLvl])
                    end
                end
                return baseDmg
            end ]]
        --[[    self.E.GetDamage = function(spellInstance, enemy, stage)
                if not spellInstance:IsReady() then return 0 end
                --
                local buff = self.recentTargets[enemy.networkID] and self.recentTargets[enemy.networkID].buff
                if buff and buff.count > 0 then
                    local eLvl = myHero:GetSpellData(_E).level
                    local baseDmg = 10 + 10 * eLvl + 0.6 * myHero.totalDamage
                    local dmgPerSpear = (eLvl * (eLvl * 0.5 + 2.5) + 7) + (3.75 * eLvl + 16.25) * myHero.totalDamage / 100
                    --
                    return baseDmg + dmgPerSpear * (buff.count - 1)
                end
                return 0
            end ]]
    end

    function Kalista:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "Unkillable", name = "Use on Unkillable", value = false })
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        --Menu.Q:MenuElement({id = "Wall"  , name = "Use to WallJump [Flee Key]", value = true})
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "Draw", name = "Draw Spots", value = false })
        Menu.W:MenuElement({ id = "Key", name = "Send Sentinel [Closest To Mouse]", key = string.byte("G") })
        Menu.W:MenuElement({ id = "Dra", name = "Dragon", value = true })
        Menu.W:MenuElement({ id = "Bar", name = "Baron[Exploit]", value = true })
        Menu.W:MenuElement({ id = "Mid", name = "Mid", value = true })
        Menu.W:MenuElement({ id = "Blu", name = "Blue", value = true })
        Menu.W:MenuElement({ id = "Red", name = "Red", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana % ", value = 0, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 0, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.E:MenuElement({ id = "LastHit", name = "Use on LastHit", value = true })
        Menu.E:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = true })
        Menu.E:MenuElement({ id = "Clear", name = "Use on LaneClear", value = true })
        Menu.E:MenuElement({ id = "Min", name = "Minions To Cast", value = 2, min = 0, max = 6, step = 1 })
        Menu.E:MenuElement({ id = "ManaClear", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "Epic", name = "Steal Baron / Dragon", value = true })
        Menu.E:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.E:MenuElement({ id = "Dying", name = "Use When Dying", value = false })
        Menu.E:MenuElement({ id = "MinHP", name = " HP <= X % ", value = 15, min = 5, max = 100, step = 5 })
        Menu.E:MenuElement({ id = "DmgMod", name = "Dmg Calc Multiplier[0.9 would overkill 10%]", value = 1, min = 0.50,
            max = 1.50, step = 0.01 })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.R:MenuElement({ id = "Count", name = "Min Enemies Around", value = 2, min = 1, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.R:MenuElement({ name = " ", drop = { "Oath Settings" } })
        Menu.R:MenuElement({ id = "Save", name = "Save Ally", value = true })
        Menu.R:MenuElement({ id = "MinHP", name = "When HP % < X", value = 20, min = 1, max = 100, step = 1 })
        Menu.R:MenuElement({ name = " ", drop = { "Balista Settings" } })
        Menu.R:MenuElement({ id = "Balista", name = "Pull Enemy", value = true })
        Menu.R:MenuElement({ id = "BalistaHP", name = "Only If HP % > X", value = 20, min = 1, max = 100, step = 1 })
        Menu.R:MenuElement({ id = "Turret", name = "Only Under Turret", value = false })
        --
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
    end

    function Kalista:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.R.Range)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.lastTarget = self.target or self.lastTarget
        self.mode = GetMode()
        --
        if myHero.isChanneling then
            return
        end
        self.rendDmgpercent = {}
        self.rendDmg = {}
        self:SentinelManager()
        self:OathManager()
        self:Auto()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 6 and self:Flee()
        --[[         self.mode == 1 and self:Combo() or
        self.mode == 2 and self:Harass() or
        self.mode == 3 and self:Clear() or
        self.mode == 4 and self:Clear() or
        self.mode == 5 and self:LastHit() or
        self.mode == 6 and self:Flee() ]]
    end

    function Kalista:OnWndMsg(msg, param)
        if param == HK_W then
            DelayAction(function()
                self:FindSentinels()
            end, 0.25)
        end
    end

    function Kalista:OnPreAttack(args)
        local target = args.Target
        local tType = target and target.type
        if not (IsValidTarget(target) and (tType == Obj_AI_Hero or tType == Obj_AI_Minion)) then
            return
        end
        --
        local netID = target.networkID
        local rendTarget = self.recentTargets[netID]
        if not rendTarget then
            self.recentTargets[netID] = { obj = target, buff = GetBuffByName(target, "kalistaexpungemarker") }
        end
    end

    function Kalista:OnAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        local tType = target and target.type
        if not (IsValidTarget(target) and (tType == Obj_AI_Hero or tType == Obj_AI_Minion)) then
            return
        end
        --
        local netID = target.networkID
        local rendTarget = self.recentTargets[netID]
        if not rendTarget then
            self.recentTargets[netID] = { obj = target, buff = GetBuffByName(target, "kalistaexpungemarker") }
        end
    end

    function Kalista:OnUnkillable(minion)
        if self.Q:IsReady() and Menu.Q.Unkillable:Value() and ManaPercent(myHero) >= Menu.Q.ManaClear:Value() then
            local col = mCollision(myHero, minion, self.Q, GetEnemyMinions(self.Q.Range))
            for i = 1, #col do
                local min = col[i]
                if min ~= minion then
                    return
                end
            end
            self.Q:Cast(minion)
        end
    end

    function Kalista:OnLoseVision(unit)
        if self.mode == 1 and self.W:IsReady() and self.lastTarget and unit.valid and not unit.dead and
            unit.networkID == self.lastTarget.networkID then
            if Menu.W.Combo:Value() and ManaPercent(myHero) >= Menu.W.Mana:Value() then
                self.W:Cast(unit.pos)
            end
        end
        self:OnPreAttack(unit)
    end

    function Kalista:Auto()
        if not self.E:IsReady() or ShouldWait() then
            return
        end
        if Menu.E.Dying:Value() and HealthPercent(myHero) < Menu.E.MinHP:Value() then
            self.E:Cast();
            return
        end
        --
        local KS, Epic = Menu.E.KS:Value(), Menu.E.Epic:Value()
        local eCombo = not KS and self.mode == 1 and Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value()
        local eHarass = not (KS or eCombo) and self.mode == 2 and Menu.E.Harass:Value() and
            ManaPercent(myHero) >= Menu.E.ManaHarass:Value()
        local eClear = not (eCombo or eHarass) and
            (
            (self.mode == 3 and Menu.E.Clear:Value()) or (self.mode == 4 and Menu.E.Jungle:Value()) or
                (self.mode == 5 and Menu.E.LastHit:Value())) and ManaPercent(myHero) >= Menu.E.ManaClear:Value()
        --
        if not (KS or Epic or eCombo or eHarass or eClear) then
            return
        end
        local killableMinions, minMinions = 0, Menu.E.Min:Value()
        local manaCheck = myHero.mana >= 60
        --
        for netID, rendData in pairs(self.recentTargets) do
            local target = rendData.obj
            local tType = target.type
            --
            if IsValidTarget(target, self.E.Range) then
                if tType == Obj_AI_Minion and (eClear or Epic) then
                    local DmgPercent = self:DmgPercent(target)
                    if DmgPercent > 100 then
                        killableMinions = killableMinions + 1
                        if target.team == 300 and Epic and
                            (
                            target.charName:lower():find("dragon") or target.charName:lower():find("baron") or
                                target.charName:lower():find("riftherald")) then
                            self.E:Cast();
                            return
                        end
                    end
                elseif tType == Obj_AI_Hero and (KS or eCombo or eHarass) then
                    local DmgPercent = self:DmgPercent(target)
                    if DmgPercent > 100 or (manaCheck and killableMinions >= 1) then
                        self.E:Cast();
                        return
                    end
                end
            end
        end
        --
        if eClear and killableMinions >= minMinions then
            self.E:Cast()
        end
    end

    function Kalista:Combo()
        if #self.enemies >= 1 and not self.target then
            --attack minions to gapclose
        end
        --
        local qTarget = GetTarget(self.Q.Range, 0)
        if qTarget and self.Q:IsReady() and Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            self.Q:CastToPred(qTarget, 2)
        end
    end

    function Kalista:Harass()
        if #self.enemies >= 1 and not self.target then
            --attack minions to gapclose
        end
        --
        local qTarget = GetTarget(self.Q.Range, 0)
        if qTarget and self.Q:IsReady() and Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            self.Q:CastToPred(qTarget, 2)
        end
    end

    function Kalista:Flee()
        --[[         if self.Q:IsReady() and Menu.Q.Wall:Value() then
            --TODO walljump logic
        end ]]
    end

    function Kalista:OnDraw()
        self:DrawSpots()
        if not Menu.Draw.drawEdmg:Value() then return end
        self:UpdateTargets()
        DrawSpells(self, function(enemy)
            local screenPos = enemy.pos:To2D()
            local colorPer, colorNum = Color.Red, Color.Red
            if self:DmgNumber(enemy) > enemy.health then
                colorPer, colorNum = Color.Green, Color.Green
            end
            if not self.E:IsReady() then
                colorPer, colorNum = Color.Gray, Color.Gray
            end
            if screenPos.onScreen then --
                DrawText(tostring(self:DmgPercent(enemy)) .. '%', 40, screenPos.x + 30, screenPos.y + 30, colorPer)
                DrawText(tostring(self:DmgNumber(enemy)) .. ' Dmg', 30, screenPos.x + 60, screenPos.y + 60, colorNum)
            end
        end)
    end

    function Kalista:SentinelManager()
        self:UpdateSentinels()
        if Menu.W.Key:Value() and self.W:IsReady() and Timer() - self.W.LastCast > 1 then
            local closestToMouse, bestDistance = nil, 3000
            for k, spot in pairs(self.SentinelSpots) do
                if GetDistance(spot) <= self.W.Range and spot.obj == nil then
                    local id = k:sub(1, 3)
                    local dist = GetDistance(mousePos, spot)
                    if Menu.W[id]:Value() and dist <= bestDistance then
                        closestToMouse = spot
                        bestDistance = dist
                        self.W.LastSpot = k
                    end
                end
            end
            if closestToMouse then
                self.W:Cast(closestToMouse.pos)
                self.W.LastCast = Timer()
            end
        end
    end

    function Kalista:DrawSpots()
        if Menu.W.Draw:Value() then
            for k, spot in pairs(self.SentinelSpots) do
                if GetDistance(spot) <= self.W.Range then
                    DrawMap(spot.pos, 200, 5, spot.obj and self.Color1 or self.Color2)
                end
            end
        end
    end

    function Kalista:FindSentinels()
        for i = ObjectCount(), 1, -1 do
            local obj = Object(i);
            if not self.W.LastSpot then return end
            if obj and obj.isAlly and obj.charName == 'KalistaSpawn' then
                self.SentinelSpots[self.W.LastSpot].obj = obj
            end
        end
    end

    function Kalista:UpdateSentinels()
        for k, spot in pairs(self.SentinelSpots) do
            local obj = spot.obj
            if not obj or not obj.valid or obj.dead then
                self.SentinelSpots[k].obj = nil
            end
        end
    end

    function Kalista:UpdateTargets()
        local time = Timer()
        --
        for netID, rendData in pairs(self.recentTargets) do
            local buff = rendData.buff
            local enemy = rendData.obj
            if not (enemy and enemy.valid) or enemy.dead then
                self.recentTargets[netID] = nil
            else
                self.recentTargets[netID].buff = GetBuffByName(enemy, "kalistaexpungemarker")
                if enemy.team == 300 then
                    local screenPos = enemy.pos:To2D()
                    local colorPer, colorNum = Color.Red, Color.Red
                    if self:DmgNumber(enemy) > enemy.health then
                        colorPer, colorNum = Color.Green, Color.Green
                    end
                    if not self.E:IsReady() then
                        colorPer, colorNum = Color.Gray, Color.Gray
                    end
                    if screenPos.onScreen then
                        DrawText(tostring(self:DmgPercent(enemy)) .. '%', 40, screenPos.x + 30, screenPos.y + 30,
                            colorPer)
                        DrawText(tostring(self:DmgNumber(enemy)) .. ' Dmg', 30, screenPos.x + 60, screenPos.y + 60,
                            colorNum)
                    end
                end
            end
        end
    end

    function Kalista:DmgPercent(target)
        if self.rendDmgpercent[target.networkID] then
            return self.rendDmgpercent[target.networkID]
        end
        --
        local dmg = floor((self.E:GetDamage(target) * 100 * Menu.E.DmgMod:Value() / (target.health + target.shieldAD)) *
            100) / 100
        self.rendDmgpercent[target.networkID] = dmg
        return dmg
    end

    function Kalista:DmgNumber(target)
        if self.rendDmg[target.networkID] then
            return self.rendDmg[target.networkID]
        end
        --
        local dmg = (self.E:GetDamage(target)) --CalcDamage
        self.rendDmg[target.networkID] = dmg
        return dmg
    end

    function Kalista:GetSwornAlly()
        for i = 1, HeroCount() do
            local hero = Hero(i)
            if hero and not hero.isMe and hero.isAlly and HasBuff(hero, "kalistacoopstrikeally") then
                return hero
            end
        end
    end

    function Kalista:OathManager()
        if not self.swornAlly then
            self.swornAlly = self:GetSwornAlly()
        end
        --
        local ally = self.swornAlly
        if self.R:IsReady() and ally and GetDistance(ally) < self.R.Range then
            local Menu = Menu.R
            --[[Combo Stuff]]
            if self.mode == 1 and Menu.Combo:Value() and ManaPercent(myHero) >= Menu.Mana:Value() then
                if CountEnemiesAround(myHero.pos, self.R.Range) > Menu.Count:Value() then
                    self.R:Cast();
                    return
                end
            end
            --[[Balista Stuff]]
            local balistaBuff = self.supportedAllies[ally.charName]
            local balistaCheck = balistaBuff and (not Menu.Turret:Value() or IsUnderTurret(myHero.pos, TEAM_ALLY))
            if Menu.Balista:Value() and balistaCheck and HealthPercent(myHero) >= Menu.BalistaHP:Value() then
                for i = 1, #self.enemies do
                    local enemy = self.enemies[i]
                    if enemy and HasBuff(enemy, balistaBuff) then
                        self.R:Cast();
                        return
                    end
                end
            end
            --[[Save Ally]]
            if Menu.Save:Value() and HealthPercent(ally) <= Menu.MinHP:Value() then
                self.R:Cast();
                return
            end
        end
    end

    insert(LoadCallbacks, function()
        Kalista()
    end)

elseif myHero.charName == "Lucian" then
    class 'Lucian'
    --Lucian = Class()

    function Lucian:__init()
        --// Data Initialization //--
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"

        self:Spells()
        self:Menu()

        --// Callbacks //--

        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttackTick(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
    end

    function Lucian:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 500,
            Delay = 0.35,
            Speed = huge,
            Radius = 30,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted
        })

        self.Q2 = Spell({
            Slot = 0,
            Range = 1000,
            Delay = 0.35,
            Speed = huge,
            Radius = 30,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted
        })

        self.W = Spell({
            Slot = 1,
            Range = 900,
            Delay = 0.30,
            Speed = 1600,
            Radius = 40,
            Collision = true,
            CollisionTypes = { COLLISION_MINION, COLLISION_ENEMYHERO, COLLISION_YASUOWALL },
            From = myHero,
            Type = SpellTypeSkillShot,
            DmgType = "Magical"
        })

        self.E = Spell({
            Slot = 2,
            Range = 425,
            Type = SpellTypeSkillShot
        })

        self.R = Spell({
            Slot = 3,
            Range = 1200,
            Delay = 0.25,
            Speed = huge,
            Radius = 50,
            Collision = true,
            CollisionTypes = { COLLISION_MINION, COLLISION_ENEMYHERO, COLLISION_YASUOWALL },
            From = myHero,
            Type = SpellTypeSkillShot
        })
        --[[         self.Q.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local qLvl = myHero:GetSpellData(_Q).level
            return 50 + 35 * qLvl + (0.6 + 0.15 * qLvl) * myHero.bonusDamage
        end
        self.W.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local wLvl = myHero:GetSpellData(_W).level
            return (35 + 40 * wLvl + 0.9 * myHero.ap)
        end ]]
    end

    function Lucian:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        -- Q SETTINGS
        Menu.Q:MenuElement({ name = " ", drop = { "Modes" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Combo", value = true })
        Menu.Q:MenuElement({ id = "Harass", name = "Harass", value = true })
        Menu.Q:MenuElement({ id = "KS", name = "KillSteal", value = true })
        Menu.Q:MenuElement({ name = " ", drop = { "Mana Manager" } })
        Menu.Q:MenuElement({ id = "ComboMana", name = "Combo - Min. Mana( % )", value = 0, min = 0, max = 100 })
        Menu.Q:MenuElement({ id = "HarassMana", name = "Harass - Min. Mana( % )", value = 50, min = 0, max = 100 })
        Menu.Q:MenuElement({ name = " ", drop = { "Customization" } })
        Menu.Q:MenuElement({ type = MENU, name = "Harass White List", id = "HarassWhiteList" })
        Menu.Q:MenuElement({ type = MENU, name = "KillSteal White List", id = "KSWhiteList" })

        -- Q2 SETTINGS
        Menu.Q2:MenuElement({ name = " ", drop = { "Modes" } })
        Menu.Q2:MenuElement({ id = "Combo", name = "Combo", value = true })
        Menu.Q2:MenuElement({ id = "Harass", name = "Harass", value = true })
        Menu.Q2:MenuElement({ id = "AutoHarass", name = "Auto Harass", value = true })
        Menu.Q2:MenuElement({ name = " ", drop = { "Mana Manager" } })
        Menu.Q2:MenuElement({ id = "ComboMana", name = "Combo - Min. Mana( % )", value = 0, min = 0, max = 100 })
        Menu.Q2:MenuElement({ id = "HarassMana", name = "Harass - Min. Mana( % )", value = 50, min = 0, max = 100 })
        Menu.Q2:MenuElement({ id = "AutoHarassMana", name = "Auto Harass - Min. Mana( % )", value = 50, min = 0,
            max = 100 })
        Menu.Q2:MenuElement({ name = " ", drop = { "Customization" } })
        Menu.Q2:MenuElement({ type = MENU, name = "Harass White List", id = "HarassWhiteList" })
        Menu.Q2:MenuElement({ type = MENU, name = "Auto Harass White List", id = "AutoHarassWhiteList" })

        -- W SETTINGS
        Menu.W:MenuElement({ name = " ", drop = { "Modes" } })
        Menu.W:MenuElement({ id = "Combo", name = "Combo", value = true })
        Menu.W:MenuElement({ id = "Harass", name = "Harass", value = true })
        Menu.W:MenuElement({ id = "KS", name = "KillSteal", value = true })
        Menu.W:MenuElement({ name = " ", drop = { "Mana Manager" } })
        Menu.W:MenuElement({ id = "ComboMana", name = "Combo - Min. Mana( % )", value = 0, min = 0, max = 100 })
        Menu.W:MenuElement({ id = "HarassMana", name = "Harass - Min. Mana( % )", value = 50, min = 0, max = 100 })
        Menu.W:MenuElement({ name = " ", drop = { "Customization" } })
        Menu.W:MenuElement({ id = "IgnorePred", name = "Ignore Prediction", value = true })
        Menu.W:MenuElement({ id = "IgnoreColl", name = "Ignore Collision", value = true })
        Menu.W:MenuElement({ type = MENU, name = "Harass White List", id = "HarassWhiteList" })
        Menu.W:MenuElement({ type = MENU, name = "KillSteal White List", id = "KSWhiteList" })

        -- E SETTINGS
        Menu.E:MenuElement({ name = " ", drop = { "Modes" } })
        Menu.E:MenuElement({ id = "Combo", name = "Combo", value = true })
        Menu.E:MenuElement({ name = " ", drop = { "Mana Manager" } })
        Menu.E:MenuElement({ id = "ComboMana", name = "Combo - Min. Mana( % )", value = 0, min = 0, max = 100 })
        Menu.E:MenuElement({ name = " ", drop = { "Customization" } })
        Menu.E:MenuElement({ name = "E Cast Mode", id = "Mode", value = 1, drop = { "To Side", "To Mouse", "To Target" } })

        -- R SETTINGS
        Menu.R:MenuElement({ name = " ", drop = { "Modes" } })
        Menu.R:MenuElement({ id = "Combo", name = "Combo", value = true })
        Menu.R:MenuElement({ name = " ", drop = { "Mana Manager" } })
        Menu.R:MenuElement({ id = "ComboMana", name = "Combo - Min. Mana( % )", value = 0, min = 0, max = 100 })
        Menu.R:MenuElement({ name = " ", drop = { "Customization" } })
        Menu.R:MenuElement({ id = "Magnet", name = "Target Magnet", value = true })
        Menu.R:MenuElement({ type = MENU, name = "Combo White List", id = "ComboWhiteList" })


        -- OTHER
        Menu:MenuElement({ name = " ", drop = { "Extra Settings" } })
        Menu:MenuElement({ name = "Combo Rotation Priority", id = "ComboRotation", value = 3, drop = { "Q", "W", "E" } })
        Menu:MenuElement({ name = " ", drop = { "Script Info" } })
        Menu:MenuElement({ name = myHero.charName .. " Script version: ", drop = { self.scriptVersion } })

        ObjectManager:OnEnemyHeroLoad(function(args)
            local unit = args.unit
            local charName = args.charName
            Menu.Q.HarassWhiteList:MenuElement({ name = unit.charName, id = unit.charName, value = true })
            Menu.Q.KSWhiteList:MenuElement({ name = unit.charName, id = unit.charName, value = true })

            Menu.Q2.HarassWhiteList:MenuElement({ name = unit.charName, id = unit.charName, value = true })
            Menu.Q2.AutoHarassWhiteList:MenuElement({ name = unit.charName, id = unit.charName, value = true })

            Menu.W.HarassWhiteList:MenuElement({ name = unit.charName, id = unit.charName, value = true })
            Menu.W.KSWhiteList:MenuElement({ name = unit.charName, id = unit.charName, value = true })

            Menu.R.ComboWhiteList:MenuElement({ name = unit.charName, id = unit.charName, value = true })
        end)
    end

    function Lucian:EnoughMana(value)
        return ManaPercent(myHero) >= value
    end

    function Lucian:WhiteListValue(menu, target)
        return menu and menu[target.charName] and menu[target.charName]:Value()
    end

    function Lucian:ClosestToMouse(p1, p2)
        return (GetDistance(mousePos, p1) > GetDistance(mousePos, p2)) and p2 or p1
    end

    function Lucian:DashRange(target)
        local pred = target:GetPrediction(huge, 0.25)
        return GetDistance(pred) < (myHero.range + target.boundingRadius + myHero.boundingRadius) and 125 or 425
    end

    function Lucian:CastQExtended(target)
        if self.Q2:IsReady() and self.Q2:CanCast(target) then
            local position, castPosition, hitChance = self.Q2:GetPrediction(target)

            if castPosition and hitChance >= HITCHANCE_NORMAL then
                local targetPos = myHero.pos:Extended(castPosition, self.Q2.Range)

                for i = 1, #self.minions do
                    local minion = self.minions[i]
                    if minion and self.Q:CanCast(minion) then
                        local minionPos = myHero.pos:Extended(minion.pos, self.Q2.Range)

                        if GetDistance(targetPos, minionPos) <= self.Q2.Radius + target.boundingRadius then
                            self.Q:Cast(minion)
                        end
                    end
                end
            end
        end
    end

    function Lucian:CastW(target, checkPrediction, checkCollision)
        if self.W:IsReady() and self.W:CanCast(target) then
            --self.W.Collision = not checkCollision

            local position, castPosition, hitChance = self.W:GetPrediction(target)
            --castPosition = checkPrediction and target.pos or castPosition

            if castPosition and hitChance >= HITCHANCE_NORMAL then
                self.W:Cast(castPosition)
            end
        end
    end

    function Lucian:CastE(target, castMode, castRange)
        if castMode == 1 then
            local c1, c2, r1, r2 = myHero.pos, target.pos, myHero.range, 525
            local O1, O2 = CircleCircleIntersection(c1, c2, r1, r2)

            if O1 and O2 then
                local closestPoint = Vector(self:ClosestToMouse(O1, O2))
                local castPos = c1:Extended(closestPoint, castRange)

                self.E:Cast(castPos)
            end
        elseif castMode == 2 then
            local castPos = myHero.pos:Extended(mousePos, castRange)

            self.E:Cast(castPos)
        elseif castMode == 3 then
            local castPos = myHero.pos:Extended(target.pos, castRange)

            self.E:Cast(castPos)
        end
    end

    function Lucian:Combo()
        local target = self.target
        if not target or not (self.Q:IsReady() or self.W:IsReady() or self.E:IsReady()) then
            if self.R:IsReady() then
                local useR = Menu.R.Combo:Value()
                local mana = Menu.R.ComboMana:Value()
                local rTarg = GetTarget(self.R.Range, 0)
                if useR and self:EnoughMana(mana) and rTarg and self:WhiteListValue(Menu.R.ComboWhiteList, rTarg) then
                    self.R:CastToPred(rTarg, 2)
                end
            end
            return
        end

        local useQ2 = Menu.Q2.Combo:Value()
        local mana = Menu.Q2.ComboMana:Value()
        if useQ2 and self:EnoughMana(mana) then
            self:CastQExtended(target)
        end
    end

    function Lucian:Harass()
        local target = self.target
        if not target then
            return
        end

        local useQ1 = Menu.Q.Harass:Value()
        local manaQ1 = Menu.Q.HarassMana:Value()
        if useQ1 and self.Q:IsReady() and self.Q:CanCast(target) and self:EnoughMana(manaQ1) and
            self:WhiteListValue(Menu.Q.HarassWhiteList, target) then
            self.Q:Cast(target)
        end

        local useQ2 = Menu.Q2.Harass:Value()
        local manaQ2 = Menu.Q2.HarassMana:Value()
        if useQ2 and self:EnoughMana(manaQ2) and self:WhiteListValue(Menu.Q2.HarassWhiteList, target) then
            self:CastQExtended(target)
        end

        local useW = Menu.W.Harass:Value()
        local manaW = Menu.W.HarassMana:Value()
        if useW and self:EnoughMana(manaW) and self:WhiteListValue(Menu.W.HarassWhiteList, target) then
            self:CastW(target, false, false)
        end
    end

    function Lucian:AutoHarass()
        local target = self.target
        if not target then
            return
        end

        local useQ2 = Menu.Q2.AutoHarass:Value()
        local manaQ2 = Menu.Q2.AutoHarassMana:Value()
        if useQ2 and self:EnoughMana(manaQ2) and self:WhiteListValue(Menu.Q2.AutoHarassWhiteList, target) then
            self:CastQExtended(target)
        end
    end

    function Lucian:KillSteal()
        local useQ = Menu.Q.KS:Value()
        local useW = Menu.W.KS:Value()

        for i = 1, #(self.enemies) do
            local unit = self.enemies[i]
            local health = unit.health
            local shield = unit.shieldAD
            if self.Q:IsReady() and self.Q:CanCast(unit) and useQ and self:WhiteListValue(Menu.Q.KSWhiteList, unit) then
                local damage = self.Q:CalcDamage(unit)

                if health + shield < damage then
                    self.Q:Cast(unit)
                end
            end

            if self.W:IsReady() and self.W:CanCast(unit) and useW and self:WhiteListValue(Menu.W.KSWhiteList, unit) then
                local damage = self.W:CalcDamage(unit)

                if health + shield < damage then
                    self:CastW(unit, false, false)
                end
            end
        end
    end

    function Lucian:Tick()
        if ShouldWait() then
            return
        end

        self.mode = GetMode()
        self.target = GetTarget(self.Q2.Range, 0)
        self.enemies = GetEnemyHeroes(self.W.Range)
        self.minions = GetEnemyMinions(self.Q2.Range)

        if myHero.isChanneling then
            return
        end

        self:AutoHarass()
        self:KillSteal()

        if not self.mode then
            return
        end

        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass()
    end

    function Lucian:OnDraw()
        local rTarg = self.target or GetTarget(self.R.Range, 0)
        if self.mode == 1 and Menu.R.Magnet:Value() and HasBuff(myHero, "LucianR") and rTarg then
            local enemyMovement = rTarg:GetPrediction(huge, 0.3) - rTarg.pos
            self.moveTo = myHero.pos + enemyMovement
        else
            self.moveTo = nil
        end
        DrawSpells(self, function(enemy)
            if Menu and Menu.Draw.Q:Value() and self.Q2 then
                self.Q2:Draw(66, 244, 113)
            end
        end)
    end

    function Lucian:OnPreMovement(args)
        if ShouldWait() then
            args.Process = false
            return
        end
        --R Magnet logic
        if self.moveTo then
            if GetDistance(self.moveTo) < 20 then
                if myHero.pathing.hasMovePath then
                    args.Target = myHero.pos
                else
                    args.Process = false
                end
            elseif not MapPosition:inWall(self.moveTo) then
                if GetDistance(self.moveTo) >= self.E.Range and self.E:IsReady() then
                    self.E:Cast(self.moveTo)
                end
                args.Target = self.moveTo
            end
        end
    end

    function Lucian:OnPreAttack(args)
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Lucian:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        if not IsValidTarget(target) then
            return
        end
        local target_type = target.type

        if target_type == Obj_AI_Hero then
            if self.mode == 1 then
                local comboRotation = Menu.ComboRotation:Value() - 1
                if Menu.Q.Combo:Value() and (comboRotation == _Q or GameCanUseSpell(comboRotation) ~= READY) and
                    self.Q:IsReady() and GetDistance(target) <= self.Q.Range then
                    self.Q:Cast(target)
                elseif Menu.E.Combo:Value() and (comboRotation == _E or GameCanUseSpell(comboRotation) ~= READY) and
                    self.E:IsReady() and GetDistance(target) <= (self.E.Range + myHero.range) then
                    local castMode = Menu.E.Mode:Value()
                    local castRange = self:DashRange(target)

                    self:CastE(target, castMode, castRange)
                elseif Menu.W.Combo:Value() and (comboRotation == _W or GameCanUseSpell(comboRotation) ~= READY) and
                    self.W:IsReady() and GetDistance(target) <= self.W.Range then
                    local checkPrediction = Menu.W.IgnorePred:Value() --true and Menu.W.Ignore_:Value() or false
                    local checkCollision = Menu.W.IgnoreColl:Value() --true and Menu.W.Ignore_:Value() or false

                    self:CastW(target, checkPrediction, checkCollision)
                end
            end
        end
    end

    insert(LoadCallbacks, function()
        Lucian()
    end)

elseif myHero.charName == "Olaf" then

    --Written by JSN and provided on:
    --http://gamingonsteroids.com/topic/24468-817-project-winrate-v18-smoother-aa-resetsgsoorb-supported/?p=180176

    class 'Olaf'
    --Olaf = Class()

    function Olaf:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        --Callback.Add("Load",          function() self:OnLoad()    end) --Just Use OnLoad()
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttack(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Olaf:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 1000,
            Delay = 0.25,
            Speed = 1550,
            Radius = 70,
            Collision = true, -- was false
            CollisionTypes = { COLLISION_YASUOWALL }, --
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.W = Spell({
            Slot = 1,
            Range = 250, -- trigger range
            Delay = 0.25,
            Speed = huge,
            Radius = huge,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.E = Spell({
            Slot = 2,
            Range = 325,
            Delay = 0.25,
            Speed = 20,
            Radius = huge,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted,
            DmgType = "True"
        })
        self.R = Spell({
            Slot = 3,
            Range = 400,
            Delay = 0.25,
            Speed = 500,
            Radius = huge,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        --[[         self.Q.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local qLvl = myHero:GetSpellData(_Q).level
            return 35 + 45 * qLvl + myHero.bonusDamage
        end
        self.E.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local eLvl = myHero:GetSpellData(_E).level
            return 25 + 45 * eLvl + 0.5 * myHero.totalDamage
        end ]]
    end

    function Olaf:Menu()
        self.Allies, self.Enemies = {}, {}
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = true })
        Menu.Q:MenuElement({ id = "Clear", name = "Use on LaneClear", value = true })
        Menu.Q:MenuElement({ id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 8, step = 1 })
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.Q:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        Menu.Q:MenuElement({ id = "Auto", name = "Auto Use on Dashing Enemies", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana % ", value = 15, min = 0, max = 100, step = 1 })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.E:MenuElement({ id = "MinHP", name = "Min Health % ", value = 5, min = 0, max = 50, step = 1 })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.R:MenuElement({ id = "Auto", name = "Use if Hard CC'ed", value = true })
        Menu.R:MenuElement({ id = "Min", name = "Min Duration", value = 0.5, min = 0, max = 3, step = 0.1 })
        --Items--
        Menu:MenuElement({ id = "Items", name = "Items Settings", type = MENU })
        Menu.Items:MenuElement({ id = "Tiamat", name = "Use Tiamat", value = true })
        Menu.Items:MenuElement({ id = "TitanicHydra", name = "Use Titanic Hydra", value = true })
        Menu.Items:MenuElement({ id = "Hydra", name = "Use Ravenous Hydra", value = true })
        Menu.Items:MenuElement({ id = "Youmuu", name = "Use Youmuu's", value = true })

        Menu:MenuElement({ name = " ", drop = { " " } })
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        Menu:MenuElement({ name = "Olaf Module Created By", drop = { "JSN" } })
    end

    function Olaf:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.Q.Range)
        self.target = GetTarget(self.Q.Range, 0)
        self.mode = GetMode()
        --
        self:UpdateItems()
        self:KillSteal()
        self:Auto()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 3 and self:Clear() or
            self.mode == 4 and self:Clear() or
            self.mode == 6 and self:Flee()
    end

    function Olaf:OnPreMovement(args)
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Olaf:OnPreAttack(args)
        if ShouldWait() then
            args.Process = false
            return
        end
        --
        if self.W:IsReady() then
            local isHero = args.Target and args.Target.type and args.Target.type == Obj_AI_Hero
            local comboCheck = self.mode == 1 and Menu.W.Combo:Value() and ManaPercent(myHero) >= Menu.W.Mana:Value()
            local harassCheck = self.mode == 2 and Menu.W.Harass:Value() and
                ManaPercent(myHero) >= Menu.W.ManaHarass:Value()
            if isHero and (comboCheck or harassCheck) then
                self.W:Cast()
            end
        end
    end

    function Olaf:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        if ShouldWait() or not IsValidTarget(target) then
            return
        end
        --
        if self.mode == 1 or self.mode == 2 then
            self:UseItems(target)
        end
    end

    function Olaf:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() then
            return
        end
        --
        if unit.team == TEAM_ENEMY and Menu.Q.Auto:Value() and self.Q:IsReady() and IsValidTarget(unit, 500) then
            if IsFacing(unit, myHero) or GetDistance(unitPosTo) > 300 then
                self.Q:CastToPred(unit, 3)
            end
        end
    end

    function Olaf:Auto()
        if Menu.R.Auto:Value() and IsImmobile(myHero, Menu.R.Min:Value()) then
            self.R:Cast()
        end
    end

    function Olaf:KillSteal()
        if self.enemies then
            for i = 1, #self.enemies do
                local enemy = self.enemies[i]
                if GetDistance(enemy) <= self.E.Range and Menu.E.KS:Value() and self.E:IsReady() and
                    self.E:CalcDamage(enemy) >= enemy.health then
                    self.E:Cast(enemy)
                elseif Menu.Q.KS:Value() and self.Q:IsReady() and
                    self.Q:CalcDamage(enemy) >= enemy.health + enemy.shieldAD then
                    self.Q:CastToPred(enemy, 2)
                end
            end
        end
    end

    function Olaf:Combo()
        local qTarget = GetTarget(self.Q.Range, 0)
        if qTarget and Menu.Q.Combo:Value() and self.Q:IsReady() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            self.Q:CastToPred(qTarget, 2)
        end
        --
        local eTarget = GetTarget(self.E.Range, 2)
        if eTarget and Menu.E.Combo:Value() and self.E:IsReady() and HealthPercent(myHero) >= Menu.E.MinHP:Value() then
            self.E:Cast(eTarget)
        end
        --
        if self.target then
            self:Youmuu(self.target)
        end
    end

    function Olaf:Harass()
        local qTarget = GetTarget(self.Q.Range, 0)
        if qTarget and Menu.Q.Harass:Value() and self.Q:IsReady() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() then
            self.Q:CastToPred(qTarget, 2)
        end
        --
        local eTarget = GetTarget(self.E.Range, 2)
        if eTarget and Menu.E.Harass:Value() and self.E:IsReady() and HealthPercent(myHero) >= Menu.E.MinHP:Value() then
            self.E:Cast(eTarget)
        end
    end

    function Olaf:Clear()
        local qRange, jCheckQ, lCheckQ = self.Q.Range, Menu.Q.Jungle:Value(), Menu.Q.Clear:Value()
        if self.Q:IsReady() and (jCheckQ or lCheckQ) and ManaPercent(myHero) >= Menu.Q.ManaClear:Value() then
            local minions = (jCheckQ and GetMonsters(qRange)) or {}
            minions = (#minions == 0 and lCheckQ and GetEnemyMinions(qRange)) or minions
            if #minions == 0 then
                return
            end
            --
            local pos, hit = GetBestLinearCastPos(self.Q, nil, minions)
            if pos and hit >= Menu.Q.Min:Value() or (minions[1] and minions[1].team == TEAM_JUNGLE) then
                self.Q:Cast(pos)
            end
        end
    end

    function Olaf:Flee()
        if #self.enemies > 0 and Menu.Q.Flee:Value() and self.Q:IsReady() then
            local qTarget = GetClosestEnemy()
            if IsValidTarget(qTarget, self.Q.Range) then
                self.Q:CastToPred(qTarget, 2)
            end
        end
    end

    function Olaf:OnDraw()
        DrawSpells(self)
    end

    function Olaf:UpdateItems()
        for i = ITEM_1, ITEM_7 do
            local id = myHero:GetItemData(i).itemID
            --[[In Case They Sell Items]]
            if self.Youmuus and i == self.Youmuus.Index and id ~= 3142 then
                self.Youmuus = nil
            elseif self.Tiamat and i == self.Tiamat.Index and id ~= 3077 then
                self.Tiamat = nil
            elseif self.Hidra and i == self.Hidra.Index and id ~= 3074 then
                self.Hidra = nil
            elseif self.Titanic and i == self.Titanic.Index and id ~= 3748 then
                self.Titanic = nil
            end
            ---
            if id == 3142 then
                self.Youmuus = { Index = i, Key = ItemHotKey[i] }
            elseif id == 3077 then
                self.Tiamat = { Index = i, Key = ItemHotKey[i] }
            elseif id == 3074 then
                self.Hidra = { Index = i, Key = ItemHotKey[i] }
            elseif id == 3748 then
                self.Titanic = { Index = i, Key = ItemHotKey[i] }
            end
        end
    end

    function Olaf:UseItems(target)
        if self.Tiamat or self.Hidra then
            self:Hydra(target)
        elseif self.Titanic then
            self:TitanicHydra(target)
        end
    end

    function Olaf:UseItem(key, reset)
        KeyDown(key)
        KeyUp(key)
        return reset and DelayAction(function()
            ResetAutoAttack()
        end, 0.2)
    end

    function Olaf:Youmuu(target)
        if self.Youmuus and Menu.Items.Youmuu:Value() and myHero:GetSpellData(self.Youmuus.Index).currentCd == 0 and
            IsValidTarget(target, 600) then
            self:UseItem(self.Youmuus.Key, false)
        end
    end

    function Olaf:TitanicHydra(target)
        if self.Titanic and Menu.Items.TitanicHydra:Value() and myHero:GetSpellData(self.Titanic.Index).currentCd == 0
            and IsValidTarget(target, 380) then
            self:UseItem(self.Titanic.Key, true)
        end
    end

    function Olaf:Hydra(target)
        if self.Hidra and Menu.Items.Hydra:Value() and myHero:GetSpellData(self.Hidra.Index).currentCd == 0 and
            IsValidTarget(target, 380) then
            self:UseItem(self.Hidra.Key, true)
        elseif self.Tiamat and Menu.Items.Tiamat:Value() and myHero:GetSpellData(self.Tiamat.Index).currentCd == 0 and
            IsValidTarget(target, 380) then
            self:UseItem(self.Tiamat.Key, true)
        end
    end

    insert(LoadCallbacks, function()
        Olaf()
    end)

elseif myHero.charName == "Riven" then

    class 'Riven'
    --Riven = Class()

    function Riven:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Tick", function()
            self:OnProcessSpell()
        end)
        Callback.Add("Tick", function()
            self:OnSpellLoop()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        Callback.Add("WndMsg", function(msg, param)
            self:OnWndMsg(msg, param)
        end)
        --[[Orb Callbacks]]
        OnAttack(function(...)
            self:OnAttack(...)
        end)
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttack(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
    end

    function Riven:Spells()
        self.Flash = myHero:GetSpellData(SUMMONER_1).name:find("Flash") and { Index = SUMMONER_1, Key = HK_SUMMONER_1 }
            or
            myHero:GetSpellData(SUMMONER_2).name:find("Flash") and { Index = SUMMONER_2, Key = HK_SUMMONER_2 } or nil
        self.Q = Spell({
            Slot = 0,
            Range = 275,
            Delay = 0.25,
            Speed = huge,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted
        })
        self.W = Spell({
            Slot = 1,
            Range = 250,
            Delay = 0.25,
            Speed = huge,
            Radius = 260,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.E = Spell({
            Slot = 2,
            Range = 250,
            Delay = 0.25,
            Speed = 2500,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.R1 = Spell({
            Slot = 3,
            Range = huge,
            Delay = 0.5,
            Speed = huge,
            Radius = huge,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.R2 = Spell({
            Slot = 3,
            Range = 1100,
            Delay = 0.25,
            Speed = huge,
            Radius = 200,
            Collision = true,
            CollisionTypes = { COLLISION_YASUOWALL },
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.Q.Stacks = 0
        self.Q.LastCast = Timer()
        --[[         self.Q.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local qLvl = myHero:GetSpellData(_Q).level
            return 15 * qLvl + (0.45 + 0.05 * qLvl) * myHero.totalDamage
        end
        self.W.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local wLvl = myHero:GetSpellData(_W).level
            return 25 + 30 * wLvl + myHero.bonusDamage
        end
        self.R2.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local rLvl = myHero:GetSpellData(_W).level
            local mod = 1 + ((100 - HealthPercent(enemy)) * 0.02667)
            --
            return (50 + 50 * rLvl + 0.6 * myHero.bonusDamage) * mod
        end
 ]]
    end

    function Riven:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "JungleClear", name = "Use on JungleClear", value = false })
        Menu.Q:MenuElement({ id = "LaneClear", name = "Use on LaneClear", value = false })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.Q:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        Menu.Q:MenuElement({ id = "Alive", name = "Keep Alive", value = false })
        Menu.Q:MenuElement({ id = "Delay", name = "Animation Cancelling", type = MENU })
        Menu.Q.Delay:MenuElement({ id = "Q1", name = "Extra Q1 Delay", value = 100, min = 0, max = 200 })
        Menu.Q.Delay:MenuElement({ id = "Q2", name = "Extra Q2 Delay", value = 100, min = 0, max = 200 })
        Menu.Q.Delay:MenuElement({ id = "Q3", name = "Extra Q3 Delay", value = 100, min = 0, max = 200 })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.W:MenuElement({ id = "JungleClear", name = "Use on JungleClear", value = false })
        Menu.W:MenuElement({ id = "LaneClear", name = "Use on LaneClear", value = false })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "AutoStun", name = "Auto Stun Nearby", value = 2, min = 0, max = 5, step = 1 })
        Menu.W:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.W:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.E:MenuElement({ id = "JungleClear", name = "Use on JungleClear", value = false })
        Menu.E:MenuElement({ id = "LaneClear", name = "Use on LaneClear", value = false })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "KS", name = "Use to Allow KS", value = true })
        Menu.E:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "R1 Settings" } })
        Menu.R:MenuElement({ id = "ComboR1", name = "Use on Combo", value = true })
        Menu.R:MenuElement({ id = "Heroes", name = "Combo Targets", type = MENU })
        Menu.R:MenuElement({ id = "DmgPercent", name = "Min. Damage Percent to Cast", value = 100, min = 50, max = 200 })
        Menu.R:MenuElement({ id = "MinHealth", name = "Min. Enemy % Health to Cast", value = 5, min = 1, max = 100 })
        Menu.R:MenuElement({ name = " ", drop = { "R2 Settings" } })
        Menu.R:MenuElement({ id = "ComboR2", name = "Use R2 on Combo", value = true })
        Menu.R:MenuElement({ id = "KS", name = "Use To KS", value = true })
        --
        Menu:MenuElement({ name = " ", drop = { "Extra Features" } })
        --Burst
        Menu:MenuElement({ id = "Burst", name = "Burst Settings", type = MENU })
        Menu.Burst:MenuElement({ id = "Flash", name = "Allow Flash On Burst", value = true })
        Menu.Burst:MenuElement({ id = "ShyKey", name = "Shy Burst Key", key = string.byte("G") })
        Menu.Burst:MenuElement({ id = "WerKey", name = "Werhli Burst Key", key = string.byte("T") })
        --Items
        Menu:MenuElement({ id = "Items", name = "Items Settings", type = MENU })
        Menu.Items:MenuElement({ id = "Tiamat", name = "Use Tiamat", value = true })
        Menu.Items:MenuElement({ id = "TitanicHydra", name = "Use Titanic Hydra", value = true })
        Menu.Items:MenuElement({ id = "Hydra", name = "Use Ravenous Hydra", value = true })
        Menu.Items:MenuElement({ id = "Youmuu", name = "Use Youmuu's", value = true })
        --
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
        ObjectManager:OnEnemyHeroLoad(function(args)
            Menu.R.Heroes:MenuElement({ id = args.charName, name = args.charName, value = true })
        end)
    end

    function Riven:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.R2.Range)
        self.target = GetTarget(self.R2.Range, 0)
        self.mode = GetMode()
        --
        self:UpdateSpells()
        self.BurstMode = self:GetActiveBurst()

        ----
        if self.BurstMode ~= 0 then
            return
        end
        self:Auto()
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 3 and self:Clear() or
            self.mode == 4 and self:Clear() or
            self.mode == 6 and self:Flee()
    end

    function Riven:OnWndMsg(msg, param)
        DelayAction(function()
            self:UpdateItems()
        end, 0.1)
        if msg ~= 257 then
            return
        end
        --
        local spell
        if param == HK_Q then
            spell = "RivenTriCleave"
        elseif param == HK_E then
            spell = "RivenFeint"
        end
        if not spell then
            return
        end
        --
        if self.mode and self.mode == 1 then
            self:OnProcessSpellCombo(spell)
        elseif self.BurstMode == 1 then
            self:OnProcessSpellShy(spell)
        elseif self.BurstMode == 2 then
            self:OnProcessSpellWer(spell)
        end
    end

    function Riven:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Riven:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Riven:OnAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        if ShouldWait() or not IsValidTarget(target) then
            return
        end
        --
        if self.mode == 1 or self.mode == 2 then
            self:UseItems(target)
        end
    end

    function Riven:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target) or GetTarget(400, 0)
        if ShouldWait() or not IsValidTarget(target) then
            return
        end
        --
        if self.BurstMode == 1 then
            self:AfterAttackShy(target)
        elseif self.BurstMode == 2 then
            self:AfterAttackWer(target)
        end
        --
        if not self.mode then
            return
        end
        if self.mode == 1 then
            self:AfterAttackCombo(target)
        elseif self.mode == 2 then
            self:AfterAttackHarass(target)
        end
    end

    function Riven:Auto()
        --
        local time = Timer()
        local qBuff = GetBuffByName(myHero, "RivenTriCleave")
        if qBuff and qBuff.expireTime >= time and Menu.Q.Alive:Value() and qBuff.expireTime - time <= 0.3 and
            not IsUnderTurret(myHero.pos + myHero.dir * self.Q.Range, TEAM_ENEMY) then
            self.Q:Cast(mousePos)
        end
        --
        local minW = Menu.W.AutoStun:Value()
        if minW ~= 0 and self.W:IsReady() and #(GetEnemyHeroes(self.W.Range)) >= minW then
            self.W:Cast()
        end
        --
        if self:IsR2() and (Menu.R.KS:Value() or (Menu.R.ComboR2:Value() and self.mode == 1)) then
            for i = 1, #self.enemies do
                local target = self.enemies[i]
                if IsValidTarget(target) then
                    --checks for immortal and etc
                    local dmg = self.R2:CalcDamage(target)
                    if dmg > target.health + target.shieldAD then
                        self:CastR2(target, 2)
                    end
                end
            end
            --
            local rBuff = GetBuffByName(myHero, "rivenwindslashready")
            if rBuff and rBuff.expireTime >= time and rBuff.expireTime - time <= 1 or HealthPercent(myHero) <= 20 then
                local targ = GetTarget(self.R2.Range, 0)
                self:CastR2(targ, 1)
            end
        end
    end

    function Riven:Combo()
        local target = GetTarget(900, 0)
        if not target then
            return
        end
        --
        local attackRange, dist = GetTrueAttackRange(myHero), GetDistance(target)
        if Menu.E.Combo:Value() and self.E:IsReady() and dist <= 600 and dist > attackRange then
            self:CastE(target)
        end
        self:CastYoumuu(target)
        if Menu.Q.Combo:Value() and self.Q:IsReady() and dist <= attackRange + self.Q.Range and dist > attackRange and
            Timer() - self.Q.LastCast > 1.1 and not myHero.pathing.isDashing then
            self:CastQ(target)
        end
        if Menu.W.Combo:Value() and self.W:IsReady() and dist <= self.W.Range then
            self:CastW(target)
        end
        self:UseItems(target)
        if Menu.R.ComboR1:Value() and self.R1:IsReady() and dist <= 600 and
            target.health < self:TotalDamage(target) * Menu.R.DmgPercent:Value() / 100 then
            self:CastR1(target)
        end
    end

    function Riven:OnProcessSpellCombo(spell)
        local target = GetTarget(self.R2.Range, 0)
        if not (spell and target) then
            return
        end
        local dist = GetDistance(target)
        if spell:find("Tiamat") then
            if Menu.W.Combo:Value() and self.W:IsReady() and dist <= self.W.Range then
                self.W:Cast()
            elseif self.Q:IsReady() and dist <= 400 then
                self:CastQ(target)
            end
        elseif spell:find("RivenMartyr") then
            if Menu.R.ComboR2:Value() and self.R1:IsReady() and self:IsR2() then
                self:CheckCastR2(target)
            end
        elseif spell:find("RivenFeint") then
            self:UseItems(target)
            if Menu.R.ComboR1:Value() and self.R1:IsReady() and dist <= 600 and
                target.health < self:TotalDamage(target) * Menu.R.DmgPercent:Value() / 100 then
                self:CastR1(target)
            elseif Menu.W.Combo:Value() and self.W:IsReady() and dist <= self.W.Range then
                self.W:Cast()
            elseif self.Q:IsReady() and dist <= 400 then
                self:CastQ(target)
            elseif Menu.R.ComboR2:Value() and self.R1:IsReady() and self:IsR2() then
                self:CheckCastR2(target)
            end
        elseif spell:find("RivenFengShuiEngine") then
            if Menu.W.Combo:Value() and self.W:IsReady() and dist <= self.W.Range then
                self.W:Cast()
            end
        elseif spell:find("RivenIzunaBlade") and self.Q.Stacks == 2 then
            if self.Q:IsReady() and dist <= 400 and myHero.attackData.state ~= STATE_WINDUP then
                self:CastQ(target)
            end
        end
    end

    function Riven:AfterAttackCombo(target)
        local dist = GetDistance(target)
        if Menu.Q.Combo:Value() and self.Q:IsReady() and dist <= 400 then
            self:CastQ(target)
        elseif Menu.R.ComboR2:Value() and self.R1:IsReady() and self.Q:IsReady() then
            self:CheckCastR2(target)
        elseif Menu.W.Combo:Value() and self.W:IsReady() and dist <= self.W.Range then
            self:CastW(target)
        elseif Menu.E.Combo:Value() and not self.Q:IsReady() and not self.W:IsReady() and self.E:IsReady() and
            dist <= 400 then
            self:CastE(target)
        end
    end

    function Riven:Harass()
        local target = GetTarget(900, 0)
        if not target then
            return
        end
        local attackRange = GetTrueAttackRange(myHero)
        if Menu.E.Harass:Value() and self.E:IsReady() and target.distance <= 600 and target.distance > attackRange then
            self:CastE(target)
        end
        if Menu.Q.Harass:Value() and self.Q:IsReady() and target.distance <= attackRange + self.Q.Range and
            target.distance > attackRange and Timer() - self.Q.LastCast > 1.1 and not myHero.pathing.isDashing then
            self:CastQ(target)
        end
        if Menu.W.Harass:Value() and self.W:IsReady() and target.distance <= self.W.Range then
            self:CastW(target)
        end
        self:UseItems(target)
    end

    function Riven:AfterAttackHarass(target)
        if Menu.Q.Harass:Value() and target.distance <= 400 then
            self:CastQ(target)
        elseif Menu.W.Harass:Value() and target.distance <= self.W.Range then
            self:CastW(target)
        elseif Menu.E.Harass:Value() and not self.Q:IsReady() and not self.W:IsReady() and target.distance <= 400 then
            self:CastE(target)
        end
    end

    function Riven:Clear()
        local monsters = GetMonsters(self.E.Range)
        if #monsters > 0 then
            local qJungle, wJungle, eJungle = self.Q:IsReady() and Menu.Q.JungleClear:Value(),
                self.W:IsReady() and Menu.W.JungleClear:Value(), self.E:IsReady() and Menu.E.JungleClear:Value()
            for i = 1, #monsters do
                self:UseItems(monsters[i])
                if qJungle and monsters[i].distance <= self.Q.Range then
                    self.Q:Cast(monsters[i]);
                    return
                elseif wJungle and monsters[i].distance <= self.W.Range then
                    self:PressKey(HK_W);
                    return
                elseif eJungle then
                    self:PressKey(HK_E);
                    return
                end
            end
        else
            local minions = GetEnemyMinions(self.Q.Range)
            if #minions == 0 then
                return
            end
            --
            local qClear, wClear = self.Q:IsReady() and Menu.Q.LaneClear:Value(),
                self.W:IsReady() and Menu.W.LaneClear:Value()
            for i = 1, #minions do
                local minion = minions[i]
                self:UseItems(minion)
                if wClear and minion.distance <= self.W.Range and self.W:CalcDamage(minion) >= minion.health then
                    self:PressKey(HK_W);
                    return
                elseif qClear and minion.distance <= self.Q.Range and self.Q:CalcDamage(minion) >= minion.health then
                    self:CastQ(minion);
                    return
                end
            end
        end
    end

    function Riven:Flee()
        Orbwalk()
        DelayAction(function()
            if self.W:IsReady() and Menu.W.Flee:Value() and #(GetEnemyHeroes(self.W.Range)) >= 1 then
                self.W:Cast()
            elseif self.E:IsReady() and Menu.E.Flee:Value() then
                self:PressKey(HK_E)
            elseif self.Q:IsReady() and Menu.Q.Flee:Value() then
                self:PressKey(HK_Q)
            end
        end, 0.2)
    end

    function Riven:KillSteal()
    end

    function Riven:OnDraw()
        DrawSpells(self, function(enemy)
            local dmg = self:TotalDamage(enemy)
            if IsValidTarget(enemy) and dmg >= enemy.health + enemy.shieldAD then
                local screenPos = enemy.pos:To2D()
                DrawText("Killable", 20, screenPos.x - 30, screenPos.y, Color.Red)
            end
        end)
    end

    function Riven:ShyCombo()
        local enemy = GetTarget(1500, 0)
        if enemy and enemy.distance <= GetTrueAttackRange(myHero) then
            Orbwalker.ForceTarget = enemy
        else
            Orbwalker.ForceTarget = nil
        end
        Orbwalk()
        if not enemy then
            return
        end
        --
        if Menu.Items.Youmuu:Value() then
            self:CastYoumuu(enemy)
        end
        --
        if self.Flash and Ready(self.Flash.Index) and Menu.Burst.Flash:Value() then
            if IsValidTarget(enemy, 500 + self.Q.Range) then
                if self.E:IsReady() then
                    KeyDown(HK_E)
                    DelayAction(function()
                        KeyUp(HK_E)
                    end, 0.01)
                end
                if self.R1:IsReady() and self:IsR1() then
                    DelayAction(function()
                        self.R1:Cast()
                    end, 0.05)
                end
                if self.W:IsReady() and Ready(self.Flash.Index) and enemy.distance > self.E.Range + 100 then
                    DelayAction(function()
                        local delay = (Latency() < 60 and 0) or (0.1 + Latency() / 1000)
                        DelayAction(function()
                            self.W:Cast()
                        end, delay)
                        Control.CastSpell(self.Flash.Key, enemy.pos:Extended(myHero.pos, 50))
                    end, 0.1)
                end
                if self.W:IsReady() and enemy.distance < self.W.Range then
                    DelayAction(function()
                        self.W:Cast()
                    end, 0.15)
                end
                if self:HasItems() then
                    DelayAction(function()
                        self:UseItems(enemy)
                    end, 0.2)
                end
                if self.R1:IsReady() and self:IsR2() and enemy.distance < self.R2.Range then
                    DelayAction(function()
                        self.R2:Cast(enemy.pos)
                    end, 0.3)
                end
                if self.Q:IsReady() and enemy.distance < self.Q.Range then
                    DelayAction(function()
                        self.Q:Cast(enemy)
                    end, 0.6)
                end
            end
        elseif enemy.distance < self.E.Range + 100 then
            if IsValidTarget(enemy, self.E.Range) then
                if self.E:IsReady() then
                    KeyDown(HK_E)
                    DelayAction(function()
                        KeyUp(HK_E)
                    end, 0.01)
                end
                if self.R1:IsReady() and self:IsR1() then
                    DelayAction(function()
                        self.R1:Cast()
                    end, 0.05)
                end
                if self.W:IsReady() and enemy.distance < self.W.Range then
                    DelayAction(function()
                        self.W:Cast()
                    end, 0.1)
                end
                if self:HasItems() then
                    DelayAction(function()
                        self:UseItems(enemy)
                    end, 0.15)
                end
                if self.R1:IsReady() and self:IsR2() and enemy.distance < self.R2.Range then
                    DelayAction(function()
                        self.R2:Cast(enemy.pos)
                    end, 0.3)
                end
                if self.Q:IsReady() and enemy.distance < self.Q.Range then
                    DelayAction(function()
                        self.Q:Cast(enemy)
                    end, 0.6)
                end
            end
        end
    end

    function Riven:OnProcessSpellShy(spell)
        local target = GetTarget(1500, 0)
        if not (spell and target) then
            return
        end
        --
        if spell:find("Tiamat") then
            if self.W:IsReady() and target.distance <= self.W.Range then
                self.W:Cast()
            elseif self.Q:IsReady() and target.distance <= 400 then
                self:CastQ(target)
            end
        elseif spell:find("RivenFeint") then
            if self.R1:IsReady() and self:IsR1() then
                self.R1:Cast()
            elseif self.W:IsReady() and target.distance <= self.W.Range then
                self.W:Cast()
            end
        elseif spell:find("RivenMartyr") then
            if self.R1:IsReady() and self:IsR2() then
                self.R2:Cast(target.pos)
            elseif self.Q:IsReady() and target.distance <= 400 then
                self:CastQ(target)
            end
        elseif spell:find("RivenIzunaBlade") and self.Q.Stacks ~= 2 then
            if self.Q:IsReady() and target.distance <= 400 then
                self:CastQ(target)
            end
        end
    end

    function Riven:AfterAttackShy(target)
        self:UseItems(target)
        if self.W:IsReady() and target.distance <= self.W.Range then
            self.W:Cast()
        elseif self.R1:IsReady() and self:IsR2() and IsValidTarget(target, self.R2.Range) then
            self.R2:Cast(target.pos)
        elseif not self.R1:IsReady() and not self.W:IsReady() and self.Q:IsReady() and
            IsValidTarget(target, self.Q.Range) then
            self:CastQ(target)
        end
    end

    function Riven:WerCombo()
        local enemy = GetTarget(1200, 0)
        if enemy and enemy.distance <= GetTrueAttackRange(myHero) then
            Orbwalker.ForceTarget = enemy
        else
            Orbwalker.ForceTarget = nil
        end
        Orbwalk()
        if not enemy then
            return
        end
        --
        if Menu.Items.Youmuu:Value() then
            self:CastYoumuu(enemy)
        end
        --
        if self.R1:IsReady() and self:IsR1() then
            DelayAction(function()
                self.R1:Cast()
            end, 0.01)
        end
        if self.Flash and Ready(self.Flash.Index) and Menu.Burst.Flash:Value() and enemy.distance > 600 then
            if IsValidTarget(enemy, self.R2.Range - 100) then
                if not self:IsR2() then
                    return
                end
                if self.E:IsReady() then
                    KeyDown(HK_E)
                    DelayAction(function()
                        KeyUp(HK_E)
                    end, 0.01)
                end
                if self.R2:IsReady() then
                    DelayAction(function()
                        self.R2:Cast(enemy.pos)
                    end, 0.1)
                end
                if self.W:IsReady() and Ready(self.Flash.Index) and GetDistance(myHero, enemy) > self.E.Range + 100 then
                    DelayAction(function()
                        if not self.R1:IsReady() then
                            local delay = (Latency() < 60 and 0) or (0.1 + Latency() / 1000)
                            DelayAction(function()
                                self.W:Cast()
                            end, delay)
                            Control.CastSpell(self.Flash.Key, enemy.pos + (myHero.pos - enemy.pos):Normalized() * 50)
                        end
                    end, 0.35)
                end
                if self.W:IsReady() and enemy.distance < self.W.Range then
                    DelayAction(function()
                        self.W:Cast()
                    end, 0.4)
                end
                if self.Q:IsReady() and enemy.distance < self.R2.Range then
                    DelayAction(function()
                        self:CastQ(enemy)
                    end, 0.45)
                end
                if self:HasItems() then
                    DelayAction(function()
                        self:UseItems(enemy)
                    end, 0.5)
                end
            end
        elseif enemy.distance < 600 then
            if IsValidTarget(enemy, 600) then
                if not self:IsR2() then
                    return
                end
                if self.E:IsReady() then
                    KeyDown(HK_E)
                    DelayAction(function()
                        KeyUp(HK_E)
                    end, 0.01)
                end
                if self.R2:IsReady() then
                    DelayAction(function()
                        self.R2:Cast(enemy.pos)
                    end, 0.1)
                end
                if self.W:IsReady() and enemy.distance < self.W.Range then
                    DelayAction(function()
                        self.W:Cast()
                        KeyUp(HK_W)
                    end, 0.2)
                end
                if self.Q:IsReady() and enemy.distance < self.R2.Range then
                    DelayAction(function()
                        self:CastQ(enemy)
                    end, 0.25)
                end
                if self:HasItems() then
                    DelayAction(function()
                        self:UseItems(enemy)
                    end, 0.3)
                end
            end
        end
    end

    function Riven:OnProcessSpellWer(spell)
        local target = GetTarget(self.R2.Range, 0)
        if not (spell and target) then
            return
        end
        --
        if Menu.Items.Youmuu:Value() then
            self:CastYoumuu(target)
        end
        --
        if spell:find("Tiamat") then
            if self.W:IsReady() and target.distance <= self.W.Range then
                self.W:Cast()
            elseif self.Q:IsReady() and target.distance <= 400 then
                self:CastQ(target)
            end
        elseif spell:find("RivenFeint") then
            if self.R1:IsReady() and self:IsR2() then
                self.R2:Cast(target.pos)
            elseif self.W:IsReady() and target.distance <= self.W.Range then
                self.W:Cast()
            end
        elseif spell:find("RivenMartyr") then
            if self.Q:IsReady() and IsValidTarget(target, 400) then
                self:CastQ(target)
            end
        elseif spell:find("RivenIzunaBlade") and self.Q.Stacks ~= 2 then
            if self.Q:IsReady() and target.distance <= 400 then
                self:CastQ(target)
            end
        end
    end

    function Riven:AfterAttackWer(target)
        self:UseItems(target)
        if self.R1:IsReady() and self:IsR2() and IsValidTarget(target, self.R2.Range) then
            self.R2:Cast(target.pos)
        elseif self.W:IsReady() and target.distance <= self.W.Range then
            self.W:Cast()
        elseif self.Q:IsReady() and IsValidTarget(target, self.Q.Range) then
            self:CastQ(target)
        end
    end

    function Riven:OnSpellLoop()
        local time = Timer()
        if not self.Q:IsReady() then
            local spellQ = myHero:GetSpellData(_Q)
            for i = 1, 3 do
                local i3 = i ~= 3
                if (i3 and spellQ.cd or 0.25) + time - spellQ.castTime < 0.1 and (i3 and i or 0) == spellQ.ammo and
                    (i3 or self.Q.Stacks ~= 0) and self.Q.Stacks ~= i then
                    --print("Q"..i.." Cast")
                    self.Q.LastCast = time
                    self.Q.Stacks = i
                    self:ResetQ(i);
                    return
                end
            end
        end
    end

    function Riven:OnProcessSpell()
        local lastSpell = { "Spell Reset", Timer() } --was outside

        local spell = myHero.activeSpell
        local time = Timer()
        if time - lastSpell[2] > 1 then
            lastSpell = { "Spell Reset", time }
        end
        if spell.valid and spell.name ~= lastSpell[1] then
            if self.mode and self.mode == 1 then
                self:OnProcessSpellCombo(spell.name)
            elseif self.BurstMode == 1 then
                self:OnProcessSpellShy(spell.name)
            elseif self.BurstMode == 2 then
                self:OnProcessSpellWer(spell.name)
            end
            lastSpell = { spell.name, time }
        end
    end

    function Riven:ResetQ(x)
        if not self.mode or self.mode >= 3 then
            return
        end
        local extraDelay = Menu.Q.Delay["Q" .. x]:Value()
        DelayAction(function()
            ResetAutoAttack()
            Control.Move(myHero.posTo)
        end, extraDelay / 1000)
    end

    function Riven:CastQ(targ)
        local target = targ or mousePos
        if not self.Q:IsReady() or (Orbwalker:CanAttack() and GetDistance(targ) <= GetTrueAttackRange(myHero)) then
            return
        end
        self.Q:Cast(targ)
    end

    function Riven:CastW(target)
        if not (self.W:IsReady() and IsValidTarget(target, self.W.Range)) then
            return
        end
        if self.Q.Stacks ~= 0 or (self.Q.Stacks == 0 and not self.Q:IsReady()) or HasBuff(myHero, "RivenFeint") or
            not IsFacing(target) then
            self.W:Cast()
        end
    end

    function Riven:CastE(target)
        if not (self.E:IsReady() and IsValidTarget(target)) then
            return
        end
        local dist, aaRange = GetDistance(target), GetTrueAttackRange(myHero)
        if Menu.Q.Combo:Value() and self.Q:IsReady() and dist <= aaRange + 260 and self.Q.Stacks == 0 then
            return
        end
        --
        local qReady, wReady = self.Q:IsReady(), self.W:IsReady()
        local qRange, wRange, eRange = (qReady and self.Q.Stacks == 0 and 260 or 0), (wReady and self.W.Range or 0),
            self.E.Range
        if (dist <= eRange + qRange) or (dist <= eRange + wRange) or
            (not wReady and not qReady and dist <= eRange + aaRange) then
            self.E:Cast(target.pos)
        end
    end

    function Riven:CastR1(target)
        if not (IsValidTarget(target, self.R2.Range) and self:IsR1() and Menu.R.ComboR1:Value()) or
            HealthPercent(target) <= Menu.R.MinHealth:Value() then
            return
        end
        self.R1:Cast()
    end

    function Riven:CastR2(target, hC)
        if not (IsValidTarget(target) and self:IsR2()) then
            return
        end
        --
        self.R2.Radius = GetDistance(target) * 0.8
        self.R2:CastToPred(target, hC)
    end

    function Riven:CheckCastR2(target)
        if not (IsValidTarget(target) and self:IsR2()) then
            return
        end

        local rDmg, aaDmg = self.R2:CalcDamage(target), Damage:GetAADamage(self.from, target)
        --
        local rBuff = GetBuffByName(myHero, "rivenwindslashready")
        local time = Timer()
        if rBuff and rBuff.expireTime >= time and rBuff.expireTime - time <= 1 or HealthPercent(myHero) <= 20 or
            (target.health > rDmg + aaDmg * 2 and HealthPercent(target) < 40) or target.health <= rDmg then
            self:CastR2(target, HITCHANCE_NORMAL)
        end
    end

    function Riven:UpdateSpells()
        if self.Q.Stacks ~= 0 and Timer() - self.Q.LastCast > 3.8 then
            self.Q.Stacks = 0
        end
        if self:IsR2() then
            self.W.Range = 330
        else
            self.W.Range = 260
        end
    end

    function Riven:GetActiveBurst()
        if Menu.Burst.ShyKey:Value() then
            self:ShyCombo()
            return 1
        elseif Menu.Burst.WerKey:Value() then
            self:WerCombo()
            return 2
        end
        return 0
    end

    function Riven:HasItems()
        return self.Youmuu or false --or self.Tiamat or self.Hydra or self.Titanic..
    end

    function Riven:IsR1()
        return myHero:GetSpellData(_R).name:find("RivenFengShuiEngine")
    end

    function Riven:IsR2()
        return myHero:GetSpellData(_R).name:find("RivenIzunaBlade")
    end

    function Riven:UpdateItems()
        local itemID = { Youmuu = ItemID.YoumuusGhostblade, }
        local itemName = { [ItemID.YoumuusGhostblade] = "Youmuu", }
        for i = ITEM_1, ITEM_7 do
            local id = myHero:GetItemData(i).itemID
            local name = itemName[id]
            if name then
                if (self[name] and i == self[name].Index and id ~= itemID[name]) then
                    self[name] = nil
                end --In Case They Sell Items Or Change Slots
                self[name] = { Index = i, Key = ItemHotKey[i] }
            end
        end
    end

    function Riven:GetPassive()
        return 0.2 + floor(myHero.levelData.lvl / 3) * 0.05
    end

    function Riven:TotalDamage(target)
        local damage = 0
        if self.Q:IsReady() or HasBuff(myHero, "RivenTriCleave") then
            local Qleft = 3 - self.Q.Stacks
            local Qpassive = Qleft * (1 + self:GetPassive())
            damage = damage + self.Q:CalcDamage(target) * (Qleft + Qpassive)
        end
        if self.W:IsReady() then
            damage = damage + self.W:CalcDamage(target)
        end
        if self.R1:IsReady() then
            damage = damage + self.R2:CalcDamage(target)
        end
        damage = damage + Damage:GetAADamage(self.from, target)
        return damage
    end

    function Riven:UseItems(target)
        --[[         if self.Tiamat or self.Hydra then
            self:CastHydra(target)
        elseif self.Titanic then
            self:CastTitanicHydra(target)
        end ]]
    end

    function Riven:CastYoumuu(target)
        if self.Youmuu and Menu.Items.Youmuu:Value() and myHero:GetSpellData(self.Youmuu.Index).currentCd == 0 and
            IsValidTarget(target, 600) then
            self:PressKey(self.Youmuu.Key)
        end
    end

    --[[     function Riven:CastTitanicHydra(target)
        if self.Titanic and Menu.Items.TitanicHydra:Value() and myHero:GetSpellData(self.Titanic.Index).currentCd == 0 and IsValidTarget(target, 380) then
            self:PressKey(self.Titanic.Key)
            ResetAutoAttack()
        end
    end

    function Riven:CastHydra(target)
        if not IsValidTarget(target, 380) then
            return
        end
        if self.Hydra and Menu.Items.Hydra:Value() and myHero:GetSpellData(self.Hydra.Index).currentCd == 0 then
            self:PressKey(self.Hydra.Key)
            ResetAutoAttack()
        elseif self.Tiamat and Menu.Items.Tiamat:Value() and myHero:GetSpellData(self.Tiamat.Index).currentCd == 0 then
            self:PressKey(self.Tiamat.Key)
            ResetAutoAttack()
        end
    end ]]

    function Riven:PressKey(k)
        KeyDown(k)
        KeyUp(k)
    end

    insert(LoadCallbacks, function()
        Riven()
    end)

elseif myHero.charName == "Sion" then

    class 'Sion'
    --Sion = Class()

    function Sion:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.castingQ = false
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        --Callback.Add("Load",          function() self:OnLoad()    end) --Just Use OnLoad()
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        Callback.Add("WndMsg", function(msg, param)
            self:OnWndMsg(msg, param)
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnInterruptable(function(unit, spell)
            self:OnInterruptable(unit, spell)
        end)
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Sion:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 850,
            Delay = 0.25,
            Speed = huge,
            Radius = 200, --reduced on purpose
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.W = Spell({
            Slot = 1,
            Range = huge,
            Delay = 0.25,
            Speed = huge,
            Radius = 525,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.E = Spell({
            Slot = 2,
            Range = 780,
            Delay = 0.25,
            Speed = 1800,
            Radius = 100,
            Collision = true, --was false
            CollisionTypes = { COLLISION_MINION, COLLISION_ENEMYHERO, COLLISION_YASUOWALL }, --
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.E2 = Spell({
            Slot = 2,
            Range = 1300,
            Delay = 0.25,
            Speed = 1800,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.E.ExtraRange = 520
        self.R = Spell({
            Slot = 3,
            Range = 7600,
            Delay = 8,
            Speed = 950,
            Radius = 200,
            Collision = true,
            CollisionTypes = { COLLISION_ENEMYHERO },
            From = myHero,
            Type = SpellTypePress
        })
    end

    function Sion:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Count", name = "Enemies To Cast", value = 1, min = 0, max = 5, step = 1 })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "CountHarass", name = "Enemies To Cast", value = 1, min = 0, max = 5, step = 1 })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.Q:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.Q:MenuElement({ id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 6, step = 1 })
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.W:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.W:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.W:MenuElement({ id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 6, step = 1 })
        Menu.W:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.E:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.E:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.E:MenuElement({ id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 6, step = 1 })
        Menu.E:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.E:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --R--
        Menu.R:MenuElement({ name = "Spell Not Supported", drop = { " " } })
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
    end

    function Sion:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.E2.Range)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.mode = GetMode()
        --
        if myHero.isChanneling then
            return
        end
        self:Auto()
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 3 and self:Clear() or
            self.mode == 4 and self:Clear() or
            self.mode == 6 and self:Flee()
    end

    function Sion:OnWndMsg(msg, param)
        if not self.qCastPos and msg == 256 and param == HK_Q then
            for i = 1, 3 do
                DelayAction(function()
                    self:CheckParticle()
                end, i * 0.1)
            end
        end
    end

    function Sion:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() or self.castingQ then
            args.Process = false
            return
        end
    end

    function Sion:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() or self.castingQ then
            args.Process = false
            return
        end
    end

    function Sion:OnInterruptable(unit, spell)
        if ShouldWait() or self.castingQ then
            return
        end
        if Menu.R.Interrupt[spell.name]:Value() and IsValidTarget(enemy) and Ready(_R) then
        end
    end

    function Sion:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() or self.castingQ then
            return
        end
        if IsValidTarget(unit) and GetDistance(unitPosTo) < 500 and unit.team == TEAM_ENEMY and IsFacing(unit, myHero) then
            --Gapcloser
        end
    end

    function Sion:Auto()
    end

    function Sion:Combo()
        if self.W:IsReady() and Menu.W.Combo:Value() and ManaPercent(myHero) >= Menu.W.Mana:Value() then
            self:CastW()
        end
        if self.E:IsReady() and Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value() then
            local eTarget = GetTarget(self.E.Range + 775)
            self:CastE(eTarget)
        elseif self.Q:IsReady() and Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            local pos, hit = self.Q:GetBestCircularCastPos(nil, GetEnemyHeroes(self.Q.Range))
            local willHit, entering, leaving = self:CheckPolygon(pos)
            if pos and GetDistance(pos) < 600 and willHit >= Menu.Q.Count:Value() and leaving == 0 then
                self:StartCharging(pos)
            end
        end
    end

    function Sion:Harass()
        if self.W:IsReady() and Menu.W.Combo:Value() and ManaPercent(myHero) >= Menu.W.Mana:Value() then
            self:CastW()
        end
        if self.E:IsReady() and Menu.E.Harass:Value() and ManaPercent(myHero) >= Menu.E.ManaHarass:Value() then
            local eTarget = GetTarget(self.E.Range + 775)
            self:CastE(eTarget)
        elseif self.Q:IsReady() and Menu.Q.Harass:Value() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() then
            local pos, hit = self.Q:GetBestCircularCastPos(nil, GetEnemyHeroes(self.Q.Range))
            local willHit, entering, leaving = self:CheckPolygon(pos)
            if pos and willHit >= Menu.Q.Count:Value() and leaving == 0 then
                self:StartCharging(pos)
            end
        end
    end

    function Sion:Clear()
        local qRange, jCheckQ, lCheckQ = self.Q.Range, Menu.Q.Jungle:Value(), Menu.Q.Clear:Value()
        local wRange, jCheckW, lCheckW = self.W.Radius, Menu.W.Jungle:Value(), Menu.W.Clear:Value()
        local eRange, jCheckE, lCheckE = self.E.Range, Menu.E.Jungle:Value(), Menu.E.Clear:Value()
        --
        if self.W:IsReady() and (jCheckW or lCheckW) then
            local minions = (jCheckW and GetMonsters(wRange)) or {}
            minions = (#minions == 0 and lCheckW and GetEnemyMinions(wRange)) or minions
            if #minions == 0 then
                return
            end
            --
            self.W:Cast()
        elseif self.E:IsReady() and (jCheckE or lCheckE) then
            local minions = (jCheckE and GetMonsters(eRange)) or {}
            minions = (#minions == 0 and lCheckE and GetEnemyMinions(eRange)) or minions
            if #minions == 0 then
                return
            end
            --
            local pos, hit = GetBestLinearCastPos(self.E, nil, minions)
            if pos and hit >= Menu.E.Min:Value() or (minions[1] and minions[1].team == TEAM_JUNGLE) then
                self.E:Cast(pos)
            end
        elseif self.Q:IsReady() and (jCheckQ or lCheckQ) then
            local minions = (jCheckQ and GetMonsters(qRange)) or {}
            minions = (#minions == 0 and lCheckQ and GetEnemyMinions(qRange)) or minions
            if #minions == 0 then
                return
            end
            --
            local pos, hit = GetBestCircularCastPos(self.Q, nil, minions)
            if pos and (hit >= Menu.Q.Min:Value() or (minions[1] and minions[1].team == TEAM_JUNGLE)) then
                self:StartCharging(pos)
                return
            end
        end
    end

    function Sion:Flee()
        if self.E:IsReady() and Menu.E.Flee:Value() then
            local eTarget = GetTarget(self.E.Range)
            self:CastE(eTarget)
        elseif self.W:IsReady() and Menu.W.Flee:Value() then
            self:CastW()
        end
    end

    function Sion:KillSteal()
        if self.E:IsReady() and Menu.E.KS:Value() then
            local targets = GetEnemyHeroes(self.E.Range + 775)
            for i = 1, #targets do
                local eTarget = targets[i]
                local hp = eTarget.health
                if self.E:GetDamage(eTarget) >= hp and (hp >= 50 or HeroesAround(400, eTarget.pos, TEAM_ALLY) == 0) then
                    if self:CastE(eTarget) then
                        return
                    end
                end
            end
        end
    end

    function Sion:OnDraw()
        self:LogicQ()
        DrawSpells(self)
    end

    function Sion:LogicQ()
        --[[As of March/2018 EXT's myHero.dir wont update if you cast the spell somewhere you're not facing. To fix that, I used Sion's Q particle.]]
        local spell = myHero.activeSpell
        self.castingQ = spell.isCharging and spell.name == "SionQ" --HasBuff(myHero, "SionQ")
        if not self.castingQ then
            local qSpell = myHero:GetSpellData(self.Q.Slot)
            if (qSpell.currentCd ~= 0 and qSpell.cd - qSpell.currentCd > 0.5) then
                self.qCastPos = nil
                if IsKeyDown(HK_Q) then
                    KeyUp(HK_Q)
                end --release stuck key
            end
            return
        end
        --
        local qRange = self.Q.Range
        local willHit, entering, leaving = self:CheckPolygon()
        DrawText("Q will hit: " .. willHit, myHero.pos:To2D())
        if entering <= leaving and (willHit > 0 or entering == 0) then
            if leaving > 0 and IsKeyDown(HK_Q) then
                KeyUp(HK_Q) --release skill
            end
        end
    end

    function Sion:CheckPolygon(targetPos)
        local pP, eP = myHero.pos, targetPos or self.qCastPos
        local endPointCenter = targetPos and pP + (eP - pP):Normalized() * 770 or
            RotateAroundPoint(pP + (eP - pP):Normalized() * 770, pP, (0.5 / 180) * pi) --0.5 degrees for angleCorrection fml
        --
        local perpend1, perpend2 = (pP - eP):Perpendicular():Normalized(), (pP - eP):Perpendicular2():Normalized()
        local startPoint1, startPoint2 = pP + 160 * perpend1, pP + 180 * perpend2 --why the fuck is this not symmetrical rito
        local endPoint1, endPoint2 = endPointCenter + 290 * perpend1, endPointCenter + 290 * perpend2
        --
        local willHit, entering, leaving = 0, 0, 0
        local qPolygon = Polygon(Point(startPoint1), Point(endPoint1), Point(endPoint2), Point(startPoint2))
        for i = 1, #self.enemies do
            local target = self.enemies[i]
            local tP, tP2 = Point(target.pos), Point(target:GetPrediction(huge, 0.2))
            --
            if qPolygon:__contains(tP) then
                --if inside(might leave)
                willHit = willHit + 1
                if not qPolygon:__contains(tP2) then
                    leaving = leaving + 1
                end
            else
                --if outside(might come in)
                if qPolygon:__contains(tP2) then
                    entering = entering + 1
                end
            end
        end
        --qPolygon:__draw()
        --[[Maxxx 2dGeoLib draw functions are broken, I told him already how to fix and am waiting for response.]] --Fixed, we're waiting for Fere to push a lib update
        --DrawLine(startPoint1:To2D(), startPoint2:To2D())
        --DrawLine(startPoint1:To2D(), endPoint1:To2D())
        --DrawLine(endPoint1:To2D(), endPoint2:To2D())
        --DrawLine(endPoint2:To2D(), startPoint2:To2D())
        return willHit, entering, leaving
    end

    function Sion:CheckParticle()
        for i = 1, ParticleCount() do
            local obj = Particle(i)
            if obj then
                if obj.name:find("Sion_Base_Q_Indicator") then
                    self.qCastPos = obj.pos
                    return true
                end
            end
        end
    end

    local castSpell = { state = 0, tick = TickCount(), casting = TickCount() - 1000, mouse = mousePos }
    function Sion:StartCharging(pos)
        local ticker = TickCount()
        if castSpell.state == 0 and GetDistance(myHero.pos, pos) < self.Q.Range + 100 and
            ticker - castSpell.casting > self.Q.Delay + Latency() and pos:ToScreen().onScreen then
            castSpell.state = 1
            castSpell.mouse = mousePos
            castSpell.tick = ticker
        end
        if castSpell.state == 1 then
            if ticker - castSpell.tick < Latency() then
                SetCursorPos(pos)
                self.qCastPos = pos
                KeyDown(HK_Q)
                castSpell.casting = ticker + self.Q.Delay
                DelayAction(function()
                    if castSpell.state == 1 then
                        SetCursorPos(castSpell.mouse)
                        castSpell.state = 0
                    end
                end, Latency() / 1000)
            end
            if ticker - castSpell.casting > Latency() then
                SetCursorPos(castSpell.mouse)
                castSpell.state = 0
            end
        end
    end

    function Sion:CastE(eTarget)
        if not IsValidTarget(eTarget) then
            return
        end
        if GetDistance(eTarget) <= self.E.Range then
            return self.E:CastToPred(eTarget, 2)
        else
            local extendTargets, temp = GetEnemyMinions(self.E.Range), GetMonsters(self.E.Range)
            for i = 1, #temp do
                extendTargets[#extendTargets + 1] = temp[i]
            end
            local bestPos, castPos, hC = self.E2:GetPrediction(eTarget)
            if bestPos and hC >= HITCHANCE_NORMAL and #mCollision(myHero.pos, bestPos, self.E, extendTargets) >= 1 then
                return self.E:Cast(bestPos)
            end
        end
    end

    function Sion:CastW()
        if #GetEnemyHeroes(self.W.Radius) >= 1 then
            return self.W:Cast()
        end
    end

    insert(LoadCallbacks, function()
        Sion()
    end)

elseif myHero.charName == "Syndra" then

    class 'Syndra'
    --Syndra = Class()

    function Syndra:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        Callback.Add("WndMsg", function(msg, param)
            self:OnWndMsg(msg, param)
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnInterruptable(function(unit, spell)
            self:OnInterruptable(unit, spell)
        end)
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)

    end

    function Syndra:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 800,
            Delay = 0.85,
            Speed = huge,
            Radius = 180,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE,
            DmgType = "Magical"
        })
        self.QE = Spell({
            Slot = 2,
            Range = 1300,
            Delay = 0.25,
            Speed = 1600,
            Radius = 60,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot,
        })
        self.W = Spell({
            Slot = 1,
            Range = 925,
            Delay = 0.25,
            Speed = 1450,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE,
            DmgType = "Magical"
        })
        self.E = Spell({
            Slot = 2,
            Range = 700,
            Delay = 0.25,
            Speed = 2500,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot,
            DmgType = "Magical"
        })
        self.R = Spell({
            Slot = 3,
            Range = 675,
            Delay = 0.25,
            Speed = huge,
            Radius = 0,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted,
            DmgType = "Magical"
        })
        self.OrbData = {
            Obj = {},
            Spawning = nil,
            SearchParticles = true,
            SearchMissiles = true,
        }
        --[[         self.Q.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local qLvl = myHero:GetSpellData(_Q).level
            local dmg = 35 + 35 * qLvl + 0.65 * myHero.ap
            --
            if qLvl == 5 and enemy.type == Obj_AI_Hero then
                dmg = dmg + 34.5 + 0.0975 * myHero.ap
            end
            return dmg
        end
        self.W.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local wLvl = myHero:GetSpellData(_W).level
            local dmg = 30 + 40 * wLvl + 0.7 * myHero.ap
            --
            if wLvl == 5 then
                dmg = dmg + 46 + 0.14 * myHero.ap
            end
            return dmg
        end
        self.R.GetDamage = function(spellInstance, enemy, stage)
            if not spellInstance:IsReady() then
                return 0
            end
            --
            local rLvl = myHero:GetSpellData(_R).level
            local ammo = myHero:GetSpellData(_R).ammo or 3
            --
            return (40 + 50 * rLvl + 0.2 * myHero.ap) * ammo
        end ]]
    end

    function Syndra:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Pred", name = "Prediction Mode", value = 2,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "AutoHarass", name = "Auto Harass", value = true })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "PredHarass", name = "Prediction Mode", value = 3,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "KS", name = "Use to KS", value = true })
        Menu.Q:MenuElement({ id = "Auto", name = "Auto Use on Immobile", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Pred", name = "Prediction Mode", value = 2,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "AutoHarass", name = "Auto Harass", value = true })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "PredHarass", name = "Prediction Mode", value = 3,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "KS", name = "Use to KS", value = true })
        Menu.W:MenuElement({ id = "Auto", name = "Auto Use on Immobile", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Pred", name = "Prediction Mode", value = 2,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "PredHarass", name = "Prediction Mode", value = 2,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.E:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --R--
        Menu.R:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.R:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.R:MenuElement({ id = "Heroes", name = "Whitelist", type = MENU })
        --
        Menu:MenuElement({ name = " ", drop = { "Extra Features" } })
        --Q+E
        Menu:MenuElement({ id = "QE", name = "Q+E Settings", type = MENU })
        Menu.QE:MenuElement({ id = "ComboQ", name = "Use on Combo", value = true })
        Menu.QE:MenuElement({ id = "HarassQ", name = "Use on Harass", value = true })
        Menu.QE:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        Menu.QE:MenuElement({ id = "Interrupt", name = "Interrupt Targets", type = MENU })
        Menu.QE:MenuElement({ id = "Gapcloser", name = "Anti Gapcloser", type = MENU })
        --
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --

        ObjectManager:OnEnemyHeroLoad(function(args)
            local hero = args.unit
            local charName = args.charName
            Interrupter:AddToMenu(hero, Menu.QE.Interrupt)
            Menu.QE.Gapcloser:MenuElement({ id = charName, name = charName, value = true })
            Menu.R.Heroes:MenuElement({ id = charName, name = charName, value = true })
        end)
    end

    function Syndra:Tick()
        if ShouldWait() then
            return
        end
        --
        self:ClearBalls()
        self.enemies = GetEnemyHeroes(self.QE.Range)
        self.target = GetTarget(self.QE.Range, 0)
        self.mode = GetMode()
        --
        if myHero.isChanneling then
            return
        end
        self:Auto()
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 6 and self:Flee()
    end

    function Syndra:OnWndMsg(msg, param)
        if param >= HK_Q and param <= HK_R then
            self:UpdateBalls()
        end
    end

    function Syndra:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Syndra:OnPreAttack(args)
        --args.Process|args.Target
        local target = args.Target
        local tType = target and target.type
        if not (IsValidTarget(target) and (tType == Obj_AI_Hero or tType == Obj_AI_Minion)) then
            return
        end
        --
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Syndra:OnInterruptable(unit, spell)
        if ShouldWait() then
            return
        end
        if Menu.QE.Interrupt[spell.name] and Menu.QE.Interrupt[spell.name]:Value() and IsValidTarget(enemy) and
            self.E:IsReady() then
            self:CastE(1, unit)
        end
    end

    function Syndra:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() or not (IsValidTarget(unit, self.Q.Range) and unit.team == TEAM_ENEMY) then
            return
        end
        if Menu.QE.Gapcloser[unit.charName] and Menu.QE.Gapcloser[unit.charName]:Value() and
            GetDistance(unitPosTo) <= self.QE.Range and IsFacing(unit, myHero) then
            --Gapcloser
            self:CastE(1, unit)
        elseif Menu.Q.Auto:Value() and GetDistance(unitPosTo) <= self.Q.Range then
            self.Q:CastToPred(unit, 2)
        end
    end

    function Syndra:Auto()
        if Menu.Q.Auto:Value() then
            for i = 1, #self.enemies do
                local enemy = self.enemies[i]
                if GetDistance(enemy) <= self.Q.Range and IsImmobile(enemy, 0.5) then
                    self.Q:Cast(enemy)
                end
            end
        end
        if Menu.Q.AutoHarass:Value() then
            self:Harass(true)
        end
    end

    function Syndra:Combo()
        local target = self.target
        if not target then
            return
        end
        --
        if Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            self:CastQ(target, Menu.Q.Pred:Value())
        end
        if Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value() then
            self:CastE(Menu.E.Pred:Value())
        end
        if Menu.W.Combo:Value() and ManaPercent(myHero) >= Menu.W.Mana:Value() then
            self:CastW(target, Menu.W.Pred:Value())
        end
    end

    function Syndra:Harass(auto)
        local target = self.target
        if not target then
            return
        end
        --
        if Menu.Q.Harass:Value() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() then
            self:CastQ(target, Menu.Q.PredHarass:Value())
        end
        --
        if auto then
            return
        end
        if Menu.W.Harass:Value() and ManaPercent(myHero) >= Menu.W.ManaHarass:Value() then
            self:CastW(target, Menu.W.PredHarass:Value())
        end
        if Menu.E.Harass:Value() and ManaPercent(myHero) >= Menu.E.ManaHarass:Value() then
            self:CastE(Menu.E.PredHarass:Value())
        end
    end

    function Syndra:Flee()
        if not self.E:IsReady() then
            return
        end
        for i = 1, #self.enemies do
            local enemy = self.enemies[i]
            if GetDistance(enemy) <= 900 and Menu.QE.Flee:Value() then
                self:CastE(1, enemy)
            elseif GetDistance(enemy) <= 400 and Menu.E.Flee:Value() then
                self.E:CastToPred(enemy, 1)
            end
        end
    end

    function Syndra:KillSteal(unit)
        for i = 1, #self.enemies do
            local unit = self.enemies[i]
            if not IsValidTarget(unit) then
                return
            end
            --
            if self.Q:IsReady() and self.Q:CanCast(unit) and Menu.Q.KS:Value() then
                local damage = self.Q:CalcDamage(unit)
                if unit.health + unit.shieldAP < damage then
                    self:CastQ(unit, 1);
                    return
                end
            end
            if self.W:IsReady() and self.W:CanCast(unit) and Menu.W.KS:Value() then
                local damage = self.W:CalcDamage(unit)
                if unit.health + unit.shieldAP < damage then
                    self:CastW(unit, 1);
                    return
                end
            end
            if self.R:IsReady() and self.R:CanCast(unit) and Menu.R.KS:Value() and Menu.R.Heroes[unit.charName] and
                Menu.R.Heroes[unit.charName]:Value() then
                local damage = self.R:CalcDamage(unit, 2)
                if unit.health + unit.shieldAP < damage then
                    self.R:Cast(unit);
                    return
                end
            end
        end
    end

    function Syndra:OnDraw()
        DrawSpells(self)
    end

    function Syndra:UpdateBalls()
        --
        local qCd = myHero:GetSpellData(_Q).currentCd
        if qCd == 0 then
            self.OrbData.SearchParticles = true
        elseif qCd > 0 and self.OrbData.SearchParticles then
            self.OrbData.SearchParticles = false
            self.OrbData.Spawning = self:GetSpawningOrb()
        end

        DelayAction(function()
            self.OrbData.Spawning = nil
            self:LoopOrbs()
        end, 0.75)

        --Update spells
        if self.R.Range ~= 750 and myHero:GetSpellData(_R).level >= 3 then
            self.R.Range = 750
        end
    end

    function Syndra:CastQ(target, hC)
        if self.Q:IsReady() and self.Q:CanCast(target) then
            self.Q:CastToPred(target, hC)
        end
    end

    function Syndra:CastW(target, hC)
        if self.W:IsReady() and self.W:CanCast(target) then
            local toggleState = myHero:GetSpellData(_W).toggleState
            if toggleState == 2 then
                self.W:CastToPred(target, hC)
            elseif toggleState == 1 then
                local CastPosition = self:GrabObj()
                if CastPosition then
                    self.W:Cast(CastPosition)
                end
            end
        end
    end

    function Syndra:CanHitQE(target, orbPos, castPos)
        if self.E:IsReady() and GetDistance(orbPos) <= self.E.Range then
            local startPos, endPos = orbPos:Extended(myHero.pos, 100),
                orbPos:Extended(myHero.pos, -(1050 - 0.6 * GetDistance(orbPos)))
            DrawCircle(startPos)
            DrawCircle(endPos)
            local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(startPos, endPos, castPos)
            return isOnSegment and GetDistance(pointLine, castPos) <= (self.QE.Radius + target.boundingRadius)
        end
    end

    function Syndra:CastE(hC, target)
        local enemy = target or GetTarget(1200, 1)
        if not (self.E:IsReady() and enemy) then
            return
        end
        --

        local unitPos, castPos, hitChance = self.QE:GetPrediction(enemy)
        if castPos and hitChance >= HITCHANCE_NORMAL then
            local pos = self.OrbData.PrePos
            if pos and self:CanHitQE(enemy, pos, castPos) then
                self.E:Cast(pos)
            else
                for i, orb in pairs(self.OrbData.Obj) do
                    if orb and not orb.dead and self:CanHitQE(enemy, orb.pos, castPos) then
                        self.E:Cast(orb.pos)
                        return
                    end
                end
                --[[In Case there are no orbs]]
                if self.Q:IsReady() then
                    local bestCast = myHero.pos:Extended(castPos, GetDistance(myHero, enemy) * 0.6)
                    self.Q:Cast(bestCast)
                    DelayAction(function()
                        self.E:Cast(bestCast)
                    end, 0.2)
                end
            end
        end
    end

    function Syndra:GrabObj()
        for i = 1, #self.OrbData.Obj do
            local orb = self.OrbData.Obj[i]
            if orb and not orb.dead and GetDistance(orb) <= self.W.Range then
                return orb.pos
            end
        end

        local minions = GetEnemyMinions(self.W.Range)
        for i = 1, #minions do
            local minion = minions[i]
            if minion and not minion.dead and GetDistance(minion) < self.W.Range then
                return minion.pos
            end
        end
    end

    function Syndra:ClearBalls()
        for i = 1, #self.OrbData.Obj do
            local orb = self.OrbData.Obj[i]
            if orb and orb.dead then
                remove(self.OrbData.Obj, i)
            end
        end
    end

    function Syndra:GetSpawningOrb()
        for i = ParticleCount(), 1, -1 do
            local obj = Particle(i)
            if obj and obj.type == "obj_GeneralParticleEmitter" and obj.name:find("_aoe_gather.troy") then
                return obj.pos
            end
        end
    end

    function Syndra:LoopOrbs()
        local objectCount = ObjectCount()
        for i = ObjectCount(), 1, -1 do
            local obj = Object(i)
            if obj and not obj.dead and obj.name:lower() == "seed" then
                self.OrbData.Obj[#self.OrbData.Obj + 1] = obj
            end
        end
    end

    insert(LoadCallbacks, function()
        Syndra()
    end)

elseif myHero.charName == "Talon" then

    class 'Talon'
    --Talon = Class()

    function Talon:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.fleeTimer = Timer()
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
    end

    function Talon:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 575,
            Delay = 0.25,
            Speed = huge,
            Radius = 0,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted
        })
        self.W = Spell({
            Slot = 1,
            Range = 900,
            Delay = 0.25,
            Speed = 1450,
            Radius = 250,
            Collision = true, --was false
            CollisionTypes = { COLLISION_YASUOWALL }, --
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.E = Spell({
            Slot = 2,
            Range = 0,
            Delay = 0.25,
            Speed = 0,
            Radius = 0,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.R = Spell({
            Slot = 3,
            Range = 550,
            Delay = 0.25,
            Speed = huge,
            Radius = 550,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        local flashData = myHero:GetSpellData(SUMMONER_1).name:find("Flash") and SUMMONER_1 or
            myHero:GetSpellData(SUMMONER_2).name:find("Flash") and SUMMONER_2 or nil
        self.Flash = flashData and Spell({
            Slot = flashData,
            Range = 400,
            Delay = 0.25,
            Speed = huge,
            Radius = 200,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
    end

    function Talon:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "LastHit", name = "Use to LastHit", value = false })
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "Auto", name = "Auto Proc Passive", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.W:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.W:MenuElement({ id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 6, step = 1 })
        Menu.W:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Auto", name = "Use When Surrounded", value = true })
        Menu.R:MenuElement({ id = "Min", name = "Min X Enemies Around", value = 2, min = 1, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "Combo", name = "Use To Assassinate", value = true })
        Menu.R:MenuElement({ id = "Heroes", name = "Assassinate Targets", type = MENU })
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana %", value = 0, min = 0, max = 100, step = 1 })
        --Burst
        Menu:MenuElement({ id = "Burst", name = "Burst Settings", type = MENU })
        Menu.Burst:MenuElement({ id = "Flash", name = "Allow Flash On Burst", value = true })
        Menu.Burst:MenuElement({ id = "Key", name = "Burst Key", key = string.byte("T") })
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
        ObjectManager:OnEnemyHeroLoad(function(args)
            Menu.R.Heroes:MenuElement({ id = args.charName, name = args.charName, value = false })
        end)
    end

    function Talon:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.W.Range + self.Flash.Range)
        self.target = GetTarget(self.W.Range, 0)
        self.mode = GetMode()
        --
        if Menu.Burst.Key:Value() then
            self:Burst()
            return
        end
        if myHero.isChanneling then
            return
        end
        self:Auto()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 3 and self:Clear() or
            self.mode == 4 and self:Clear() or
            self.mode == 5 and self:LastHit() or
            self.mode == 6 and self:Flee()
    end

    function Talon:Auto()
        if not self.target then
            return
        end
        --
        if self.Q:IsReady() and Menu.Q.Auto:Value() then
            self:ProcQ()
        end
        if self.mode == 1 and self.R:IsReady() and Menu.R.Auto:Value() and #self.enemies >= Menu.R.Min:Value() and
            not self:Stealthed() then
            self.R:Cast()
        end
    end

    function Talon:Combo()
        local wTarget = self.target
        if not wTarget then
            return
        end
        --
        if self.R:IsReady() and Menu.R.Combo:Value() and ManaPercent(myHero) >= Menu.R.Mana:Value() and
            not self:Stealthed() then
            if GetDistance(wTarget) <= self.R.Range and Menu.R.Heroes[wTarget.charName] and
                Menu.R.Heroes[wTarget.charName]:Value() then
                self.R:Cast()
                return
            end
        end
        if self.W:IsReady() and Menu.W.Combo:Value() and not self:Stealthed() and
            ManaPercent(myHero) >= Menu.W.Mana:Value() then
            self.W:CastToPred(wTarget, 2)
        elseif self.Q:IsReady() and Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            self.Q:Cast(wTarget)
            ResetAutoAttack()
        end
    end

    function Talon:Harass()
        local wTarget = self.target
        if not wTarget then
            return
        end
        --
        if self.W:IsReady() and Menu.W.Harass:Value() and not self:Stealthed() and
            ManaPercent(myHero) >= Menu.W.ManaHarass:Value() then
            self.W:CastToPred(wTarget, 2)
        elseif self.Q:IsReady() and Menu.Q.Harass:Value() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() then
            self:ProcQ()
        end
    end

    function Talon:Clear()
        if self.W:IsReady() and Menu.W.Clear:Value() and ManaPercent(myHero) >= Menu.W.ManaClear:Value() then
            local pos, hit = GetBestCircularFarmPos(self.W)
            if hit >= Menu.W.Min:Value() then
                self.W:Cast(pos)
            end
        end
    end

    local dmgTableClean = 0
    function Talon:LastHit()
        if self.Q:IsReady() and Menu.Q.LastHit:Value() and ManaPercent(myHero) >= Menu.Q.ManaClear:Value() then
            --
            if Timer() - dmgTableClean >= 1 then
                self.dmgTable = { Melee = {}, Ranged = {} }
                self.minions = GetEnemyMinions(self.Q.Range)
                dmgTableClean = Timer()
            end
            --
            for i = 1, #self.minions do
                local minion = self.minions[i]
                --
                local range = GetDistance(minion) <= 225 and "Melee" or "Ranged"
                local qDmg = self.dmgTable[range][minion.charName]
                if not qDmg then
                    qDmg = self:GetDamage(_Q, minion)
                    self.dmgTable[range][minion.charName] = qDmg
                end
                --
                if qDmg >= minion.health then
                    self.Q:Cast(minion)
                    return --Last Hit
                end
            end
        end
    end

    function Talon:Flee()
        if Timer() - self.fleeTimer >= 0.5 then
            self.E:Cast()
            self.fleeTimer = Timer()
        end
    end

    function Talon:OnDraw()
        DrawSpells(self)
    end

    function Talon:Burst()
        Orbwalk()
        if self.Q:IsReady() and self.W:IsReady() and self.R:IsReady() then
            local canFlash = self.Flash and self.Flash:IsReady() and Menu.Burst.Flash:Value()
            local range = self.Q.Range + (canFlash and self.Flash.Range or 0)
            local bTarget, eTarget = GetTarget(range, 0), GetTarget(self.Q.Range, 0)
            local shouldFlash = canFlash and bTarget ~= eTarget
            --
            if bTarget then
                self:BurstCombo(bTarget, shouldFlash, shouldFlash and 1 or 2)
            end
        end
    end

    function Talon:BurstCombo(target, shouldFlash, step)
        if step == 1 then
            if shouldFlash then
                local pos, hK = mousePos, self.Flash:SlotToHK()
                SetCursorPos(target.pos)
                KeyDown(hK)
                KeyUp(hK)
                DelayAction(function()
                    SetCursorPos(pos)
                end, 0.05)
            end
            DelayAction(function()
                self:BurstCombo(target, shouldFlash, 2)
            end, 0.3)
        elseif step == 2 then
            self.W:CastToPred(target, 1)
            DelayAction(function()
                self.Q:Cast(target)
                self.R:Cast()
            end, 0.3)
        end
    end

    function Talon:CalculatePhysicalDamage(target, damage)
        if target and damage then
            local targetArmor = target.armor * myHero.armorPenPercent - myHero.armorPen
            local damageReduction = 100 / (100 + targetArmor)
            if targetArmor < 0 then
                damageReduction = 2 - (100 / (100 - targetArmor))
            end
            damage = damage * damageReduction
            return damage
        end
        return 0
    end

    function Talon:GetDamage(skill, targ)
        if skill == _Q then
            local level = myHero:GetSpellData(_Q).level
            local IsMelee = targ and GetDistance(targ) <= 225
            local rawDmg = (40 + 25 * level + 1.1 * myHero.bonusDamage) * (IsMelee and 1.5 or 1)
            return self:CalculatePhysicalDamage(targ, rawDmg)
        end
    end

    function Talon:Stealthed()
        return HasBuff(myHero, "TalonRStealth")
    end

    function Talon:ProcQ()
        for i = 1, #self.enemies do
            local target = self.enemies[i]
            if GetDistance(target) <= self.Q.Range then
                local buff = GetBuffByName(target, "TalonPassiveStack")
                if buff and buff.count == 2 then
                    self.Q:Cast(target)
                    return
                end
            end
        end
    end

    insert(LoadCallbacks, function()
        Talon()
    end)

elseif myHero.charName == "Teemo" then

    class 'Teemo'
    --Teemo = Class()

    function Teemo:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self:ShroomData()
        self.Color1 = DrawColor(255, 35, 219, 81)
        self.Color2 = DrawColor(255, 216, 121, 26)
        self.scriptVersion = "1.02"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        Callback.Add("WndMsg", function(msg, param)
            self:OnWndMsg(msg, param)
        end)
    end

    function Teemo:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 680,
            Delay = 0.25,
            Speed = 2500,
            Radius = 0,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted
        })
        self.W = Spell({
            Slot = 1,
            Range = 0,
            Delay = 0.0,
            Speed = 0,
            Radius = 0,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.R = Spell({
            Slot = 3,
            Range = 600, --see OnWndMsg + 750, 900
            Delay = 1.25,
            Speed = 1000,
            Radius = 75,
            ExploRadius = 450,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
        self.R.LastCast = 0
    end

    function Teemo:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "LastHit", name = "Use to LastHit", value = true })
        Menu.Q:MenuElement({ id = "ManaLastHit", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = true })
        Menu.Q:MenuElement({ id = "Clear", name = "Use on LaneClear", value = true })
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ id = "MeleeHeros", name = "Auto Use on Melee Heros at [Q] range", value = false })
        Menu.Q:MenuElement({ id = "Melee", name = "Auto Use on Any in Melee range", value = true })
        Menu.Q:MenuElement({ id = "KS", name = "Use on KS", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "Auto", name = "Free ELO", value = true })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "WR Shroom Helper - Auto Shroomer" } })
        Menu.R:MenuElement({ id = "Enabled", name = "Enabled Shroom Helper", value = false })
        Menu.R:MenuElement({ id = "MinAmmo", name = "Save Min X Shrooms", value = 2, min = 0, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "Draw", name = "Draw Nearby Spots", value = false })

        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.R:MenuElement({ id = "ComboMinAmmo", name = "Save Min X Shrooms", value = 2, min = 0, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
    end

    function Teemo:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.R.Range + 300)
        self.target = GetTarget(self.Q.Range + 200, 0) or GetTarget(GetTrueAttackRange(myHero), 0)
        self.mode = GetMode()
        self.incamo = HasBuff(myHero, "camouflagestealth")
        self.isblind = HasBuff(self.target, "BlindingDart")
        self.steppedonshroom = HasBuff(self.target, "bantamptraptarget")
        --
        if Menu.R.Enabled:Value() then
            self:UpdateSpots()
        end
        if myHero.isChanneling then
            return
        end
        self:Auto()
        if Menu.Q.KS:Value() then
            self:KillSteal()
        end

        --
        if not self.target or not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 3 and self:Clear() or
            self.mode == 4 and self:Clear() or
            self.mode == 5 and self:LastHit() or
            self.mode == 6 and self:Flee()
    end

    function Teemo:OnWndMsg(msg, param)
        if param == HK_R and Menu.R.Enabled:Value() then
            for delay = 1, 2, 0.5 do
                DelayAction(function()
                    self:FindShrooms()
                end, delay)
            end
        end

        local level = myHero:GetSpellData(_R).level
        if level >= 1 then
            self.R.Range = ({ 600, 700, 900 })[level]
        end
    end

    function Teemo:Auto()
        local qMelee = nil
        local qMeleeHeros = nil

        if self.incamo then
            return
        end

        if Menu.Q.Melee:Value() then
            qMelee = GetTarget(350, 1)
        end
        if Menu.Q.MeleeHeros:Value() then
            qMeleeHeros = GetTarget(self.Q.Range, 1)
            --qMeleeHeros = DamageLib:IsMelee(GetTarget(self.Q.Range, 1))
        end

        if self.isblind then
            return
        end

        if self.Q:IsReady() and qMelee and Menu.Q.Melee:Value() then
            self.Q:Cast(qMelee)
        end

        if self.Q:IsReady() and qMeleeHeros and Menu.Q.MeleeHeros:Value() then
            self.Q:Cast(qMeleeHeros)
        end
        if self.mode ~= 6 and self.R:IsReady() and Timer() - self.R.LastCast >= 1.25 and Menu.R.Enabled:Value() and
            myHero:GetSpellData(_R).ammo > Menu.R.MinAmmo:Value() then
            for i = 1, #self.nearbySpots do
                local spot = self.nearbySpots[i]
                if GetDistance(myHero, spot) <= self.R.Range and not spot.active then
                    self.R:Cast(spot.pos)
                    self.R.LastCast = Timer()
                    return
                end
            end
        end
    end

    function Teemo:Combo()
        local target = self.target
        local distance = GetDistance(myHero, target)
        --
        if self.W:IsReady() and Menu.W.Combo:Value() and ManaPercent(myHero) >= Menu.W.Mana:Value() and
            (distance <= 300 or distance >= 550) then
            self.W:Cast()
        elseif self.Q:IsReady() and Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() and
            distance <= self.Q.Range and not self.isblind then
            self.Q:Cast(target)
        elseif self.R:IsReady() and Timer() - self.R.LastCast >= 3 and Menu.R.Combo:Value() and
            ManaPercent(myHero) >= Menu.R.Mana:Value() and distance <= self.R.Range and
            myHero:GetSpellData(_R).ammo > Menu.R.ComboMinAmmo:Value() and not self.steppedonshroom then
            local bestPos = self.R:GetBestCircularCastPos(target, GetEnemyHeroes(self.R.ExploRadius))
            if bestPos then
                Control.CastSpell(HK_R, bestPos)
            end
            --self.R:CastToPred(target, 3)
            self.R.LastCast = Timer()
        end
    end

    function Teemo:Harass()
        local target = self.target
        local distance = GetDistance(myHero, target)
        local QManaHarass = Menu.Q.ManaHarass:Value()
        local WManaHarass = Menu.W.ManaHarass:Value()
        --
        if self.W:IsReady() and Menu.W.Harass:Value() and ManaPercent(myHero) >= WManaHarass and
            (distance <= 300 or distance >= 550) then
            self.W:Cast()
        elseif self.Q:IsReady() and Menu.Q.Harass:Value() and ManaPercent(myHero) >= QManaHarass and
            distance <= self.Q.Range then
            self.Q:Cast(target)
        end
    end

    function Teemo:Clear()
        local qRange, jCheckQ, lCheckQ = self.Q.Range, Menu.Q.Jungle:Value(), Menu.Q.Clear:Value()
        local QManaClear = Menu.Q.ManaClear:Value()
        --
        if self.Q:IsReady() and (jCheckQ or lCheckQ) and ManaPercent(myHero) >= QManaClear then
            local minions = (jCheckQ and GetMonsters(qRange)) or {}
            minions = (#minions == 0 and lCheckQ and GetEnemyMinions(qRange)) or minions
            for i = 1, #minions do
                local minion = minions[i]
                local distance = GetDistance(myHero, minion)
                if minion.health <= self.Q:GetDamage(minion) or minion.team == TEAM_JUNGLE and distance <= self.Q.Range then
                    self.Q:Cast(minion)
                    return
                end
            end
        end
    end

    function Teemo:LastHit()
        local QManaLastHit = Menu.Q.ManaLastHit:Value()
        if self.Q:IsReady() and Menu.Q.LastHit:Value() and ManaPercent(myHero) >= QManaLastHit then
            local minions = GetEnemyMinions(self.Q.Range)
            for i = 1, #minions do
                local minion = minions[i]
                local distance = GetDistance(myHero, minion)
                if minion.health <= self.Q:GetDamage(minion) and distance <= self.Q.Range then
                    --check if Q dmg is right
                    self.Q:Cast(minion)
                    return
                end
            end
        end
    end

    function Teemo:Flee()
        if self.W:IsReady() and Menu.W.Flee:Value() and GetTarget(self.Q.Range, 1) then
            self.W:Cast()
        end
    end

    function Teemo:KillSteal()
        if (Menu.Q.KS:Value() and self.Q:IsReady()) then
            for i = 1, #self.enemies do
                local enemy = self.enemies[i]
                local distance = GetDistance(myHero, enemy)
                if enemy and self.Q:GetDamage(enemy) >= enemy.health and distance <= self.Q.Range then
                    self.Q:Cast(self.target);
                    return
                end
            end
        end
    end

    function Teemo:OnDraw()
        DrawSpells(self)
        --
        if Menu.Draw.ON:Value() then
            if self.nearbySpots and Menu.R.Draw:Value() then
                for i = 1, #self.nearbySpots do
                    local spot = self.nearbySpots[i]
                    DrawCircle(spot.pos, 30, spot.active and self.Color1 or self.Color2)
                end
            end
        end
    end

    function Teemo:UpdateSpots()
        for k, obj in pairs(self.nearbyShrooms) do
            if not obj or not obj.valid or obj.dead then
                self:SectorDataExecutor(obj, function(spot, obj)
                    if GetDistanceSqr(spot, obj) <= 200 * 200 then
                        spot.active = false
                    end
                end)
                self.nearbyShrooms[k] = nil
            end
        end

        self.nearbySpots = {}
        self:SectorDataExecutor(myHero, function(spot, obj)
            if GetDistanceSqr(spot.pos, myHero) <= 1000 * 1000 and spot.pos:To2D().onScreen then
                self.nearbySpots[#self.nearbySpots + 1] = spot
            end
        end)
    end

    function Teemo:CheckNearbySpots(x, z)
        if self.shroomSpots[x][z] then
            local t = self.shroomSpots[x][z]
            for i = 1, #t do
                --Worst Case = 3
                local spot = t[i]
                if GetDistanceSqr(spot.pos, myHero) <= 1000 * 1000 and spot.pos:To2D().onScreen then
                    self.nearbySpots[#self.nearbySpots + 1] = spot
                end
            end
        end
    end

    function Teemo:FindShrooms()
        for i = ObjectCount(), 1, -1 do
            local obj = Object(i)
            if obj and not obj.dead and obj.name == "Noxious Trap" then
                self:SectorDataExecutor(obj, function(spot, obj)
                    if GetDistanceSqr(spot, obj) <= 200 * 200 then
                        spot.active = true
                    end
                end)
                self.nearbyShrooms[obj.networkID] = obj
            end
        end
    end

    function Teemo:SectorDataExecutor(obj, func)
        local xFloor, zFloor = floor(obj.pos.x / 1000), floor(obj.pos.z / 1000)
        for x = xFloor - 1, xFloor + 1 do
            if self.shroomSpots[x] then
                for z = zFloor - 1, zFloor + 1 do
                    if self.shroomSpots[x][z] then
                        local t = self.shroomSpots[x][z]
                        for j = 1, #t do
                            local spot = t[j]
                            func(spot, obj)
                        end
                    end
                end
            end
        end
    end

    function Teemo:ShroomData()
        self.nearbySpots = {}
        self.nearbyShrooms = {}
        local mapID = Game.mapID
        if mapID == HOWLING_ABYSS then
            self.shroomSpots = {}
            print("No Shroom Data - HOWLING_ABYSS")
        elseif mapID == SUMMONERS_RIFT then
            self.shroomSpots = {
                [1] = {
                    [12] = {
                        { active = false, pos = Vector(1170, 0, 12320) },
                    },
                    [13] = {
                        { active = false, pos = Vector(1671, 0, 13000) },
                    },
                },
                [2] = {
                    [4] = {
                        { active = false, pos = Vector(2742, 0, 4959) },
                    },
                    [7] = {
                        { active = false, pos = Vector(2997, 0, 7597) },
                    },
                    [11] = {
                        { active = false, pos = Vector(2807, 0, 11909) },
                        { active = false, pos = Vector(2247, 0, 11847) },
                    },
                    [12] = {
                        { active = false, pos = Vector(2875, 0, 12553) },
                    },
                    [13] = {
                        { active = false, pos = Vector(2400, 0, 13511) },
                    },
                },
                [3] = {
                    [7] = {
                        { active = false, pos = Vector(3157, 0, 7206) },
                    },
                    [9] = {
                        { active = false, pos = Vector(3548, 0, 9286) },
                        { active = false, pos = Vector(3752, 0, 9437) },
                    },
                    [10] = {
                        { active = false, pos = Vector(3067, 0, 10899) },
                    },
                    [11] = {
                        { active = false, pos = Vector(3857, 0, 11358) },
                    },
                    [12] = {
                        { active = false, pos = Vector(3900, 0, 12829) },
                    },
                },
                [4] = {
                    [2] = {
                        { active = false, pos = Vector(4972, 0, 2882) },
                    },
                    [6] = {
                        { active = false, pos = Vector(4698, 0, 6140) },
                    },
                    [7] = {
                        { active = false, pos = Vector(4750, 0, 7211) },
                    },
                    [8] = {
                        { active = false, pos = Vector(4749, 0, 8022) },
                    },
                    [10] = {
                        { active = false, pos = Vector(4703, 0, 10063) },
                    },
                    [11] = {
                        { active = false, pos = Vector(4467, 0, 11841) },
                    },
                },
                [5] = {
                    [3] = {
                        { active = false, pos = Vector(5716, 0, 3505) },
                    },
                },
                [6] = {
                    [4] = {
                        { active = false, pos = Vector(6546, 0, 4723) },
                    },
                    [9] = {
                        { active = false, pos = Vector(6200, 0, 9288) },
                    },
                    [10] = {
                        { active = false, pos = Vector(6019, 0, 10405) },
                    },
                    [11] = {
                        { active = false, pos = Vector(6800, 0, 11558) },
                    },
                    [12] = {
                        { active = false, pos = Vector(6780, 0, 13011) },
                    },
                },
                [7] = {
                    [2] = {
                        { active = false, pos = Vector(7968, 0, 2197) },
                    },
                    [3] = {
                        { active = false, pos = Vector(7973, 0, 3362) },
                        { active = false, pos = Vector(7117, 0, 3100) },
                    },
                    [6] = {
                        { active = false, pos = Vector(7225, 0, 6216) },
                    },
                    [11] = {
                        { active = false, pos = Vector(7768, 0, 11808) },
                    },
                    [12] = {
                        { active = false, pos = Vector(7252, 0, 12546) },
                    },
                },
                [8] = {
                    [5] = {
                        { active = false, pos = Vector(8619, 0, 5622) },
                    },
                    [10] = {
                        { active = false, pos = Vector(8280, 0, 10245) },
                    },
                },
                [9] = {
                    [2] = {
                        { active = false, pos = Vector(9222, 0, 2129) },
                    },
                    [6] = {
                        { active = false, pos = Vector(9702, 0, 6319) },
                    },
                    [11] = {
                        { active = false, pos = Vector(9371, 0, 11445) },
                    },
                    [12] = {
                        { active = false, pos = Vector(9845, 0, 12060) },
                    },
                },
                [10] = {
                    [1] = {
                        { active = false, pos = Vector(10900, 0, 1970) },
                    },
                    [3] = {
                        { active = false, pos = Vector(10407, 0, 3091) },
                    },
                    [4] = {
                        { active = false, pos = Vector(10097, 0, 4972) },
                    },
                    [6] = {
                        { active = false, pos = Vector(10081, 0, 6590) },
                    },
                    [7] = {
                        { active = false, pos = Vector(10070, 0, 7299) },
                    },
                },
                [11] = {
                    [2] = {
                        { active = false, pos = Vector(11700, 0, 2036) },
                        { active = false, pos = Vector(11866, 0, 3186) },
                    },
                    [3] = {
                        { active = false, pos = Vector(11024, 0, 3883) },
                        { active = false, pos = Vector(11866, 0, 3186) },
                    },
                    [4] = {
                        { active = false, pos = Vector(11730, 0, 4091) },
                    },
                    [5] = {
                        { active = false, pos = Vector(11230, 0, 5575) },
                    },
                    [7] = {
                        { active = false, pos = Vector(11627, 0, 7103) },
                        { active = false, pos = Vector(11873, 0, 7530) },
                    },
                },
                [12] = {
                    [1] = {
                        { active = false, pos = Vector(12225, 0, 1292) },
                    },
                    [2] = {
                        { active = false, pos = Vector(12987, 0, 2028) },
                    },
                    [3] = {
                        { active = false, pos = Vector(12827, 0, 3131) },
                    },
                    [5] = {
                        { active = false, pos = Vector(12611, 0, 5318) },
                    },
                    [8] = {
                        { active = false, pos = Vector(12133, 0, 8821) },
                    },
                    [9] = {
                        { active = false, pos = Vector(12063, 0, 9974) },
                    },
                },
                [13] = {
                    [2] = {
                        { active = false, pos = Vector(13499, 0, 2837) },
                    },
                },
            }
        else
            --self.shroomSpots = {}
            print("No Shroom Data - Unsupported Map")
        end
        --[[         self.shroomSpots = {
            [1] = {
                [12] = {
                    {active = false, pos = Vector(1170, 0, 12320)},
                },
                [13] = {
                    {active = false, pos = Vector(1671, 0, 13000)},
                },
            },
            [2] = {
                [4] = {
                    {active = false, pos = Vector(2742, 0, 4959)},
                },
                [7] = {
                    {active = false, pos = Vector(2997, 0, 7597)},
                },
                [11] = {
                    {active = false, pos = Vector(2807, 0, 11909)},
                    {active = false, pos = Vector(2247, 0, 11847)},
                },
                [12] = {
                    {active = false, pos = Vector(2875, 0, 12553)},
                },
                [13] = {
                    {active = false, pos = Vector(2400, 0, 13511)},
                },
            },
            [3] = {
                [7] = {
                    {active = false, pos = Vector(3157, 0, 7206)},
                },
                [9] = {
                    {active = false, pos = Vector(3548, 0, 9286)},
                    {active = false, pos = Vector(3752, 0, 9437)},
                },
                [10] = {
                    {active = false, pos = Vector(3067, 0, 10899)},
                },
                [11] = {
                    {active = false, pos = Vector(3857, 0, 11358)},
                },
                [12] = {
                    {active = false, pos = Vector(3900, 0, 12829)},
                },
            },
            [4] = {
                [2] = {
                    {active = false, pos = Vector(4972, 0, 2882)},
                },
                [6] = {
                    {active = false, pos = Vector(4698, 0, 6140)},
                },
                [7] = {
                    {active = false, pos = Vector(4750, 0, 7211)},
                },
                [8] = {
                    {active = false, pos = Vector(4749, 0, 8022)},
                },
                [10] = {
                    {active = false, pos = Vector(4703, 0, 10063)},
                },
                [11] = {
                    {active = false, pos = Vector(4467, 0, 11841)},
                },
            },
            [5] = {
                [3] = {
                    {active = false, pos = Vector(5716, 0, 3505)},
                },
            },
            [6] = {
                [4] = {
                    {active = false, pos = Vector(6546, 0, 4723)},
                },
                [9] = {
                    {active = false, pos = Vector(6200, 0, 9288)},
                },
                [10] = {
                    {active = false, pos = Vector(6019, 0, 10405)},
                },
                [11] = {
                    {active = false, pos = Vector(6800, 0, 11558)},
                },
                [12] = {
                    {active = false, pos = Vector(6780, 0, 13011)},
                },
            },
            [7] = {
                [2] = {
                    {active = false, pos = Vector(7968, 0, 2197)},
                },
                [3] = {
                    {active = false, pos = Vector(7973, 0, 3362)},
                    {active = false, pos = Vector(7117, 0, 3100)},
                },
                [6] = {
                    {active = false, pos = Vector(7225, 0, 6216)},
                },
                [11] = {
                    {active = false, pos = Vector(7768, 0, 11808)},
                },
                [12] = {
                    {active = false, pos = Vector(7252, 0, 12546)},
                },
            },
            [8] = {
                [5] = {
                    {active = false, pos = Vector(8619, 0, 5622)},
                },
                [10] = {
                    {active = false, pos = Vector(8280, 0, 10245)},
                },
            },
            [9] = {
                [2] = {
                    {active = false, pos = Vector(9222, 0, 2129)},
                },
                [6] = {
                    {active = false, pos = Vector(9702, 0, 6319)},
                },
                [11] = {
                    {active = false, pos = Vector(9371, 0, 11445)},
                },
                [12] = {
                    {active = false, pos = Vector(9845, 0, 12060)},
                },
            },
            [10] = {
                [1] = {
                    {active = false, pos = Vector(10900, 0, 1970)},
                },
                [3] = {
                    {active = false, pos = Vector(10407, 0, 3091)},
                },
                [4] = {
                    {active = false, pos = Vector(10097, 0, 4972)},
                },
                [6] = {
                    {active = false, pos = Vector(10081, 0, 6590)},
                },
                [7] = {
                    {active = false, pos = Vector(10070, 0, 7299)},
                },
            },
            [11] = {
                [2] = {
                    {active = false, pos = Vector(11700, 0, 2036)},
                    {active = false, pos = Vector(11866, 0, 3186)},
                },
                [3] = {
                    {active = false, pos = Vector(11024, 0, 3883)},
                    {active = false, pos = Vector(11866, 0, 3186)},
                },
                [4] = {
                    {active = false, pos = Vector(11730, 0, 4091)},
                },
                [5] = {
                    {active = false, pos = Vector(11230, 0, 5575)},
                },
                [7] = {
                    {active = false, pos = Vector(11627, 0, 7103)},
                    {active = false, pos = Vector(11873, 0, 7530)},
                },
            },
            [12] = {
                [1] = {
                    {active = false, pos = Vector(12225, 0, 1292)},
                },
                [2] = {
                    {active = false, pos = Vector(12987, 0, 2028)},
                },
                [3] = {
                    {active = false, pos = Vector(12827, 0, 3131)},
                },
                [5] = {
                    {active = false, pos = Vector(12611, 0, 5318)},
                },
                [8] = {
                    {active = false, pos = Vector(12133, 0, 8821)},
                },
                [9] = {
                    {active = false, pos = Vector(12063, 0, 9974)},
                },
            },
            [13] = {
                [2] = {
                    {active = false, pos = Vector(13499, 0, 2837)},
                },
            },
        } ]]
    end

    insert(LoadCallbacks, function()
        Teemo()
    end)


elseif myHero.charName == "Thresh" then

    class 'Thresh'
    --Thresh = Class()

    function Thresh:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Custom Callbacks]]
        OnInterruptable(function(unit, spell)
            self:OnInterruptable(unit, spell)
        end)
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Thresh:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 1000, --max range misses most of the time zz
            Delay = 0.5,
            Speed = 1900,
            Radius = 70,
            Collision = true,
            CollisionTypes = { COLLISION_MINION, COLLISION_ENEMYHERO, COLLISION_YASUOWALL },
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.Q2 = Spell({
            Slot = 0,
            Range = huge,
            Delay = 0.5,
            Speed = 1900,
            Radius = 70,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.W = Spell({
            Slot = 1,
            Range = 950,
            Delay = 0.25,
            Speed = 1450,
            Radius = 150,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
        self.E = Spell({
            Slot = 2,
            Range = 400,
            Delay = 0.25,
            Speed = 1100,
            Radius = 150,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.R = Spell({
            Slot = 3,
            Range = 375,
            Delay = 0.25,
            Speed = huge,
            Radius = 320,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
    end

    function Thresh:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Interrupt Settings" } })
        Menu.Q:MenuElement({ id = "Interrupter", name = "Use To Interrupt", value = true })
        Menu.Q:MenuElement({ id = "Interrupt", name = "Interrupt Targets", type = MENU })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "Auto", name = "Auto Use on Immobile", value = true })
        Menu.Q:MenuElement({ id = "Dashing", name = "Auto Use on Dashing", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        Menu.W:MenuElement({ id = "HardCC", name = "Use on CCed Allies", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Interrupt Settings" } })
        Menu.E:MenuElement({ id = "Interrupter", name = "Use To Interrupt", value = true })
        Menu.E:MenuElement({ id = "Interrupt", name = "Interrupt Targets", type = MENU })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "Dashing", name = "Auto Use on Dashing", value = true })
        Menu.E:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        Menu.E:MenuElement({ id = "Key", name = "Toggle Push-Pull", key = string.byte("T"), toggle = true })
        Menu.E:MenuElement({ id = "Draw", name = "Draw Toggle State", value = false })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.R:MenuElement({ id = "Count", name = "When X Enemies Around", value = 2, min = 1, max = 5, step = 1 })
        Menu.R:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.R:MenuElement({ id = "Auto", name = "Auto Use When X Enemies Around", value = 3, min = 0, max = 5, step = 1 })

        Menu.R:MenuElement({ id = "Mana", name = "Min Mana %", value = 0, min = 0, max = 100, step = 1 })
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
        ObjectManager:OnEnemyHeroLoad(function(args)
            Interrupter:AddToMenu(args.unit, Menu.Q.Interrupt)
            Interrupter:AddToMenu(args.unit, Menu.E.Interrupt)
        end)
    end

    function Thresh:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.Q.Range)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0) --GetTarget(self.E.Range, 0)
        self.mode = GetMode()
        --
        if myHero.isChanneling then
            return
        end
        self:Auto()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 6 and self:Flee()
    end

    function Thresh:OnInterruptable(unit, spell)
        if not IsValidTarget(unit) or ShouldWait() then
            return
        end
        --
        if self.E:IsReady() and GetDistance(unit) < self.E.Range and Menu.E.Interrupter:Value() and
            Menu.E.Interrupt[spell.name]:Value() then
            self.E:Cast(self:GetPosE(unit, "Pull"))
        elseif self.Q:IsReady() and GetDistance(unit) < self.Q.Range and Menu.Q.Interrupter:Value() and
            Menu.Q.Interrupt[spell.name]:Value() then
            self.Q:CastToPred(unit, 2)
        end
    end

    function Thresh:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if unit.team ~= TEAM_ENEMY or ShouldWait() or not IsValidTarget(unit, self.Q.Range) then
            return
        end
        --
        if self.E:IsReady() and GetDistance(unit) < self.E.Range then
            if GetDistance(unitPosTo) < self.E.Range and IsFacing(unit, myHero) then
                --Gapcloser
                self.E:Cast(self:GetPosE(unit, "Push"))
            elseif GetDistance(unitPosTo) > self.E.Range and not IsFacing(unit, myHero) then
                --Running Away
                self.E:Cast(self:GetPosE(unit, "Pull"))
            end
        elseif Menu.Q.Dashing:Value() and self.Q:IsReady() then
            self.Q:CastToPred(unit, 3)
        end
    end

    function Thresh:OnDraw()
        DrawSpells(self)
        local threshPushPull = Menu.E.Draw:Value() and
            DrawText("E Mode:" .. (Menu.E.Key:Value() and "Push" or "Pull"), 20, myHero.pos:To2D().x - 33,
                myHero.pos:To2D().y + 60, Color.Green) --was pLambda
    end

    function Thresh:Auto()
        local nearby = #GetEnemyHeroes(self.R.Range)
        --
        if self.R:IsReady() and nearby > 0 then
            local autoMin = Menu.R.Auto:Value()
            local autoCheck = autoMin ~= 0 and nearby >= autoMin and Menu.R.Auto:Value()
            local comboCheck = self.mode == 1 and nearby >= Menu.R.Count:Value() and Menu.R.Combo:Value()
            --
            if autoCheck or comboCheck then
                self.R:Cast()
                return
            end
        end
        --
        if self.Q:IsReady() and Menu.Q.Auto:Value() then
            for i = 1, #self.enemies do
                local enemy = self.enemies[i]
                if IsImmobile(enemy, 0.75) then
                    self.Q:Cast(enemy)
                    return
                end
            end
        end
        --
        if self.W:IsReady() then
            local comboCheck = Menu.W.Combo:Value() and self.mode == 1 and ManaPercent(myHero) >= Menu.W.Mana:Value()
            if Menu.W.HardCC:Value() or comboCheck then
                local allies = GetAllyHeroes(self.W.Range)
                local furthest = myHero
                --
                for i = 1, #allies do
                    local ally = allies[i]
                    local enemyCount = CountEnemiesAround(ally, 800)
                    --
                    if ally.health < enemyCount * ally.levelData.lvl * 25 then
                        self.W:Cast(ally);
                        return
                    end
                    if IsImmobile(ally) and enemyCount > 0 then
                        self.W:Cast(ally);
                        return
                    end
                    --
                    if GetDistanceSqr(ally) >= GetDistanceSqr(furthest) then
                        furthest = ally
                    end
                end
                --
                if comboCheck and not self.Q:IsReady() and GetDistance(furthest) >= 600 then
                    self.W:Cast(furthest)
                end
            end
        end
    end

    function Thresh:Flee()
        if self.target then
            if Menu.E.Flee:Value() and self.E:IsReady() then
                self.E:Cast(self:GetPosE(self.target, "Push"))
            elseif Menu.W.Flee:Value() and self.W:IsReady() then
                self.W:Cast(myHero)
            end
        end
    end

    function Thresh:GetPosE(unit, mode)
        local push = mode == "Push" and true or Menu.E.Key:Value()
        --
        return myHero.pos:Extended(unit.pos, self.E.Range * (push and 1 or -1))
    end

    function Thresh:Combo()
        local target = GetTarget(self.Q.Range, 0)
        if not target then
            return
        end
        --
        if self.E:IsReady() and Menu.E.Combo:Value() and GetDistance(target) < self.E.Range and
            ManaPercent(myHero) >= Menu.E.Mana:Value() then
            local flayTowards = self:GetPosE(target)
            self.E:Cast(flayTowards)
        elseif self.Q:IsReady() and Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
            self.Q:CastToPred(target, 2)
        end
    end

    function Thresh:Harass()
        local target = GetTarget(self.Q.Range, 0)
        if not target then
            return
        end
        --
        if self.E:IsReady() and Menu.E.Harass:Value() and GetDistance(target) < self.E.Range and
            ManaPercent(myHero) >= Menu.E.ManaHarass:Value() then
            local flayTowards = self:GetPosE(target)
            self.E:Cast(flayTowards)
        elseif self.Q:IsReady() and Menu.Q.Harass:Value() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() then
            self.Q:CastToPred(target, 2)
        end
    end

    insert(LoadCallbacks, function()
        Thresh()
    end)

elseif myHero.charName == "TwistedFate" then

    class 'TwistedFate'
    --TwistedFate = Class()

    function TwistedFate:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnAttack(function(...)
            self:OnAttack(...)
        end)
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
    end

    function TwistedFate:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 1450,
            Delay = 0.25,
            Speed = 1000,
            Radius = 50,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.W = Spell({
            Slot = 1,
            Range = huge,
            From = myHero,
            Type = SpellTypePress
        })
        self.R = Spell({
            Slot = 3,
            Range = 5500,
            Delay = 1,
            Speed = huge,
            Radius = 150,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
        self.W.Pick = "DONTPICKSHIT"
        self.W.LastCast = 0
    end

    function TwistedFate:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Pred", name = "Prediction Mode", value = 2,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "PredHarass", name = "Prediction Mode", value = 3,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "Auto", name = "Auto Use on Immobile", value = true })
        Menu.Q:MenuElement({ id = "KS", name = "Use on KS", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "Auto", name = "Pick Gold Card On Ult", value = true })
        Menu.W:MenuElement({ id = "ManaMin", name = "Pick Blue Card if Mana < X", value = 30, min = 0, max = 100,
            step = 1 })
        Menu.W:MenuElement({ id = "Flee", name = "Use on Flee", value = true })

        Menu:MenuElement({ name = " ", drop = { "Extra Features" } })
        --CardPicker
        Menu:MenuElement({ id = "Key", name = "Card Picker", type = MENU })
        Menu.Key:MenuElement({ id = "Gold", name = "Pick Gold Card", key = string.byte("E") })
        Menu.Key:MenuElement({ id = "Blue", name = "Pick Blue Card", key = string.byte("T") })
        Menu.Key:MenuElement({ id = "Red", name = "Pick Red Card", key = string.byte("Z") })

        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
    end

    function TwistedFate:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.Q.Range)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.mode = GetMode()
        --
        self:Auto()
        if myHero.isChanneling then
            return
        end
        self:KillSteal()
        --
        if not (self.mode and self.enemies) then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 6 and self:Flee()
    end

    function TwistedFate:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function TwistedFate:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function TwistedFate:OnAttack()
        if self.W:IsReady() and ManaPercent(myHero) <= Menu.W.ManaMin:Value() then
            self:PickCard("Blue")
        end
    end

    function TwistedFate:Auto()
        if Menu.Key.Gold:Value() or Menu.W.Auto:Value() and HasBuff(myHero, "Gate") and self:CanPick() then
            self:PickCard("Gold")
        elseif Menu.Key.Blue:Value() then
            self:PickCard("Blue")
        elseif Menu.Key.Red:Value() then
            self:PickCard("Red")
        end
        if HasBuff(myHero, "pickacard_tracker") then
            self.IsPicking = true
            local spellName = myHero:GetSpellData(_W).name
            if spellName:find(self.W.Pick) and self.W:IsReady() then
                self.W:Cast()
                self.W.Pick = "DONTPICKSHIT"
            end
        else
            self.IsPicking = false
        end

        if self.Q:IsReady() and Menu.Q.Auto:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() and self.enemies then
            for i = 1, #self.enemies do
                local enemy = self.enemies[i]
                if IsImmobile(enemy) then
                    self.Q:Cast(enemy.pos)
                end
            end
        end
    end

    function TwistedFate:Combo()
        if Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() and self.Q:IsReady() then
            qTarget = GetTarget(self.Q.Range)
            self.Q:CastToPred(qTarget, Menu.Q.Pred:Value())
        end
        if Menu.W.Combo:Value() and ManaPercent(myHero) >= Menu.W.Mana:Value() and self:CanPick() and self.target then
            self:PickCard("Gold")
        end
    end

    function TwistedFate:Harass()
        if Menu.Q.Harass:Value() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() and self.Q:IsReady() then
            qTarget = GetTarget(self.Q.Range)
            self.Q:CastToPred(qTarget, Menu.Q.PredHarass:Value())
        end
        if Menu.W.Harass:Value() and ManaPercent(myHero) >= Menu.W.ManaHarass:Value() and self:CanPick() and self.target then
            self:PickCard("Gold")
        end
    end

    function TwistedFate:Flee()
        if not self.target then
            return
        end
        if Menu.W.Flee:Value() and self:CanPick() then
            self:PickCard("Gold")
        end
        if HasBuff(myHero, "GoldCardPreAttack") then
            Control.Attack(self.target)
        end
    end

    function TwistedFate:KillSteal()
        for i = 1, #self.enemies do
            local unit = self.enemies[i]
            if IsValidTarget(unit) and self.Q:IsReady() and Menu.Q.KS:Value() then
                local damage = self.Q:GetDamage(unit)
                if unit.health + unit.shieldAP < damage then
                    self.Q:CastToPred(unit, 1);
                    return
                end
            end
        end
    end

    function TwistedFate:OnDraw()
        DrawSpells(self)
    end

    function TwistedFate:PickCard(card)
        self.W.Pick = card
        if self:CanPick() then
            self.W.LastCast = Timer()
            self.W:Cast()
        end
    end

    function TwistedFate:CanPick(card)
        return self.W:IsReady() and self.IsPicking == false and Timer() - self.W.LastCast >= 0.3
    end

    insert(LoadCallbacks, function()
        TwistedFate()
    end)

elseif myHero.charName == "Twitch" then

    class 'Twitch'
    --Twitch = Class()

    function Twitch:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.poisonTable = {}
        self.Killable = {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttack(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Twitch:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 800,
            Delay = 0.85,
            Speed = huge,
            Radius = huge,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.W = Spell({
            Slot = 1,
            Range = 950,
            Delay = 0.25,
            Speed = 1400,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
        self.E = Spell({
            Slot = 2,
            Range = 1200,
            Delay = 0.25,
            Speed = huge,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.R = Spell({
            Slot = 3,
            Range = 850,
            Delay = 0.25,
            Speed = huge,
            Radius = 150,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
    end

    function Twitch:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "Turret", name = "Use on Turret", value = true })
        Menu.Q:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        Menu.W:MenuElement({ id = "Gapcloser", name = "Use on Gapcloser", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Min", name = "Min Stacks", value = 6, min = 1, max = 30, step = 1 })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "MinHarass", name = "Min Stacks", value = 6, min = 1, max = 30, step = 1 })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "KS", name = "Use to KS", value = true })
        Menu.E:MenuElement({ id = "Dying", name = "Use If Dying", value = true })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Count", name = "Use When X Enemies", value = 2, min = 0, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "Duel", name = "Use on Duel", value = true })
        Menu.R:MenuElement({ id = "Heroes", name = "Duel Targets", type = MENU })
        ObjectManager:OnEnemyHeroLoad(function(args)
            self.poisonTable[args.networkID] = { stacks = 0, endTime = 0, dmg = 0 }
            Menu.R.Heroes:MenuElement({ id = args.charName, name = args.charName, value = false })
        end)
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana %", value = 0, min = 0, max = 100, step = 1 })

        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
    end

    function Twitch:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.E.Range)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.mode = GetMode()
        --
        if myHero.isChanneling then
            return
        end
        self:UpdatePoison()
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 6 and self:Flee()
    end

    function Twitch:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Twitch:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Twitch:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        if ShouldWait() or not IsValidTarget(target) then
            return
        end
        local tType = target.type
        --
        if self.Q:IsReady() and not self:IsInvisible() then
            local qCombo, qHarass = self.mode == 1 and Menu.Q.Combo:Value() and
                ManaPercent(myHero) >= Menu.Q.Mana:Value(),
                not qCombo and self.mode == 2 and Menu.Q.Harass:Value() and
                ManaPercent(myHero) >= Menu.Q.ManaHarass:Value()
            if (tType == Obj_AI_Turret and Menu.Q.Turret:Value()) or (tType == Obj_AI_Hero and (qCombo or qHarass)) then
                self.Q:Cast()
            end
        end
        if self.W:IsReady() and tType == Obj_AI_Hero and not self:IsUlting() then
            local wCombo, wHarass = self.mode == 1 and Menu.W.Combo:Value() and
                ManaPercent(myHero) >= Menu.W.Mana:Value(),
                not wCombo and self.mode == 2 and Menu.W.Harass:Value() and
                ManaPercent(myHero) >= Menu.W.ManaHarass:Value()
            if wCombo or wHarass then
                self.W:CastToPred(target, 2)
            end
        end
    end

    function Twitch:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() or not (Menu.W.Gapcloser:Value() and self.W:IsReady()) then
            return
        end
        if not self:IsInvisible() and IsValidTarget(unit) and GetDistance(unitPosTo) < self.W.Range and
            unit.team == TEAM_ENEMY and IsFacing(unit, myHero) then
            --Gapcloser
            self.W:CastToPred(unit, 2)
        end
    end

    function Twitch:Combo()
        if self.R:IsReady() and ManaPercent(myHero) >= Menu.R.Mana:Value() and Menu.R.Count:Value() ~= 0 then
            local rTarget = GetTarget(self.R.Range)
            if (#GetEnemyHeroes(self.R.Range) >= Menu.R.Count:Value()) or
                (Menu.R.Duel:Value() and IsValidTarget(rTarget) and Menu.R.Heroes[rTarget.charName]:Value()) then
                self.R:Cast()
                return
            end
        end
        --
        if self.E:IsReady() and Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value() then
            local stacks = 0
            for i = 1, #self.enemies do
                stacks = stacks + self.poisonTable[self.enemies[i].networkID].stacks
            end
            if stacks >= Menu.E.Min:Value() then
                self.E:Cast()
            end
        end
        --
        if not self:IsInvisible() and not GetTarget(GetTrueAttackRange(myHero), 0) and GetTarget(self.W.Range, 0) then
            if self.Q:IsReady() and Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
                self.Q:Cast()
            end
            if self.W:IsReady() and not self:IsUlting() and Menu.W.Combo:Value() and
                ManaPercent(myHero) >= Menu.W.Mana:Value() then
                self.W:CastToPred(target, 2)
            end
        end
    end

    function Twitch:Harass()
        if self.E:IsReady() and Menu.E.Harass:Value() and ManaPercent(myHero) >= Menu.E.ManaHarass:Value() then
            local stacks = 0
            for i = 1, #self.enemies do
                stacks = stacks + self.poisonTable[self.enemies[i].networkID].stacks
            end
            if stacks >= Menu.E.MinHarass:Value() then
                self.E:Cast()
            end
        end
        --
        if not self:IsInvisible() and not GetTarget(GetTrueAttackRange(myHero), 0) and GetTarget(self.W.Range, 0) then
            if self.Q:IsReady() and Menu.Q.Harass:Value() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() then
                self.Q:Cast()
            end
            if self.W:IsReady() and not self:IsUlting() and Menu.W.Harass:Value() and
                ManaPercent(myHero) >= Menu.W.ManaHarass:Value() then
                self.W:CastToPred(target, 2)
            end
        end
    end

    function Twitch:Flee()
        if #GetEnemyHeroes(1000) == 0 then
            return
        end
        local wTarget = GetTarget(600, 0)
        if not self:IsInvisible() and self.W:IsReady() and Menu.W.Flee:Value() and wTarget then
            self.W:CastToPred(wTarget, 2)
        elseif self.Q:IsReady() and Menu.Q.Flee:Value() then
            self.Q:Cast()
        end
    end

    function Twitch:KillSteal()
        if not self.E:IsReady() then
            return
        end
        if Menu.E.Dying:Value() and HealthPercent(myHero) <= 10 then
            self.E:Cast()
        elseif Menu.E.KS:Value() then
            for k, enemy in pairs(self.Killable) do
                if IsValidTarget(enemy, self.E.Range) then
                    self.E:Cast()
                end
            end
        end
    end

    function Twitch:OnDraw()
        DrawSpells(self)
        --
        if Menu.Draw.ON:Value() then
            for k, enemy in pairs(self.Killable) do
                local pos = enemy.toScreen
                if pos.onScreen and IsValidTarget(enemy, self.E.Range) then
                    DrawText("Killable", 50, pos.x - enemy.boundingRadius, pos.y, DrawColor(255, 66, 244, 98))
                end
            end
        end
    end

    function Twitch:IsInvisible()
        return HasBuff(myHero, "TwitchHideInShadows")
    end

    function Twitch:IsUlting()
        return myHero.range >= 800
    end

    function Twitch:CalcDamage(enemy)
        local eLvl = myHero:GetSpellData(_E).level
        local stacks = self.poisonTable[enemy.networkID].stacks
        if stacks ~= 0 then
            local baseDmg, stackDmg = (10 + 10 * eLvl), (15 + 5 * eLvl + 0.35 * myHero.bonusDamage + 0.333 * myHero.ap)
            return Damage:getdmg(_E, enemy, self.From, 1, eLvl) --Damage:CalcDamage(myHero, enemy, 1, baseDmg + stackDmg * stacks)
        end
        return 0
    end

    function Twitch:UpdatePoison()
        for i = 1, #self.enemies do
            local enemy = self.enemies[i]
            local ID = enemy.networkID
            --
            if not self.poisonTable[ID] then
                self.poisonTable[ID] = { stacks = 0, endTime = 0, dmg = 0 }
            end
            --
            local oldStacks, oldTime = self.poisonTable[ID].stacks, self.poisonTable[ID].endTime
            --
            local buff = GetBuffByName(enemy, "TwitchDeadlyVenom")
            if buff and buff.count > 0 and Timer() < buff.expireTime then
                if buff.expireTime > oldTime and oldStacks < 6 then
                    self.poisonTable[ID].stacks = oldStacks + 1
                end
                self.poisonTable[ID].endTime = buff.expireTime
            else
                self.poisonTable[ID].stacks = 0
            end
            --
            local eDmg = self:CalcDamage(enemy)
            self.poisonTable[ID].dmg = eDmg
            if eDmg >= enemy.health + enemy.shieldAD then
                self.Killable[ID] = enemy
            else
                self.Killable[ID] = nil
            end
        end
    end

    insert(LoadCallbacks, function()
        Twitch()
    end)

elseif myHero.charName == "Varus" then

    class 'Varus'
    --Varus = Class()

    function Varus:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Varus:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 925 or 1625,
            Delay = 0.25,
            Speed = 1850,
            Radius = 70,
            Collision = true, --was false
            CollisionTypes = { COLLISION_YASUOWALL }, --
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.W = Spell({
            Slot = 1,
            Range = huge,
            From = myHero,
            Type = SpellTypePress
        })
        self.E = Spell({
            Slot = 2,
            Range = 925,
            Delay = 0.25,
            Speed = 1500,
            Radius = 550,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
        self.R = Spell({
            Slot = 3,
            Range = 1075,
            Delay = 0.25,
            Speed = 1500,
            Radius = 120,
            Collision = true, --was false
            CollisionTypes = { COLLISION_YASUOWALL }, --
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.Q.MaxRange = 1625
    end

    function Varus:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Stack", name = "Save To Proc 3 Stacks", value = true })
        Menu.Q:MenuElement({ id = "Pred", name = "Prediction Mode", value = 3,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "StackHarass", name = "Save To Proc 3 Stacks", value = false })
        Menu.Q:MenuElement({ id = "PredHarass", name = "Prediction Mode", value = 2,
            drop = { "Fuck it", "Normal", "High", "Immobile", "Dashing" } })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "KS", name = "Use on KS", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ id = "Stack", name = "Save To Proc 3 Stacks", value = true })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ id = "StackHarass", name = "Save To Proc 3 Stacks", value = true })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        -- Menu.E:MenuElement({id = "KS", name = "Use on KS", value = true})
        Menu.E:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Combo", name = "Use on Duel", value = true })
        Menu.R:MenuElement({ id = "Min", name = "Min Target HP%", value = 15, min = 0, max = 100, step = 1 })
        Menu.R:MenuElement({ id = "Heroes", name = "Duel Targets", type = MENU })
        Menu.R:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.R:MenuElement({ id = "Peel", name = "Auto Use To Peel", value = true })
        Menu.R:MenuElement({ id = "PeelList", name = "Whitelist", type = MENU })
        Menu.R:MenuElement({ id = "Gapcloser", name = "Auto Use On Dash", value = true })
        Menu.R:MenuElement({ id = "GapList", name = "Whitelist", type = MENU })
        Menu.R:MenuElement({ id = "Auto", name = "Auto Use On Immobile", value = true })
        --
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
        ObjectManager:OnEnemyHeroLoad(function(args)
            local charName = args.charName
            Menu.R.Heroes:MenuElement({ id = charName, name = charName, value = false })
            Menu.R.PeelList:MenuElement({ id = charName, name = charName, value = true })
            Menu.R.GapList:MenuElement({ id = charName, name = charName, value = true })
        end)
    end

    function Varus:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.Q.MaxRange)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.mode = GetMode()
        --
        self:LogicQ()
        if myHero.isChanneling then
            return
        end
        self:Auto()
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 6 and self:Flee()
    end

    function Varus:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Varus:OnPreAttack(args)
        --args.Process|args.Target
        if self.Charging or ShouldWait() then
            args.Process = false
            return
        end
    end

    function Varus:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() or not (self.R:IsReady() and Menu.R.Gapcloser:Value()) then
            return
        end
        if IsValidTarget(unit) and GetDistance(unitPosTo) < 500 and unit.team == TEAM_ENEMY and
            Menu.R.GapList[unit.charName] and Menu.R.GapList[unit.charName]:Value() and IsFacing(unit, myHero) then
            --Gapcloser
            self.R:CastToPred(unit, 3)
        end
    end

    function Varus:Auto()
        if not self.R:IsReady() then
            return
        end
        local autoCheck, peelCheck = Menu.R.Auto:Value(), Menu.R.Peel:Value()
        if autoCheck or peelCheck then
            for i = 1, #self.enemies do
                local enemy = self.enemies[i]
                if autoCheck and GetDistance(enemy) <= self.R.Range and IsImmobile(enemy, 0.5) then
                    self.R:Cast(enemy)
                end
                if peelCheck and GetDistance(enemy) <= 400 and Menu.R.PeelList[enemy.charName] and
                    Menu.R.PeelList[enemy.charName]:Value() then
                    self.R:CastToPred(enemy, 2)
                end
            end
        end
    end

    function Varus:Combo()
        local target = GetTarget(self.R.Range, 0)
        if not IsValidTarget(target) then
            return
        end
        --
        local validTarg = Menu.R.Heroes[target.charName] and Menu.R.Heroes[target.charName]:Value() and
            HealthPercent(target) >= Menu.R.Min:Value()
        if Menu.R.Combo:Value() and validTarg and HealthPercent(myHero) <= 60 then
            self.R:CastToPred(target, 2)
        end
        if Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value() then
            local waitForStacks = self.mode == 1 and Menu.E.Stack:Value()
            local target = self:GetBestTarget(waitForStacks, self.E.Range)
            if target then
                self.E:CastToPred(target, 2)
            end
        end
    end

    function Varus:Harass()
        local waitForStacks = self.mode == 2 and Menu.E.StackHarass:Value()
        local target = self:GetBestTarget(waitForStacks, self.E.Range)
        if not IsValidTarget(target) then
            return
        end
        --
        if Menu.E.Harass:Value() and ManaPercent(myHero) >= Menu.E.ManaHarass:Value() then
            self.E:CastToPred(target, 2)
        end
    end

    function Varus:Flee()
        if not self.E:IsReady() then
            return
        end
        for i = 1, #self.enemies do
            local enemy = self.enemies[i]
            if Menu.E.Flee:Value() then
                self.E:CastToPred(enemy, 2)
            end
        end
    end

    function Varus:KillSteal()
    end

    function Varus:OnDraw()
        DrawSpells(self)
    end

    function Varus:LogicQ()
        self.Charging = self:IsCharging()
        self:UpdateCharge()
        local enemy = #self.enemies >= 1
        if not (self.Q:IsReady() and enemy and self.mode and self.mode <= 2) then
            return
        end
        --
        local isCombo, isHarass = self.mode == 1, self.mode == 2
        local waitForStacks = ((isCombo and Menu.Q.Stack:Value()) or (isHarass and Menu.Q.StackHarass:Value()))
        local target = self:GetBestTarget(waitForStacks, self.Q.Range)
        --
        if not self:IsCastE(target) then
            return
        end
        if target or not waitForStacks then
            if not self.Charging then
                if isCombo and ManaPercent(myHero) >= Menu.Q.Mana:Value() or
                    isHarass and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value() then
                    self.W:Cast()
                    KeyDown(HK_Q)
                end
            elseif target then
                local minHitChance = isCombo and Menu.Q.Pred:Value() or isHarass and Menu.Q.PredHarass:Value()
                local bestPos, castPos, hC = self.Q:GetPrediction(target)
                if bestPos and hC >= minHitChance then
                    --print("release")
                    self:ReleaseSpell(bestPos)
                end
            end
        end
    end

    function Varus:UpdateCharge()
        if self.Charging then
            self.Q.Range = min(925 + 425 * (Timer() - myHero.activeSpell.startTime), 1625)
        else
            self.Q.Range = 975
            if IsKeyDown(HK_Q) then
                DelayAction(function()
                    if IsKeyDown(HK_Q) and not self.Charging then
                        KeyUp(HK_Q)
                    end
                end, Latency() * 2 / 1000)
            end
        end
    end

    function Varus:GetBestTarget(waitStacks, range)
        local lowestHealth, bestTarget = 10000, nil
        for i = 1, #self.enemies do
            local enemy = self.enemies[i]
            local health = enemy.health
            if health <= lowestHealth and IsValidTarget(enemy, range) and (not waitStacks or self:GetStacks(enemy) == 3) then
                bestTarget = enemy
                lowestHealth = health
            end
        end
        return bestTarget
    end

    local spellData = { state = 0, tick = TickCount(), casting = TickCount() - 1000, mouse = mousePos }
    function Varus:ReleaseSpell(pos)

        --Noddy's Cast Method adapted to my needs
        if ShouldWait() then
            return
        end
        local ticker, latency = TickCount(), Latency()
        if spellData.state == 0 and GetDistance(myHero.pos, pos) < self.Q.Range and
            ticker - spellData.casting > self.Q.Delay + latency then
            spellData.state = 1
            spellData.mouse = mousePos
            spellData.tick = ticker
        end
        if spellData.state == 1 then
            if ticker - spellData.tick < latency then
                if not pos:ToScreen().onScreen then
                    local dist = GetDistance(pos)
                    repeat
                        dist = dist - 100
                        pos = myHero.pos:Extended(pos, dist)
                    until (pos:ToScreen().onScreen)
                end
                local pos2 = pos:To2D()
                Control.LeftClick(pos2.x, pos2.y)
                spellData.casting = ticker
                DelayAction(function()
                    if spellData.state == 1 then
                        SetCursorPos(spellData.mouse)
                        spellData.state = 0
                    end
                end, latency / 1000)
            end
            if ticker - spellData.casting > latency then
                SetCursorPos(spellData.mouse)
                spellData.state = 0
            end
        end
    end

    function Varus:IsCharging()
        local spell = myHero.activeSpell
        return spell and spell.valid and spell.name == "VarusQ"
    end

    function Varus:GetStacks(target)
        local buff = GetBuffByName(target, "VarusWDebuff")
        return buff and buff.expireTime >= Timer() and buff.count
    end

    function Varus:IsCastE(target)
        local spell = myHero:GetSpellData(_E)
        local checkMode = (self.mode == 1 and Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value()) or
            (self.mode == 3 and Menu.E.Harass:Value() and ManaPercent(myHero) >= Menu.E.ManaHarass:Value())
        return (not target or GetDistance(target) > self.E.Range) or
            (checkMode and spell.currentCd ~= 0 and spell.cd - spell.currentCd >= 1)
    end

    insert(LoadCallbacks, function()
        Varus()
    end)

elseif myHero.charName == "Vayne" then

    local mapPos = MapPosition
    local intersectsWall = MapPosition.intersectsWall
    class 'Vayne'
    --Vayne = Class()

    function Vayne:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.1"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttackTick(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnInterruptable(function(unit, spell)
            self:OnInterruptable(unit, spell)
        end)
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Vayne:Spells()
        self.Q = Spell({
            Slot = 0,
            Range = 300,
            Delay = 0.25,
            Speed = 200,
            Radius = 200,
            Collision = false,
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.W = Spell({
            Slot = 1,
            Range = huge,
            Delay = 0,
            Speed = huge,
            Radius = 0,
            Collision = false,
            From = myHero,
            Type = ""
        })
        self.E = Spell({
            Slot = 2,
            Range = 550,
            Delay = 0.5,
            Speed = 2000,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted
        })
        self.R = Spell({
            Slot = 3,
            Range = 1000,
            Delay = 0.5,
            From = myHero,
            Type = SpellTypePress
        })
        self.Q.LastReset = Timer()
    end

    function Vayne:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } }) --
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true }) --
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 }) --
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } }) --
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true }) --
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 }) --
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } }) --
        Menu.Q:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false }) --
        Menu.Q:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 }) --
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } }) --
        Menu.Q:MenuElement({ id = "Logic", name = "Tumble Logic", value = 1,
            drop = { "Prestigious Smart", "Agressive", "Kite[To Mouse]" } }) --
        Menu.Q:MenuElement({ id = "Flee", name = "Use on Flee", value = true }) --
        --W--
        Menu.W:MenuElement({ id = "Heroes", name = "Force Marked Heroes", value = true }) --
        Menu.W:MenuElement({ id = "Minions", name = "Force Marked Minions", value = false }) --
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true }) --
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 }) --
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Third", name = "Use To Proc 3rd Mark", value = false })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        --
        Menu.E:MenuElement({ name = " ", drop = { "Peel Settings" } })
        Menu.E:MenuElement({ id = "Gapcloser", name = "Use as Anti Gapcloser", value = true }) --
        Menu.E:MenuElement({ id = "Flee", name = "Use on Flee", value = true }) --
        Menu.E:MenuElement({ id = "AutoPeel", name = "Auto Peel", value = true }) --
        Menu.E:MenuElement({ id = "Peel", name = "Whitelist", type = MENU }) --
        --
        Menu.E:MenuElement({ name = " ", drop = { "Interrupter Settings" } }) --
        Menu.E:MenuElement({ id = "Interrupter", name = "Use as Interrupter", value = true }) --
        Menu.E:MenuElement({ id = "Interrupt", name = "Whitelist", type = MENU }) --
        --
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } }) --
        Menu.E:MenuElement({ id = "Auto", name = "Auto Stun", value = true }) --
        Menu.E:MenuElement({ id = "Push", name = "Distance", value = 450, min = 400, max = 475, step = 25 }) --
        --R--
        Menu.R:MenuElement({ id = "Count", name = "Use When X Enemies", value = 2, min = 0, max = 5, step = 1 }) --
        Menu.R:MenuElement({ id = "Combo", name = "Use on Duel", value = true }) --
        Menu.R:MenuElement({ id = "Duel", name = "Duel Targets", type = MENU }) --
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } }) --
        --
        ObjectManager:OnEnemyHeroLoad(function(args)
            local hero = args.unit
            local charName = args.charName
            Interrupter:AddToMenu(hero, Menu.E.Interrupt)
            if GetTrueAttackRange(hero) <= 500 then
                Menu.E.Peel:MenuElement({ id = charName, name = charName, value = false })
            end
            Menu.R.Duel:MenuElement({ id = charName, name = charName, value = false })
        end)
    end

    function Vayne:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.E.Range + self.Q.Range)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.mode = GetMode()
        --
        self:ResetAA()
        if myHero.isChanneling or not self.enemies then
            return
        end
        self:Auto()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 6 and self:Flee()
    end

    function Vayne:ResetAA()
        if HasBuff(myHero, "vaynetumblebonus") then
            ResetAutoAttack()
            self.Q.LastReset = Timer()
        end
    end

    function Vayne:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Vayne:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
        --
        local range = GetTrueAttackRange(myHero)
        if HasBuff(myHero, "VayneTumbleFade") then
            for i = 1, #self.enemies do
                if GetDistance(self.enemies[i]) <= 300 then
                    args.Process = false
                    return
                end
            end
        end
        if Menu.W.Heroes:Value() then
            local nearby = GetEnemyHeroes(range)
            for i = 1, #nearby do
                local hero = nearby[i]
                if self:GetStacks(hero) >= 2 then
                    args.Target = hero
                    return
                end
            end
        end
        if args.Target.type == myHero.type then
            return
        end
        if Menu.W.Minions:Value() then
            local nearby = GetEnemyMinions(range)
            for i = 1, #nearby do
                local minion = nearby[i]
                if self:GetStacks(minion) >= 2 then
                    args.Target = minion
                    return
                end
            end
        end
    end

    function Vayne:OnPostAttack()
        local target = GetTargetByHandle(myHero.attackData.target)
        if ShouldWait() or not IsValidTarget(target) then
            return
        end
        --
        local tType, tTeam = target.type, target.team

        if tType == Obj_AI_Hero then
            if self.R:IsReady() and Menu.R.Combo:Value() and Menu.R.Duel[target.charName] and
                Menu.R.Duel[target.charName]:Value() then
                self.R:Cast()
            elseif self.mode == 2 and self.E:IsReady() and Menu.E.Third:Value() and
                ManaPercent(myHero) >= Menu.E.ManaHarass:Value() and self:GetStacks(target) == 1 then
                self.E:Cast(target)
            elseif self.Q:IsReady() then
                local modeCheck = (
                    self.mode == 1 and Menu.Q.Combo:Value() and ManaPercent(myHero) >= Menu.Q.Mana:Value()) or
                    (self.mode == 2 and Menu.Q.Harass:Value() and ManaPercent(myHero) >= Menu.Q.ManaHarass:Value())
                local tPos = self:GetBestTumblePos()
                if modeCheck and tPos then
                    self.Q:Cast(tPos)
                end
            end
        elseif self.Q:IsReady() and self.mode and self.mode >= 3 and Menu.Q.Jungle:Value() and
            ManaPercent(myHero) >= Menu.Q.ManaClear:Value() and tTeam == 300 then
            local tPos = self:GetKitingTumblePos(target)
            if tPos then
                self.Q:Cast(tPos)
            end
            --elseif self.Q:IsReady() and tType == Obj_AI_Turret then
            --tumble to closest wall
        end
    end

    function Vayne:OnInterruptable(unit, spell)
        if ShouldWait() or not Menu.E.Interrupter:Value() or not self.E:IsReady() then
            return
        end
        if IsValidTarget(unit, self.E.Range) and unit.team == TEAM_ENEMY and Menu.E.Interrupt[spell.name]:Value() then
            self.E:Cast(unit)
        end
    end

    function Vayne:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() or not Menu.E.Gapcloser:Value() or not self.E:IsReady() then
            return
        end
        if IsValidTarget(unit) and GetDistance(unitPosTo) < 500 and unit.team == TEAM_ENEMY and IsFacing(unit, myHero) then
            self.E:Cast(unit)
        end
    end

    function Vayne:Auto()
        local rCount = Menu.R.Count:Value()
        if self.R:IsReady() and rCount ~= 0 and #self.enemies >= rCount and self.mode == 1 then
            self.R:Cast()
        end
        local autoE, peelE, comboE = Menu.E.Auto:Value(), Menu.E.AutoPeel:Value(),
            (Menu.E.Combo:Value() and self.mode == 1 and ManaPercent(myHero) >= Menu.E.Mana:Value())
        if self.E:IsReady() and (autoE or peelE or comboE) then
            for i = 1, #self.enemies do
                local enemy = self.enemies[i]
                local enemyRange = GetTrueAttackRange(enemy)
                local autoPeel = GetDistance(enemy) <= enemyRange + 50 and Menu.E.Peel[enemy.charName] and
                    Menu.E.Peel[enemy.charName]:Value()
                if IsValidTarget(enemy, self.E.Range) and
                    (((autoE or comboE) and self:CheckCondemn(enemy)) or (peelE and autoPeel)) then
                    self.E:Cast(enemy)
                    break
                end
            end
        end
    end

    function Vayne:Flee()
        local closest = GetClosestEnemy()
        local dist = GetDistance(closest)
        local castCheck = dist <= GetTrueAttackRange(closest) or HealthPercent(myHero) <= 30
        --
        if IsValidTarget(closest) then
            if Menu.E.Flee:Value() and self.E:IsReady() and dist <= 400 and castCheck then
                self.E:Cast(closest)
            elseif Menu.Q.Flee:Value() and self.Q:IsReady() and dist <= 600 then
                local bestPos = self:GetBestTumblePos()
                if bestPos then
                    self.Q:Cast(bestPos)
                end
            end
        end
    end

    function Vayne:OnDraw()
        DrawSpells(self)
    end

    function Vayne:CheckCondemn(enemy, pos)
        local eP, pP, pD = enemy.pos, pos or myHero.pos, Menu.E.Push:Value()
        local segment = LineSegment(eP, eP:Extended(pP, -pD))
        return intersectsWall(mapPos, segment)
    end

    function Vayne:GetStacks(target)
        if not target then
            error("", 2)
        end
        local buff = GetBuffByName(target, "VayneSilveredDebuff")
        return buff and buff.count or 0
    end

    function Vayne:GetBestTumblePos()
        local logic = Menu.Q.Logic:Value()
        local target = GetClosestEnemy()
        if not target then
            return
        end
        --
        if logic == 1 then
            return self:GetSmartTumblePos(target)
        elseif logic == 2 then
            return self:GetAggressiveTumblePos(target)
        elseif logic == 3 then
            return self:GetKitingTumblePos(target)
        end
    end

    function Vayne:GetAggressiveTumblePos(target)
        local root1, root2 = CircleCircleIntersection(myHero.pos, target.pos, GetTrueAttackRange(myHero), 500)
        if root1 and root2 then
            local closest = GetDistance(root1, mousePos) < GetDistance(root2, mousePos) and root1 or root2
            return myHero.pos:Extended(closest, 300)
        end
    end

    function Vayne:GetKitingTumblePos(target)
        local hP, tP = myHero.pos, target.pos
        local posToKite = hP:Extended(tP, -300)
        local posToMouse = hP:Extended(mousePos, 300)
        local range = GetTrueAttackRange(myHero)
        --
        if not self:IsDangerousPosition(posToKite) and GetDistance(tP, posToKite) <= range then
            return posToKite
        elseif not self:IsDangerousPosition(posToMouse) and GetDistance(tP, posToMouse) <= range then
            return posToMouse
        end
    end

    function Vayne:GetSmartTumblePos(target)
        if not self.enemies or not self.Q:IsReady() then
            return
        end
        local pP, range = myHero.pos, self.E.Range ^ 2
        local offset, rAngle = pP + Vector(0, 0, 300), 360 / 16 * pi / 180
        --
        local result = {}
        for i = 1, 17 do
            local pos = RotateAroundPoint(offset, pP, rAngle * (i - 1))
            for j = 1, #self.enemies do
                --Max 5
                local enemy = self.enemies[j]
                if GetDistanceSqr(pos, enemy) <= range and self:CheckCondemn(enemy, pos) then
                    result[i] = pos
                    break
                else
                    result[i] = 1
                end
            end
        end
        return self:GetBestPoint(result) or self:GetKitingTumblePos(target)
    end

    function Vayne:IsDangerousPosition(pos, turretList, heroList)
        local turretList = turretList or GetEnemyTurrets(1200)
        for i = 1, #turretList do
            --Max 2 (on nexus)
            local turret = turretList[i]
            if GetDistance(turret, pos) < 900 then
                return true
            end
        end
        --
        local heroList = heroList or GetEnemyHeroes(1200)
        for i = 1, #heroList do
            --Max 5
            local enemy = heroList[i]
            local range = GetTrueAttackRange(enemy)
            if range < 500 and GetDistance(enemy, pos) < range then
                return true
            end
        end
    end

    function Vayne:GetBestPoint(t)
        local dist, best = 10000, nil
        local heroList, turretList = GetEnemyHeroes(1200), GetEnemyTurrets(1200)
        for i = 1, #t do
            local point = t[i]
            if point and point ~= 1 then
                local dist2 = GetDistance(point, mousePos)
                if dist2 <= dist and not self:IsDangerousPosition(point, turretList, heroList) then
                    best = point
                    dist = dist2
                end
            end
        end
        return best
    end

    insert(LoadCallbacks, function()
        Vayne()
    end)

elseif myHero.charName == "Vladimir" then

    class 'Vladimir'
    --Vladimir = Class()

    function Vladimir:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.09"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Vladimir:Spells()
        local flashData = myHero:GetSpellData(SUMMONER_1).name:find("Flash") and SUMMONER_1 or
            myHero:GetSpellData(SUMMONER_2).name:find("Flash") and SUMMONER_2 or nil
        self.Q = Spell({
            Slot = 0,
            Range = 600,
            Delay = 0.25,
            Speed = huge,
            Radius = huge,
            Collision = false,
            From = myHero,
            Type = SpellTypeTargetted
        })
        self.W = Spell({
            Slot = 1,
            Range = huge,
            Delay = 0,
            Speed = huge,
            Radius = 175,
            Collision = false,
            From = myHero,
            Type = SpellTypePress and SpellTypeAOE
        })
        self.E = Spell({ --Missile name = VladimirEMissile
            Slot = 2,
            Range = 600, --Missile range 1200
            Delay = 0.25,
            Speed = 4000, --was 2500
            Radius = 60,
            Collision = true, --
            CollisionTypes = { COLLISION_MINION, COLLISION_ENEMYHERO, COLLISION_YASUOWALL },
            From = myHero,
            Type = SpellTypePress and SpellTypeAOE
        })
        self.R = Spell({
            Slot = 3,
            Range = 625,
            Delay = 0.25,
            Speed = huge,
            Radius = 375,
            Collision = false,
            From = myHero,
            Type = SpellTypeAOE
        })
        self.Flash = flashData and Spell({
            Slot = flashData,
            Range = 425,
            Delay = 0.00,
            Speed = huge,
            Radius = 200 or myHero.boundingRadius, --or myHero.boundingRadius
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
    end

    function Vladimir:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.Q:MenuElement({ id = "LastHit", name = "Use to LastHit", value = false })
        --Menu.Q:MenuElement({id = "Unkillable", name = "    Only when Unkillable", value = false})
        Menu.Q:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.Q:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "Auto", name = "Auto Use to Harass", value = true })
        Menu.Q:MenuElement({ id = "MinHealth", name = "    When Health Below %", value = 100, min = 10, max = 100,
            step = 1 })
        Menu.Q:MenuElement({ id = "KS", name = "Use on KS", value = true })
        Menu.Q:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.W:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.W:MenuElement({ id = "Gapcloser", name = "Use on GapCloser", value = false })
        Menu.W:MenuElement({ id = "Count", name = "Auto Use When X Enemies Around", value = 2, min = 0, max = 5, step = 1 })
        Menu.W:MenuElement({ id = "Flee", name = "Use on Flee", value = true })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use on Harass", value = false })
        Menu.E:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.E:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.E:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.E:MenuElement({ id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 6, step = 1 })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Duel", name = "Use To Duel", value = true })
        Menu.R:MenuElement({ id = "Heroes", name = "Duel Targets", type = MENU })
        Menu.R:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.R:MenuElement({ id = "Count", name = "Auto Use When X Enemies", value = 2, min = 0, max = 5, step = 1 })
        --Burst
        Menu:MenuElement({ id = "Burst", name = "Burst Settings", type = MENU })
        Menu.Burst:MenuElement({ id = "Flash", name = "Allow Flash On Burst", value = true })
        Menu.Burst:MenuElement({ id = "Key", name = "Burst Key", key = string.byte("T") })
        --
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
        ObjectManager:OnEnemyHeroLoad(function(args)
            Menu.R.Heroes:MenuElement({ id = args.charName, name = args.charName, value = false })
        end)
    end

    function Vladimir:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(self.R.Range + self.Flash.Range)
        self.target = GetTarget(self.Q.Range, 1)
        self.mode = GetMode()
        --
        if Menu.Burst.Key:Value() then
            self:Burst()
            return
        end
        self:LogicE()
        self:LogicW()
        if myHero.isChanneling then
            return
        end
        self:Auto()
        self:KillSteal()
        --
        if not self.mode then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 3 and self:Clear() or
            self.mode == 4 and self:Clear() or
            self.mode == 5 and self:LastHit() or
            self.mode == 6 and self:Flee()
    end

    function Vladimir:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Vladimir:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() or not myHero.valid then
            args.Process = false
            return
        end
    end

    function Vladimir:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() or not self.W:IsReady() or not Menu.W.Gapcloser:Value() then
            return
        end
        if IsValidTarget(unit) and GetDistance(unitPosTo) < 500 and unit.team == TEAM_ENEMY and IsFacing(unit, myHero) then
            --Gapcloser
            if self.E:IsReady() and not IsKeyDown(HK_E) then
                --*
                KeyDown(HK_E)
                self.W:Cast()
            elseif IsKeyDown(HK_E) then
                self.W:Cast()
            end
        end
    end

    function Vladimir:Auto()
        local rMinHit, wMinHit = Menu.R.Count:Value(), Menu.W.Count:Value()
        --
        if self.Q:IsReady() and (Menu.Q.Auto:Value() and HealthPercent(myHero) <= Menu.Q.MinHealth:Value()) then
            if self.target then
                self.Q:Cast(self.target);
                return
            end
        end
        if rMinHit ~= 0 and self.R:IsReady() then
            local bestPos, hit = self.R:GetBestCircularCastPos(nil, GetEnemyHeroes(1000))
            if bestPos and hit >= rMinHit then
                self.R:Cast(bestPos);
                return
            end
        end
        if wMinHit ~= 0 and self.W:IsReady() and IsKeyDown(HK_E) then
            --*
            local nearby = GetEnemyHeroes(600)
            if #nearby >= wMinHit then
                self.W:Cast();
                return
            end
        end
    end

    function Vladimir:Combo()
        if not self.target then
            return
        end
        --
        if self.R:IsReady() and Menu.R.Duel:Value() and Menu.R.Heroes[self.target.charName] and
            Menu.R.Heroes[self.target.charName]:Value() then
            self.R:CastToPred(self.target, 2)
        elseif self.Q:IsReady() and Menu.Q.Combo:Value() then
            self.Q:Cast(self.target)
        elseif self.E:IsReady() and not IsKeyDown(HK_E) and Menu.E.Combo:Value() then
            KeyDown(HK_E)
        end
    end

    function Vladimir:Harass()
        if not self.target then
            return
        end
        --
        if self.Q:IsReady() and Menu.Q.Harass:Value() then
            self.Q:Cast(self.target)
        elseif self.E:IsReady() and not IsKeyDown(HK_E) and Menu.E.Harass:Value() then
            KeyDown(HK_E)
        end
    end

    function Vladimir:Clear()
        local qRange, jCheckQ, lCheckQ = self.Q.Range, Menu.Q.Jungle:Value(), Menu.Q.Clear:Value()
        local eRange, jCheckE, lCheckE = self.E.Range, Menu.E.Jungle:Value(), Menu.E.Clear:Value()
        --
        if self.Q:IsReady() and (jCheckQ or lCheckQ) then
            local minions = (jCheckQ and GetMonsters(qRange)) or {}
            minions = (#minions == 0 and lCheckQ and GetEnemyMinions(qRange)) or minions
            for i = 1, #minions do
                local minion = minions[i]
                local distance = GetDistance(myHero, minion)
                if minion.health <= self.Q:GetDamage(minion) or minion.team == TEAM_JUNGLE and distance <= self.Q.Range then
                    self.Q:Cast(minion)
                    return
                end
            end
        end
        if self.E:IsReady() and (jCheckE or lCheckE) then
            local minions = (jCheckE and GetMonsters(eRange)) or {}
            minions = (#minions == 0 and lCheckE and GetEnemyMinions(eRange)) or minions
            if #minions >= Menu.E.Min:Value() or (minions[1] and minions[1].team == TEAM_JUNGLE) then
                KeyDown(HK_E)
            end
        end
    end

    function Vladimir:LastHit()
        if self.Q:IsReady() and Menu.Q.LastHit:Value() then
            local minions = GetEnemyMinions(self.Q.Range)
            for i = 1, #minions do
                local minion = minions[i]
                local distance = GetDistance(myHero, minion)
                if minion.health <= self.Q:GetDamage(minion) and distance <= self.Q.Range then
                    --check if Q dmg is right
                    self.Q:Cast(minion)
                    return
                end
            end
        end
    end

    function Vladimir:Flee()
        if Menu.Q.Flee:Value() and self.Q:IsReady() then
            if self.target then
                self.Q:Cast(self.target)
            end
        elseif Menu.W.Flee:Value() and self.W:IsReady() then
            if #GetEnemyHeroes(400) >= 1 then
                self.W:Cast()
            end
        end
    end

    function Vladimir:KillSteal()
        if (Menu.Q.KS:Value() and self.Q:IsReady()) then
            for i = 1, #self.enemies do
                local enemy = self.enemies[i]
                local distance = GetDistance(myHero, enemy)
                if enemy and self.Q:GetDamage(enemy) >= enemy.health and distance <= self.Q.Range then
                    self.Q:Cast(self.target);
                    return
                end
            end
        end
    end

    function Vladimir:OnDraw()
        DrawSpells(self)
    end

    function Vladimir:LogicE()
        local eBuff = GetBuffByName(myHero, "VladimirE")
        if not eBuff then
            local eSpell = myHero:GetSpellData(self.E.Slot)
            if eSpell.currentCd ~= 0 and eSpell.cd - eSpell.currentCd > 0.3 and IsKeyDown(HK_E) then
                KeyUp(HK_E) --release stuck key
            end
            return
        end
        --
        local eRange = self.E.Range
        local enemies, minions = GetEnemyHeroes(eRange + 300), GetEnemyMinions(eRange + 300)
        local willHit, entering, leaving = 0, 0, 0
        for i = 1, #enemies do
            local target = enemies[i]
            local tP, tP2, pP2 = target.pos, target:GetPrediction(huge, 0.2), myHero:GetPrediction(huge, 0.2)
            --
            if GetDistance(tP) <= eRange then
                --if inside(might go out)
                if #mCollision(myHero.pos, tP, self.E, minions) == 0 then
                    willHit = willHit + 1
                end
                if GetDistance(tP2, pP2) > eRange then
                    leaving = leaving + 1
                end
            elseif GetDistance(tP2, pP2) < eRange then
                --if outside(might come in)
                entering = entering + 1
            end
        end
        if entering <= leaving and (willHit > 0 or entering == 0) then
            if leaving > 0 and IsKeyDown(HK_E) then
                KeyUp(HK_E) --release skill
            end
        end
        if eBuff and eBuff.duration<=0.6 and willHit > 0 and self.mode == 1 then
            KeyUp(HK_E)
        end
    end

    function Vladimir:LogicW()
        if self.W:IsReady() and not self.Q:IsReady() and not self.E:IsReady() and
            ((self.mode == 1 and Menu.W.Combo:Value()) or (self.mode == 2 and Menu.W.Harass:Value())) then
            local nearby = GetEnemyHeroes(600)
            --
            for i = 1, #nearby do
                local enemy = nearby[i]
                if GetDistance(enemy) <= 300 and IsKeyDown(HK_E) then
                    --*
                    self.W:Cast()
                end
            end
        end
    end

    local bursting, startEarly = false, false
    function Vladimir:Burst()
        Orbwalk()
        if not HasBuff(myHero, "vladimirqfrenzy") then
            return self.Q:IsReady() and self:LoadQ()
        end
        if not bursting and self.Q:IsReady() and (self.E:IsReady() or startEarly) and self.R:IsReady() then
            local canFlash = self.Flash and self.Flash:IsReady() and Menu.Burst.Flash:Value()
            local range = self.E.Range + (canFlash and self.Flash.Range or 0)
            local bTarget, eTarget = GetTarget(range + 300, 1), GetTarget(self.E.Range, 1)
            local shouldFlash = canFlash and bTarget ~= eTarget
            --
            if bTarget then
                startEarly = GetDistance(bTarget) > 600 and KeyDown(HK_E)
                if GetDistance(bTarget) < range then
                    self:BurstCombo(bTarget, shouldFlash, 1)
                end
            end
        end
    end

    function Vladimir:BurstCombo(target, shouldFlash, step)
        if step == 1 then
            bursting = true
            local chargeE = not IsKeyDown(HK_E) and KeyDown(HK_E)
            if shouldFlash then
                local pos, hK = mousePos, self.Flash:SlotToHK()
                SetCursorPos(target.pos)
                KeyDown(hK)
                KeyUp(hK)
                DelayAction(function()
                    SetCursorPos(pos)
                end, 0.03)
            end
            DelayAction(function()
                self:BurstCombo(target, shouldFlash, 2)
            end, 0.3)
        elseif step == 2 then
            local bestPos = self.R:GetBestCircularCastPos(target, GetEnemyHeroes(self.R.Radius or 1000))
            Control.CastSpell(HK_R, bestPos or target) --Control.CastSpell(HK_R, target, pos)
            local releaseE = IsKeyDown(HK_E) and KeyUp(HK_E)
            DelayAction(function()
                self:BurstCombo(target, shouldFlash, 3)
            end, 0.3)
        elseif step == 3 then
            self.Q:Cast(target)
            if self.E:IsReady() and not IsKeyDown(HK_E) then
                KeyDown(HK_E)
                DelayAction(function()
                    self.W:Cast()
                end, 0.3)
            elseif not self.E:IsReady() then
                DelayAction(function()
                    self.W:Cast()
                end, 0.3)
            end
            DelayAction(function()
                self:Protobelt(target)
            end, 0.3)
            bursting = false
        end
    end

    function Vladimir:LoadQ()
        local qRange = self.Q.Range
        local qTarget = GetTarget(qRange, 1)
        if qTarget then
            return self.Q:Cast(qTarget)
        end
        --
        local minions = GetEnemyMinions(qRange)
        if #minions < 1 then
            minions = GetMonsters(qRange)
        end
        if minions[1] then
            return self.Q:Cast(minions[1])
        end
    end

    function Vladimir:Protobelt(target)
        local slot, key = GetItemSlot(3152)
        if key and slot ~= 0 then
            Control.CastSpell(key, target)
        end
    end

    insert(LoadCallbacks, function()
        Vladimir()
    end)

elseif myHero.charName == "Xayah" then

    class 'Xayah'
    --Xayah = Class()

    function Xayah:__init()
        --[[Data Initialization]]
        self.Allies, self.Enemies = {}, {}
        self.scriptVersion = "1.0"
        self:Spells()
        self:Menu()
        --[[Default Callbacks]]
        Callback.Add("Tick", function()
            self:Tick()
        end)
        Callback.Add("Draw", function()
            self:OnDraw()
        end)
        Callback.Add("WndMsg", function(msg, param)
            self:OnWndMsg(msg, param)
        end)
        --Callback.Add("ProcessRecall", function(unit, proc) self:OnRecall(unit, proc) end)
        --[[Orb Callbacks]]
        OnPreAttack(function(...)
            self:OnPreAttack(...)
        end)
        OnPostAttack(function(...)
            self:OnPostAttack(...)
        end)
        OnPreMovement(function(...)
            self:OnPreMovement(...)
        end)
        --[[Custom Callbacks]]
        OnDash(function(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
            self:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        end)
    end

    function Xayah:Spells()
        self.PassiveTable = {}
        self.Q = Spell({
            Slot = 0,
            Range = 1100,
            Delay = 0.5,
            Speed = 1200,
            Width = 70,
            Collision = true, --was false
            CollisionTypes = { COLLISION_YASUOWALL }, --
            From = myHero,
            Type = SpellTypeSkillShot
        })
        self.W = Spell({
            Slot = 1,
            Range = 925,
            Delay = 0.25,
            Speed = 1450,
            Radius = 100,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.E = Spell({
            Slot = 2,
            Range = 1000,
            Delay = 0.25,
            Speed = 2000,
            Width = 160,
            Collision = false,
            From = myHero,
            Type = SpellTypePress
        })
        self.R = Spell({
            Slot = 3,
            Range = 1100,
            Delay = 1,
            Speed = 1200,
            Radius = 150,
            Collision = true, --was false
            CollisionTypes = { COLLISION_YASUOWALL }, --
            From = myHero,
            Type = SpellTypeAOE
        })
    end

    function Xayah:Menu()
        ObjectManager:OnAllyHeroLoad(function(args)
            insert(self.Allies, args.unit)
        end)
        ObjectManager:OnEnemyHeroLoad(function(args)
            insert(self.Enemies, args.unit)
        end)
        --Q--
        Menu.Q:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.Q:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.Q:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.Q:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.Q:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.Q:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        --Menu.Q:MenuElement({name = " ", drop = {"Farm Settings"}})
        --Menu.Q:MenuElement({id = "Clear", name = "Use on LaneClear", value = false})
        --Menu.Q:MenuElement({id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 6, step = 1})
        --Menu.Q:MenuElement({id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1})
        Menu.Q:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.Q:MenuElement({ id = "KS", name = "Use on KS[Not Implemented]", value = true })
        --W--
        Menu.W:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.W:MenuElement({ id = "Combo", name = "Use on Combo", value = true })
        Menu.W:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.W:MenuElement({ id = "Harass", name = "Use on Harass", value = true })
        Menu.W:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.W:MenuElement({ name = " ", drop = { "Farm Settings" } })
        Menu.W:MenuElement({ id = "Jungle", name = "Use on JungleClear", value = false })
        Menu.W:MenuElement({ id = "Clear", name = "Use on LaneClear", value = false })
        Menu.W:MenuElement({ id = "Min", name = "Minions To Cast", value = 3, min = 0, max = 6, step = 1 })
        Menu.W:MenuElement({ id = "ManaClear", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        --E--
        Menu.E:MenuElement({ name = " ", drop = { "Auto Settings" } })
        Menu.E:MenuElement({ id = "Auto", name = "Auto Use", value = true })
        Menu.E:MenuElement({ id = "MinRoot", name = "If Can Root X Enemies", value = 2, min = 1, max = 5, step = 1 })
        Menu.E:MenuElement({ id = "MinFeather", name = "If Can Hit X Feathers", value = 10, min = 3, max = 20, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.E:MenuElement({ id = "Combo", name = "Use in Combo", value = true })
        Menu.E:MenuElement({ id = "MinRootCombo", name = "If Can Root X Enemies", value = 2, min = 1, max = 5, step = 1 })
        Menu.E:MenuElement({ id = "MinFeatherCombo", name = "If Can Hit X Feathers", value = 5, min = 3, max = 20,
            step = 1 })
        Menu.E:MenuElement({ id = "Mana", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Harass Settings" } })
        Menu.E:MenuElement({ id = "Harass", name = "Use in Harass", value = false })
        Menu.E:MenuElement({ id = "MinRootHarass", name = "If Can Root X Enemies", value = 2, min = 1, max = 5, step = 1 })
        Menu.E:MenuElement({ id = "MinFeatherHarass", name = "If Can Hit X Feathers", value = 5, min = 3, max = 20,
            step = 1 })
        Menu.E:MenuElement({ id = "ManaHarass", name = "Min Mana %", value = 15, min = 0, max = 100, step = 1 })
        Menu.E:MenuElement({ name = " ", drop = { "Misc" } })
        Menu.E:MenuElement({ id = "KS", name = "Use in KS", value = true })
        --R--
        Menu.R:MenuElement({ name = " ", drop = { "Combo Settings" } })
        Menu.R:MenuElement({ id = "Peel", name = "Use To Peel", value = true })
        Menu.R:MenuElement({ id = "Min", name = "Use When X Enemies", value = 2, min = 1, max = 5, step = 1 })
        Menu.R:MenuElement({ id = "Gapcloser", name = "Use On Gapcloser", value = true })
        Menu.R:MenuElement({ id = "Heroes", name = "Dodge Gapclosers From", type = MENU })
        --Menu.R:MenuElement({id = "Spells", name = "Dodge Spells", type = MENU})
        Menu.R:MenuElement({ id = "Mana", name = "Min Mana %", value = 0, min = 0, max = 100, step = 1 })
        --Draw--
        Menu.Draw:MenuElement({ id = "Hit", name = "Draw X Feathers Hit", value = true })
        Menu.Draw:MenuElement({ id = "Feathers", name = "Draw Feathers Pos", value = true })
        Menu.Draw:MenuElement({ id = "Lines", name = "Draw Feathers Collision Lines", value = true })
        --
        Menu:MenuElement({ name = "[WR] " .. charName .. " Script", drop = { "Release_" .. self.scriptVersion } })
        --
        ObjectManager:OnEnemyHeroLoad(function(args)
            Menu.R.Heroes:MenuElement({ id = args.charName, name = args.charName, value = false })
        end)
    end

    function Xayah:Tick()
        if ShouldWait() then
            return
        end
        --
        self.enemies = GetEnemyHeroes(1500)
        self.target = GetTarget(GetTrueAttackRange(myHero), 0)
        self.mode = GetMode()
        --
        if myHero.isChanneling then
            return
        end
        self:Auto()
        self:KillSteal()
        --
        if not self.mode or (self.mode < 3 and #self.enemies == 0) then
            return
        end
        local executeMode = self.mode == 1 and self:Combo() or
            self.mode == 2 and self:Harass() or
            self.mode == 3 and self:Clear() or
            self.mode == 4 and self:Clear()

    end

    function Xayah:OnWndMsg(msg, param)
        if msg == 257 then
            local ping, delay = Game.Latency() / 1000, nil
            if param == HK_Q then
                delay = self.Q.Delay + ping
            elseif param == HK_R then
                delay = self.R.Delay + ping
            elseif param == HK_E then
                delay = ping
            end
            if delay then
                DelayAction(function()
                    self:UpdateFeathers()
                end, delay)
            end
        end
    end

    --function Xayah:OnRecall(unit, proc)
    --    --something with rakan later (?)
    --end

    function Xayah:OnPreMovement(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
    end

    function Xayah:OnPreAttack(args)
        --args.Process|args.Target
        if ShouldWait() then
            args.Process = false
            return
        end
        local wMenu = Menu.W
        if args.Target and self.W:IsReady() and myHero.hudAmmo <= 2 then
            local check = (self.mode == 1 and wMenu.Combo:Value() and ManaPercent(myHero) >= wMenu.Mana:Value()) or
                (self.mode == 2 and wMenu.Harass:Value() and ManaPercent(myHero) >= wMenu.ManaHarass:Value()) or
                (
                self.mode == 3 and wMenu.Clear:Value() and ManaPercent(myHero) >= wMenu.ManaClear:Value() and
                    #GetEnemyMinions(600) >= wMenu.Min:Value()) or
                (
                self.mode == 4 and wMenu.Jungle:Value() and ManaPercent(myHero) >= wMenu.ManaClear:Value() and
                    args.Target.team == TEAM_JUNGLE)
            if check then
                self.W:Cast()
            end
        end
    end

    function Xayah:OnPostAttack()
        self:UpdateFeathers()
        local target = GetTargetByHandle(myHero.attackData.target)
        if ShouldWait() or not IsValidTarget(target) then
            return
        end
    end

    function Xayah:OnDash(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
        if ShouldWait() or not self.R:IsReady() then
            return
        end
        if IsValidTarget(unit) and GetDistance(unitPosTo) < 400 and unit.team == TEAM_ENEMY and IsFacing(unit, myHero)
            and Menu.R.Gapcloser:Value() then
            --Gapcloser
            if Menu.R.Heroes[unit.charName] and Menu.R.Heroes[unit.charName]:Value() then
                self.R:Cast(unitPosTo)
            end
        end
    end

    function Xayah:Auto()
        if Menu.E.Auto:Value() or Menu.E.KS:Value() then
            self:AutoE()
        end
        if Menu.R.Peel:Value() and self.R:IsReady() then
            local nearby = GetEnemyHeroes(400)
            if #nearby >= Menu.R.Min:Value() then
                self.R:Cast(nearby[1])
            end
        end
    end

    function Xayah:Combo()
        if not Menu.E.Auto:Value() and Menu.E.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value() then
            self:AutoE()
        end
        --
        if not HasBuff(myHero, "XayahW") or myHero.hudAmmo <= 2 then
            if Menu.Q.Combo:Value() and self.Q:IsReady() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
                local qTarget = GetTarget(self.Q.Range, 1)
                self.Q:CastToPred(qTarget, 2)
            end
        end
    end

    function Xayah:Harass()
        if not Menu.E.Auto:Value() and Menu.E.Harass:Value() and ManaPercent(myHero) >= Menu.E.ManaHarass:Value() then
            self:AutoE()
        end
        --
        if not HasBuff(myHero, "XayahW") or myHero.hudAmmo <= 2 then
            if Menu.Q.Combo:Value() and self.Q:IsReady() and ManaPercent(myHero) >= Menu.Q.Mana:Value() then
                local qTarget = GetTarget(self.Q.Range, 1)
                self.Q:CastToPred(qTarget, 2)
            end
        end
    end

    function Xayah:Clear()
    end

    function Xayah:KillSteal()

    end

    function Xayah:OnDraw()
        local drawSettings = Menu.Draw
        local col2 = DrawColor(255, 153, 0, 153)

        if drawSettings.ON:Value() then
            local qLambda = drawSettings.Q:Value() and self.Q and self.Q:Draw(66, 244, 113)
            local wLambda = drawSettings.W:Value() and self.W and self.W:Draw(66, 229, 244)
            local eLambda = drawSettings.E:Value() and self.E and self.E:Draw(244, 238, 66)
            local rLambda = drawSettings.R:Value() and self.R and self.R:Draw(244, 66, 104)
            local tLambda = drawSettings.TS:Value() and self.target and
                DrawMark(self.target.pos, 3, self.target.boundingRadius, Color.Red)
            if self.enemies then
                local Hit, Feathers, Lines = drawSettings.Hit:Value(), drawSettings.Feathers:Value(),
                    drawSettings.Lines:Value()
                local currentTime = Timer()
                local myPos = myHero.pos:To2D()
                if Hit then
                    for i = 1, #self.enemies do
                        local target = self.enemies[i]
                        local hits = self:CountFeatherHits(target)
                        local pos = target.pos:To2D()
                        DrawText(tostring(hits), 25, pos.x, pos.y, Color.Yellow)
                    end
                end
                if Feathers or Lines then
                    for i = 1, #self.PassiveTable do
                        local object = self.PassiveTable[i]
                        if object and object.placetime > currentTime then
                            if Feathers then
                                DrawCircle(object.pos, 50, 3, object.hit and Color.Red or col2)
                            end
                            if Lines then
                                local pos = object.pos:To2D()
                                DrawLine(myPos.x, myPos.y, pos.x, pos.y, 4, object.hit and Color.Red or col2)
                            end
                            object.hit = false
                        else
                            remove(self.PassiveTable, i)
                        end
                    end
                end
            end
        end
    end

    function Xayah:CheckFeather(obj)
        for i = 1, #self.PassiveTable do
            if self.PassiveTable[i].ID == obj.networkID then
                return true
            end
        end
    end

    function Xayah:CountFeatherHits(target)
        local HitCount = 0
        if target then
            for i = 1, #self.PassiveTable do
                local collidingLine = LineSegment(myHero.pos, self.PassiveTable[i].pos)
                if Point(target):__distance(collidingLine) < 80 + target.boundingRadius then
                    HitCount = HitCount + 1
                    self.PassiveTable[i].hit = true
                end
            end
        end
        return HitCount
    end

    function Xayah:UpdateFeathers()
        --[[Particles are more precise but will only be detected on endPos]]
        --for i = 0,GameObjectCount() do
        --    local obj = GameObject(i)
        --    if obj.owner == myHero and obj.name == "Feather" and not obj.dead and not self:CheckFeather(obj) then
        --        self.PassiveTable[#self.PassiveTable+1] = {placetime = Timer() + 6, ID = obj.networkID, pos = Vector(obj.pos), hit = false})
        --    end
        --end
        --[[Missiles will be detected instantly but can lead to wrong positions (eg out of map bondaries)]]
        for i = 1, MissileCount() do
            local missile = Missile(i)
            --print(missile.missileData.name)
            if missile.missileData and missile.missileData.owner == myHero.handle and not self:CheckFeather(missile) then
                if missile.missileData.name:find("XayahQMissile1") or missile.missileData.name:find("XayahQMissile2") then
                    --pls dont change this line
                    self.PassiveTable[#self.PassiveTable + 1] = { placetime = Timer() + 6, ID = missile.networkID,
                        pos = Vector(missile.missileData.endPos), hit = false } --pls dont remove Vector() here
                elseif missile.missileData.name:find("XayahRMissile") then
                    self.PassiveTable[#self.PassiveTable + 1] = { placetime = Timer() + 6, ID = missile.networkID,
                        pos = Vector(missile.missileData.endPos):Extended(myHero.pos, 100), hit = false } --pls dont remove Vector() here
                elseif missile.missileData.name:find("XayahPassiveAttack") then
                    self.PassiveTable[#self.PassiveTable + 1] = { placetime = Timer() + 6, ID = missile.networkID,
                        pos = Vector(myHero.pos:Extended(missile.missileData.endPos, 1000)), hit = false } --pls dont remove Vector() here
                elseif missile.missileData.name:find("XayahEMissileSFX") then
                    self.PassiveTable = {}
                end
            end
        end
    end

    function Xayah:AutoE()
        if not (self.enemies and self.E:IsReady()) then
            return
        end
        local config = Menu.E
        local ksActive = config.KS:Value()
        local Auto, Combo, Harass = config.Auto:Value() and self.mode and self.mode >= 3,
            (config.Combo:Value() and ManaPercent(myHero) >= Menu.E.Mana:Value() and self.mode == 1),
            (config.Harass:Value() and ManaPercent(myHero) >= Menu.E.ManaHarass:Value() and self.mode == 2)
        local minRoot = (Auto and config.MinRoot:Value()) or (Combo and config.MinRootCombo:Value()) or
            (Harass and config.MinRootHarass:Value()) or huge
        local minHit = (Auto and config.MinFeather:Value()) or (Combo and config.MinFeatherCombo:Value()) or
            (Harass and config.MinFeatherHarass:Value()) or huge
        local rootedEnemies, feathersHit = 0, 0
        --
        if not (Auto or Combo or Harass or ksActive) then
            return
        end
        for i = 1, #(self.enemies) do
            local target = self.enemies[i]
            if IsValidTarget(target) then
                local hitsOnTarget = self:CountFeatherHits(target)
                --
                feathersHit = feathersHit + hitsOnTarget
                if hitsOnTarget >= 3 then
                    rootedEnemies = rootedEnemies + 1
                end
                --
                if ksActive then
                    local rawDmg = Damage:getdmg(_E, target, self.From) * hitsOnTarget * (1 + myHero.critChance / 2) --(45 + myHero:GetSpellData(_E).level * 10 + 0.6 * myHero.bonusDamage) * hitsOnTarget * (1 + myHero.critChance / 2)
                    local dmg = Damage:CalcDamage(myHero, target, 1, rawDmg)
                    if dmg > target.health then
                        self.E:Cast()
                    end
                end
            end
        end
        if rootedEnemies >= minRoot or feathersHit >= minHit then
            self.E:Cast()
        end
    end

    insert(LoadCallbacks, function()
        Xayah()
    end)
end
--------------------------------------

--# Load callbacks --
Callback.Add('Load', function()
    _G.WR_COMMON_LOADED = true
    for i = 1, #LoadCallbacks do
        LoadCallbacks[i]()
    end
    loadedCallbacks = true
    --if modules or Menu.Profiler.ON:Value() then Profiler:Start() end
end)
--------------------------------------