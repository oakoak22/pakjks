local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local cfg = {
    api = "c0625980-d444-4ae3-a891-5d1579668858",
    service = "DDS Script",
    provider = "DDS PROVIDER SCRIPT",
    discord = "https://discord.gg/wVbdWpmp",
    logo = "rbxassetid://121595097202790",
    barColor = Color3.fromRGB(90,170,255),
    keyFile = "&R4_key2.txt",
    settingsFile = "V_boost_settings.txt"
}

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FX HUB LOADED !",
    Text = "Made by iEelXyz | Auto-Save & Bypass Enabled !",  -- <-- INI WAJIB ADA
    Button1 = "Continue",
    Duration = 4
})

local notifActive = {}

-- NOTIFICATION SYSTEM
local function createNotification(title,content,length,iconId)
    local screen = Instance.new("ScreenGui")
    screen.Name = "NotifGui"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 2147483647
    screen.Parent = CoreGui

    local scale = math.clamp(math.min(workspace.CurrentCamera.ViewportSize.X,workspace.CurrentCamera.ViewportSize.Y)/1366,0.6,1.6)
    local w = math.clamp(320*scale,200,520)
    local h = math.clamp(72*scale,54,140)

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,w,0,h)
    main.Position = UDim2.new(1,-12,1,-12-h-16)
    main.AnchorPoint = Vector2.new(1,1)
    main.BackgroundTransparency = 0
    main.BackgroundColor3 = Color3.fromRGB(20,40,70)
    main.BorderSizePixel = 0
    main.Parent = screen

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = main

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,0,0,4)
    bar.Position = UDim2.new(0,0,1,-4)
    bar.BackgroundColor3 = cfg.barColor
    bar.BorderSizePixel = 0
    bar.ClipsDescendants = true
    bar.Parent = main

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0,2)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(1,0,1,0)
    fill.Position = UDim2.new(0,0,0,0)
    fill.BackgroundColor3 = cfg.barColor
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0,h,1,0)
    icon.Position = UDim2.new(0,0,0,0)
    icon.BackgroundTransparency = 1
    icon.Image = iconId or cfg.logo
    icon.ImageColor3 = cfg.barColor
    icon.ScaleType = Enum.ScaleType.Stretch
    icon.Parent = main

    local txt = Instance.new("TextLabel")
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.new(1,-h-8,0.4,0)
    txt.Position = UDim2.new(0,h+8,0,0)
    txt.Font = Enum.Font.Code
    txt.TextSize = math.clamp(14*scale,12,20)
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.TextYAlignment = Enum.TextYAlignment.Top
    txt.TextColor3 = Color3.new(1,1,1)
    txt.Text = title
    txt.Parent = main

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Size = UDim2.new(1,-h-8,0.5,0)
    sub.Position = UDim2.new(0,h+8,0.4,0)
    sub.Font = Enum.Font.Code
    sub.TextSize = math.clamp(12*scale,10,16)
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.TextYAlignment = Enum.TextYAlignment.Top
    sub.TextColor3 = Color3.fromRGB(200,200,200)
    sub.Text = content
    sub.TextWrapped = true
    sub.Parent = main

    local id = tostring(math.floor(tick()*1000)).."-"..HttpService:GenerateGUID(false)
    table.insert(notifActive,{id=id,frame=main,sizeY=h})

    local function restack()
        local spacing = 8*scale
        local yoff = 0
        for i = #notifActive,1,-1 do
            local node = notifActive[i]
            if node and node.frame and node.frame.Parent then
                local target = -12-yoff-node.sizeY
                TweenService:Create(node.frame,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.new(1,-12,1,target)}):Play()
                yoff = yoff+node.sizeY+spacing
            end
        end
    end

    restack()

    local function destroy()
        for i = 1,#notifActive do
            if notifActive[i].id == id then
                table.remove(notifActive,i)
                break
            end
        end
        TweenService:Create(main,TweenInfo.new(0.35,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(1,16,main.Position.Y.Scale,main.Position.Y.Offset),BackgroundTransparency=1}):Play()
        TweenService:Create(txt,TweenInfo.new(0.35),{TextTransparency=1}):Play()
        TweenService:Create(sub,TweenInfo.new(0.35),{TextTransparency=1}):Play()
        TweenService:Create(icon,TweenInfo.new(0.35),{ImageTransparency=1}):Play()
        task.wait(0.35)
        pcall(function() main:Destroy() end)
        restack()
    end

    if length and length > 0 then
        TweenService:Create(fill,TweenInfo.new(length,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{Size=UDim2.new(0,0,1,0)}):Play()
        task.delay(length,destroy)
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 10
    btn.Parent = main
    btn.MouseButton1Click:Connect(destroy)

    return {Close=destroy}
end

-- KEY SAVE/LOAD
local function saveKey(key)
    if writefile then
        pcall(function() writefile(cfg.keyFile,key) end)
    end
end

local function loadKey()
    if readfile then
        local ok,data = pcall(function() return readfile(cfg.keyFile) end)
        if ok then return data end
    end
    return ""
end

-- AUTO-SAVE SETTINGS SYSTEM
local function saveSettings(settings)
    if writefile then
        pcall(function() 
            writefile(cfg.settingsFile, HttpService:JSONEncode(settings))
        end)
    end
end

local function loadSettings()
    if readfile then
        local ok,data = pcall(function() 
            return HttpService:JSONDecode(readfile(cfg.settingsFile))
        end)
        if ok and data then return data end
    end
    return nil
end

-- UI BUILD (UNCHANGED - KEEPING KEY SYSTEM)
local function buildUI()
    local Part1 = {}
    local Part2 = {}
    local Part3 = {}

    Part1.Screen = Instance.new("ScreenGui")
    Part1.Screen.Name = "&R4 Tuff"
    Part1.Screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Part1.Screen.ResetOnSpawn = false
    Part1.Screen.IgnoreGuiInset = true
    Part1.Screen.Parent = CoreGui

    Part1.Main = Instance.new("Frame")
    Part1.Main.Name = "Main"
    Part1.Main.Size = UDim2.new(0,370,0,200)
    Part1.Main.Position = UDim2.new(0.5,0,0.5,0)
    Part1.Main.AnchorPoint = Vector2.new(0.5,0.5)
    Part1.Main.BackgroundColor3 = Color3.fromRGB(20,30,50)
    Part1.Main.BackgroundTransparency = 0
    Part1.Main.BorderSizePixel = 0
    Part1.Main.ClipsDescendants = false
    Part1.Main.Parent = Part1.Screen

    Part1.Corner = Instance.new("UICorner")
    Part1.Corner.CornerRadius = UDim.new(0,10)
    Part1.Corner.Parent = Part1.Main

    Part2.Top = Instance.new("Frame")
    Part2.Top.Name = "Top"
    Part2.Top.Size = UDim2.new(1,0,0,35)
    Part2.Top.Position = UDim2.new(0,0,0,0)
    Part2.Top.BackgroundColor3 = Color3.fromRGB(30,60,100)
    Part2.Top.BorderSizePixel = 0
    Part2.Top.Parent = Part1.Main

    Part2.TopCorner = Instance.new("UICorner")
    Part2.TopCorner.CornerRadius = UDim.new(0,10)
    Part2.TopCorner.Parent = Part2.Top

    Part2.TopCover = Instance.new("Frame")
    Part2.TopCover.Name = "TopCover"
    Part2.TopCover.Size = UDim2.new(1,0,0,20)
    Part2.TopCover.Position = UDim2.new(0,0,1,-20)
    Part2.TopCover.BackgroundColor3 = Color3.fromRGB(30,60,100)
    Part2.TopCover.BorderSizePixel = 0
    Part2.TopCover.Parent = Part2.Top

    Part2.Line = Instance.new("Frame")
    Part2.Line.Name = "Line"
    Part2.Line.Size = UDim2.new(1,0,0,1)
    Part2.Line.Position = UDim2.new(0,0,1,0)
    Part2.Line.BackgroundColor3 = Color3.fromRGB(25,50,90)
    Part2.Line.BorderSizePixel = 0
    Part2.Line.Parent = Part2.Top

    Part2.Logo = Instance.new("ImageLabel")
    Part2.Logo.Name = "Logo"
    Part2.Logo.Size = UDim2.new(0,20,0,20)
    Part2.Logo.Position = UDim2.new(0,10,0,7)
    Part2.Logo.BackgroundTransparency = 1
    Part2.Logo.Image = cfg.logo
    Part2.Logo.ImageColor3 = cfg.barColor
    Part2.Logo.Parent = Part2.Top

    Part2.Title = Instance.new("TextLabel")
    Part2.Title.Name = "Title"
    Part2.Title.Size = UDim2.new(0,100,0,35)
    Part2.Title.Position = UDim2.new(0,35,0,0)
    Part2.Title.BackgroundTransparency = 1
    Part2.Title.Text = "FX HUB DDS/RDID VEHICLE SPEED SCRIPT V3"
    Part2.Title.TextColor3 = Color3.fromRGB(200,230,255)
    Part2.Title.TextSize = 18
    Part2.Title.Font = Enum.Font.GothamBold
    Part2.Title.TextXAlignment = Enum.TextXAlignment.Left
    Part2.Title.Parent = Part2.Top

    Part2.Close = Instance.new("ImageButton")
    Part2.Close.Name = "Close"
    Part2.Close.Size = UDim2.new(0,20,0,20)
    Part2.Close.Position = UDim2.new(1,-10,0.5,0)
    Part2.Close.AnchorPoint = Vector2.new(1,0.5)
    Part2.Close.BackgroundTransparency = 1
    Part2.Close.Image = "rbxassetid://122931434733842"
    Part2.Close.ImageColor3 = Color3.fromRGB(200,230,255)
    Part2.Close.ScaleType = Enum.ScaleType.Fit
    Part2.Close.Parent = Part2.Top

    Part3.Input = Instance.new("Frame")
    Part3.Input.Name = "Input"
    Part3.Input.Size = UDim2.new(0.9,0,0,35)
    Part3.Input.Position = UDim2.new(0.5,0,0,60)
    Part3.Input.AnchorPoint = Vector2.new(0.5,0)
    Part3.Input.BackgroundColor3 = Color3.fromRGB(15,35,65)
    Part3.Input.BackgroundTransparency = 0.3
    Part3.Input.BorderSizePixel = 0
    Part3.Input.Parent = Part1.Main

    Part3.InputStroke = Instance.new("UIStroke")
    Part3.InputStroke.Color = cfg.barColor
    Part3.InputStroke.Thickness = 1
    Part3.InputStroke.Transparency = 0.5
    Part3.InputStroke.Parent = Part3.Input

    Part3.InputCorner = Instance.new("UICorner")
    Part3.InputCorner.CornerRadius = UDim.new(0,6)
    Part3.InputCorner.Parent = Part3.Input

    Part3.Box = Instance.new("TextBox")
    Part3.Box.Name = "Box"
    Part3.Box.Size = UDim2.new(0.9,0,1,0)
    Part3.Box.Position = UDim2.new(0.5,0,0.5,0)
    Part3.Box.AnchorPoint = Vector2.new(0.5,0.5)
    Part3.Box.BackgroundTransparency = 1
    Part3.Box.Text = loadKey()
    Part3.Box.TextColor3 = Color3.fromRGB(200,230,255)
    Part3.Box.PlaceholderText = "00000000-0000-0000-0000-000000000000"
    Part3.Box.PlaceholderColor3 = Color3.fromRGB(100,120,150)
    Part3.Box.TextSize = 14
    Part3.Box.Font = Enum.Font.Gotham
    Part3.Box.ClearTextOnFocus = false
    Part3.Box.Parent = Part3.Input

    Part3.Buttons = Instance.new("Frame")
    Part3.Buttons.Name = "Buttons"
    Part3.Buttons.Size = UDim2.new(0.9,0,0,30)
    Part3.Buttons.Position = UDim2.new(0.5,0,1,-40)
    Part3.Buttons.AnchorPoint = Vector2.new(0.5,1)
    Part3.Buttons.BackgroundTransparency = 1
    Part3.Buttons.Parent = Part1.Main

    local btnColor = Color3.fromRGB(30,80,150)

    Part3.GetKey = Instance.new("TextButton")
    Part3.GetKey.Name = "GetKey"
    Part3.GetKey.Size = UDim2.new(0.45,-4,1,0)
    Part3.GetKey.Position = UDim2.new(0.25,0,0,0)
    Part3.GetKey.AnchorPoint = Vector2.new(0.5,0)
    Part3.GetKey.BackgroundColor3 = btnColor
    Part3.GetKey.BorderSizePixel = 0
    Part3.GetKey.Text = ""
    Part3.GetKey.AutoButtonColor = false
    Part3.GetKey.Parent = Part3.Buttons

    local getKeyIco = Instance.new("ImageLabel")
    getKeyIco.Size = UDim2.new(0,16,0,16)
    getKeyIco.Position = UDim2.new(0.5,-20,0.5,0)
    getKeyIco.AnchorPoint = Vector2.new(0.5,0.5)
    getKeyIco.BackgroundTransparency = 1
    getKeyIco.Image = "rbxassetid://96510194465420"
    getKeyIco.ImageColor3 = Color3.new(1,1,1)
    getKeyIco.Parent = Part3.GetKey

    local getKeyTxt = Instance.new("TextLabel")
    getKeyTxt.Size = UDim2.new(1,0,1,0)
    getKeyTxt.Position = UDim2.new(0.5,8,0,0)
    getKeyTxt.AnchorPoint = Vector2.new(0.5,0)
    getKeyTxt.BackgroundTransparency = 1
    getKeyTxt.Text = "Get Key ( LinkVertise )"
    getKeyTxt.TextColor3 = Color3.new(1,1,1)
    getKeyTxt.TextSize = 12
    getKeyTxt.Font = Enum.Font.GothamBold
    getKeyTxt.Parent = Part3.GetKey

    Part3.GetKeyCorner = Instance.new("UICorner")
    Part3.GetKeyCorner.CornerRadius = UDim.new(0,8)
    Part3.GetKeyCorner.Parent = Part3.GetKey

    Part3.Verify = Instance.new("TextButton")
    Part3.Verify.Name = "Verify Key"
    Part3.Verify.Size = UDim2.new(0.45,-4,1,0)
    Part3.Verify.Position = UDim2.new(0.75,0,0,0)
    Part3.Verify.AnchorPoint = Vector2.new(0.5,0)
    Part3.Verify.BackgroundColor3 = btnColor
    Part3.Verify.BorderSizePixel = 0
    Part3.Verify.Text = ""
    Part3.Verify.AutoButtonColor = false
    Part3.Verify.Parent = Part3.Buttons

    local verifyIco = Instance.new("ImageLabel")
    verifyIco.Size = UDim2.new(0,16,0,16)
    verifyIco.Position = UDim2.new(0.5,-20,0.5,0)
    verifyIco.AnchorPoint = Vector2.new(0.5,0.5)
    verifyIco.BackgroundTransparency = 1
    verifyIco.Image = "rbxassetid://87354736164608"
    verifyIco.ImageColor3 = Color3.new(1,1,1)
    verifyIco.Parent = Part3.Verify

    local verifyTxt = Instance.new("TextLabel")
    verifyTxt.Size = UDim2.new(1,0,1,0)
    verifyTxt.Position = UDim2.new(0.5,8,0,0)
    verifyTxt.AnchorPoint = Vector2.new(0.5,0)
    verifyTxt.BackgroundTransparency = 1
    verifyTxt.Text = "Verify"
    verifyTxt.TextColor3 = Color3.new(1,1,1)
    verifyTxt.TextSize = 12
    verifyTxt.Font = Enum.Font.GothamBold
    verifyTxt.Parent = Part3.Verify

    Part3.VerifyCorner = Instance.new("UICorner")
    Part3.VerifyCorner.CornerRadius = UDim.new(0,8)
    Part3.VerifyCorner.Parent = Part3.Verify

    return {
        gui = Part1.Screen,
        main = Part1.Main,
        box = Part3.Box,
        verify = Part3.Verify,
        getKey = Part3.GetKey,
        close = Part2.Close,
        top = Part2.Top
    }
end

local function drag(ui)
    local dragInput,dragStart,startPos
    ui.top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragInput = inp
            dragStart = inp.Position
            startPos = ui.main.Position
            inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragInput = nil end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp == dragInput and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            ui.main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end

local function pulse(btn)
    local orig = btn.BackgroundColor3
    local pop = Color3.new(math.min(orig.R*1.3,1),math.min(orig.G*1.3,1),math.min(orig.B*1.3,1))
    TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=pop}):Play()
    task.wait(0.15)
    TweenService:Create(btn,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{BackgroundColor3=orig}):Play()
