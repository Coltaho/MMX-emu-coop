-- GLOBALS
opts = {
	hpshare = false,
	ammoshare = false,
	dashmode = false,
	overlay = false
}

myweapons = {
	"homing",
	"sting",
	"shield",
	"fire",
	"storm",
	"spark",
	"cutter",
	"ice"
}
					
weapons = {
	homing = false,
	sting = false,
	shield = false,
	fire = false,
	storm = false,
	spark = false,
	cutter = false,
	ice = false,
	count = 0
}

myhearts = {
	"octopus",
	"chameleon",
	"armadillo",
	"mammoth",
	"eagle",
	"mandrill",
	"kuwanger",
	"penguin"
}

hearts = {
	octopus = false,
	chameleon = false,
	armadillo = false,
	mammoth = false,
	eagle = false,
	mandrill = false,
	kuwanger = false,
	penguin = false	
}

mytanks = {
	"armadillo",
	"mammoth",
	"eagle",
	"mandrill"
}

tanks = {
	armadillo = false,
	mammoth = false,
	eagle = false,
	mandrill = false
}

myupgrades = {
	"boots",
	"head",
	"body",
	"arm",
	"hado"
}

upgrades = {
	boots = false,
	head = false,
	body = false,
	arm = false,
	hado = false
}

locations = {
	sigma = 0,
	partnerlocation = 0
}

-- UTILITIES

function nonempty(s) return s and s ~= "" end
function nonzero(s) return s and s ~= 0 end

pngImage = require("png")

--Collected weapon icons
local weaponIcons = {
						pngImage("./images/homing.png", nil, false, false),
						pngImage("./images/sting.png", nil, false, false),
						pngImage("./images/shield.png", nil, false, false),
						pngImage("./images/fire.png", nil, false, false),
						pngImage("./images/storm.png", nil, false, false),	
						pngImage("./images/spark.png", nil, false, false),
						pngImage("./images/cutter.png", nil, false, false),
						pngImage("./images/ice.png", nil, false, false)
					}
--Greyed out weapon icons
local weaponuIcons = {
						pngImage("./images/homingu.png", nil, false, false),
						pngImage("./images/stingu.png", nil, false, false),
						pngImage("./images/shieldu.png", nil, false, false),
						pngImage("./images/fireu.png", nil, false, false),
						pngImage("./images/stormu.png", nil, false, false),	
						pngImage("./images/sparku.png", nil, false, false),
						pngImage("./images/cutteru.png", nil, false, false),
						pngImage("./images/iceu.png", nil, false, false)
					}
				
			
local sigmaIcons = {
						pngImage("./images/one.png", nil, false, false),
						pngImage("./images/two.png", nil, false, false),
						pngImage("./images/three.png", nil, false, false),
						pngImage("./images/four.png", nil, false, false),
						pngImage("./images/five.png", nil, false, false)
					}
	
local etankIcon = pngImage("./images/etank.png", nil, false, false)
local heartIcon = pngImage("./images/heart.png", nil, false, false)
local heartuIcon = pngImage("./images/heartu.png", nil, false, false)
local oneupIcon = pngImage("./images/oneup.png", nil, false, false)


local upgradeIcons = {
						pngImage("./images/boots.png", nil, false, false),
						pngImage("./images/helmet.png", nil, false, false),
						pngImage("./images/body.png", nil, false, false),
						pngImage("./images/arm.png", nil, false, false),
						pngImage("./images/hado.png", nil, false, false)
					}
					
local upgradeuIcons = {
						pngImage("./images/bootsu.png", nil, false, false),
						pngImage("./images/helmetu.png", nil, false, false),
						pngImage("./images/bodyu.png", nil, false, false),
						pngImage("./images/armu.png", nil, false, false)
					}
					
local selectedWeapon = 0
local frameCounter = 0
local xhp = 0

local soulSplit = {
					dash = pngImage("./images/hpdash.png", nil, false, false),
					background = pngImage("./images/hpbackground.png", nil, false, false)
				  }
