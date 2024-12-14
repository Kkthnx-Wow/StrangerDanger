local _, namespace = ...

-- Create the About section canvas
local function CreateAboutCanvas(canvas)
	canvas:SetAllPoints(true)

	-- Title
	local title = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOP", canvas, "TOP", 0, -70)
	title:SetText("|cffFFD700StrangerDanger|r") -- Gold-colored title

	-- Description
	local description = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	description:SetPoint("TOP", title, "BOTTOM", 0, -10)
	description:SetWidth(500)
	description:SetText("StrangerDanger keeps you safe from unwanted whispers and invites. Developed by Kkthnx, it provides automatic blocking of unknown whispers and invites, giving you peace of mind while you play.")

	-- Features Section
	local featuresHeading = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	featuresHeading:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -20)
	featuresHeading:SetText("|cffFFD700Features:|r")

	local features = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	features:SetPoint("TOPLEFT", featuresHeading, "BOTTOMLEFT", 0, -10)
	features:SetWidth(500)
	features:SetText("- Block party invites from strangers.\n- Block whispers from strangers.\n- Fully customizable options via Dashi.\n- Minimal impact on game performance.\n- Debug mode for troubleshooting.")

	-- Support Section
	local supportHeading = canvas:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	supportHeading:SetPoint("TOPLEFT", features, "BOTTOMLEFT", 0, -20)
	supportHeading:SetText("|cffFFD700Support:|r")

	local support = canvas:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	support:SetPoint("TOPLEFT", supportHeading, "BOTTOMLEFT", 0, -10)
	support:SetWidth(500)
	support:SetText("Have feedback, ideas, or bugs to report? Contact us directly or visit the official GitHub repository for StrangerDanger. Thank you for using our addon!")
end

-- Register the About canvas with the interface
namespace:RegisterSubSettingsCanvas("About", CreateAboutCanvas)
