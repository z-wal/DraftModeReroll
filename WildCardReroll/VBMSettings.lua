--[[
	********************************************************************
	********************************************************************
	Handles Slash commands and settings menu	
	********************************************************************
	********************************************************************
]]--
local VBMSettings;
local VBM_CHAR_SAVE;
function VBM_Settings_SetDefaults()
	if(not _G["VBMSettings"]) then _G["VBMSettings"] = {}; end
	VBMSettings = _G["VBMSettings"];
	if(not _G["VBM_CHAR_SAVE"]) then _G["VBM_CHAR_SAVE"] = {}; end
	VBM_CHAR_SAVE = _G["VBM_CHAR_SAVE"];
	
	-- WildCard
		--if(VBMSettings['ShowRollAmount'] == nil) then VBMSettings['ShowRollAmount'] = 1; end
		--if(VBMSettings['ShowRollingSpells'] == nil) then VBMSettings['ShowRollingSpells'] = 1; end
		if(VBMSettings['ExitOnSuccess'] == nil) then VBMSettings['ExitOnSuccess'] = 1; end
		VBMSettings['ShowRollAmount'] = 0;
		VBMSettings['ShowRollingSpells'] = 0;
		VBMSettings['WILDCARD_SET_ONE_ENABLED'] = 0;
		VBMSettings['WILDCARD_SET_TWO_ENABLED'] = 0;
		VBMSettings['WILDCARD_SET_THREE_ENABLED'] = 0;
		VBMSettings['WILDCARD_SET_FOUR_ENABLED'] = 0;
		VBMSettings['WILDCARD_SET_FIVE_ENABLED'] = 0;
		VBMSettings['WILDCARD_SET_SIX_ENABLED'] = 0;
		VBMSettings['WILDCARD_SET_SEVEN_ENABLED'] = 0;
		VBMSettings['WILDCARD_SET_EIGHT_ENABLED'] = 0;
		VBMSettings['WILDCARD_SET_NINE_ENABLED'] = 0;
		VBMSettings['WILDCARD_SET_TEN_ENABLED'] = 0;
end

function VBM_Toggle_Bool(var)
	if(var) then
		return false;
	else
		return true;
	end
end

function VBM_Toggle_Options(setting,...)
	local arg = {...};
	local num = #arg;
	local i;
	for i=1,num do
		if(VBMSettings[setting] == arg[i]) then
			if(i==num) then
				VBMSettings[setting] = arg[1];
				break;
			else
				VBMSettings[setting] = arg[i+1];
				break;
			end
		end
	end
	vbm_printc("Setting |cFFFFFFFF"..setting.."|cFF8888CC set to |cFFFFFFFF"..VBMSettings[setting]);
end

function VBM_Toggle_Setting()
	local s = this.value;
	if(VBMSettings[s]==1) then
		VBMSettings[s] = 0;
		vbm_printc("Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFFoff");
	else
		VBMSettings[s] = 1;
		vbm_printc("Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFFon");
	end
end

function VBM_GetCVar(var,value)
	if(GetCVar(var)==value) then
		return true;
	else
		return false;
	end
end

function VBM_ToggleCVar(var)
	if(GetCVar(var)=="1") then
		SetCVar(var,"0");
	else
		SetCVar(var,"1");
	end
	vbm_printc("Setting WoWCVar |cFFFFFFFF"..var.."|cFF8888CC to |cFFFFFFFF"..GetCVar(var));
end

function VBM_SetCVar(var,value,quiet)
	SetCVar(var,value);
	if(not quiet) then
		vbm_printc("Setting WoWCVar |cFFFFFFFF"..var.."|cFF8888CC to |cFFFFFFFF"..value);
	end
end

function VBM_SetS(s,value)
	VBMSettings[s] = value;
	vbm_printc("Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFF"..value);
end

function VBM_GetS(s)
	if(VBMSettings[s] == 1) then
		return true;
	elseif(VBMSettings[s] == 0) then
		return false;
	else
		return VBMSettings[s];
	end
end

