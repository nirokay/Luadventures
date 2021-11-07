--require("boot/devices")
monitor = peripheral.wrap("")
chat    = peripheral.wrap("") -- Advanced Peripherals!
chatTick = 0

-- Position of redstone input
local alarm   = "" -- Trigger alarm
local blocker = "" -- Block Chat Messages

-- Variables for animation
local animationTick = 0
local animation = ""

-- Monitor stuff
local width, height = monitor.getSize()

if width % 2 == 1 then
    width = width + 1
end


-- FUNCTIONS

-- oOoo Animation
function animation()
    local frames = 6
    local art = {"Oooo", "oOoo", "ooOo", "oooO", "ooOo", "oOoo", "placeholder"}
    -- Tick
    if animationTick >= frames then
        animationTick = 1
    else
        animationTick = animationTick + 1
    end
    
    -- Returns the "image"
    return art[animationTick]
end

-- Sends warning message in the chat
function chatWarning(text)
    if not redstone.getInput(blocker) then
        chat.sendMessage(text)
    end
end


-- Prints text to the screen
function print2Screen(line, text, colour)
    monitor.setCursorPos(width/2-#text/2, line)
    monitor.clearLine()
    monitor.setTextColour(colour)
    monitor.write(text)
    monitor.setTextColour(colours.white)
end


function startedInformation()
    print("Started on - "..os.date())
    print("Monitor Size: "..width.."x"..height)
end


-- MAIN LOOP
startedInformation()
monitor.clear()
print2Screen(1, "Reactor Status", colours.white)

while true do
    local isAlarm = rs.getInput(alarm)
    
    -- Redstone input
    if isAlarm then
        chatWarning("Reactor offline!")
        print2Screen(4, "Reactor offline", colours.red)       
    else
        print2Screen(4, "Reactor online", colours.green)
    end
    
    print2Screen(2, animation(), colours.orange)
    os.sleep(0.5)
end
