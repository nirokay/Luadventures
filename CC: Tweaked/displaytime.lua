-- DEVICES
monitor = peripheral.wrap("")



-- VARIABLES
local width, height = monitor.getSize()
local defaultText = colours.white
local defaultBackground = colours.black



-- FUNCTIONS

-- Sets everything up before running
function setup()
    monitor.setBackgroundColour(defaultBackground)
    monitor.setTextColour(defaultText)
    monitor.clear()
end

-- Prints stuff to the screen
function print2Screen(line, colour, text)
    -- Centers Cursor in line and clears line
    monitor.setCursorPos(width/2-#text/2, line)
    monitor.clearLine()
    
    -- Print to screen
    if colour == nil then
        -- no colour given
        monitor.setTextColour(defaultText)
    else
        -- colour given
        monitor.setTextColour(colour)
    end
    monitor.write(text)
    
    -- Colour reset
    monitor.setTextColour(defaultText)
end

-- Gets the current time (true -> 12h format)
function getTime(isInsane)
    local time = ""
    local tizn = os.date("%z")
    
    if isInsane then
        -- 12h format
        time = os.date("%r")
    else
        -- 24h format
        time = os.date("%H:%M:%S   ")
    end
    
    return tostring(time.." UTC"..tizn)
end

-- Gets the current date (true -> american date format)
function getDate(isInsane)
    local date = ""
    
    if isInsane then
        -- american date format
        date = os.date("%D")
    else
        -- normal date format
        date = os.date("%d.%m.%Y")
    end
    
    return date
end

-- Gets Minecraft Day
function getMCDay()
    return os.day()
end

-- Gets Minecraft Time
function getMCTime(isInsane)
    return textutils.formatTime(os.time(), not isInsane)
end



-- MAIN LOOP
print("Script running since: "..os.date())
print("Monitor dimensions: "..width.."x"..height)

setup()
print2Screen(1, colours.grey, "Server Time:")
print2Screen(6, colours.grey, "Minecraft Time:")
while true do
    -- EXAMPLES:
    -- Server Time:
    print2Screen(2, colours.yellow, getTime())
    print2Screen(4, colours.orange, getDate())
    
    -- Minecraft Time:
    print2Screen(7, colours.pink, getMCTime())
    print2Screen(9, colours.purple, "Day: "..getMCDay())
    
    -- Update Frequency
    os.sleep(0.5)
end