function FullToNumber(full)
	if(full == "ONE") then
		return "1";
	elseif(full == "TWO") then
		return "2";
	elseif(full == "THREE") then
		return "3";
	elseif(full == "FOUR") then
		return "4";
	elseif(full == "FIVE") then
		return "5";
	elseif(full == "SIX") then
		return "6";
	elseif(full == "SEVEN") then
		return "7";
	elseif(full == "EIGHT") then
		return "8";
	elseif(full == "NINE") then
		return "9";
	elseif(full == "TEN") then
		return "10";
	end
end

function NumberToFull(number)
	if(number == 1) then
		return "ONE";
	elseif(number == 2) then
		return "TWO";
	elseif(number == 3) then
		return "THREE";
	elseif(number == 4) then
		return "FOUR";
	elseif(number == 5) then
		return "FIVE";
	elseif(number == 6) then
		return "SIX";
	elseif(number == 7) then
		return "SEVEN";
	elseif(number == 8) then
		return "EIGHT";
	elseif(number == 9) then
		return "NINE";
	elseif(number == 10) then
		return "TEN";
	end
end

function ResetSets()
	StaticPopupDialogs["RESET_CONFIRM"] =
	{
		text = "Are you sure you want to reset your sets?",
		button1 = "Reset";
		button2 = "Cancel";
		
		OnAccept = function(self)
			for r = 1,#SETS do
				PerformReset(NumberToFull(r));
				VBMSettings['WILDCARD_SET_'..NumberToFull(r)..'_ENABLED'] = 0;
			end
			vbm_printc("|cFFFFFFFFYour sets have been reset.");
			self:Hide();
		end,
		
		OnCancel = function(self)
			self:Hide();
		end,
		
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		
		timeout = 0; -- to prevent OnUpdate error
	};
	StaticPopup_Show("RESET_CONFIRM");
end

function PerformReset(set) -- thanks to Kap
	for r = 1, #SPELLS do		
		_G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set] = "Anything";
		_G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set..'_ALT_ONE'] = "Nothing";
		_G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set..'_ALT_TWO'] = "Nothing";
		_G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set..'_FOUND'] = false
		_G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set..'_USING_GROUPS'] = false;
		_G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set..'_ALT_ONE_'..'USING_GROUPS'] = false;
		_G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set..'_ALT_TWO_'..'USING_GROUPS'] = false;
	end
end

function ShowHelpPopup()
	StaticPopupDialogs["HELP_POPUP"] =
	{
		text = "Welcome to DraftModeReroll.\n\n"..
		"Please make sure the macro named 'RerollVBM' is on your action bar. If it isn't, type /macro, select Specific Macros and drag it onto your action bar.\n\nTHE MACRO HAS TO BE ON ACTION BAR SLOT 1.\n\n"..
		"Please make sure to NOT spam the macro fast, don't press it faster than once per second or the AddOn won't work properly due to WoW limitations.\n\n"..
		"For any issues, questions or comments, feel free to open an issue on github.",
		button1 = "Show help";
		
		OnAccept = function(self)
			self:Hide();
			ShowActualHelp();
		end,
		
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		
		timeout = 0; -- to prevent OnUpdate error
	};
	StaticPopup_Show("HELP_POPUP");
end

function ShowActualHelp()
	StaticPopupDialogs["ACTUAL_HELP_POPUP"] =
	{
		text = "You can have up to 10 sets of spells. To configure what spells you want, hover over the set you want to configure, and click a spell.\n\n\n"..
		--" Please make sure you are typing the exact spell name, for example: Immolate; and not immolate.\n\n\n"..
		--"You can use groups of spells in place of a single spell. For example: \n'HOT' will let you roll all Heal over Time spells.\n\n\n"..
		"The import and export set will give you a string that you can use to easily share either a single set, or all sets at once. Good for easily setting up new characters or sharing sets with friends!\n\n\n"..
		"When you are done configuring a set, toggle the 'Enable set' option. It must be enabled for each set you want to roll for.\n\n\n"..
		"All you have to do now is press the macro on your action bar slowly, and DraftModeReroll will automatically delete the macro once you hit a set of spells, so you can't accidentally roll over it. Enjoy!",
		button1 = "Okay";
		
		OnAccept = function(self)
			self:Hide();
		end,
		
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		
		timeout = 0; -- to prevent OnUpdate error
	};
	StaticPopup_Show("ACTUAL_HELP_POPUP");
