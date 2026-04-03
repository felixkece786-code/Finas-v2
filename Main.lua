local HttpService = game:GetService("HttpService")
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- LINK DATA GUNUNG LO (Pastikan Nama File di GitHub "Gunung.json")
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

    -- Loop otomatis buat bikin Toggle tiap ada gunung di JSON
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
                                    -- Teleport ke koordinat
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p[1], p[2], p[3])
                                end
                                task.wait(0.07) -- Jeda antar titik (biar gak kena kick/stack)
                            end
                            task.wait(1) -- Jeda sebelum balik ke titik awal rute
                        end
                    end)
                end
            end
        })
    end
else
    Tab:Section({ Title = "❌ DATA GAGAL DIMUAT" })
    Tab:Button({ Title = "Cek Console F9", Callback = function() print("Gagal load dari: " .. jsonUrl) end })
end
