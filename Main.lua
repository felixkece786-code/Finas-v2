local HttpService = game:GetService("HttpService")
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local jsonUrl = "https://raw.githubusercontent.com/felixkece786-code/Finas-v2/refs/heads/main/Gunung.json"

local function AmbilData()
    local s, r = pcall(function() 
        return game:HttpGet(jsonUrl .. "?t=" .. os.time()) 
    end)
    if s then
        local ds, dr = pcall(function() return HttpService:JSONDecode(r) end)
        if ds then return dr end
    end
    return nil
end

local dataGunung = AmbilData()

local Window = WindUI:CreateWindow({
    Title = "Finas Gaming | Auto Summit Hub",
    Icon = "rbxassetid://10888673623",
    Author = "Felix"
})

local Tab = Window:Tab({ Title = "Auto Summit", Icon = "mountain" })

if dataGunung then
    Tab:Section({ Title = "🏔️ DAFTAR GUNUNG" })

    for namaGunung, rute in pairs(dataGunung) do
        Tab:Toggle({
            Title = "Auto Summit - " .. namaGunung,
            Callback = function(v)
                _G[namaGunung] = v
                if v then
                    task.spawn(function()
                        while _G[namaGunung] do
                            for _, p in ipairs(rute) do
                                if not _G[namaGunung] then break end
                                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p[1], p[2], p[3])
                                end
                                -- GANTI ANGKA DI BAWAH INI BUAT ATUR KECEPATAN:
                                task.wait(0.2) -- 0.2 itu lebih pelan dan aman dari kick
                            end
                            task.wait(1)
                        end
                    end)
                end
            end
        })
    end
else
    Tab:Section({ Title = "❌ DATA GAGAL DIMUAT" })
end
