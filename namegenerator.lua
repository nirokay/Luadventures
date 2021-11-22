#!/usr/bin/env lua5.4

--[[

           This script generates random city/place names.
    The quality of names varies, but as long as it has some gems
        and/or strikes inspiration, it's a win in my books :)

      This script can be modified to include special characters,
     as well as use other prefixes/affixes and modify the chance
                       of them appearing.

]]


-- How many names to generate
local generateTimes = ...

-- Correct if invalid or not provided
if tonumber(generateTimes) == nil or tonumber(generateTimes) < 1 then
	generateTimes = 1
end

-- Randomness
math.randomseed(os.time())



-- TABLES

-- uppercase letters ([1]: non-vocals - [2]: vocals)
local big = {
	{
		"B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Y", "Z",
		"Sh", "Ch"
	},
	{
		"A", "E", "I", "O", "U"
	}
	
}

-- lowercase letters ([1]: non-vocals - [2]: vocals)
local small = {
	{
		"b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z",
		"sh", "ch"
	},
	{
		"a", "e", "i", "o", "u"
	}
}

-- Prefixes
local prefix = {
	"North ", "South ", "West ", "East ",
	"High ", "Low ",
	"New ", "Nova ", "Neo ", "Old ",
	"El ", "Del ", "L'", "Las ",
	"Kingdom of ", "Land of the ", "Republic of ", "Region of "
}

-- Affixes
local affix = {
	" Town", " City",
	" River", " Lake",
	" Mountain", " Hill", 
	" Valley", " Plains", " Plateau", " Dune", " Desert", " Forest"
}

-- determines the formatting of names (a = vocals; x = non-vocals)
local format = {
	"axa", "xax", "xxa", "axx", "aax", "xaa",
	"axax", "aaxa", "xaax", "xxax", "xaxa", "xaxx",
	"axaax", "xaaxa", "xaxaa", "xaxax", "axaxa", "xaxxa",
	"axaaxa", "aaxaxa", "aaxaax", "xaaxax", "xaxxax",
	"axaxxax", "axaxaax", "xaxxaxa", "xaxaxxa", "xaxaxax"
}



-- FUNCTIONS

--   MATH

-- more easy to use random number generator
local function random(max)
	return math.random(1, max)
end

-- generates a percentage (only for simpler odds manipulation) (accepts numbers between 0 and 100 - up to 2 decimals after the . )
function perc(num)
	local comp = math.random(0, 10000)/100

	if comp > tonumber(num) then
		return false
	else
		return true
	end
end


--   WORDS

-- checks if a letter is a vocal
local function isVocal(char)
	local vocal = {
		"A", "a",
		"E", "e",
		"I", "i",
		"O", "o",
		"U", "u"
	}

	local isVocal = false
	for i=1,#vocal do
		if vocal[i] == tostring(char) then
			isVocal = true
		end
	end
	return isVocal
end

-- gets an item from a list
local function getItem(list)
	if list == nil then
		return "!"
	else
		return list[random(#list)]
	end
end

-- gets a prefix
local function getPrefix(chance)
	if perc(chance) then
		return getItem(prefix)
	else
		return ""
	end
end

-- gets an affix
local function getAffix(chance)
	if perc(chance) then
		return getItem(affix)
	else
		return ""
	end
end

-- gets the actual name
local function getName()
	local form = getItem(format)
	local name = ""

	for i=1,#form do
		local s = string.sub(form, i, i)

		-- only uppercase when first run
		local letters = nil
		if i == 1 then
			letters = big
		else
			letters = small
		end

		
		if isVocal(s) then
			name = name..getItem(letters[2])
		else
			name = name..getItem(letters[1])
		end
	end

	return name
end

-- constructs the name
local function constructName()
	return getPrefix(20)..getName()..getAffix(40)
end



-- MAIN

local function main()
	local output = {}

	-- add names to output table
	for i=1, generateTimes do
		table.insert(output, constructName())
	end

	-- print output table
	for i=1,#output do
		-- adds spacing on the left
		local spacing = ""
		for x=1,#tostring(generateTimes)-#tostring(i) do
			spacing = spacing.." "
		end

		-- print
		print(spacing..tostring(i)..":  "..output[i])
	end
end

main()