scCoreCFG = {}

scCoreCFG.MaxPlayers = GetConvarInt('sv_maxclients', 350) -- Gets max players from config file, default 32
scCoreCFG.IdentifierType = "steam" -- Set the identifier type (can be: steam, license)
scCoreCFG.DefaultSpawn = {x=-1035.71,y=-2731.87,z=12.86,a=0.0}

scCoreCFG.Money = {}
-- NEEDS ECONOMY CHANGES (START CASH, BANK)
scCoreCFG.Money.MoneyTypes = {['cash'] = 0, ['bank'] = 0, ['crypto'] = 0 , ['pzz'] = 0 , ['bny'] = 0 , ['lcm'] = 0 , ['rdo'] = 0 , ['csn'] = 0 , ['wn'] = 0 , ['txi'] = 0 ,['bus'] = 0 , ['lar'] = 0 ,['lc'] = 0 ,['mbc'] = 0 ,['ppc'] = 0 ,} -- ['type']=startamount - Add or remove money types for your server (for ex. ['blackmoney']=0), remember once added it will not be removed from the database!
scCoreCFG.Money.DontAllowMinus = {'cash', 'crypto'} -- Money that is not allowed going in minus

scCoreCFG.Player = {}
scCoreCFG.Player.MaxWeight = 70000 -- Max weight a player can carry (Current: 70kg)
scCoreCFG.Player.MaxInvSlots = 40 -- Max inventory slots for a player
scCoreCFG.Player.Bloodtypes = {
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
}

scCoreCFG.Server = {} -- General server config
scCoreCFG.Server.closed = false -- Set server closed (no one can join except people with ace permission 'scadmin.join')
scCoreCFG.Server.closedReason = "Server is currently down for maintenance" -- Reason message to display when people can't join the server
scCoreCFG.Server.uptime = 0 -- Time the server has been up.
scCoreCFG.Server.whitelist = false -- Enable or disable whitelist on the server
scCoreCFG.Server.discord = "https://discord.gg/CyRcApsHTx" -- Discord invite link
scCoreCFG.Server.PermissionList = {} -- permission list
scCoreCFG.Server.permLevels = {
    ["user"] = {rank = 1},
    ["helper"] = {rank = 2}, 
    ["mod"] = {rank = 3},
    ["admin"] = {rank = 4},
    ["god"] = {rank = 5},
}


scCoreCFG.Player.StrengthScale = 0.6