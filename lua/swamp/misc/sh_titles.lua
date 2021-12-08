﻿-- This file is subject to copyright - contact swampservers@gmail.com for more information.
local Player = FindMetaTable("Player")

function Player:GetTitle()
    return self:GetNWString("title", "")
end

--NOMINIFY

Titles = {}
TitleRefreshDir = defaultdict(function() return {} end)


print("HI")
if SERVER then for k,v in pairs(player.GetAll()) do v.TitleCache=nil end end


function AddTitle(reward_id, thresholds, description, nwp_vars, progress_fn)

    local title = {}

    if isstring(thresholds) then
        thresholds = {{1, thresholds}}
    end

    function title:Thresholds()
        local i,n = 0,#thresholds
        return function()
            i=i+1
            if i<=n then local v=thresholds[i] return i,v[1],v[2],(v[3] or 0) end
        end
    end

    if isstring(description) then
        function title:Description(i, min)
            return description:format(min)
        end
    else
        function title:Description(i, min)
            return description[i]
        end
    end

    if isstring(nwp_vars) then
        nwp_vars = {nwp_vars}
    end

    local function num(p)
        if not isnumber(p) then p= p and 1 or 0 end
        return p
    end

    progress_fn = progress_fn or function(ply)
        local p = 0
        for i,var in ipairs(nwp_vars) do
            p = p + num(ply.NWPrivate[var])
        end
        return p
    end


    local sv_last_max = {}
    function title:Progress(ply)
        local p = num(progress_fn(ply))

        if SERVER and reward_id~="" then
            local r = 0
            local t = nil
            local im=0
            for i,min,name,reward in self:Thresholds() do
                if min>p then break end
                t = name
                r = r + reward
                im=i
            end
            
            if sv_last_max[ply] and sv_last_max[ply]<im then 
                ply:Notify("Unlocked a new title: "..t.."")
            end
            sv_last_max[ply] = im

            ply:PointsReward(reward_id, r, "unlocking a title")
        end

        return p
    end

    table.insert(Titles, title)
    
    for i,v in ipairs(nwp_vars) do
        table.insert(TitleRefreshDir[v], #Titles)
    end
end

--AddTitle(reward_id, thresholds, description, nwpvars, progressfn)
--reward_id: string to identify points given for this sequence, use empty string if there are no rewards
--thresholds: {{progress1, title1, reward1}, {progress2, title2, reward2}} rewards are optional
--description: string which can be formatted with the threshold for the next target, or list of strings corresponding to each level
--nwp_vars: var or list of vars that are used to calculate progress, so when they change the server can strip the title if necessary
--progress_fn: optional function to compute progess, defaults to summing nwp vars

AddTitle("", "Newfriend", "Welcome to the Swamp", {}, function() return true end)

AddTitle("popcornhit", {{10, "Goofball", 2000}, {200, "Troll", 10000}, {1000, "Asshole", 50000}, {100000, "Retard", 0}}, "Throw popcorn in someone's face %s times", "s_popcornhit")

-- TODO put back the flags thing?
AddTitle("megavape", {{1, "Vapist", 50000}}, "Find the mega vape and hit it", "s_megavape")

--todo: print who currently has the title?
AddTitle("", {{1, "The 1%"}, {13,"Illuminati"}}, {"Be among the 15 richest players","Be among the 3 richest players"}, "points_leader", function(ply) return 16-(ply.NWPrivate.points_leader or 16) end)
AddTitle("", {{1, "Patriot"}, {2, "Golden Patriot"}, {3,"Platinum Patriot"}}, {"Visit Donald Trump's donation box and give at least 100,000 points", "Be on Donald Trump's donation leaderboard", "Be the top donor to Donald Trump"}, {"s_trump_donation", "s_trump_donation_leader"}, function(ply) return ( (ply.NWPrivate.s_trump_donation or 0)>=100000 and 1 or 0) + (ply.NWPrivate.s_trump_donation_leader and 1 or 0) + (ply.NWPrivate.s_trump_donation_leader==1 and 1 or 0) end)
AddTitle("", {{1, "Ally"}, {2, "Libtard"}, {3,"Greatest Ally"}}, {"Visit Joe Biden's donation box and give at least 100,000 points","Be on Joe Biden's donation leaderboard", "Be the top donor to Joe Biden"}, {"s_lefty_donation", "s_lefty_donation_leader"}, function(ply) return ( (ply.NWPrivate.s_lefty_donation or 0)>=100000 and 1 or 0) + (ply.NWPrivate.s_lefty_donation_leader and 1 or 0) + (ply.NWPrivate.s_lefty_donation_leader==1 and 1 or 0) end)
AddTitle("kleinertp", {{1, "Test Subject", 10000}}, "Be subjected to one of Dr. Isaac Kleiner's teleportation experiments", "s_kleinertp")


--NOT IMPLEMENTED

--TODO: try to make it where you have to give it to X DIFFERENT players
-- just take player:AccountID() (id3) and convert the last number to 4 uint bytes, there probably wont be universe conflicts and if there are its not a big deal
-- local id = ply:AccountID()
-- id = string.char(bit.band(bit.rshift(id, 24), 255), bit.band(bit.rshift(id, 16), 255), bit.band(bit.rshift(id, 8), 255), bit.band(id, 255))

-- FIX THE DONATION BOXES

AddTitle("", {{100, "Gift Giver"},{1000, "Santa"}}, "Give %s gifts (mystery boxes) to other players", "s_giftgiver")
AddTitle("garfield", {{200, "Chonkers", 10000}, {1000, "Fat Cat", 100000}, {10000, "I Eat, Jon.", 1000000}}, "Become Garfield and grow to weigh at least %s pounds", "s_garfield")