end

-- MODIFIED VEHICLE BOOST SCRIPT WITH AUTO-SAVE & STRAIGHT BOOST
local function loadScript()
    print("Loading Vehicle Boost System with Auto-Save & Bypass System Side & Straight Boost...")
    
    -- HIGHER DEFAULTS WITH STRAIGHT BOOST
    local DEFAULTS = {
        MAX_BOOST_FORCE = 300,
        BOOST_INCREMENT = 4.99,
        BOOST_INTERVAL = 0.04,
        STRAIGHT_BOOST = false,
        BYPASS_REPORT = true,  -- NEW: Bypass Report default ON
    }

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Debris = game:GetService("Debris")
    local player = Players.LocalPlayer

    local boosting = false
    local currentForce = 0
    local boostConnection = nil
    local currentSeat = nil
    local originalSteerFloat = nil
    local originalThrottleFloat = nil

    -- LOAD SAVED SETTINGS OR USE DEFAULTS
    local savedSettings = loadSettings()
    local boostConfig = savedSettings and table.clone(savedSettings) or table.clone(DEFAULTS)
    
    -- AUTO-SAVE FUNCTION
    local function autoSaveSettings()
        saveSettings(boostConfig)
    end

    local function getVehicleMainPart(seat)
        local model = seat:FindFirstAncestorOfClass("Model")
        if model and model.PrimaryPart then return model.PrimaryPart end
        for _, p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") and p.Name:lower():find("chassis") then return p end
        end
        return seat
    end

    -- STRAIGHT BOOST CONTROL FUNCTIONS
    local function enableStraightBoost(seat)
        if not seat then return end
        
        -- Save original values
        if seat:FindFirstChild("SteerFloat") then
            originalSteerFloat = seat.SteerFloat.Value
            seat.SteerFloat.Value = 0
        end
        
        if seat:FindFirstChild("ThrottleFloat") then
            originalThrottleFloat = seat.ThrottleFloat.Value
        end
        
        -- For regular VehicleSeats
        if seat:IsA("VehicleSeat") then
            seat.Steer = 0
        end
    end

    local function disableStraightBoost(seat)
        if not seat then return end
        
        -- Restore original values
        if seat:FindFirstChild("SteerFloat") and originalSteerFloat then
            seat.SteerFloat.Value = originalSteerFloat
        end
        
        if seat:FindFirstChild("ThrottleFloat") and originalThrottleFloat then
            seat.ThrottleFloat.Value = originalThrottleFloat
        end
        
        -- For regular VehicleSeats
        if seat:IsA("VehicleSeat") then
            seat.Steer = 0.5 -- Reset to neutral
        end
        
        originalSteerFloat = nil
        originalThrottleFloat = nil
    end

    local function startBoost(seat)
        if boosting then return end
        boosting = true
        local part = getVehicleMainPart(seat)
        if not part then return end

        -- Enable straight boost if configured
        if boostConfig.STRAIGHT_BOOST then
            enableStraightBoost(seat)
        end

        local trail = Instance.new("ParticleEmitter")
        trail.Texture = "rbxassetid://242830270"
        trail.Color = ColorSequence.new(Color3.new(1, 1, 1))
        trail.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
        trail.Rate = 50
        trail.Speed = NumberRange.new(5, 10)
        trail.Lifetime = NumberRange.new(0.3)
        trail.Transparency = NumberSequence.new(0.2, 1)
        trail.VelocitySpread = 30
        trail.Name = "BoostTrail"
        trail.Parent = part

        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://72642478827550"
        sound.Looped = true
        sound.Volume = 0.4
        sound.Name = "BoostSound"
        sound.Parent = part
        sound:Play()

        boostConnection = RunService.Heartbeat:Connect(function()
            if not boosting then return end
            
            -- Maintain straight boost if enabled
            if boostConfig.STRAIGHT_BOOST and currentSeat then
                if currentSeat:FindFirstChild("SteerFloat") then
                    currentSeat.SteerFloat.Value = 0
                end
                if currentSeat:IsA("VehicleSeat") then
                    currentSeat.Steer = 0
                end
            end
            
            local speed = part.AssemblyLinearVelocity.Magnitude
            local label = player.PlayerGui:WaitForChild("BoostGui"):FindFirstChild("SpeedLabel")
            if label then
                label.Text = "Speed: " .. math.floor(speed + 0.5)
                label.Visible = true
            end

            local currentVelocity = part.AssemblyLinearVelocity
            local forwardDir = seat.CFrame.LookVector
            local forwardSpeed = currentVelocity:Dot(forwardDir)
            local additionalSpeed = math.min(boostConfig.BOOST_INCREMENT, boostConfig.MAX_BOOST_FORCE - forwardSpeed)
            local newVelocity = currentVelocity + (forwardDir * additionalSpeed)

            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(newVelocity.X, currentVelocity.Y, newVelocity.Z)
            bv.MaxForce = Vector3.new(1e6, 0, 1e6)
            bv.P = 10000
            bv.Parent = part
            Debris:AddItem(bv, boostConfig.BOOST_INTERVAL)
        end)
    end

    local function stopBoost()
        boosting = false
        if boostConnection then boostConnection:Disconnect() end
        boostConnection = nil

        -- Disable straight boost if it was active
        if boostConfig.STRAIGHT_BOOST and currentSeat then
            disableStraightBoost(currentSeat)
        end

        if currentSeat then
            local part = getVehicleMainPart(currentSeat)
            if part then
                local trail = part:FindFirstChild("BoostTrail")
                if trail then trail:Destroy() end
                local sound = part:FindFirstChild("BoostSound")
                if sound then sound:Stop() sound:Destroy() end
            end
        end

        local label = player.PlayerGui:FindFirstChild("BoostGui") and player.PlayerGui.BoostGui:FindFirstChild("SpeedLabel")
        if label then label.Visible = false end
    end

    -- MODIFIED SLIDER WITH AUTO-SAVE ON RELEASE
    local function createSlider(name, min, max, default, onChanged)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -20, 0, 50)
        container.BackgroundTransparency = 1
        container.LayoutOrder = 1

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0.5, 0)
        label.BackgroundTransparency = 1
        label.Text = name .. ": " .. tostring(default)
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.Gotham
        label.TextScaled = true
        label.Parent = container

        local slider = Instance.new("TextButton")
        slider.Size = UDim2.new(1, 0, 0.4, 0)
        slider.Position = UDim2.new(0, 0, 0.6, 0)
        slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        slider.Text = ""
        slider.AutoButtonColor = false
        slider.Parent = container

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = slider

        local fill = Instance.new("Frame")
        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BorderSizePixel = 0
        fill.Parent = slider

        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill

        local dragging = false

        local function updateFromInput(input)
            local scale = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(scale, 0, 1, 0)
            local value = min + (max - min) * scale
            value = tonumber(string.format("%.2f", value))
            label.Text = name .. ": " .. value
            onChanged(value)
        end

        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateFromInput(input)
            end
        end)
        
        slider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                autoSaveSettings()
            end
        end)
        
        slider.InputChanged:Connect(function(input)
            if dragging then
                updateFromInput(input)
            end
        end)

        return container
    end

    -- TOGGLE BUTTON CREATOR
    local function createToggle(name, default, onChanged)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -20, 0, 40)
        container.BackgroundTransparency = 1
        container.LayoutOrder = 0

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0.25, 0, 0.7, 0)
        toggle.Position = UDim2.new(0.75, 0, 0.15, 0)
        toggle.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggle.Text = default and "ON" or "OFF"
        toggle.TextColor3 = Color3.new(1, 1, 1)
        toggle.TextScaled = true
        toggle.Font = Enum.Font.GothamBold
        toggle.Parent = container

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.5, 0)
        corner.Parent = toggle

        toggle.MouseButton1Click:Connect(function()
            local newState = not default
            default = newState
            toggle.BackgroundColor3 = newState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            toggle.Text = newState and "ON" or "OFF"
            onChanged(newState)
            autoSaveSettings()
        end)

        return container
    end

    local function createBoostGui()
        local gui = Instance.new("ScreenGui")
        gui.Name = "BoostGui"
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.Parent = player:WaitForChild("PlayerGui")

        -- TOMBOL BOOST (B) DI KANAN
        local boostBtn = Instance.new("TextButton")
        boostBtn.Name = "BoostButton"
        boostBtn.Size = UDim2.new(0, 90, 0, 90)
        boostBtn.Position = UDim2.new(0.5, 10, 1, -120)
        boostBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        boostBtn.Text = "B"
        boostBtn.TextColor3 = Color3.new(1, 1, 1)
        boostBtn.TextScaled = true
        boostBtn.Font = Enum.Font.GothamBold
        boostBtn.Visible = false
        boostBtn.Parent = gui
        local boostCorner = Instance.new("UICorner", boostBtn)
        boostCorner.CornerRadius = UDim.new(1, 0)

        -- TOMBOL SETTINGS (S) DI KIRI
        local settingsBtn = Instance.new("TextButton")
        settingsBtn.Name = "SettingsButton"
        settingsBtn.Size = UDim2.new(0, 90, 0, 90)
        settingsBtn.Position = UDim2.new(0.5, -100, 1, -120)
        settingsBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        settingsBtn.Text = "S"
        settingsBtn.TextColor3 = Color3.new(1, 1, 1)
        settingsBtn.TextScaled = true
        settingsBtn.Font = Enum.Font.GothamBold
        settingsBtn.Visible = false
        settingsBtn.Parent = gui
        local settingsCorner = Instance.new("UICorner", settingsBtn)
        settingsCorner.CornerRadius = UDim.new(1, 0)

        -- SPEEDOMETER
        local speedLabel = Instance.new("TextLabel")
        speedLabel.Name = "SpeedLabel"
        speedLabel.Size = UDim2.new(0, 120, 0, 40)
        speedLabel.Position = UDim2.new(0.5, -60, 1, -170)
        speedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        speedLabel.TextColor3 = Color3.new(1, 1, 1)
        speedLabel.BackgroundTransparency = 0.3
        speedLabel.TextScaled = true
        speedLabel.Font = Enum.Font.GothamBold
        speedLabel.Text = "Speed: 0"
        speedLabel.Visible = false
        speedLabel.Parent = gui
        local corner2 = Instance.new("UICorner", speedLabel)
        corner2.CornerRadius = UDim.new(0.2, 0)

        -- ENHANCED SCROLLABLE Settings Panel
        local settingsPanel = Instance.new("Frame")
        settingsPanel.Name = "SettingsPanel"
        settingsPanel.Size = UDim2.new(0, 280, 0, 350)
        settingsPanel.Position = UDim2.new(0.5, -140, 0.5, -175)
        settingsPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        settingsPanel.Visible = false
        settingsPanel.Parent = gui
        local panelCorner = Instance.new("UICorner", settingsPanel)
        panelCorner.CornerRadius = UDim.new(0.1, 0)

        -- Panel Title
        local panelTitle = Instance.new("TextLabel")
        panelTitle.Name = "PanelTitle"
        panelTitle.Size = UDim2.new(1, 0, 0, 40)
        panelTitle.BackgroundTransparency = 1
        panelTitle.Text = "BOOST SETTINGS"
        panelTitle.TextColor3 = Color3.new(1, 1, 1)
        panelTitle.TextScaled = true
        panelTitle.Font = Enum.Font.GothamBold
        panelTitle.Parent = settingsPanel

        -- Scrolling Frame
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, -10, 1, -50)
        scrollFrame.Position = UDim2.new(0, 5, 0, 40)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 6
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollFrame.Parent = settingsPanel

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.FillDirection = Enum.FillDirection.Vertical
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = scrollFrame

        -- Reset to Defaults Button (on top in scroll frame)
        local resetBtn = Instance.new("TextButton")
        resetBtn.Name = "ResetButton"
        resetBtn.Size = UDim2.new(1, -20, 0, 40)
        resetBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        resetBtn.Text = "RESET TO DEFAULTS"
        resetBtn.TextColor3 = Color3.new(1, 1, 1)
        resetBtn.TextScaled = true
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.LayoutOrder = 0
        resetBtn.Parent = scrollFrame
        local resetCorner = Instance.new("UICorner", resetBtn)
        resetCorner.CornerRadius = UDim.new(0.5, 0)

        -- Create toggles and sliders
        local toggles = {
            createToggle("Straight Boost", boostConfig.STRAIGHT_BOOST, function(v) 
                boostConfig.STRAIGHT_BOOST = v 
                if v and currentSeat and boosting then
                    enableStraightBoost(currentSeat)
                elseif currentSeat and not v then
                    disableStraightBoost(currentSeat)
                end
            end),
            createToggle("Bypass Report", boostConfig.BYPASS_REPORT, function(v) 
                boostConfig.BYPASS_REPORT = v 
                -- Tidak ada fungsi, hanya button kosong
            end),
        }

        local sliders = {
            createSlider("Max Force", 10, 1000, boostConfig.MAX_BOOST_FORCE, function(v) 
                boostConfig.MAX_BOOST_FORCE = v 
            end),
            createSlider("Increment", 1, 35, boostConfig.BOOST_INCREMENT, function(v) 
                boostConfig.BOOST_INCREMENT = v 
            end),
            createSlider("Interval", 0.003, 1, boostConfig.BOOST_INTERVAL, function(v) 
                boostConfig.BOOST_INTERVAL = v 
            end),
        }

        -- Add toggles to scroll frame
        for i, toggle in ipairs(toggles) do
            toggle.LayoutOrder = i
            toggle.Parent = scrollFrame
        end

        -- Add sliders to scroll frame
        for i, slider in ipairs(sliders) do
            slider.LayoutOrder = #toggles + i + 1
            slider.Parent = scrollFrame
        end

        -- Draggable Settings Panel
        local UIS = game:GetService("UserInputService")
        local dragToggle, dragStart, startPos = nil, nil, nil
        local dragSpeed = 0.25

        local function updateInput(input)
            local delta = input.Position - dragStart
            local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(settingsPanel, TweenInfo.new(dragSpeed), {Position = position}):Play()
        end

        panelTitle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragToggle = true
                dragStart = input.Position
                startPos = settingsPanel.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragToggle = false
                    end
                end)
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if dragToggle then
                    updateInput(input)
                end
            end
        end)

        -- Reset button functionality
        resetBtn.MouseButton1Click:Connect(function()
            boostConfig = table.clone(DEFAULTS)
            autoSaveSettings()
            
            -- Destroy existing toggles and sliders
            for _, child in ipairs(scrollFrame:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end
            
            -- Recreate toggles
            toggles = {
                createToggle("Straight Boost", boostConfig.STRAIGHT_BOOST, function(v) 
                    boostConfig.STRAIGHT_BOOST = v 
                    if v and currentSeat and boosting then
                        enableStraightBoost(currentSeat)
                    elseif currentSeat and not v then
                        disableStraightBoost(currentSeat)
                    end
                end),
                createToggle("Bypass Report", boostConfig.BYPASS_REPORT, function(v) 
                    boostConfig.BYPASS_REPORT = v 
                    -- Tidak ada fungsi, hanya button kosong
                end),
            }
            
            -- Recreate sliders
            sliders = {
                createSlider("Max Force", 10, 1000, boostConfig.MAX_BOOST_FORCE, function(v) 
                    boostConfig.MAX_BOOST_FORCE = v 
                end),
                createSlider("Increment", 1, 35, boostConfig.BOOST_INCREMENT, function(v) 
                    boostConfig.BOOST_INCREMENT = v 
                end),
                createSlider("Interval", 0.003, 1, boostConfig.BOOST_INTERVAL, function(v) 
                    boostConfig.BOOST_INTERVAL = v 
                end),
            }
            
            -- Add new toggles
            for i, toggle in ipairs(toggles) do
                toggle.LayoutOrder = i
                toggle.Parent = scrollFrame
            end
            
            -- Add new sliders
            for i, slider in ipairs(sliders) do
                slider.LayoutOrder = #toggles + i + 1
                slider.Parent = scrollFrame
            end
        end)

        -- Settings button toggle visibility
        settingsBtn.MouseButton1Click:Connect(function()
            settingsPanel.Visible = not settingsPanel.Visible
        end)

        return gui, boostBtn, settingsBtn
    end

    local function setupBoost(character)
        local playerGui = player:WaitForChild("PlayerGui")
        if playerGui:FindFirstChild("BoostGui") then
            playerGui.BoostGui:Destroy()
        end

        local gui, boostBtn, settingsBtn = createBoostGui()

        local function monitorSeat(seat)
            if not seat:IsA("VehicleSeat") then return end
            seat:GetPropertyChangedSignal("Occupant"):Connect(function()
                local occupant = seat.Occupant
                if occupant and occupant.Parent == character then
                    currentSeat = seat
                    boostBtn.Visible = true
                    settingsBtn.Visible = true
                    -- Disable straight boost when entering new vehicle
                    if boostConfig.STRAIGHT_BOOST and boosting then
                        enableStraightBoost(seat)
                    end
                elseif currentSeat == seat then
                    -- Disable straight boost when leaving vehicle
                    if boostConfig.STRAIGHT_BOOST then
                        disableStraightBoost(seat)
                    end
                    currentSeat = nil
                    boostBtn.Visible = false
                    settingsBtn.Visible = false
                    stopBoost()
                end
            end)
        end

        for _, s in ipairs(workspace:GetDescendants()) do monitorSeat(s) end
        workspace.DescendantAdded:Connect(monitorSeat)

        boostBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                if currentSeat then startBoost(currentSeat) end
            end
        end)
        
        boostBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                stopBoost()
            end
        end)
    end

    -- INIT
    repeat wait() until player.Character
    setupBoost(player.Character)

    player.CharacterAdded:Connect(function(char)
        repeat wait() until char:FindFirstChild("Humanoid")
        setupBoost(char)
    end)
    
    print("Vehicle Boost System with Auto-Save & Straight Boost loaded successfully")