end

function ShowPopup(var)
	if(LOCKED_TO_SET) then
		StaticPopupDialogs["SHOW_ERROR"] =
		{
			text = "You can't edit a set while rolling!";
			button1 = "Okay",
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
		};
		StaticPopup_Show("SHOW_ERROR");
		return;
	end
	
	StaticPopupDialogs["SPELL_KEEP"] =
	{
		text = "Type a spell name or press ESC to exit. (case sensitive)",
		hasEditBox = 1;
		maxLetters = 64;
		button1 = "Add";
		--button2 = "Choose group";
		
		OnAccept = function(self)
			local keyword = self.editBox:GetText();
			self:Hide();
			SaveWildCardVariable(var, keyword);
		end,
		
		OnCancel = function(self)
			self:Hide();
			ShowGroup(var);
		end,
			
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent();
			local keyword = parent.editBox:GetText();
			parent:Hide();
			SaveWildCardVariable(var, keyword);
		end,
		
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		
		timeout = 0; -- to prevent OnUpdate error
	};
	StaticPopup_Show("SPELL_KEEP");
end

function ShowGroup(var)
	StaticPopupDialogs["SPELL_KEEP_GROUP"] =
	{
		text = "Type a group name or press ESC to exit. You must type the group name in full caps.\n\nHOT: Renew, Rejuvation\n\n"..
		"HEAL: Healing Touch, Holy Light, Healing Wave\n\n"..
		"DOT: Immolate, Corruption, Curse of Agony, Moonfire, Shadow Word: Pain\n\n"..
		"SLOW: Concussive Shot, Frostbolt, Earthbind Totem, Hamstring\n\n"..
		"BUFF: Thorns, Mark of the Wild,  Arcane Intellect, Blessing of Wisdom, Blessing of Might, Power Word: Fortitude, Battle Shout, Power Word: Shield\n\n"..
		"SELFBUFF: Aspect of the Monkey, Aspect of the Hawk, Frost Armor, Seal of Righteousness, Divine Protection, Righteous Fury, Fade, Evasion, Lightning Shield, Demon Skin\n\n"..
		"MELEEBUFF: Mark of the Wild, Blessing of Might, Power Word: Fortitude, Battle Shout\n\n"..
		"CASTERBUFF: Mark of the Wild, Arcane Intellect, Blessing of Wisdom, Power Word: Fortitude, Power Word: Shield",
		hasEditBox = 1;
		maxLetters = 10;
		button1 = "Add";
		button2 = "Back";
		
		OnAccept = function(self)
			local keyword = self.editBox:GetText();
			self:Hide();
			SaveWildCardVariable(var, keyword);
		end,
		
		OnCancel = function(self)
			self:Hide();
			ShowPopup(var);
		end,
			
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent();
			local keyword = parent.editBox:GetText();
			parent:Hide();
			SaveWildCardVariable(var, keyword);
		end,
		
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		
		timeout = 0; -- to prevent OnUpdate error
	};
	StaticPopup_Show("SPELL_KEEP_GROUP");
end

function ImportSet(set, import)
	PerformReset(set);
	local spell_tbl = {}
	
	for spell in string.gmatch(import, "[^|]+") do
		local spell_tbl_tmp = {}
		for token in string.gmatch(spell, "[^0]+") do
			table.insert(spell_tbl_tmp, token)
		end
		table.insert(spell_tbl, spell_tbl_tmp)
	end

	for r = 1, #spell_tbl do	
		if string.len(spell_tbl[r][1]) == 2 then
			local spell_var = "WILDCARD_SPELL_"..NumberToFull(tonumber(string.sub(spell_tbl[r][1], 2, 2))).."_SET_"..set
			local spell_name = spell_tbl[r][2]
			SaveWildCardVariable(spell_var, spell_name)
			
		elseif string.len(spell_tbl[r][1]) == 4 then
			local spell_var = "WILDCARD_SPELL_"..NumberToFull(tonumber(string.sub(spell_tbl[r][1], 2, 2))).."_SET_"..set.."_ALT_"..NumberToFull(tonumber(string.sub(spell_tbl[r][1], 4, 4)))
			local spell_name = spell_tbl[r][2]
			SaveWildCardVariable(spell_var, spell_name)
		end
	end
