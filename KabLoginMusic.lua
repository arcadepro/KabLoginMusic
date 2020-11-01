local f       					= CreateFrame("Frame")
local fadetime 					= 45                           		-- time in seconds / 1 step per second
local master_musicvolume 		= GetCVar("Sound_MusicVolume") 		-- stored as 0 to 1 in config.wtf
local musicvolume_to_percent  	= master_musicvolume*100       		-- multiplied by 100
local stepsize 					= musicvolume_to_percent/fadetime	--

local function setvol()
	if (musicvolume_to_percent <= stepsize) then 					-- for arbitrary step sizes
		SetCVar("Sound_EnableMusic", 0)
		SetCVar("Sound_MusicVolume", master_musicvolume) 			-- restore original volume from when we logged in
		--print("burp")
	else
		SetCVar("Sound_MusicVolume", musicvolume_to_percent/100)
		musicvolume_to_percent = musicvolume_to_percent - stepsize
	end
end

f:SetScript("OnEvent", function(self, event, ...)
	if event == "VARIABLES_LOADED" then
		f:UnregisterEvent("VARIABLES_LOADED")
		for i = 1, fadetime, 1
			do
				C_Timer.After(i, setvol)
		end
	elseif event == "PLAYER_LOGOUT" then
		SetCVar("Sound_MusicVolume", master_musicvolume) 			-- restore original volume from when we logged in
		SetCVar("Sound_EnableMusic", 1)								-- turn music on for next log in
	end
end)

f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("PLAYER_LOGOUT")