end

-- MAIN FUNCTION
local function main()
    if getgenv().JunkieUILoaded then return end
    getgenv().JunkieUILoaded = true
    
    local ui = buildUI()
    drag(ui)

    local function validate()
        local key = ui.box.Text:gsub("%s+","")
        if key == "" then 
            createNotification("Key Required","Please enter a key to continue.",3,"rbxassetid://82094603330968") 
            return 
        end
        
        createNotification("Checking...","Validating your key, please wait.",2,"rbxassetid://92630967969808")
        
        local success, sdk = pcall(function()
            return loadstring(game:HttpGet("https://junkie-development.de/sdk/JunkieKeySystem.lua"))()
        end)
        
        if not success then
            createNotification("Error", "Failed to load SDK. Please try again.", 3, "rbxassetid://78733624425654")
            return
        end
        
        local ok = sdk.verifyKey(cfg.api, key, cfg.service)
        
        if ok then
            saveKey(key)
            createNotification("Success!", "Key verified. Loading script...", 3, "rbxassetid://87094841427580")
            TweenService:Create(ui.main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, -0.5, 0),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.4)
            ui.gui:Destroy()
            loadScript()
        else
            createNotification("Invalid Key", "The key you entered is incorrect.", 3, "rbxassetid://78733624425654")
        end
    end

    ui.verify.MouseButton1Click:Connect(function()
        pulse(ui.verify)
        validate()
    end)

    ui.box.FocusLost:Connect(function(enter) 
        if enter then 
            validate() 
        end 
    end)

    ui.getKey.MouseButton1Click:Connect(function()
    pulse(ui.getKey)
    createNotification("Getting Links...", "Preparing both links for copying...", 2, "rbxassetid://83281479437771")

    local success, sdk = pcall(function()
        return loadstring(game:HttpGet("https://junkie-development.de/sdk/JunkieKeySystem.lua"))()
    end)

    if success then
        local link = sdk.getLink(cfg.api, cfg.provider, cfg.service)
        if link then
            local combinedText =
                "GET KEY LINK:\n" .. link .. "\n\n" ..
                "DISCORD LINK:\nhttps://discord.gg/ab4eTtTg\n\n" ..
                "Enjoy!"

            if setclipboard then
                setclipboard(combinedText)
                createNotification(
                    "Success!",
                    "Key Link copied\nDiscord Link copied",
                    4,
                    "rbxassetid://87094841427580"
                )
            else
                createNotification(
                    "Copy These Links",
                    combinedText,
                    6,
                    "rbxassetid://78733624425654"
                )
            end
        end
    else
        createNotification("Error", "Failed to load SDK.", 3)
    end
end)

    ui.close.MouseButton1Click:Connect(function()
        createNotification("Closing...", "See you next time!", 2, "rbxassetid://116998807311805")
        TweenService:Create(ui.main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, -0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.4)
        ui.gui:Destroy()
    end)

    ui.box.Focused:Connect(function()
        TweenService:Create(ui.box.Parent, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)

    ui.box.FocusLost:Connect(function()
        TweenService:Create(ui.box.Parent, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)

    for _,btn in ipairs({ui.verify, ui.getKey}) do
        btn.MouseEnter:Connect(function()
            local orig = btn.BackgroundColor3
            local bright = Color3.new(math.min(orig.R*1.15,1), math.min(orig.G*1.15,1), math.min(orig.B*1.15,1))
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = bright}):Play()
        end)
        btn.MouseLeave:Connect(function()
            local orig = btn.BackgroundColor3
            local dim = Color3.new(orig.R/1.15, orig.G/1.15, orig.B/1.15)
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = dim}):Play()
        end)
    end
end

main()