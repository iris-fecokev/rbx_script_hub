local Config = {
    scriptsLoadstrings = {
        {
            name = "ESP",
            loadstring = "loadstring(game:HttpGet('https://raw.githubusercontent.com/iris-fecokev/esp-rbx-script/refs/heads/main/main.lua'))()"
        },
        {
            name = "EMPTY",
            loadstring = "EMPTY"
        },
        {
            name = "Aimbot",
            loadstring = "loadstring(game:HttpGet('https://raw.githubusercontent.com/iris-fecokev/rbx-aimbot/refs/heads/main/main.lua'))()"
        },
        {
            name = "EMPTY",
            loadstring = "loadstring(game:HttpGet('https://example.com/empty.lua'))()"
        },
        {
            name = "c00lgu(key: 27jUkl)",
            loadstring = "loadstring(game:HttpGet('https://pastebin.com/raw/vuNh0P0V'))()"
        }
    }
}

local function CreateHub()
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScriptHub"
    screenGui.Parent = CoreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = mainFrame

    -- Header с кнопкой сворачивания
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    header.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "Script Hub"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 30, 0, 30)
    toggleButton.Position = UDim2.new(1, -30, 0, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = "-"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 18
    toggleButton.Parent = header

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton

    -- Контентная область
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -50)
    contentFrame.Position = UDim2.new(0, 10, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.Parent = contentFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = scrollFrame

    -- Переменные для перемещения окна
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    -- Функция для перемещения окна
    local function updateInput(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)

    -- Функция для анимации текста загрузки (замедленная)
    local function AnimateText(button, originalText)
        local loadingFrames = {
            "з", "за", "заг", "загр", "загру", "загруз", "загрузк", "загрузка", 
            "загрузка.", "загрузка..", "загрузка..."
        }
        
        local connection
        local frame = 1
        local lastUpdate = tick()
        local updateInterval = 0.2 -- Увеличили интервал до 0.2 секунд
        
        local function update()
            local currentTime = tick()
            if currentTime - lastUpdate >= updateInterval then
                button.Text = loadingFrames[frame]
                frame = frame + 1
                if frame > #loadingFrames then
                    frame = 1
                end
                lastUpdate = currentTime
            end
        end
        
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            update()
        end)
        
        return connection
    end

    -- Функция для сворачивания/разворачивания (исправленная)
    local isMinimized = false
    local originalSize = mainFrame.Size
    local minimizedSize = UDim2.new(0, 300, 0, 30)
    
    toggleButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if isMinimized then
            -- Сворачиваем основное окно
            local tween = TweenService:Create(mainFrame, tweenInfo, {Size = minimizedSize})
            tween:Play()
            toggleButton.Text = "+"
            
            -- Скрываем контент
            contentFrame.Visible = false
        else
            -- Разворачиваем основное окно
            local tween = TweenService:Create(mainFrame, tweenInfo, {Size = originalSize})
            tween:Play()
            toggleButton.Text = "-"
            
            -- Показываем контент с небольшой задержкой для плавности
            wait(0.15)
            contentFrame.Visible = true
        end
    end)

    -- Создание кнопок скриптов
    for _, scriptData in ipairs(Config.scriptsLoadstrings) do
        if scriptData.name ~= "EMPTY" and scriptData.loadstring ~= "EMPTY" then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 40)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Text = scriptData.name
            button.Font = Enum.Font.Gotham
            button.TextSize = 14
            button.AutoButtonColor = false
            button.Parent = scrollFrame

            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = button

            local connection
            button.MouseButton1Click:Connect(function()
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                
                local originalText = button.Text
                connection = AnimateText(button, originalText)
                
                local success, err = pcall(function()
                    loadstring(scriptData.loadstring)()
                end)
                
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                
                button.Text = originalText
                
                if not success then
                    warn("Ошибка выполнения скрипта: " .. err)
                end
            end)

            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            end)

            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end)
        end
    end

    -- Обновление размера скролл фрейма
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)
end

CreateHub()