end

function ExportSet(set)
	local export_str = ""
	for r = 1, #SPELLS do
		if _G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set] ~="Anything" then
			export_str = export_str.."S"..r.."0".._G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set].."|"
		end
		if _G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set..'_ALT_ONE'] ~="Nothing" then
			export_str = export_str.."S"..r.."A10".._G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set..'_ALT_ONE'].."|"
		end
		if _G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set..'_ALT_TWO'] ~="Nothing" then
			export_str = export_str.."S"..r.."A20".._G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..set..'_ALT_TWO'].."|"
		end
	end
	return export_str;
end

function ImportAllSets(import)
	local set_table = {}
	for set in string.gmatch(import, "[^/]+") do
		table.insert(set_table, set)
	end
	local setNum = 1
	for _,imported_set in pairs(set_table) do
		ImportSet(NumberToFull(setNum), imported_set)
		setNum = setNum + 1
	end
end

function ExportAllSets()
	export_str = ""

	for i = 1, #SETS do
		-- check if set is used
		local set_used = false
		for r = 1, #SPELLS do
			if _G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..NumberToFull(i)] ~="Anything" then
				set_used = true
				break
			end
			if _G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..NumberToFull(i)..'_ALT_ONE'] ~="Nothing" then
				set_used = true
				break
			end
			if _G['WILDCARD_SPELL_'..NumberToFull(r)..'_SET_'..NumberToFull(i)..'_ALT_TWO'] ~="Nothing" then
				set_used = true
				break
			end
		end
		
		if set_used == true then 
			export_str = export_str..ExportSet(NumberToFull(i))..'/'
		end
	end
	
	return export_str
end

function ShowImportPopup(set_num)
	StaticPopupDialogs["IMPORT_POPUP"] =
	{
		text = "Import a set of spells.\nMake sure you are importing a single set, not a grouping of sets.\nThis will reset all sets and replace them with imported sets!",
		hasEditBox = 1;
		maxLetters = 2000;
		button1 = "Import";
		button2 = "Cancel";
		
		OnAccept = function(self)
			local import = self.editBox:GetText();
			self:Hide();
			ImportSet(set_num, import);
		end,
			
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent();
			local import = parent.editBox:GetText();
			parent:Hide();
			ImportSet(set_num, import);
		end,
		
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		
		timeout = 0; -- to prevent OnUpdate error
	};
	StaticPopup_Show("IMPORT_POPUP");
end

