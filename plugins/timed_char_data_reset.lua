--THIS IS A 1.1-BETA PLUGIN
--It will not work on 1.1 unless you make the change to not convert the regular time as 1.1 stores the unix time in int
--1.1-beta however stores the time in a formatted string that you need to convert which is what I have done
PLUGIN.name = "Data Reset"
PLUGIN.author = "Stan"
PLUGIN.desc = "Do stuff to a character/player after inactive on a character for selected timeframe"


if CLIENT then return end
function PLUGIN:PrePlayerLoadedChar(client, char)
	if !IsValid(client) then return end
	--load the lastjointime data out of the database
	local create = nut.db.select({"_lastJoinTime"}, "characters", "_id = "..char.id)
	--PrintTable(create.value.results)
	
	--convert the time string into its os.time() int
	local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
	local timeToConvert = create.value.results[1]._lastJoinTime
	local runyear, runmonth, runday, runhour, runminute, runseconds = timeToConvert:match(pattern)
	
	local convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
	
	--If the player has been inactive on this character for a month
	--change the + number to whatever timeframe you want to do in seconds. use a time converter or something
	local inactiveTime = convertedTimestamp + 262980
	if inactiveTime < os.time() then
		--WHATEVER YOU WANT TO DO TO THE PLAYER/CHARACTER IN HERE
	end
end
