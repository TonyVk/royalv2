Config = {}

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
Config.Priority = {
    ["steam:110000106921eea"] = 1,
    ["steam:11000013f12b917"] = 1,
    ["steam:110000133eac837"] = 1,
	["steam:1100001352b6361"] = 1,
	["steam:1100001176adda0"] = 1,
	["steam:110000133eac837"] = 1,
	["steam:11000013f869a80"] = 1,
	["steam:11000010dfc0d8a"] = 1,
	["steam:11000013293c9d0"] = 1,
	["steam:11000013fb40157"] = 1,
	["steam:1100001049ffa72"] = 1,
	["steam:11000011255f3bc"] = 100, -- Hesh
	["steam:11000013bfba03a"] = 1,
	["steam:110000136b59326"] = 1,
	["steam:11000011b6b1cf5"] = 1,
	["steam:11000013ce55843"] = 1,
	["steam:1100001094f08e4"] = 1,
	["steam:11000010e790d6e"] = 1,
	["steam:11000010e9b0414"] = 1,
	["steam:11000013b23cc30"] = 1,
	["steam:11000013f0057cc"] = 1,
	["steam:11000011b3f85b5"] = 1,
	["steam:1100001405836b7"] = 1,
	["steam:110000104465acf"] = 1,
	["steam:11000010da6dbc7"] = 1,
	["steam:11000013fc59e3b"] = 1,
	["steam:11000010897e828"] = 1,
	["steam:110000115eeff48"] = 1,
	["steam:11000011b463714"] = 1,
	["steam:11000013c1a9aaf"] = 1,
	["steam:11000010441bee9"] = 100,  -- Sikora
	["steam:110000133b385a7"] = 1,
	["steam:110000112e16d39"] = 1,
	["steam:110000114907c81"] = 1,
	["steam:11000010b025e18"] = 100,  -- RazZ
	["steam:11000013cc965f3"] = 1,
	["steam:11000013eccd88b"] = 1,
	["steam:1100001191b5fdd"] = 1,
	["steam:11000011472ad50"] = 1,
	["steam:11000013c23448d"] = 100,  -- Hilmac
	["steam:1100001182db889"] = 100,  -- Leho
	["steam:11000011ab0340f"] = 100,  -- Infected
	["steam:11000013f2a6711"] = 1,
	["steam:110000102ddbaed"] = 1,
	["steam:11000010c23a8fd"] = 100,  -- Zane
	["steam:110000111ece89c"] = 1,
	["steam:11000013efa4718"] = 1,
	["steam:1100001368ae7c4"] = 1,
	["steam:11000011c7365a6"] = 1,
	["steam:11000010546956c"] = 1,
	["steam:110000104bbc6a1"] = 1,
	["steam:11000010ba48125"] = 1,
	["steam:1100001056fc256"] = 1,
	["steam:1100001049f70e0"] = 1,
	["steam:11000010e086b7e"] = 1,
	["steam:110000136444b53"] = 1,
	["steam:110000132785bef"] = 1,
	["steam:11000013d9715fe"] = 1,
	["steam:110000136426db4"] = 1,
	["steam:110000111cd0aa0"] = 1,
	["steam:110000134f0c302"] = 1,
	["steam:1100001038bebae"] = 1,
	["steam:11000011904562e"] = 1,
	["steam:110000109de1457"] = 1,
	["steam:11000013a558299"] = 1,
	["steam:11000013fc740ea"] = 1,
	["steam:11000013fc59e3b"] = 1,
	["steam:110000100124dc0"] = 1,
	["steam:11000013482d578"] = 1,
	["steam:11000011a74a1af"] = 1, 
    ["ip:0.0.0.0"] = 85
	
}

-- require people to run steam
Config.RequireSteam = true

-- "whitelist" only server
Config.PriorityOnly = false

-- disables hardcap, should keep this true
Config.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
Config.ConnectTimeOut = 600

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
Config.QueueTimeOut = 90

-- will give players temporary priority when they disconnect and when they start loading in
Config.EnableGrace = true

-- how much priority power grace time will give
Config.GracePower = 5

-- how long grace time lasts in seconds
Config.GraceTime = 120

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
Config.JoinDelay = 30000

-- will show how many people have temporary priority in the connection message
Config.ShowTemp = false

-- simple localization
Config.Language = {
    joining = "\xF0\x9F\x8E\x89Povezivanje...",
    connecting = "\xE2\x8F\xB3Povezivanje...",
    idrr = "\xE2\x9D\x97[Queue] Pogreska: Pogreska pri pronalazenju tvojeg id-a, restartaj steam.",
    err = "\xE2\x9D\x97[Queue] Greska pri povezivanju",
    pos = "\xF0\x9F\x90\x8CTi si %d/%d u redu cekanja \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[Queue] Pogreska: Pogreska kod dodavanja na listu",
    timedout = "\xE2\x9D\x97[Queue] Pogreska: Time out?",
    wlonly = "\xE2\x9D\x97[Queue] Niste whitelistani",
    steam = "\xE2\x9D\x97 [Queue] Pogreska: Steam mora biti pokrenut"
}