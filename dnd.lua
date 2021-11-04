#!/usr/bin/env lua5.4
-- ^ Lua interpreter (if running through lua directly it is not necessary, comment out if you have problems)



-- Outside Parameter Input
local operator, par0, par1, par2 = ...
operator = tostring(operator)

-- Valid dice throws for dnd
local validThrows = {4, 6, 8, 10, 12, 20}

-- Random Number Generation
math.randomseed(os.time())



-- FUNCTIONS

-- Exit Code Control (~ error log)
function exitCode(code, errorText)
	local exit = ""
	if errorText == nil then
		errorText = ""
	end

	if code == 0 then
		-- Program normal exit	
		exit = ""

	elseif code == 1 then
		-- Operator invalid
		exit = "Invalid operator."

	elseif code == 2 then
		-- Parameter Invalid
		exit = "Invalid parameters."

	else
		-- Fallback if other code
		exit = "Unspecified error."
	end

	print(exit)
	if code ~= 0 then
		print("Type --help for instructions.")
	end
	print("Program exited with code "..tostring(code)..". "..tostring(errorText))
	os.exit()
end

-- Checks if requested die is valid
function checkValid(die)
	local valid = false

	for i = 1, #validThrows do
		if tonumber(die) == tonumber(validThrows[i]) then
			valid = true
		end
		--print("Roll check: "..tostring(die).." ?= "..tostring(validThrows[i]).." "..tostring(valid))
	end

	return valid
end

-- Rolls an x-sided die y times
function rollDie(times, sides)
	local rolls = {}
	for i = 1, times do
		local roll = math.random(1, sides)
		table.insert(rolls, roll)
	end

	-- Returns a lua table of all rolls
	return rolls
end

-- Gets the stats of the roll(s)
function rollStats()
	-- Sum of all rolls
	function sum()
		local sum = 0
		for i = 1, #results do
			sum = sum + results[i]
		end
		return sum
	end

	-- Average of all rolls
	function avg()
		return sum()/par0
	end

	-- Maximum of all rolls
	function max()
		max = 0
		for i = 1, #results do
			if results[i] > max then
				max = results[i]
			end
		end
		return max
	end

	-- Minimum of all rolls
	function min()
		min = tonumber(par1)
		for i = 1, #results do
			if results[i] < min then
				min = results[i]
			end
		end
		return min
	end

	return "Sum of all throws: "..tostring(sum()).." - Average: "..tostring(avg()).." - Minimum: "..tostring(min()).." - Maximum: "..tostring(max())
end



-- COMMANDS FUNCTIONS
function versionCommand()
	local version = "1.0"
	print("Version "..version)
end

function helpCommand()
	function helpWith(name, long, short, parameter, desc0, desc1)
		print(tostring(name)..":   "..tostring(short).." / "..tostring(long).." <"..tostring(parameter)..">")
		print("  "..tostring(desc0))
		if desc1 ~= nil then
			print("  "..tostring(desc1))
		end
		print()
	end

	-- Command "List"
	helpWith("Help Command", "--help", "-h", "", "Displays this screen")
	helpWith("Version Command", "--version", "-v", "", "Displays the version of the script")
	helpWith("Roll Command", "--roll", "-r", "numberX numberY free", "Rolls an x-sided die y-times. Put <free> at the end to roll invalid dice.", "Valid dice are: "..table.concat( validThrows, ", "))
end

function rollCommand()
	results = {}
	if par2 ~= "free" then
		-- Roll with validity check
		if checkValid(par1) then
			-- Valid
			results = rollDie(par0, par1)
		else
			-- Invalid
			exitCode(2, "Please make sure the die is a valid-sided one.")
		end
	end

	-- Roll
	results = rollDie(par0, par1)

	print("Roll results: "..table.concat( results, " "))
	print(rollStats())
end



-- MAIN LOOP
--print("Operator: "..tostring(operator).." ° Parameters: "..tostring(par0).." "..tostring(par1).." "..tostring(par2))

if operator == "-h" or operator == "--help" then
	helpCommand()

elseif operator == "-v" or operator == "--version" then
	versionCommand()

elseif operator == "-r" or operator == "--roll" then
	rollCommand()

else
	-- Invalid operator
	exitCode(1)
end

-- Normal exit
exitCode(0)
