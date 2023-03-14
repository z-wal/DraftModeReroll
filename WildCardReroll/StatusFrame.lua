--[[
******************
Core Frame
******************
]]--

function VBM_StatusFrame_Init()
	SlashCmdList["WildCardReroll_Statustoggle"] = VBM_SF_Toggle;
	SLASH_WildCardReroll_Statustoggle1 = "/dmr";
	
	VBMStatusFrameHeaderText:SetText("DraftModeReroll");
	VBM_SF_SetBorder();
	
	UIDropDownMenu_Initialize(VBMStatusFrameDropDownMenu, VBM_Settings_Menuofdoom, "MENU");
end

function VBM_SF_Toggle()
	if(VBMStatusFrame:IsShown()) then
		VBMStatusFrame:Hide();
	else
		VBMStatusFrame:Show();
	end
end

function VBM_SF_SetBorder()
	if(VBM_GetS("SFHideBorder")) then
		VBMStatusFrame:SetBackdrop( { 
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
			tile = true,
			tileSize = 16,
			insets = { left = 4, right = 4, top = 3, bottom = 3 }
		});
	else
		VBMStatusFrame:SetBackdrop( { 
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 16, 
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
		});
	end
	VBMStatusFrame:SetBackdropColor(0.1,0.1,0.1,0.8);
end

function VBMStatusFrame_OnLoad()
	
end