function ShowExportPopup(set, export)
	StaticPopupDialogs["EXPORT_POPUP"] = {
		text = "Export Set.\nCtrl + A to hightlight, then Ctrl + C to copy.",
		hasEditBox = 1;
		maxLetters = 2000;
		button1 = "Done",
		button2 = "Cancel",
		
		OnShow = function(self, data)
			self.editBox:SetText(ExportSet(set));
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
	StaticPopup_Show("EXPORT_POPUP");
end

function ShowImportAllPopup()
	StaticPopupDialogs["IMPORT_ALL_POPUP"] =
	{
		text = "Import All Sets.\nMake sure you are importing a grouping of sets, and not an individual set.",
		hasEditBox = 1;
		maxLetters = 10000;
		button1 = "Import";
		button2 = "Cancel";
		
		OnAccept = function(self)
			local import = self.editBox:GetText();
			self:Hide();
			ImportAllSets(import);
		end,
			
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent();
			local import = parent.editBox:GetText();
			parent:Hide();
			ImportAllSets(import);
		end,
		
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		
		timeout = 0; -- to prevent OnUpdate error
	};
	StaticPopup_Show("IMPORT_ALL_POPUP");
end

function ShowExportAllPopup()
	StaticPopupDialogs["EXPORT_ALL_POPUP"] = {
		text = "Export All Sets.\nCtrl + A to hightlight, then Ctrl + C to copy.",
		hasEditBox = 1;
		maxLetters = 10000;
		button1 = "Done",
		button2 = "Cancel",
		
		OnShow = function(self, data)
			self.editBox:SetText(ExportAllSets());
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
	StaticPopup_Show("EXPORT_ALL_POPUP");

end

function ShowSpellNameErrorPopup(spell)
	StaticPopupDialogs["SPELL_NAME_ERROR_POPUP"] =
			{
				text = "That spell is not available and was not saved.\n\n >>>    "..spell.."    <<<\n\n Check spelling or capitalization.",
				button1 = "Okay",
				timeout = 0,
				whileDead = 1,
				hideOnEscape = 1,
			};
	StaticPopup_Show("SPELL_NAME_ERROR_POPUP");
end

function IsValidSpell(spell)
	for _, value in pairs(ABILITY_LIST) do
		if value == spell then
			return true
		end
	end
	return false
end

function SaveWildCardVariable(var, keyword)
	if IsValidSpell(keyword) then
		_G[var] = keyword; -- thanks to Kap
		local using_groups = false
		for _, value in pairs(ABILITY_GROUPS) do
			if value == keyword then
				using_groups = true
			end
		end
		
		if using_groups then
			_G[var..'_USING_GROUPS'] = true
		else
			_G[var..'_USING_GROUPS'] = false
		end
	else
		ShowSpellNameErrorPopup(keyword);
	end
end

function VBM_Settings_Menuofdoom()
	local info = {};
	if(UIDROPDOWNMENU_MENU_LEVEL==1) then
		info = {};
		info.text = "Draft Mode";
		info.hasArrow = 1;
		info.notCheckable = 1;
		info.value = "WildCardMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
	end
					
		if(UIDROPDOWNMENU_MENU_VALUE == "WildCardMenu") then
			info = {};
			info.text = "General";
			info.isTitle = 1;
			info.notCheckable = 1;
			info.disable = 1;
			UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			
			local name, iconTexture, body, isLocal = GetMacroInfo("RerollVBM");
			local _, perChar = GetNumMacros();
			if(perChar == 18) then
				StaticPopupDialogs["TOO_MANY_MACROS"] =
				{
					text = "You have too many Character Specific macros! Please delete some.\n\nType /macro",
					button1 = "Okay";
					
					OnAccept = function(self)
						self:Hide();
					end,
					
					OnShow = function(self)
						self.editBox:SetFocus();
					end,
					
					EditBoxOnEscapePressed = function(self)
						self:GetParent():Hide();
					end,
					
					timeout = 0; -- to prevent OnUpdate error
				};
				StaticPopup_Show("TOO_MANY_MACROS");
			elseif(name == nil and perChar ~= 18) then
				info = {};
				info.text = "Create macro";
				info.tooltipTitle = info.text;
				info.tooltipText = "Creates a Character Specific macro that you can use to re-roll.";
				info.notCheckable = 1;
				info.checked = VBM_GetS("CreateMacro");
				info.func = function() LOCKED_TO_SET = false; SET_COMPLETED = false; CreateMacro("RerollVBM", 10, "/use SpellDraft Deck\n/click StaticPopup1Button1", 1); vbm_printc("|cFFFFFFFFMacro created! It is put on your first action bar slot, do NOT move it anywhere else."); PickupMacro("RerollVBM"); PlaceAction(1); end;
				info.value = "CreateMacro";
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			else
				info = {};
				info.text = "Exit game on success";
				info.tooltipTitle = info.text;
				info.tooltipText = "With this option enabled, your game will quit once you get a set of spells.";
				info.keepShownOnClick = 1;
				info.checked = VBM_GetS("ExitOnSuccess");
				info.func = VBM_Toggle_Setting;
				info.value = "ExitOnSuccess";
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Show spells";
				info.disabled = 1;
				info.tooltipTitle = info.text;
				info.tooltipText = "Shows you what spells you are rolling for every time you roll.";
				info.keepShownOnClick = 1;
				info.checked = VBM_GetS("ShowRollingSpells");
				info.func = VBM_Toggle_Setting;
				info.value = "ShowRollingSpells";
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Show amount";
				info.disabled = 1;
				info.tooltipTitle = info.text;
				info.tooltipText = "Shows you how many times you've rolled this session.";
				info.keepShownOnClick = 1;
				info.checked = VBM_GetS("ShowRollAmount");
				info.func = VBM_Toggle_Setting;
				info.value = "ShowRollAmount";
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Help";
				info.tooltipTitle = info.text;
				info.tooltipText = "Shows help on how to use the AddOn.";
				info.func = function() ShowHelpPopup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disable = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Sets";
				info.isTitle = 1;
				info.notCheckable = 1;
				info.disable = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Reset sets";
				info.tooltipTitle = info.text;
				info.tooltipText = "Reset all sets back to default.";
				info.func = function() ResetSets(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Export all sets";
				info.tooltipTitle = info.text;
				info.tooltipText = "Export all of your sets.";
				info.func = function() ShowExportAllPopup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Import all sets";
				info.tooltipTitle = info.text;
				info.tooltipText = "Imports a group of sets, all your previous sets will be reset and replaced.";
				info.func = function() ShowImportAllPopup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				for key1,setVal in ipairs(SETS) do					
					info = {};
					info.text = "Set "..FullToNumber(setVal);
					info.notCheckable = 1;
					info.hasArrow = 1;
					info.value = "UI_SET_"..setVal;
					UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				end
			end
		end
		
			for key1,setVal in ipairs(SETS) do
				if(UIDROPDOWNMENU_MENU_VALUE == "UI_SET_"..setVal) then
					info = {};
					info.text = "Enable set";
					info.tooltipTitle = info.text;
					info.tooltipText = "Please enable this AFTER you've typed in your spell names.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("WILDCARD_SET_"..setVal.."_ENABLED");
					info.func = VBM_Toggle_Setting;
					info.value = "WILDCARD_SET_"..setVal.."_ENABLED";
					UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
					
					info = {};
					info.text = "Import set";
					--info.tooltipTitle = info.text;
					--info.tooltipText = "Import a set created by either you or someone else."; -- self explanatory what it does
					info.func = function() ShowImportPopup(setVal); end;
					UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
					
					info = {};
					info.text = "Export set";
					--info.tooltipTitle = info.text;
					--info.tooltipText = "Export a set, share it with friends!"; -- self explanatory what it does
					info.func = function() ShowExportPopup(setVal); end;
					UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
					info = {};
					info.text = "";
					info.isTitle = 1;
					info.notCheckable = 1;
					info.disable = 1;
					UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
					
					for key2,spellVal in ipairs(SPELLS) do
						local spellTitle;
						spellTitle = _G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal];
							
						info = {};
						info.text = "Spell "..FullToNumber(spellVal)..": ".._G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal];
						info.tooltipTitle = "Current spell: ".._G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal];
						info.func = function() ShowPopup("WILDCARD_SPELL_"..spellVal.."_SET_"..setVal); end;
						if(info.text ~= "Spell "..FullToNumber(spellVal)..": Anything") then
							--info.hasArrow = 1;
							--info.value = "UI_SPELL_"..spellVal.."_SET_"..setVal;
						end
						UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
					end
				end
			end
			
				for key3,setVal in ipairs(SETS) do
					for key4,spellVal in ipairs(SPELLS) do						
						if(UIDROPDOWNMENU_MENU_VALUE == "UI_SPELL_"..spellVal.."_SET_"..setVal) then
							info = {};
							info.text = "Alternative spell 1: ".._G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_ALT_ONE'];
							info.tooltipTitle = "Current spell: ".._G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_ALT_ONE'];
							info.func = function() ShowPopup('WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_ALT_ONE'); end;
							UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
							
							info = {};
							info.text = "Alternative spell 2: ".._G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_ALT_TWO'];
							info.tooltipTitle = "Current spell: ".._G['WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_ALT_TWO'];
							info.func = function() ShowPopup('WILDCARD_SPELL_'..spellVal..'_SET_'..setVal..'_ALT_TWO'); end;
							UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
						end
					end
				end
end
