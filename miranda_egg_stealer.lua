-- ==================== MIRANDA HUB - EGG STEALER ====================
-- Working Rayfield Library - Best CDN Link
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Rayfield failed to load, trying alternative...")
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()
end

-- ==================== GLOBAL VARIABLES ====================
getgenv().InstantStealActive = false
getgenv().AllAnimalStealActive = false
getgenv().InfiniteJumpActive = false
getgenv().CurrentSpeed = 16 
getgenv().AutoFarmActive = false

-- ==================== CREATE WINDOW ====================
local Window = Rayfield:CreateWindow({
    Name = "⚡ Miranda Hub | Egg Stealer ⚡", 
    LoadingTitle = "Loading Miranda Engine...",
    LoadingSubtitle = "Rayfield v3 Integrated",
    ConfigurationSaving = {
        Enabled = true,                
        FolderName = "MirandaHub", 
        FileName = "EggStealerConfig"            
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false,
})

-- ==================== CREATE TABS ====================
local MainTab = Window:CreateTab("🎯 Main", 4483362458)
local AnimalTab = Window:CreateTab("🦁 Animals", 4483362458) 
local PlayerTab = Window:CreateTab("👤 Player", 4483362458)
local InfoTab = Window:CreateTab("ℹ️ Info", 4483362458)

-- ==================== UTILITY FUNCTIONS ====================

local function getCharacter()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        return player.Character
    end
    return nil
end

local function getRootPart()
    local char = getCharacter()
    if char and char:FindFirstChild("HumanoidRootPart") then
        return char.HumanoidRootPart
    end
    return nil
end

local function teleportTo(cframe)
    local root = getRootPart()
    if root then
        root.CFrame = cframe
    end
end

local function getSafeSpot()
    local root = getRootPart()
    if root then
        return root.CFrame
    end
    
    local zone = workspace:FindFirstChild("SafeZone") or workspace:FindFirstChild("Spawn") or workspace:FindFirstChild("SpawnLocation")
    if zone and zone:IsA("BasePart") then
        return zone.CFrame
    end
    
    return CFrame.new(0, 100, 0)
end

local lastSafeSpot = getSafeSpot()

local function touchItem(item)
    local root = getRootPart()
    if not root or not item then return end
    
    if firetouchinterest then
        firetouchinterest(root, item, 0)
        task.wait(0.02)
        firetouchinterest(root, item, 1)
    end
end

local function findEggs()
    local eggs = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Transparency < 1 then
            local name = string.lower(obj.Name)
            if string.find(name, "egg") or string.find(name, "collect") then
                if not obj:IsDescendantOf(game.Players.LocalPlayer.Character or Instance.new("Folder")) then
                    table.insert(eggs, obj)
                end
            end
        end
    end
    return eggs
end

local function findAnimals()
    local animals = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Transparency < 1 then
            local name = string.lower(obj.Name)
            if string.find(name, "animal") or string.find(name, "creature") or string.find(name, "pet") then
                if not obj:IsDescendantOf(game.Players.LocalPlayer.Character or Instance.new("Folder")) then
                    table.insert(animals, obj)
                end
            end
        end
    end
    return animals
end

-- ==================== MAIN FARMING LOOPS ====================

local function eggFarmLoop()
    while getgenv().InstantStealActive do
        local root = getRootPart()
        if not root then task.wait(0.5) continue end
        
        local eggs = findEggs()
        
        if #eggs > 0 then
            lastSafeSpot = getSafeSpot()
            
            for _, egg in ipairs(eggs) do
                if not getgenv().InstantStealActive then break end
                
                pcall(function()
                    teleportTo(egg.CFrame + Vector3.new(0, 2, 0))
                    task.wait(0.02)
                    touchItem(egg)
                    task.wait(0.03)
                    teleportTo(lastSafeSpot)
                    task.wait(0.05)
                end)
            end
        end
        
        task.wait(0.1)
    end
end

local function animalFarmLoop()
    while getgenv().AllAnimalStealActive do
        local root = getRootPart()
        if not root then task.wait(0.5) continue end
        
        local animals = findAnimals()
        
        if #animals > 0 then
            lastSafeSpot = getSafeSpot()
            
            for _, animal in ipairs(animals) do
                if not getgenv().AllAnimalStealActive then break end
                
                pcall(function()
                    teleportTo(animal.CFrame + Vector3.new(0, 2, 0))
                    task.wait(0.02)
                    touchItem(animal)
                    task.wait(0.03)
                    teleportTo(lastSafeSpot)
                    task.wait(0.05)
                end)
            end
        end
        
        task.wait(0.1)
    end
end

-- ==================== MAIN TAB ====================

MainTab:CreateLabel("🎯 Farming Controls")

local EggToggle = MainTab:CreateToggle({
    Name = "🥚 Auto Farm Eggs",
    CurrentValue = false,
    Flag = "EggToggleFlag",
    Callback = function(Value)
        getgenv().InstantStealActive = Value
        getgenv().AllAnimalStealActive = false
        
        if Value then
            Rayfield:Notify({
                Title = "Miranda Hub",
                Content = "✅ Egg farming started!",
                Duration = 2
            })
            task.spawn(eggFarmLoop)
        else
            Rayfield:Notify({
                Title = "Miranda Hub",
                Content = "⏹️ Egg farming stopped!",
                Duration = 1
            })
        end
    end,
})

MainTab:CreateLabel("📊 Status Info")

MainTab:CreateLabel("Eggs Found: " .. #findEggs())
MainTab:CreateLabel("Animals Found: " .. #findAnimals())

local StopButton = MainTab:CreateButton({
    Name = "🛑 STOP ALL",
    Callback = function()
        getgenv().InstantStealActive = false
        getgenv().AllAnimalStealActive = false
        getgenv().AutoFarmActive = false
        
        Rayfield:Notify({
            Title = "Miranda Hub",
            Content = "⏹️ All farming stopped!",
            Duration = 2
        })
    end
})

-- ==================== ANIMAL TAB ====================

AnimalTab:CreateLabel("🦁 Animal Farming")

local AnimalToggle = AnimalTab:CreateToggle({
    Name = "🦁 Auto Farm All Animals",
    CurrentValue = false,
    Flag = "AnimalToggleFlag",
    Callback = function(Value)
        getgenv().AllAnimalStealActive = Value
        getgenv().InstantStealActive = false
        
        if Value then
            Rayfield:Notify({
                Title = "Miranda Hub",
                Content = "✅ Animal farming started!",
                Duration = 2
            })
            task.spawn(animalFarmLoop)
        else
            Rayfield:Notify({
                Title = "Miranda Hub",
                Content = "⏹️ Animal farming stopped!",
                Duration = 1
            })
        end
    end,
})

AnimalTab:CreateLabel("🌍 Teleport Commands")

local TeleportSpawnButton = AnimalTab:CreateButton({
    Name = "📍 Teleport to Spawn",
    Callback = function()
        local spawn = workspace:FindFirstChild("Spawn") or workspace:FindFirstChild("SpawnLocation")
        if spawn and spawn:IsA("BasePart") then
            teleportTo(spawn.CFrame + Vector3.new(0, 5, 0))
            Rayfield:Notify({
                Title = "Miranda Hub",
                Content = "✅ Teleported!",
                Duration = 1
            })
        end
    end
})

local TeleportForestButton = AnimalTab:CreateButton({
    Name = "🌲 Teleport to Forest",
    Callback = function()
        local forest = workspace:FindFirstChild("Forest") or workspace:FindFirstChild("ForestZone")
        if forest and forest:IsA("BasePart") then
            teleportTo(forest.CFrame + Vector3.new(0, 5, 0))
            Rayfield:Notify({
                Title = "Miranda Hub",
                Content = "✅ Teleported to Forest!",
                Duration = 1
            })
        end
    end
})

-- ==================== PLAYER TAB ====================

PlayerTab:CreateLabel("⚡ Player Enhancements")

local SpeedSlider = PlayerTab:CreateSlider({
    Name = "💨 Walk Speed",
    Min = 16,
    Max = 200,
    DefaultValue = 16,
    Color = Color3.fromRGB(255, 200, 0),
    Flag = "SpeedSliderFlag",
    Callback = function(Value)
        getgenv().CurrentSpeed = Value
        local char = getCharacter()
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end,
})

-- Speed loop to maintain speed
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().CurrentSpeed > 16 then
            local char = getCharacter()
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid.WalkSpeed = getgenv().CurrentSpeed
            end
        end
    end
end)

local JumpToggle = PlayerTab:CreateToggle({
    Name = "🚀 Infinite Jump",
    CurrentValue = false,
    Flag = "JumpToggleFlag",
    Callback = function(Value)
        getgenv().InfiniteJumpActive = Value
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfiniteJumpActive then
        local char = getCharacter()
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ==================== INFO TAB ====================

InfoTab:CreateLabel("ℹ️ Miranda Hub Info")
InfoTab:CreateLabel("Version: 2.0")
InfoTab:CreateLabel("Status: Working ✅")
InfoTab:CreateLabel("")
InfoTab:CreateLabel("Features:")
InfoTab:CreateLabel("✅ Egg Farming")
InfoTab:CreateLabel("✅ Animal Farming")
InfoTab:CreateLabel("✅ Speed Hack")
InfoTab:CreateLabel("✅ Infinite Jump")
InfoTab:CreateLabel("✅ Teleport")
InfoTab:CreateLabel("")

InfoTab:CreateButton({
    Name = "🔄 Rejoin Game",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

-- ==================== STARTUP NOTIFICATION ====================
Rayfield:Notify({
    Title = "🚀 Miranda Hub",
    Content = "✅ Script loaded successfully! All systems ready!",
    Duration = 5
})

print("[Miranda Hub] ✅ Egg Stealer loaded and ready to go!")
print("[Miranda Hub] Use the toggles to start farming!")