function DrawGUIOverlay()
	--Draw weapons
	local weaponCount = 0
	
	for i = 1, 8 do
		if weapons[myweapons[i]] then
			drawIcon(weaponIcons[i], i*16, 207)
			weaponCount = weaponCount + 1
		else
			drawIcon(weaponuIcons[i], i*16, 207)
		end
	end
    
	--If we have hado, stop drawing hearts/subtanks
	if not upgrades.hado then
		--Draw hearts  
		for i = 1, 8 do
			if hearts[myhearts[i]] then
				drawIcon(heartIcon, i * 16, 199, "#000000")
			end
		end
		
		--Draw subtanks
		for i = 1, 4 do
			if tanks[mytanks[i]] then
				drawIcon(etankIcon, ((i + 2) * 16) + 8, 199, "#000000")
			end
		end
	end
	
	--Draw Current Sigma
	if weaponCount == 8 and locations.sigma == 0 then 
		drawIcon(sigmaIcons[locations.sigma + 1], 146, 207)
	else
		drawIcon(sigmaIcons[locations.sigma + 1], 146, 207)
	end
	
	--Draw Current Upgrades
	for i = 1, 4 do
		if upgrades[myupgrades[i]] then
			drawIcon(upgradeIcons[i], 148 + (i * 16), 207)
		else
			drawIcon(upgradeuIcons[i], 148 + (i * 16), 207)
		end
	end
	
	--Draw Hado upgrade over helmet if we have it
	if upgrades[myupgrades[5]] then
		drawIcon(upgradeIcons[5], 180, 207)
	end
	
	--Reads selected weapon every frame (multiple of 2 so divided by to for 1 - 8)
	--Then draws a box around the icons
	
	
	if frameCounter >= 10 then
		selectedWeapon = memory.readbyte(0x7E0BDB) / 2
		xhp = memory.readbyte(0x7E0BCF)
		frameCounter = 0
	end
	
	if selectedWeapon ~= 0 then
		gui.box(selectedWeapon * 16 + 1, 208, (selectedWeapon * 16) + 16, 223, "#FFFFFF00", "#FFFF00FF")
	end
	
	--Draw partner location
	if locations.partnerlocation > 0 and locations.partnerlocation < 10 then
		drawIcon(oneupIcon, locations.partnerlocation * 16, 216, "#000000")
	end
	
	if opts.hpshare then
		drawIcon(soulSplit["background"], 9, 12, "#FF0000")
		for i = 1, xhp do
			drawIcon(soulSplit["dash"], 13, 79 - (i * 2), "#FF0000")
		end
	end
	
	
	
	frameCounter = frameCounter + 1
end
   
   function drawIcon(icon, offx, offy, transparent)
   for h = 1, icon.height do
		for w = 1, icon.width do
			local hexadecimal = '#'
			r = rgbToHex(icon.pixels[h][w].R)
			g = rgbToHex(icon.pixels[h][w].G)
			b = rgbToHex(icon.pixels[h][w].B)
			a = rgbToHex(icon.pixels[h][w].A)
			
			hexadecimal = hexadecimal .. r .. g .. b

			if transparent ~= nil then
				if transparent ~= hexadecimal then
					gui.pixel(w + offx, h + offy, hexadecimal)
				end
			else
				gui.pixel(w + offx, h + offy, hexadecimal)
			end
		end
	end
end

function rgbToHex(value)
	
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

	return hex
end
  
  
function rgbToHex(value)
	
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

	return hex
end

-- TICKER

local currentError = nil
local currentMessages = List()
local MESSAGE_DURATION = 300

-- Set the current message (optionally, make it an error)
function message(msg, isError)
	if isError then
		currentError = msg
	else
		currentMessages:put({msg, life=MESSAGE_DURATION})
	end
	if msg then print(msg) end -- Double to the Lua log
end

function statusMessage(msg)
	message(msg, true)
end

function errorMessage(msg)
	message(msg and "Error: " .. msg, true)
end

-- Version string tools
function parseVersion(s)
	local split = stringx.split(s)
	if not split[1] then return null end

	local split2 = stringx.split(split[1], ".")
	if not (split2[1] and split2[2]) then return null end

	local variant = {}
	for x=2,#split do table.insert(variant, split[x]) end

	return {major=split2[1], minor=split2[2], patch=split2[3], variant=variant}
end

function parsedVersionMatches(mine, theirs, exact)
	if not (mine and theirs) then -- Blank == wildcard
		return false
	end
	local mineMajor = tonumber(mine.major)
	local mineMinor = tonumber(mine.minor)
	local theirsMajor = tonumber(theirs.major)
	local theirsMinor = tonumber(theirs.minor)
	if not theirsMajor or not theirsMinor or
	   (theirsMajor > mineMajor) or -- FIXME: This is not how semver works but all versions are currently 1.0 so whatever
	   (exact and theirsMajor < mineMajor) or
	   (theirsMajor == mineMajor and theirsMinor > mineMinor) or
	   (exact and theirsMinor < mineMinor) then
	   return false
	end
	if tablex.find(theirs.variant, "beta") and not tablex.find(mine.variant, "beta") then
		return false
	end
	return true
end

function versionMatches(mine, theirs, exact) -- If exact is false allow "downgrades"
	mine = mine and parseVersion(mine)
	theirs = theirs and parseVersion(theirs)
	return parsedVersionMatches(mine, theirs, exact)
end

function optionsMatch(mine, theirs)
	local ordered_keys = {}

	for k in pairs(mine) do
    table.insert(ordered_keys, k)
	end

	table.sort(ordered_keys)
	for i = 1, #ordered_keys do
    if mine[ordered_keys[i]] ~= theirs[ordered_keys[i]] then
			return false
		end
	end
	return true
end

-- Callback to print the current error message
function printMessage()
	local msg = null
	if currentError then
		msg = currentError
	else
		while currentMessages:len() > 0 do
			local messageRecord = currentMessages[#currentMessages]
			if messageRecord.life <= 0 then
				currentMessages:pop()
			else
				msg = messageRecord[1]
				messageRecord.life = messageRecord.life - 1
				break
			end
		end
	end
	if msg then
		--DrawGUIOverlay()
		gui.text(5, 2, msg) --254-40
	end
end
