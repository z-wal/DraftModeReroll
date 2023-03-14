--[[	
	******************
	Settings and global vars
	******************
]]--

VBM_VERSION = "3.0";

IS_LOGGING_OUT = false;
WILDCARD_SET_TO_CHECK = 1;
SET_ENABLED = false;

SetToCheck = 1;
StopAt = 4;

LOCKED_TO_SET = false;
SPELLS_TO_CHECK = {};
FOUND_IN_SETS = {};
SET_COMPLETED = false;

SETS = {"ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN"};
SPELLS = {"ONE", "TWO", "THREE", "FOUR"};

ABILITY_LIST = {"Wrath", "Moonfire", "Thorns", "Demoralizing Roar", "Maul", "Growl", "Bear Form", "Swipe (Bear)", "Greater Heal",
				"Healing Touch", "Mark of the Wild", "Rejuvenation", "Aspect of the Monkey", "Aspect of the Hawk", "Tame Beast", 
				"Auto Shot", "Serpent Sting", "Arcane Shot", "Hunter's Mark", "Concussive Shot", "Raptor Strike", "Track Beasts",
				"Mongoose Bite", "Arcane Intellect", "Conjure Water", "Conjure Food", "Arcane Missiles", "Fireball", "Fire Blast", 
				"Frost Armor", "Frostbolt", "Holy Light", "Seal of Righteousness", "Blessing of Wisdom", "Devotion Aura",
				"Divine Protection", "Hammer of Justice", "Righteous Fury", "Blessing of Might", "Judgement of Light", "Judgement of Wisdom",
				"Power Word: Fortitude", "Power Word: Shield", "Lesser Heal", "Renew", "Smite", "Shadow Word: Pain", "Fade", "Eviscerate",
				"Slice and Dice", "Sinister Strike", "Backstab", "Gouge", "Evasion", "Sprint", "Stealth", "Pick Pocket", "Lightning Bolt",
				"Earth Shock", "Earthbind Totem", "Stoneclaw Totem", "Searing Totem", "Stoneskin Totem", "Lightning Shield", "Healing Wave",
				"Curse of Weakness", "Corruption", "Life Tap", "Curse of Agony", "Fear", "Drain Soul", "Demon Skin", "Summon Imp", "Summon Voidwalker",
				"Shadow Bolt", "Immolate", "Heroic Strike", "Battle Stance", "Charge", "Rend", "Thunder Clap", "Hamstring", "Overpower",
				"Battle Shout", "Victory Rush", "Bloodrage", "Defensive Stance", "Shield Bash", "Shield Block", "Taunt", "Anything", "Nothing",
				"HOT", "DOT", "BUFF", "SELFBUFF", "HEAL", "MELEEBUFF", "CASTERBUFF", "SLOW", "Dominate Undead", "Mana-forged Barrier", "Tame Dragonkin",
				"Brilliance Aura", "Fizzle", "Rebuke", "Enslave Demon", "Concentration Aura", "Cat Form", "Bear Form", "Searing Totem", "Hand of Reckoning",
				"Tether Elemental", "Flametongue Totem", "Demoralizing Shout", "Claw", "Rip", "Rake", "Maul", "Hunter Aspect Master", "Paladin Aura Mastery",
				"Warlock Armor Mastery", "Feral Shapeshift Mastery", "Seal Mastery", "Earth Totem Mastery", "Seal of Wisdom", "Shout Mastery",
				"Blessing Mastery", "Shred", "Fire Totem Mastery", "Mage Armor Mastery", "Stance Mastery"}
				
ABILITY_GROUPS = {"HOT", "DOT", "BUFF", "HEAL", "SELFBUFF", "MELEEBUFF", "CASTERBUFF", "SLOW"}

ABILITY_GROUP_HOT = {"Renew", "Rejuvenation"}

ABILITY_GROUP_HEAL = {"Healing Touch", "Holy Light", "Healing Wave", "Greater Heal"}

ABILITY_GROUP_DOT = {"Immolate", "Corruption", "Curse of Agony", "Moonfire", "Shadow Word: Pain"}

