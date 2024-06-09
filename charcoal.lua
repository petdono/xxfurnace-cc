-- Function to list all connected peripherals
local function listAllPeripherals()
    local peripherals = {}
    for _, name in pairs(peripheral.getNames()) do
        peripherals[name] = peripheral.getType(name)
    end
    return peripherals
end

-- Function to transfer items from source to destination
local function transferItems(source, sourceSlot, destination, destSlot, amount)
    if peripheral.call(source, "getItemDetail", sourceSlot) then
        peripheral.call(source, "pushItems", destination, sourceSlot, amount, destSlot)
    end
end

-- Function to collect specific items from chests
local function collectItems(chests, itemNamePatterns)
    local itemSlots = {}
    for chest, _ in pairs(chests) do
        local inventory = peripheral.call(chest, "list")
        for slot, item in pairs(inventory) do
            for _, pattern in ipairs(itemNamePatterns) do
                if string.find(item.name, pattern) then
                    table.insert(itemSlots, {chest = chest, slot = slot, count = item.count, name = item.name})
                end
            end
        end
    end
    return itemSlots
end

-- Function to distribute items to furnaces in a round-robin manner
local function distributeItemsRoundRobin(itemSlots, furnaces, furnaceSlot)
    local furnacesList = {}
    for furnace, _ in pairs(furnaces) do
        table.insert(furnacesList, furnace)
    end

    local furnaceIndex = 1
    while #itemSlots > 0 do
        local currentFurnace = furnacesList[furnaceIndex]
        local itemsToTransfer = 1

        local itemSlot = table.remove(itemSlots, 1)
        transferItems(itemSlot.chest, itemSlot.slot, currentFurnace, furnaceSlot, itemsToTransfer)
        itemSlot.count = itemSlot.count - itemsToTransfer

        if itemSlot.count > 0 then
            table.insert(itemSlots, itemSlot)
        end

        furnaceIndex = furnaceIndex + 1
        if furnaceIndex > #furnacesList then
            furnaceIndex = 1
        end
    end
end

-- Get all peripherals on the network
local peripherals = listAllPeripherals()

-- Separate chests and furnaces
local chests = {}
local furnaces = {}
for name, type in pairs(peripherals) do
    if string.find(name, "chest") then
        chests[name] = type
    elseif string.find(name, "furnace") then
        furnaces[name] = type
    end
end

-- Collect coal, charcoal, and logs from chests
local coalSlots = collectItems(chests, {"minecraft:coal"})
local charcoalSlots = collectItems(chests, {"minecraft:charcoal"})
local logSlots = collectItems(chests, {"log"})

-- Distribute coal to furnaces (fuel slot) in a round-robin manner
distributeItemsRoundRobin(coalSlots, furnaces, 2)

-- Distribute charcoal to furnaces (fuel slot) in a round-robin manner
distributeItemsRoundRobin(charcoalSlots, furnaces, 2)

-- Distribute logs to furnaces (top slot) in a round-robin manner
distributeItemsRoundRobin(logSlots, furnaces, 1)

print("Distribution complete.")
