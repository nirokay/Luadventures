-- Devices
chat = peripheral.wrap("") -- Advanced Peripherals!

-- Variable Declaration:
local hour   = 0
local minute = 0



-- FUNCTIONS

-- Updates the current time
function updateTime()
    hour   = os.date("%H")
    minute = os.date("%M")
end

-- Checks if time and reminder are the same
function checkTime(hrs, min, message)
    if hrs == hour and min == minute then
        print("")
        chat.sendMessage(" > "..message.." ("..hour..":"..minute..")")
    end
end 



-- MAIN

while true do
    updateTime()
    
    -- Example:
    checkTime("04", "59", "Server is about to restart!")
    
    os.sleep(20) -- Sleep time can be varied
end
