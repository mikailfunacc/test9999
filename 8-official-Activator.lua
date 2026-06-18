local ActivatorMenu = MenuElement({type = MENU, id = "ActivatorMenu", name = "Activator", leftIcon = "http://puu.sh/rUXrf/a6a1976046.png"})
ActivatorMenu:MenuElement({id = "Enabled", name = "Enabled", value = true})
ActivatorMenu:MenuElement({type = MENU, id = "Healing", name = "Auto Healing", leftIcon = "http://puu.sh/rXioi/2ac872033c.png"})
ActivatorMenu.Healing:MenuElement({id = "Enabled", name = "Enabled", value = true})
ActivatorMenu.Healing:MenuElement({id = "UsePots", name = "Use Health Potions", value = true, leftIcon = "http://puu.sh/rUYAW/7fe329aa43.png"})
ActivatorMenu.Healing:MenuElement({id = "UsePotsPercent", name = "Use if health is below:", value = 50, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rUYAW/7fe329aa43.png"})
ActivatorMenu.Healing:MenuElement({id = "UseCookies", name = "Use Cookie Potions", value = true, leftIcon = "http://puu.sh/rUZL0/201b970f16.png"})
ActivatorMenu.Healing:MenuElement({id = "UseCookiesPercent", name = "Use if health is below:", value = 50, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rUZL0/201b970f16.png"})
ActivatorMenu.Healing:MenuElement({id = "UseRefill", name = "Use Refillable Potion", value = true, leftIcon = "http://puu.sh/rUZPt/da7fadf9d1.png"})
ActivatorMenu.Healing:MenuElement({id = "UseRefillPercent", name = "Use if health is below:", value = 50, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rUZPt/da7fadf9d1.png"})
ActivatorMenu.Healing:MenuElement({id = "UseCorrupt", name = "Use Corrupting Potion", value = true, leftIcon = "http://puu.sh/rUZUu/130c59cdc7.png"})
ActivatorMenu.Healing:MenuElement({id = "UseCorruptPercent", name = "Use if health is below:", value = 50, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rUZUu/130c59cdc7.png"})
ActivatorMenu.Healing:MenuElement({id = "UseHunters", name = "Use Hunter's Potion", value = true, leftIcon = "http://puu.sh/rUZZM/46b5036453.png"})
ActivatorMenu.Healing:MenuElement({id = "UseHuntersPercent", name = "Use if health is below:", value = 50, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rUZZM/46b5036453.png"})
ActivatorMenu.Healing:MenuElement({id = "UseHeal", name = "Use Summoner Heal", value = true, leftIcon = "http://puu.sh/rXioi/2ac872033c.png"})
ActivatorMenu.Healing:MenuElement({id = "UseHealPercent", name = "Use if health is below:", value = 30, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rXioi/2ac872033c.png"})
ActivatorMenu:MenuElement({type = MENU, id = "Shielding", name = "Auto Shielding", leftIcon = "http://puu.sh/rXjQ1/af78cc6c34.png"})
ActivatorMenu.Shielding:MenuElement({id = "Enabled", name = "Enabled", value = true})
ActivatorMenu.Shielding:MenuElement({id = "UseSeraph", name = "Use Seraph's Embrace", value = true, leftIcon = "http://puu.sh/rXlH8/f25c083b1f.png"})
ActivatorMenu.Shielding:MenuElement({id = "UseSeraphPercent", name = "Use if health is below:", value = 30, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rXlH8/f25c083b1f.png"})
ActivatorMenu.Shielding:MenuElement({id = "UseSolari", name = "Use the Iron Solari", value = true, leftIcon = "http://puu.sh/rXlT4/c540637cdc.png"})
ActivatorMenu.Shielding:MenuElement({id = "UseSolariPercent", name = "Use if health is below:", value = 30, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rXlT4/c540637cdc.png"})
ActivatorMenu.Shielding:MenuElement({id = "UseMountain", name = "Use Face of the Mountain", value = true, leftIcon = "http://puu.sh/rXm1O/ff038205b1.png"})
ActivatorMenu.Shielding:MenuElement({id = "UseMountainPercent", name = "Use if health is below:", value = 30, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rXm1O/ff038205b1.png"})
ActivatorMenu.Shielding:MenuElement({id = "UseBarrier", name = "Use Summoner Barrier", value = true, leftIcon = "http://puu.sh/rXjQ1/af78cc6c34.png"})
ActivatorMenu.Shielding:MenuElement({id = "UseBarrierPercent", name = "Use if health is below:", value = 30, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rXjQ1/af78cc6c34.png"})
ActivatorMenu:MenuElement({type = MENU, id = "Cleansing", name = "Auto Cleansing", leftIcon = "http://puu.sh/rYrzP/5853206291.png"})
ActivatorMenu.Cleansing:MenuElement({id = "Enabled", name = "Enabled", value = true})
ActivatorMenu.Cleansing:MenuElement({id = "UseMikaels", name = "Use Mikael's Crucible", value = true, leftIcon = "http://puu.sh/rYsia/c5bba5b8bf.png"})
ActivatorMenu.Cleansing:MenuElement({id = "UseMikaelsPercent", name = "Use if health is below:", value = 95, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rYsia/c5bba5b8bf.png"})
ActivatorMenu.Cleansing:MenuElement({id = "UseQSS", name = "Use Quicksilver Sash", value = true, leftIcon = "http://puu.sh/rUXrf/a6a1976046.png"})
ActivatorMenu.Cleansing:MenuElement({id = "UseQSSPercent", name = "Use if health is below:", value = 95, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rUXrf/a6a1976046.png"})
ActivatorMenu.Cleansing:MenuElement({id = "UseMercurial", name = "Use Mercurial Scimitar", value = true, leftIcon = "http://puu.sh/rYsHN/405084b03f.png"})
ActivatorMenu.Cleansing:MenuElement({id = "UseMercurialPercent", name = "Use if health is below:", value = 95, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rYsHN/405084b03f.png"})
ActivatorMenu.Cleansing:MenuElement({id = "UseDervish", name = "Use Dervish Blade", value = true, leftIcon = "http://puu.sh/rYsLV/7bd4233f1a.png"})
ActivatorMenu.Cleansing:MenuElement({id = "UseDervishPercent", name = "Use if health is below:", value = 95, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rYsLV/7bd4233f1a.png"})
ActivatorMenu.Cleansing:MenuElement({id = "UseCleanse", name = "Use Summoner Cleanse", value = true, leftIcon = "http://puu.sh/rYrzP/5853206291.png"})
ActivatorMenu.Cleansing:MenuElement({id = "UseCleansePercent", name = "Use if health is below:", value = 95, min = 5, max = 95, identifier = "%", leftIcon = "http://puu.sh/rYrzP/5853206291.png"})



local myPotTicks = 0;
local myHealTicks = 0;
local myShieldTicks = 0;
local myAntiCCTicks = 0;

local hotkeyTable = {};
hotkeyTable[ITEM_1] = HK_ITEM_1;
hotkeyTable[ITEM_2] = HK_ITEM_2;
hotkeyTable[ITEM_3] = HK_ITEM_3;
hotkeyTable[ITEM_4] = HK_ITEM_4;
hotkeyTable[ITEM_5] = HK_ITEM_5;
hotkeyTable[ITEM_6] = HK_ITEM_6;
local InventoryTable = {};
local currentlyDrinkingPotion = false;
local heroesNearby = false;
local HealthPotionSlot = 0;
local CookiePotionSlot = 0;
local RefillablePotSlot = 0;
local CorruptPotionSlot = 0;
local HuntersPotionSlot = 0;
local HealSlot = 0;
local BarrierSlot = 0;
local BoostSlot = 0;
local SeraphSlot = 0;
local SolariSlot = 0;
local MountainSlot = 0;
local DervishSlot = 0;
local MercurialSlot = 0;
local QSS_Slot = 0;
local MikaelSlot = 0;



local function GrabSummSpell(summName)
local retval = 0;
local spellName = myHero:GetSpellData(SUMMONER_1).name;
if spellName == summName then 
	retval = SUMMONER_1;
	else
	local spellName = myHero:GetSpellData(SUMMONER_2).name;
	if spellName == summName then
		retval = SUMMONER_2;
		end
	end
return retval
end


local function CastSummSpell(summSlot)
if summSlot == SUMMONER_1 then
	Control.CastSpell(HK_SUMMONER_1)
else
	Control.CastSpell(HK_SUMMONER_2)
	end
end


function OnLoad()
HealSlot = GrabSummSpell("SummonerHeal");
BarrierSlot = GrabSummSpell("SummonerBarrier");
BoostSlot = GrabSummSpell("SummonerBoost");
end



local function EnemyChampNearby()
local retval = false
local heroCount = Game.HeroCount();
if heroCount == 1 then
	return true --simulate true in a solo room for testing purposes
	else
	for i = 1, heroCount do
		hero = Game.Hero(i);
		if hero and hero.valid and hero.visible and hero.isEnemy and hero.distance <= 1200 then
			retval = true
			break
		end
	end	
	end
return retval
end

local function myGetSlot(itemID)
local retval = 0;
for i = ITEM_1, ITEM_6 do
	if InventoryTable[i] ~= nil then
		if InventoryTable[i].itemID == itemID then
			if (itemID > 2030) and (itemID < 2034) then --potion solution
				if InventoryTable[i].ammo > 0 then
					retval = i;
					break;
					end
				else
				retval = i;
				break;
				end
			end
		end
	end
return retval
end

local function AutoPotionUse(type,invSlot)
	if not ActivatorMenu.Healing[type] then
		return
	end
	if ActivatorMenu.Healing[type]:Value() then
		if (myHero.maxHealth * (ActivatorMenu.Healing[type .. "Percent"]:Value() * 0.01)) > myHero.health then
			Control.CastSpell(hotkeyTable[invSlot]);
		end
	end
end

local function AutoShieldingUse(type,invSlot,selfCast)
	if not ActivatorMenu.Shielding[type] then
		return
	end
	if ActivatorMenu.Shielding[type]:Value() then
		if (myHero.maxHealth * (ActivatorMenu.Shielding[type .. "Percent"]:Value() * 0.01)) > myHero.health then
			if selfCast then
				Control.CastSpell(hotkeyTable[invSlot],myHero);
				else
				Control.CastSpell(hotkeyTable[invSlot]);
			end
		end
	end
end

local function AutoCleansingUse(type,invSlot,selfCast)
	if not ActivatorMenu.Cleansing[type] then
		return
	end
	if ActivatorMenu.Cleansing[type]:Value() then
		if (myHero.maxHealth * (ActivatorMenu.Cleansing[type .. "Percent"]:Value() * 0.01)) > myHero.health then
			if selfCast then
				Control.CastSpell(hotkeyTable[invSlot],myHero);
				else
				Control.CastSpell(hotkeyTable[invSlot]);
			end
		end
	end
end



function OnTick()
if ActivatorMenu.Enabled:Value() == false then return end
if myHero.alive == false then return end --ignore activator when dead?

hotkeyTable[ITEM_1] = HK_ITEM_1;
hotkeyTable[ITEM_2] = HK_ITEM_2;
hotkeyTable[ITEM_3] = HK_ITEM_3;
hotkeyTable[ITEM_4] = HK_ITEM_4;
hotkeyTable[ITEM_5] = HK_ITEM_5;
hotkeyTable[ITEM_6] = HK_ITEM_6;

if (myPotTicks + 1000 < GetTickCount()) and ActivatorMenu.Healing.Enabled:Value() then
	myPotTicks = GetTickCount();
	heroesNearby = EnemyChampNearby();
	currentlyDrinkingPotion = false;
	for j = ITEM_1, ITEM_6 do
		InventoryTable[j] = myHero:GetItemData(j);
	end
	HealthPotionSlot = myGetSlot(2003);
	CookiePotionSlot = myGetSlot(2010);
	RefillablePotSlot = myGetSlot(2031);
	HuntersPotionSlot = myGetSlot(2032);
	CorruptPotionSlot = myGetSlot(2033);
	--print("gonna cast it")
	for i = 0, 63 do
		local buffData = myHero:GetBuff(i);
		if buffData.count > 0 then
			if (buffData.type == 13) or (buffData.type == 26) then --HealBuffType or Counter
				if (buffData.name == "ItemDarkCrystalFlask") or (buffData.name == "ItemCrystalFlaskJungle") or (buffData.name == "ItemCrystalFlask") or (buffData.name == "ItemMiniRegenPotion") or (buffData.name == "RegenerationPotion") then
					currentlyDrinkingPotion = true;
					break;
				end
			end
		end
	end	
	if (currentlyDrinkingPotion == false) and (heroesNearby == true) then
		if HealthPotionSlot > 0 then
			AutoPotionUse("UsePots",HealthPotionSlot);
		end
		if CookiePotionSlot > 0 then
			AutoPotionUse("UseCookies",CookiePotionSlot);
		end
		if RefillablePotSlot > 0 then
			AutoPotionUse("UseRefill",RefillablePotSlot);
		end
		if CorruptPotionSlot > 0 then
			AutoPotionUse("UseCorrupt",CorruptPotionSlot);
		end
		if HuntersPotionSlot > 0 then
			AutoPotionUse("UseHunters",HuntersPotionSlot);
		end
	end
	end
	
if (myHealTicks + 100 < GetTickCount()) and ActivatorMenu.Healing.Enabled:Value() and ActivatorMenu.Healing.UseHeal:Value() then
	myHealTicks = GetTickCount();
	if HealSlot > 0 then
		local healData = myHero:GetSpellData(HealSlot);
		if healData.level > 0 then
			if healData.currentCd == 0 then
				heroesNearby = EnemyChampNearby();
				if (heroesNearby == true) then
					if (myHero.maxHealth * (ActivatorMenu.Healing.UseHealPercent:Value() * 0.01)) > myHero.health then
						CastSummSpell(HealSlot);
						end
					end
				end
			end
		end
	end
	
if (myShieldTicks + 200 < GetTickCount()) and ActivatorMenu.Shielding.Enabled:Value() then
	myShieldTicks = GetTickCount();
	heroesNearby = EnemyChampNearby();
	for j = ITEM_1, ITEM_6 do
		InventoryTable[j] = myHero:GetItemData(j);
	end
	SeraphSlot = myGetSlot(3040);
	if SeraphSlot == 0 then
		SeraphSlot = myGetSlot(3048);
		end
	SolariSlot = myGetSlot(3190);
	MountainSlot = myGetSlot(3401);
	if (heroesNearby == true) then
		if SeraphSlot > 0 then
			local itemData = myHero:GetSpellData(SeraphSlot);
			if itemData.currentCd == 0 then
				AutoShieldingUse("UseSeraph",SeraphSlot,false);
				end
			end
		if SolariSlot > 0 then
			local itemData = myHero:GetSpellData(SolariSlot);
			if itemData.currentCd == 0 then
				AutoShieldingUse("UseSolari",SolariSlot,false);
				end
			end
		if MountainSlot > 0 then
			local itemData = myHero:GetSpellData(MountainSlot);
			if itemData.currentCd == 0 then
				AutoShieldingUse("UseMountain",MountainSlot,true);
				end
			end
		end
	if (BarrierSlot > 0) and ActivatorMenu.Shielding.UseBarrier:Value() then
		local barrierData = myHero:GetSpellData(BarrierSlot);
		if barrierData.level > 0 then
			if barrierData.currentCd == 0 then
				if (heroesNearby == true) then
					if (myHero.maxHealth * (ActivatorMenu.Shielding.UseBarrierPercent:Value() * 0.01)) > myHero.health then
						CastSummSpell(BarrierSlot);
						end
					end
				end
			end
		end
	end
	
if (myAntiCCTicks + 200 < GetTickCount()) and ActivatorMenu.Cleansing.Enabled:Value() then
	myAntiCCTicks = GetTickCount();
	local weJustAntiCCed = false;
	for j = ITEM_1, ITEM_6 do
		InventoryTable[j] = myHero:GetItemData(j);
	end
	DervishSlot = myGetSlot(3137);
	MercurialSlot = myGetSlot(3139);
	QSS_Slot = myGetSlot(3140);
	MikaelSlot = myGetSlot(3222);
	
	if (DervishSlot > 0) or (MercurialSlot > 0) or (QSS_Slot > 0) or (MikaelSlot > 0) then --just to avoid extra loops when we don't have the items
	for i = 0, 63 do
		local buffData = myHero:GetBuff(i);
		if buffData.count > 0 then
			-- stun or taunt or polymorph or snare or fear or charm or supression
			if (buffData.type == 5) or (buffData.type == 8) or (buffData.type == 9) or (buffData.type == 11) or (buffData.type == 21) or (buffData.type == 22) or (buffData.type == 24) or (buffData.type == 28) then
				if (weJustAntiCCed == false) then
					if (DervishSlot > 0) and (weJustAntiCCed == false) then
						local itemData = myHero:GetSpellData(DervishSlot);
						if itemData.currentCd == 0 then
							AutoCleansingUse("UseDervish",DervishSlot,false);
							weJustAntiCCed = true;
							end
						end
					if (MercurialSlot > 0) and (weJustAntiCCed == false) then
						local itemData = myHero:GetSpellData(MercurialSlot);
						if itemData.currentCd == 0 then
							AutoCleansingUse("UseMercurial",MercurialSlot,false);
							weJustAntiCCed = true;
							end
						end
					if (QSS_Slot > 0) and (weJustAntiCCed == false) then
						local itemData = myHero:GetSpellData(QSS_Slot);
						if itemData.currentCd == 0 then
							AutoCleansingUse("UseQSS",QSS_Slot,false);
							weJustAntiCCed = true;
							end
						end
					if (MikaelSlot > 0) and (weJustAntiCCed == false) then
						local itemData = myHero:GetSpellData(MikaelSlot);
						if itemData.currentCd == 0 then
							AutoCleansingUse("UseQSS",MikaelSlot,true);
							weJustAntiCCed = true;
							end
						end
					if (BoostSlot > 0) and (weJustAntiCCed == false) and ActivatorMenu.Cleansing.UseCleanse:Value() and (buffData.type ~= 24) then --SummonerBoost can't handle Supression ...
						local boostData = myHero:GetSpellData(BarrierSlot);
							if boostData.level > 0 then
								if boostData.currentCd == 0 then
									if (myHero.maxHealth * (ActivatorMenu.Cleansing.UseCleansePercent:Value() * 0.01)) > myHero.health then
										CastSummSpell(BoostSlot);
										weJustAntiCCed = true;
									end
								end
							end
						end
					end
				break;
				end
			end
		end
	end	

	
	end
	
end


--PrintChat("Activator by Feretorix loaded.")