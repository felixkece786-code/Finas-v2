local HttpService = game:GetService("HttpService")
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- LINK FIX (Sesuai link yang lo kasih tadi)
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
    Title = "Finas Gaming V2",
    Icon = "rbxassetid://10888673623",
    Author = "Felix"
})

local Tab = Window:Tab({ Title = "Main", Icon = "mountain" })

if dataGunung then
    local list = {}
    for n, _ in pairs(dataGunung) do table.insert(list, n) end
    
    Tab:Dropdown({
        Title = "Pilih Gunung", 
        Options = list, 
        Callback = function(v) _G.Pilih = v end
    })

    Tab:Toggle({
        Title = "Mulai Auto Summit", 
        Callback = function(v)
            _G.Mulai = v
            if v and _G.Pilih then
                task.spawn(function()
                    while _G.Mulai do
                        local rute = dataGunung[_G.Pilih]
                        for _, p in ipairs(rute) do
                            if not _G.Mulai then break end
                            if game.Players.LocalPlayer.Character then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p[1], p[2], p[3])
                            end
                            task.wait(0.05)
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
else
  
    Tab:Section({ Title = "❌ DATA GAGAL LOAD" })
    Tab:Button({ Title = "Cek Console F9", Callback = function() print("Gagal ambil data dari: " .. jsonUrl) end })
end
