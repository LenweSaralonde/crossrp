-------------------------------------------------------------------------------
-- Some nice localization to make those other people in the world feel right
--  at home too.
-------------------------------------------------------------------------------

local _, Me = ...

-------------------------------------------------------------------------------
-- First of all, we have this table filled with localization strings.
-- In bigger projects, this can get quite massive. We don't have that many
-- strings, but we'll still use some decent practices so we don't have a bunch 
-- of stuff lying around in memory;
local Locales = {} -- For example, we'll delete this big table after 
Locales.enUS = {      --  we get what we want from it.
	CROSS_RP = "Cross RP";
	ADDON_NOTES = "Links friends for cross-faction roleplay!";
	
	RP_CHANNELS = "RP Channels";
	RP_CHANNELS_TOOLTIP = "Select which /rp channels to show in your chatboxes.";
	RP_IS_MUTED = "RP Is Muted";
	RP_IS_MUTED_TOOLTIP = "When RP is muted, normal community members cannot post in /rp. They can still post in /rp2-9.";
	SETTINGS = "Settings";
	SETTINGS_TIP = "Open Interface options panel.";
	CONNECT_TO_SERVER_TOOLTIP = "Click to connect.";
	RP_WARNING = "RP Warning";
	RP_WARNING_TOOLTIP = "Similar to raid warning, this is accessed by leaders only with /rpw.";
	RP_CHANNEL = "RP Channel";
	RP_CHANNEL_X = "RP Channel {1}";
	RP_CHANNEL_1_TOOLTIP = "The main RP channel. Access through /rp.";
	RP_CHANNEL_X_TOOLTIP = "Channels 2-9 are meant for smaller sub-groups. Access through /rp#.";
	VERSION_LABEL = "Version: {1}";
	BY_AUTHOR = "by Tammya-MoonGuard";
	OPTION_MINIMAP_BUTTON = "Show Minimap Button";
	OPTION_MINIMAP_BUTTON_TIP = "Show or hide the minimap button (if you're using something else like Titan Panel to access it).";
	OPTION_TRANSLATE_CHAT_BUBBLES = "Translate Chat Bubbles";
	OPTION_TRANSLATE_CHAT_BUBBLES_TIP = "Try and translate chat bubbles alongside text.";
	OPTION_WHISPER_BUTTON = "Whisper Button";
	OPTION_WHISPER_BUTTON_TIP = "Adds a \"Whisper\" button when right-clicking on players from opposing faction if they're Battle.net friends. This may or may not break some things in the Blizzard UI, and you don't need it to /w someone cross-faction.";
	OPTION_CHAT_COLORS = "Chat Colors";
	
	CANT_POST_RPW2 = "Only group leaders or assistants can post in RP Warning.";
	WHISPER = "Whisper";
	WHISPER_TIP = "Whisper opposing faction. (This is sent safely over a direct Battle.net whisper, privately, and doesn't use the community relay.)";
	TRAFFIC = "Traffic";
	KBPS = "KB/s";
	BPS = "B/s";
	UNKNOWN_SERVER = "(Unknown)";
	
	MINIMAP_TOOLTIP_CLICK_OPEN_MENU = "|cffddddddClick to open menu.";
	MINIMAP_TOOLTIP_RIGHTCLICK_OPEN_MENU = "|cffddddddRight-click to open menu.";
	
	HEIGHT_UNIT = "FEETINCHES";
	WEIGHT_UNIT = "POUNDS";
	MAP_TRACKING_CROSSRP_PLAYERS = "Cross RP Players";
	
	-- The API can't fetch these for us for languages we don't know. These need
	--  to be filled in for each locale. In the future we might add more fake
	--            languages that can have their own IDs for extra RP languages.
	LANGUAGE_1 = "Orcish";
	LANGUAGE_7 = "Common";
	LANGUAGES_NOT_SET = "Language names have not been set up for your locale. Cross RP may not function properly.";
	
	IDLE_TIME = "Idle Time";
	UPTIME = "Uptime";
	
	VERSION_TOO_OLD = "A required update is available and your current version may not work properly. Please download the latest release of Cross RP at your nearest convenience.";
	LATEST_VERSION = "Latest release version is {1}.";
	
	LINKS = "Links";
	LINKS_TOOLTIP = "Easy access to Cross RP hosted communities.";
	UPDATE_ERROR = "Cross RP is not installed correctly. If you recently updated, please close the game and restart it completely. If this error persists and you are using the latest version of Cross RP, please submit an issue report.";
	
	ELIXIR_NOTICE = "Elixir of Tongues expires in {1}.";
	ELIXIR_NOTICE_EXPIRED = "Elixir of Tongues has expired.";
	
	CROSSRP_ACTIVE = "Active";
	CROSSRP_INACTIVE = "Idle";
	
	TRANSLATE_EMOTES = "Translate Emotes";
	TRANSLATE_EMOTES_TIP = "Turn /emote text into /say text when near the opposite faction. The other side doesn't need Cross RP installed.\n\nThis doesn't have any effect if Cross RP is Idle (red icon).\n\nAvoid getting drunk.";
	
	NETWORK_STATUS = "Network Status";
	NO_CONNECTIONS = "No connections.";
	
	NOT_IN_LINKED_GROUP = "You're not in a linked group.";
	
	USER_CONNECTED_TO_YOUR_GROUP = "{1} has connected to your group.";
	LINK_GROUP = "Link Group";
	UNLINK_GROUP = "Unlink Group";
	GROUP_LINKED = "You have joined a linked group.";
	GROUP_UNLINKED = "Your group is no longer linked.";
	NEEDS_GROUP_LEADER = "Only group leaders can change this.";
	NEEDS_GROUP_LEADER2 = "Only group leaders can change that.";
	
	GROUP_STATUS_LINKED = "Group Linked";
	
	LINK_GROUP_TOOLTIP = "You can link your group to other groups with this, and /rp chat is used to talk between them.";
	UNLINK_GROUP_TOOLTIP = "Unlink your group from others, disabling /rp chat.";
	
	CROSSRP_NOT_DONE_INITIALIZING = "Cross RP hasn't finished starting up yet.";
	
	LINK_GROUP_DIALOG = "Enter a password for your linked group. Groups using the same password will be linked.";
	RPCHAT_TIMED_OUT = "Message to {1} timed out.";
	RPCHAT_NOBRIDGE = "Couldn't send message to {1}. No bridge available.";
	RELAY_RP_CHAT = "Relay RP Chat";
	RELAY_RP_CHAT_TOOLTIP = "For group leaders only: any RP chat received will be copied into /raid or /party for users without Cross RP to see.";
	
	RELAY_RP_ROLL = "[{1}] rolled {2} ({3}-{4})";
	
	NO_MORE_ELIXIRS = "You're out of elixirs!";
	
	INVALID_FACTION = "Disabling due to not having a faction selected.";
};