ABILITY_GROUP_BUFF = {"Thorns", "Mark of the Wild", "Arcane Intellect", "Blessing of Wisdom", "Blessing of Might", "Power Word: Fortitude", "Battle Shout", "Power Word: Shield", "Devotion Aura"}

ABILITY_GROUP_MELEEBUFF = {"Mark of the Wild", "Blessing of Might", "Power Word: Fortitude", "Battle Shout"}

ABILITY_GROUP_CASTERBUFF = {"Mark of the Wild", "Arcane Intellect", "Blessing of Wisdom", "Power Word: Fortitude", "Power Word: Shield"}
						
ABILITY_GROUP_SELFBUFF = {"Aspect of the Monkey", "Aspect of the Hawk", "Frost Armor", "Seal of Righteousness", "Divine Protection", "Righteous Fury", "Fade", "Evasion", "Lightning Shield", "Demon Skin"}

ABILITY_GROUP_SLOW = {"Concussive Shot", "Frostbolt", "Earthbind Totem", "Hamstring"}

for key1,setVal in ipairs(SETS) do
	for key2,spellVal in ipairs(SPELLS) do
		_G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal] = "Anything";
		_G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_ALT_ONE'] = "Nothing";
		_G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_ALT_TWO'] = "Nothing";
		_G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_FOUND'] = false
		_G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_USING_GROUPS'] = false;
		_G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_ALT_ONE_'..'USING_GROUPS'] = false;
		_G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_ALT_TWO_'..'USING_GROUPS'] = false;
	end
end

for i=1, #SPELLS do
	_G["WILDCARD_SPELL_"..NumberToFull(i).."_CHECKED"] = false;
end

--[[
************************************************
               FRAME FUNCTIONS
************************************************
]]--

function WildCardReroll_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("CHAT_MSG_CHANNEL");
	this:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	this:RegisterEvent("CHAT_MSG_ADDON");
	this:RegisterEvent("LEARNED_SPELL_IN_TAB");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function WildCardReroll_OnEvent(event)
	if (event == "VARIABLES_LOADED") then 
		WildCardReroll_Init();
		VBM_StatusFrame_Init();
		--support for mod mods feature
		if(VBM_Mod_Mods_Init) then
			VBM_Mod_Mods_Init();
		end
		JoinChannelByName("WildCardReroll");
		REALM_NAME = GetRealmName();
		return;
	end
	
	if (event == "PLAYER_ENTERING_WORLD") then
		DeleteMacro("LearnSpell");
		DeleteMacro("RerollVBM");
		WILDCARD_SET_TO_CHECK = 1;
	end
	
	if (event == "CHAT_MSG_ADDON") then
		if(arg1 == "SAIO") then -- Ascension AddOn
			if(string.sub(arg2, 20, 30) == "UpdateCards") then
				--[[SpellOneName = Card1.nameFrame;
				SpellTwoName = Card2.nameFrame;
				SpellThreeName = Card3.nameFrame;]]--
			end
		end
	end
	
	if(event == "UNIT_SPELLCAST_SUCCEEDED") then
		if(arg1 == "player" and arg2 == "Dummy Spell" and UnitLevel("player") == 1) then
			-- do shit
		end
	end
	
	if(event == "LEARNED_SPELL_IN_TAB") then
		CheckOtherSets();
	end
	
	if (event == "CHAT_MSG_SYSTEM") then
		if (arg1 == "Refund Complete for Spells") then
			for i = 1, #SPELLS_TO_CHECK do SPELLS_TO_CHECK[i] = nil end
			for i = 1, #FOUND_IN_SETS do FOUND_IN_SETS[i] = nil end
			StopAt = 4;
			LOCKED_TO_SET = false;
			if(not SET_ENABLED) then
				StaticPopupDialogs["WARN_NO_SETS_ENABLED"] =
				{
					text = "You don't have any sets enabled.",
					button1 = "Okay",
					timeout = 0,
					whileDead = 1,
					hideOnEscape = 1,
					
					OnAccept = function(self)
						self:Hide();
					end,
					
					EditBoxOnEscapePressed = function(self)
						self:GetParent():Hide();
					end,
				};
				StaticPopup_Show("WARN_NO_SETS_ENABLED");
				return;
			end
		end
	end
	
	if (event == "CHAT_MSG_CHANNEL") then
		local ChanID = GetChannelName("WildCardReroll");
		local AllowCommand = false;
		local name = UnitName("player");
		
		WCR_MSG_FROM = arg2;
		local found,_,p1 = string.find(arg4," (.+)") ;
		if (found) then
			if(p1 == "WildCardReroll") then
				if(REALM_NAME == "Andorhal - No-Risk") then
					if(WCR_MSG_FROM == "Leguaris") then
						AllowCommand = true;
					end
				elseif(REALM_NAME == "Laughing Skull - High-Risk") then
					if(WCR_MSG_FROM == "Leguaris") then
						AllowCommand = true;
					end
				elseif(REALM_NAME == "Shadowsong - WildCard") then
					if(WCR_MSG_FROM == "Leguaris") then
						AllowCommand = true;
					end
				elseif(REALM_NAME == "Darkmoon - Season IV") then
					if(WCR_MSG_FROM == "Leguaris") then
						AllowCommand = true;
					end
				end
				
				if(not AllowCommand) then
					return;
				end
				
				if(string.find(arg1,"wcr_version_check_")) then
					if(arg2 ~= UnitName("player")) then
						if(string.find(arg1, "wcr_version_check_(.+)")) then
							_,_,VerNum = string.find(arg1, "wcr_version_check_(.+)");
							VerNumInt = tonumber(VerNum);
							MyVerNumInt = tonumber(VBM_VERSION);
							
							if(MyVerNumInt < VerNumInt) then
								SendChatMessage("My version is "..VBM_VERSION, "CHANNEL", nil, ChanID);
								
								StaticPopupDialogs["UPDATE_WCR_SILENT"] =
									{
										text = "Please update DraftModeReroll to "..VerNum..".",
										button1 = "Cancel",
										button2 = "Show link",
										timeout = 0,
										whileDead = 1,
										hideOnEscape = 1,
										
										OnAccept = function(self)
											self:Hide();
										end,
		
										OnCancel = function(self)
											self:Hide();
											ShowDownloadLink();
										end,
										
										EditBoxOnEscapePressed = function(self)
											self:GetParent():Hide();
										end,
									};
									StaticPopup_Show("UPDATE_WCR_SILENT");
							else
								SendChatMessage("I have the latest version!", "CHANNEL", nil, ChanID);
							end
						end
					end
				end
			end
		end
	end
