-- Devices
monitor = peripheral.wrap("")


-- Variables
width, height = monitor.getSize()
line = width/2


-- Setup
function setup()
    monitor.setBackgroundColour(colours.black)
    monitor.setTextColour(colours.white)
    monitor.setTextScale(1)
    monitor.clear()
end

-- Empty Line
function resetLine()
    local xPast, yPast = monitor.getCursorPos()
    monitor.setCursorPos(1, line)
    monitor.clear()
    
    
    -- actions after reset
    drawTime()
    
    -- snap back
    monitor.setCursorPos(xPast, yPast)
end

function drawTime()
    -- Minecraft Time
    local dayL = os.day()
    local timeL = os.time()
    local minecraftTime = "Day: "..dayL.." - ".."Time: "..textutils.formatTime(timeL, true)
    
    monitor.setCursorPos(width/2-#minecraftTime/2+1, height/2)
    monitor.setTextColour(colours.yellow)
    monitor.write(minecraftTime)
    
    
    
    -- Server Time
    local realTime = "Server Time: "..os.date()
    monitor.setCursorPos(width/2-#realTime/2+1, height/2+1)
    monitor.setTextColour(colours.lightGrey)
    monitor.write(realTime)
    
    -- Update Frequency
    monitor.setTextColour(colours.white)
    os.sleep(0.5)
end


-- Main
term.setTextColour(64)
startTime = os.date()
print("Clock started on  "..startTime)
term.setTextColour(1)
print("Monitor Size: "..width.."x"..height)
setup()
while true do
    resetLine()
end



