-- StrangerDanger.lua
local addonName, namespace = ...

-- Register configuration settings with Dashi
namespace:RegisterSettings("StrangerDangerDB", {
	{
		key = "BlockInvite",
		type = "toggle",
		title = "Block Invites",
		tooltip = "Automatically decline invites from strangers.",
		default = true,
	},
	{
		key = "BlockWhisper",
		type = "toggle",
		title = "Block Whispers",
		tooltip = "Automatically block whispers from strangers.",
		default = true,
	},
	{
		key = "Debugging",
		type = "toggle",
		title = "Enable Debugging",
		tooltip = "Enable debug messages for troubleshooting.",
		default = false,
	},
	{
		key = "WelcomeMessage",
		type = "toggle",
		title = "Enable Welcome Message",
		tooltip = "Display the addon welcome message in chat.",
		default = false,
	},
})