end

function ShowDownloadLink()
	StaticPopupDialogs["UPDATE_WCR_LINK"] = {
		text = "CTRL + A > CTRL + C to copy",
		hasEditBox = 1;
		maxLetters = 128;
		button1 = "Okay",
		button2 = "Cancel",
		
		OnShow = function(self, data)
			self.editBox:SetText("https://youtu.be/sKt3-87lJE8");
			self.editBox:SetFocus();
		end,
			
		OnCancel = function(self)
			self:Hide();
		end,
		
		EditBoxOnEnterPressed = function(self)
			self:GetParent():Hide();
		end,
		
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
		};
	StaticPopup_Show("UPDATE_WCR_LINK");
end

function WildCardReroll_OnUpdate()
	-- don't update too fast
	--[[if(this.lastupdate and this.lastupdate + 0.05 > GetTime()) then
		return;
	end
	this.lastupdate = GetTime();]]--
	
	if(WildCardCheck and WildCardCheck + 0.10 > GetTime()) then
		-- do nothing
	else
		WildCardCheck = GetTime();
		if(VBM_GetS("WILDCARD_SET_ONE_ENABLED")
		or VBM_GetS("WILDCARD_SET_TWO_ENABLED")
		or VBM_GetS("WILDCARD_SET_THREE_ENABLED")
		or VBM_GetS("WILDCARD_SET_FOUR_ENABLED")
		or VBM_GetS("WILDCARD_SET_FIVE_ENABLED")
		or VBM_GetS("WILDCARD_SET_SIX_ENABLED")
		or VBM_GetS("WILDCARD_SET_SEVEN_ENABLED")
		or VBM_GetS("WILDCARD_SET_EIGHT_ENABLED")
		or VBM_GetS("WILDCARD_SET_NINE_ENABLED")
		or VBM_GetS("WILDCARD_SET_TEN_ENABLED")) then
			SET_ENABLED = true;
			if (not SET_COMPLETED) then
				CheckCardsForSpells();
			end
		else
			SET_ENABLED = false;
		end
	end
