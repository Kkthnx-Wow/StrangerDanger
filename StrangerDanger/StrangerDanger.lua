local addon, namespace = ...

-- Cache global variables for performance
local C_BattleNet_GetGameAccountInfoByGUID = C_BattleNet.GetGameAccountInfoByGUID
local C_FriendList_IsFriend = C_FriendList.IsFriend
local IsGuildMember = IsGuildMember
local DeclineGroup = DeclineGroup
local StaticPopup_Hide = StaticPopup_Hide
local GetNextPendingInviteConfirmation = GetNextPendingInviteConfirmation
local RespondToInviteConfirmation = RespondToInviteConfirmation
local Ambiguate = Ambiguate
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local UnitName = UnitName
local C_AddOns_GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid

-- Color constants
local GREEN = "|cff00ff00"
local GREY = "|cff808080"
local RED = "|CFFFF0000"
local YELLOW = "|cffffff00"

-- Cache for line IDs to prevent duplicate processing
local seenLineIDs = {}

-- Helper function for debug messages
local function DebugPrint(...)
	if namespace:GetOption("Debugging") then
		namespace:Print(RED .. "Debug|r", GREY .. date("%H:%M:%S|r"), ...)
	end
end

-- Helper function to check if the GUID is a known friend, guild member, or BNet friend
local function IsKnownContact(guid)
	if not guid then
		DebugPrint("GUID is nil. Possible issue with Blizzard's API.")
		return false
	end
	return C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) or IsGuildMember(guid)
end

-- Local function to handle chat filter for whispers
local function HandleChatFilter(_, _, _, author, _, _, _, flag, _, _, _, _, lineID, guid)
	if seenLineIDs[lineID] then
		DebugPrint("Duplicate lineID detected. Ignoring message. LineID:", lineID)
		return false
	end
	seenLineIDs[lineID] = true

	local name = Ambiguate(author, "none")
	DebugPrint("Processing whisper from", name, "LineID:", lineID, "GUID:", guid or "nil")

	if name == UnitName("player") then
		DebugPrint("Message from self ignored.")
		return false
	end

	if flag == "GM" or flag == "DEV" then
		DebugPrint("Message from GM or DEV. Ignoring.")
		return false
	end

	if UnitInParty(name) or UnitInRaid(name) then
		DebugPrint("Message from party or raid member. Ignoring.")
		return false
	end

	if guid and IsKnownContact(guid) then
		DebugPrint("Message from known contact. Ignoring.")
		return false
	end

	local blockWhisper = namespace:GetOption("BlockWhisper")
	if blockWhisper then
		DebugPrint("Blocked whisper from stranger:", name, "LineID:", lineID)
		return true
	end

	DebugPrint("Message allowed from", name)
	return false
end

-- Register the chat filter for whispers
local function BlockStrangerWhisper()
	if not namespace.whisperBlockRegistered then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", HandleChatFilter)
		namespace.whisperBlockRegistered = true
	end
end

-- Event Handlers for party invites
local function OnPartyInviteRequest(_, _, _, _, _, _, _, guid)
	if not guid then
		DebugPrint("No GUID for PARTY_INVITE_REQUEST event.")
		return
	end
	local blockInvite = namespace:GetOption("BlockInvite")
	if blockInvite and not IsKnownContact(guid) then
		DeclineGroup()
		StaticPopup_Hide("PARTY_INVITE")
		DebugPrint("Blocked party invite from stranger with GUID:", guid)
	end
end

local function OnGroupInviteConfirmation()
	local guid = GetNextPendingInviteConfirmation()
	if not guid then
		DebugPrint("No GUID for GROUP_INVITE_CONFIRMATION event.")
		return
	end
	local blockInvite = namespace:GetOption("BlockInvite")
	if blockInvite and not IsKnownContact(guid) then
		RespondToInviteConfirmation(guid, false)
		StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
		DebugPrint("Blocked group invite confirmation from stranger with GUID:", guid)
	end
end

-- Block invites from strangers
local function BlockStrangerInvite()
	if not namespace.inviteBlockRegistered then
		namespace:RegisterEvent("PARTY_INVITE_REQUEST", OnPartyInviteRequest)
		namespace:RegisterEvent("GROUP_INVITE_CONFIRMATION", OnGroupInviteConfirmation)
		namespace.inviteBlockRegistered = true
	end
end

-- Display welcome message
function namespace:OnLoad()
	if namespace:GetOption("WelcomeMessage") then
		local AddonTitle = C_AddOns_GetAddOnMetadata(addon, "Title") or addon or "Unknown Addon"
		local AddonVersion = C_AddOns_GetAddOnMetadata(addon, "Version") or "Unknown Version"
		print(GREEN .. "Welcome to " .. RED .. AddonTitle .. "|r v" .. AddonVersion .. "!|r")
		print(YELLOW .. "Stay safe from strangers — We've got your back!|r")
	end
end

-- Initialize the addon
function namespace:OnLogin()
	local blockInvite = namespace:GetOption("BlockInvite")
	if blockInvite then
		BlockStrangerInvite()
	end

	local blockWhisper = namespace:GetOption("BlockWhisper")
	if blockWhisper then
		BlockStrangerWhisper()
	end
end
