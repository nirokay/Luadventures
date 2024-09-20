-------------
-- CONFIG: --
-------------

local config = {
    -- Sleeping in seconds:
    sleep = {
        forRefuel = 5,                            -- Default:  10
        afterEmptying = 180                       -- Default: 180
    },

    -- Full name of crop as item and block and ripeness:
    crop = {
        block = "minecraft:potatoes",
        item  = "minecraft:potato",
        ripe  = 7                                 -- Default: 7 (crops have grow stages between 0 and 7)
    },

    -- Blocks to listen to for instructions on how to move/interact:
    blocks = {
        forward   = "minecraft:white_wool",       -- optional (turtle will move forwards each step regardless, only useful for debugging)
        turnRight = "minecraft:green_wool",       -- required
        turnLeft  = "minecraft:blue_wool",        -- required

        emptyInventory = "minecraft:hopper",      -- required
        refuelTurtle   = "minecraft:yellow_wool"  -- optional *(removing will require manual refueling)*
    },

    -- Print out debug information on what the turtle is currently doing:
    debug = false                                 -- Default: false
}


----------------
-- VARIABLES: --
----------------

-- Function getting called the next step:
local BufferFunction = nil

-- Dictionary of block names and its effects on the turtle:
local BlockList = {}


----------------
-- FUNCTIONS: --
----------------

-- Function to print debug information: (with and without newline)
local function debug_write(txt, ...)
    if not config.debug then return end
    io.write(string.format(txt, ...))
end
local function debug_print(txt, ...)
    debug_write(txt.."\n", ...)
end

-- Print out current config at start:
local function printWelcomeMessage()
    -- Clear screen:
    term.clear()
    term.setCursorPos(1, 1)
    -- Print text:
    local text = {
        "Welcome to the farming program!",
        "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯",
        "  Author: nirokay",
        "  Repo: https://github.com/nirokay/Luadventures\n",

        "Current config:",
        "  Crop: " .. config.crop.item,
        "  Idle & Refuel time: " .. config.sleep.afterEmptying .. "s and " .. config.sleep.forRefuel .. "s",
        "  Debug printout: " .. tostring(config.debug)
    }
    print(table.concat(text, "\n"))
    sleep(2)
end


-- Add blocks to check for to BlockList dictionary:
local function newBlock(blockName, blockFunction)
    local temp = {
        block = blockName,
        fn = blockFunction
    }
    BlockList[blockName] = blockFunction
    return temp
end


--------------------
-- TURTLE BLOCKS: --
--------------------

-- Movement:
newBlock(config.blocks.forward, function(_)
    debug_print("Moving forwards...")
    -- Empty because move forward is called after every step.
end)
newBlock(config.blocks.turnRight, function(_)
    debug_print("Turning right...")
    turtle.turnRight()
end)
newBlock(config.blocks.turnLeft, function(_)
    debug_print("Turning left...")
    turtle.turnLeft()
end)

-- Inventory:
newBlock(config.blocks.emptyInventory, function(_)
    debug_print("Emptying inventory...")
    for i = 16, 1, -1 do
        turtle.select(i)
        turtle.dropDown()
    end
    debug_print(" > Going to sleep for %s seconds!", tostring(config.sleep.afterEmptying))
    sleep(config.sleep.afterEmptying)
    debug_print(" > Done sleeping.")
end)

-- Refueling:
newBlock(config.blocks.refuelTurtle, function(_)
    -- Sleep to allow items to get input through a hopper:
    debug_print("Refueling, going to sleep for %s seconds.", config.sleep.forRefuel)
    sleep(config.sleep.forRefuel)

    -- Cycle through inventory and refuel:
    BufferFunction = function()
        debug_print(" > Done sleeping, refueling...")
        for i = 16, 1, -1 do
            turtle.select(i)
            turtle.refuel()
        end
        debug_print(" > Finished refueling!")
    end
end)

-- Harvesting and Replanting:
local function attemptReplanting()
    local currentItem = turtle.getItemDetail()
    if currentItem ~= nil then
        -- Place potato from currently held item:
        if currentItem.name == config.crop.item then
            debug_print("Placing down crop!")
            turtle.placeDown()
            return
        end
    end

    -- Find potato in inventory and place it down: (more expensive on computation, please do not happen in praxis)
    debug_print("Locating crop to replant...")
    for i = 1, 16 do
        turtle.select(i)
        local newItem = turtle.getItemDetail()
        if newItem ~= nil then
            if newItem.name == config.crop.item then
                debug_print("Placing down crop!")
                turtle.placeDown()
                return
            end
        end
    end

    -- Failed to replant:
    debug_print("Could not locate crop in inventory to replant... carrying on.")
end
newBlock(config.crop.block, function(block)
    debug_write("Crop found... ")
    if block.state.age >= config.crop.ripe then
        debug_print("ready to harvest!")
        turtle.digDown()
        attemptReplanting()
    else
        debug_print("still growing...")
    end
end)


-----------
-- MAIN: --
-----------

local function main()
    -- Execute Buffer function from last step:
    if BufferFunction ~= nil then
        debug_print("Executing buffer function!")
        BufferFunction()
        BufferFunction = nil
    end

    -- Check for the current block underneath turtle:
    local isBlock, block = turtle.inspectDown()
    if isBlock and block ~= nil then
        -- Execute Block function:
        if BlockList[block.name] ~= nil then
            BlockList[block.name](block)
        end
    end

    -- Move forward: (gets called after every block check, because yeah... stuff)
    turtle.forward()
end


printWelcomeMessage()
while true do
    main()
end