end

function WildCardReroll_Init()
	--print load message 
	vbm_print("|cFF8888CCDraftModeReroll v"..VBM_VERSION.." loaded! Type /dmr to show/hide the frame.");
	
	--Set default settings
	VBM_Settings_SetDefaults();
end

-- needed for ability groups. There's a corner case where CheckNewLearnedSpells would think it's found two or more abilities of a group, even though there's only one.
function SpellAlreadyValidated(spell, spells_checked_so_far)
	for _,checkedSpell in ipairs(spells_checked_so_far) do
		if spell == checkedSpell then
			return true
		end
	end
	return false
end

function CheckCardsForSpells()
if(not SET_COMPLETED) then
	if (not LOCKED_TO_SET and not VBM_GetS("WILDCARD_SET_"..NumberToFull(WILDCARD_SET_TO_CHECK).."_ENABLED")) then -- if the set is not enabled
		if (WILDCARD_SET_TO_CHECK == #SETS) then -- #SETS is the maximum amount of sets possible, so when WILDCARD_SET_TO_CHECK reaches the maximum amount, reset to set 1, creating an infinite loop
			WILDCARD_SET_TO_CHECK = 1;
		else
			WILDCARD_SET_TO_CHECK = WILDCARD_SET_TO_CHECK + 1;
		end
		return;
	end
	
	local setAmount = #FOUND_IN_SETS;
	local setFullName = "";
	if (LOCKED_TO_SET) then
		setFullName = FOUND_IN_SETS[SetToCheck];
	else
		ResetChecked();
		setFullName = NumberToFull(WILDCARD_SET_TO_CHECK);
	end
	
	if (SetToCheck >= setAmount) then
		SetToCheck = 1;
	else
		SetToCheck = SetToCheck + 1;
	end
	
	if (LOCKED_TO_SET and #FOUND_IN_SETS == 1) then
		for i=1, 4 do
			if (setFullName ~= nil and _G["WILDCARD_SPELL_"..NumberToFull(i).."_SET_"..setFullName] == "Anything" and not _G["WILDCARD_SPELL_"..NumberToFull(i).."_CHECKED"]) then
				StopAt = StopAt - 1;
				_G["WILDCARD_SPELL_"..NumberToFull(i).."_CHECKED"] = true;
			end
		end
		
		if (StopAt ~= 0 and #SPELLS_TO_CHECK == StopAt) then
			SET_COMPLETED = true;
			CompletedSet(FullToNumber(setFullName));
			return;
		end
	end
	
	local SpellOneName = Card1.nameFrame.text:GetText();
	local SpellTwoName = Card2.nameFrame.text:GetText();
	local SpellThreeName = Card3.nameFrame.text:GetText();
	
	if (setFullName == nil) then
		return;
	end
	
	local i = 1;
	while i <= #SPELLS do -- we should only check #SPELLS amount of times per set
		local spellValue = NumberToFull(i);
		local macroName,_,_,_ = GetMacroInfo("LearnSpell");

		if ((_G["WILDCARD_SPELL_"..spellValue.."_SET_"..setFullName] == SpellOneName) or
			(_G["WILDCARD_SPELL_"..spellValue.."_SET_"..setFullName] == SpellTwoName) or
			(_G["WILDCARD_SPELL_"..spellValue.."_SET_"..setFullName] == SpellThreeName)) then
			DeleteMacro("RerollVBM");
			
			LOCKED_TO_SET = true;
			
			if (_G["WILDCARD_SPELL_"..spellValue.."_SET_"..setFullName] == SpellOneName) then
				if (macroName == nil) then
					CreateMacro("LearnSpell", 10, "/click Card1.button\n/run RecreateMacro()", 1);
				end
			elseif (_G["WILDCARD_SPELL_"..spellValue.."_SET_"..setFullName] == SpellTwoName) then
				if (macroName == nil) then
					CreateMacro("LearnSpell", 10, "/click Card2.button\n/run RecreateMacro()", 1);
				end
			elseif (_G["WILDCARD_SPELL_"..spellValue.."_SET_"..setFullName] == SpellThreeName) then
				if (macroName == nil) then
					CreateMacro("LearnSpell", 10, "/click Card3.button\n/run RecreateMacro()", 1);
				end
			end
			
			PickupMacro("LearnSpell");
			PlaceAction(1);
			
			WildCardCheck = GetTime() + 99999.0;
			break;
		end
		
		i = i + 1;
	end
	
	if (not LOCKED_TO_SET) then
		if (WILDCARD_SET_TO_CHECK == #SETS) then
			WILDCARD_SET_TO_CHECK = 1;
		else
			WILDCARD_SET_TO_CHECK = WILDCARD_SET_TO_CHECK + 1;
		end
	end
end
end

function CompletedSet(set)
	DeleteMacro("RerollVBM");
	DeleteMacro("LearnSpell");
	
	for i=1,#SETS do -- disable all sets
		VBMSettings['WILDCARD_SET_'..NumberToFull(i)..'_ENABLED'] = 0;
	end
	
	StaticPopupDialogs["REROLL_SUCCESS_POPUP"] =
	{
		text = "You got set "..set.."!";
		button1 = "Okay",
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
	};
	StaticPopup_Show("REROLL_SUCCESS_POPUP");
	
	if (VBM_GetS("ExitOnSuccess")) then
		Quit();
	end
end

function RecreateMacro()
	WildCardCheck = GetTime() + 0.5;
	DeleteMacro("LearnSpell");
	LOCKED_TO_SET = false;
	local macroName3,_,_,_ = GetMacroInfo("RerollVBM");
	
	if(macroName3 == nil) then
		CreateMacro("RerollVBM", 10, "/use Spelldraft Deck\n/click StaticPopup1Button1", 1);
		PickupMacro("RerollVBM");
		PlaceAction(1);
	end
end

function CheckOtherSets()
	for i = 1, #FOUND_IN_SETS do FOUND_IN_SETS[i] = nil end
	local i = 1;
	while true do
		local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
		if not spellName then
			break;
		else
			for _, ability in ipairs(ABILITY_LIST) do -- only do this for spells that can be learned, not stuff like racials
				if(spellName == ability) then
					if contains(SPELLS_TO_CHECK, spellName) then
						-- spell already exists in the table
					else
						table.insert(SPELLS_TO_CHECK, spellName);
					end
				end
			end
		end
		i = i + 1;
	end
	
	for _, spellName in ipairs(SPELLS_TO_CHECK) do
		local j = 1;
		local n = 1;
		
		while j <= #SETS do
			while n <= #SPELLS do
				if (_G["WILDCARD_SPELL_"..NumberToFull(n).."_SET_"..NumberToFull(j)] == spellName and VBM_GetS("WILDCARD_SET_"..NumberToFull(j).."_ENABLED")) then
					table.insert(FOUND_IN_SETS, NumberToFull(j));
				end
				n = n + 1;
			end
			if(_ > 1 and contains(FOUND_IN_SETS, NumberToFull(j))) then
					CheckDuplicates(FOUND_IN_SETS, NumberToFull(j), _);
			end
			j = j + 1;
			n = 1;
		end
	end
	
	LOCKED_TO_SET = true;
	WildCardCheck = GetTime() + 1.0;
end

function ResetChecked()
	for i=1, #SPELLS do
		_G["WILDCARD_SPELL_"..NumberToFull(i).."_CHECKED"] = false;
	end
end

function CheckDuplicates(list, value, amnt)
	if(amnt > 1) then
		local count = 0;
		for k, v in pairs(list) do
			if v == value then
				count = count + 1;
			end
		end
		
		if (count >= amnt + 1) then
			-- do nothing
		else
			removefromtable(FOUND_IN_SETS, value);
		end
	end
end

function removefromtable(list, value)
	for i, v in ipairs(list) do
		if v == value then
			return table.remove(list, i)
		end
	end
end

function contains(list, spell)
	for _, v in pairs(list) do
		if v == spell then
			return true
		end
	end
		
	return false
end

function vbm_print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function vbm_printc(msg)
	vbm_print("|cFF8888CC<DraftModeReroll> "..msg);
end