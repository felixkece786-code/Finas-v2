local HttpService = game:GetService("HttpService")
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local jsonUrl = "https://raw.githubusercontent.com/felixkece786-code/Finas-v2/refs/heads/main/Gunung.json"

local function AmbilData()
    local s, r = pcall(function() return game:HttpGet(jsonUrl .. "?t=" .. os.time()) end)
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
                        local lastPos = nil
                        while _G[namaGunung] do
                            for _, p in ipairs(rute) do
                                if not _G[namaGunung] then break end
                                local char = game.Players.LocalPlayer.Character
                                if char and char:FindFirstChild("HumanoidRootPart") then
                                    local hrp = char.HumanoidRootPart
                                    local targetPos = Vector3.new(p[1], p[2], p[3])
                                    
                                    -- CEK BIAR GAK GETER: Cuma TP kalau koordinatnya beda
                                    if lastPos ~= targetPos then
                                        hrp.Velocity = Vector3.new(0,0,0)
                                        hrp.CFrame = CFrame.new(p[1], p[2], p[3])
                                        lastPos = targetPos
                                        task.wait(0.3) -- Jeda biar summit nambah & gak kilat
                                    end
                                end
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
