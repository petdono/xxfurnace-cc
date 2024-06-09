-- Load Basalt
local basalt = require("basalt")

-- Create the main frame
local mainFrame = basalt.createFrame()

-- Function to scale and position buttons
local function scaleUI()
    local width, height = term.getSize()
    local paddingLeft = 2  -- Define left padding
    local paddingTop = 3   -- Define top padding for the first button
    local buttonHeight = 3  -- Define button height

    local buttonWidth = width - paddingLeft * 2
    
    -- Add a label at the top center
    local label = mainFrame:addLabel()
        :setText("My Scalable UI")
        :setPosition(math.floor(width / 2) - 6, 1)
    
    local button1 = mainFrame:addButton()
        :setText("Smelt Iron")
        :setSize(buttonWidth, buttonHeight)
        :setPosition(paddingLeft, paddingTop)

    local button2 = mainFrame:addButton()
        :setText("Smelt Gold")
        :setSize(buttonWidth, buttonHeight)
        :setPosition(paddingLeft, paddingTop + buttonHeight + 1)

    local button3 = mainFrame:addButton()
        :setText("Smelt Copper")
        :setSize(buttonWidth, buttonHeight)
        :setPosition(paddingLeft, paddingTop + (buttonHeight + 1) * 2)

    local button4 = mainFrame:addButton()
        :setText("Smelt Silver")
        :setSize(buttonWidth, buttonHeight)
        :setPosition(paddingLeft, paddingTop + (buttonHeight + 1) * 3)

    -- Add event handlers for the buttons
    button1:onClick(function()
        shell.run("ee-ironchunk.lua")
    end)

    button2:onClick(function()
        shell.run("ee-goldchunk.lua")
    end)

    button3:onClick(function()
        shell.run("ee-copperchunk.lua")
    end)

    button4:onClick(function()
        shell.run("ee-silverchunk.lua")
    end)
end

-- Initial UI setup
scaleUI()

-- Function to handle resizing
local function onResize()
    mainFrame:clear()
    scaleUI()
end

-- Set up event listener for resizing
mainFrame:onEvent("term_resize", onResize)

-- Show the main frame
basalt.autoUpdate()