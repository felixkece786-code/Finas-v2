local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
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
    Tab:Section({ Title = "🏔️ DAFTAR GUNUNG (SMOOTH MODE)" })

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
                                local char = game.Players.LocalPlayer.Character
                                if char and char:FindFirstChild("HumanoidRootPart") then
                                    local hrp = char.HumanoidRootPart
                                    local targetPos = CFrame.new(p[1], p[2], p[3])
                                    
                                    -- HITUNG JARAK & KECEPATAN (Biar stabil)
                                    local jarak = (hrp.Position - targetPos.Position).Magnitude
                                    local speed = 50 -- Ganti angka ini (Makin gede makin cepet meluncurnya)
                                    local info = TweenInfo.new(jarak/speed, Enum.EasingStyle.Linear)
                                    
                                    local tween = TweenService:Create(hrp, info, {CFrame = targetPos})
                                    tween:Play()
                                    tween.Completed:Wait() -- Tunggu sampe nyampe CP baru lanjut
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