---------------------------------------------------------------------------
-- Other languages imported from Curse during packaging.
---------------------------------------------------------------------------

--@insert-localizations Locales.{lang}@

-------------------------------------------------------------------------------
-- What we do now is take the enUS table, and then merge it with whatever
-- locale the client is using. Just paste it on top, and any untranslated
local locale_strings = Locales.enUS  -- strings will remain English.

do
	local client_locale = GetLocale() -- Gets the WoW locale.
	
	-- Skip this if they're using the English client, or if we don't support
	-- the locale they're using (no strings defined).
	if client_locale ~= "enUS" and Locales[client_locale] then
		if not Locales[client_locale].LANGUAGE_1 
		         or not Locales[client_locale].LANGUAGE_7 then
			-- The languages aren't translated for this locale, warn them...
			Me.languages_not_set = true
		end
		-- Go through the foreign locale strings and overwrite the English
		--  entries. I hate using the word "foreign"; it seems like I'm
		--  treating non-English speakers as aliens, ehe...
		for k, v in pairs( Locales[client_locale] ) do
			locale_strings[k] = v
		end
	end
end

-------------------------------------------------------------------------------
-- Now we've got our merged table, so we can throw away the original data for
Locales = nil -- everything. Just blow up this old Locales table.

-------------------------------------------------------------------------------
-- And here we have the main Locale API. It's simple, but has some cool
Me.Locale = setmetatable( {}, { -- features. Normally, this table will be 
                                  --  stored in a local variable called L.

	-- If we access it like L["KEY"] or L.KEY then it's a direct lookup into
	--  our locale table. If it doesn't exist, then it uses the key directly.
	__index = function( table, key ) -- Most of the translations' keys are
		return locale_strings[key]   --  literal English translations.
		       or key
	end;
	
	-- If we treat the locale table like a function, then we can do 
	--  substitutions, like `L( "string {1}", value )`.
	__call = function( table, key, ... )
		-- First we get the translation. Note this isn't a raw access, so
		key = table[key] -- this goes through the __index metamethod 
		                 -- too if it doesn't exist.
		-- Pack args into a table; iterate over them.
		local args = {...}
		for i = 1, #args do
			-- And replace {1}, {2} etc with them.
			key = key:gsub( "{" .. i .. "}", args[i] )
		end
		return key
	end;
})
