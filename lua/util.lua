-- GLOBALS
opts = {
	hpshare = false,
	ammoshare = false,
	dashmode = false
}

uiopts = {
	overlay = true
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
	ice = false
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
	penguin = false,
	maxlife = 16
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

--All these are populated in loadImages function (for some reason initializing them here resulted in nil strings
local weaponIcons = {}
local weaponuIcons = {}
				
			
local sigmaIcons = {}
	
local etankIcon = nil
local heartIcon = nil
local oneupIcon = nil


local upgradeIcons = {}
					
local upgradeuIcons = {}

soulLink = {}
				  
local sigmaanimation = {}

local creditbackground = nil
local credittext = nil
local animated = nil
					
local selectedWeapon = 0
local xhp = 0

----------------------------------------
gamefinished = false
local pauseframes = 120
local pos = 920
function scrollCredits()
		gui.gdoverlay(0, 0, creditbackground, 0, 0, 256, 224 , 1.0)
		
		gui.gdoverlay(0, pos/4, credittext, 0, 0, 256, 500 , 1.0)
		
		pos = pos - 1
		
		if(pos <= -1104 and pauseframes > 0) then
			pos = -1104
			pauseframes = pauseframes - 1
		elseif(pauseframes <= 0) then
			gamefinished = false
		end
end


--------- function to return table for animated images
function animatedImage(iconTable, totalFrames, speeds)
	local images = {}
	local index = 1
	local speed = 1
	local animationTimer = 0
	local frameCount = 10
	local maxFrames = totalFrames
	if speeds ~= nil then
		speed = speeds
	end
	
	frameCount = (60 * speed) / totalFrames
	
	for i = 1, totalFrames do
	images[i] = iconTable[i]
	end
	
	return {
        images = images,
		index = index,
		speed = speed,
		animationTimer = animationTimer,
		frameCount = frameCount,
		maxFrames = maxFrames
    }
end


---------

--Clean way of calling this function to load a single image
local loadImage = function (image) return gui.gdcreateimagestring(image) end

--Function used to initialize all images into their variables
local function loadImages()
weaponIcons = {
	loadImage("./images/homing.png"),
	loadImage("./images/sting.png"),
	loadImage("./images/shield.png"),
	loadImage("./images/fire.png"),
	loadImage("./images/storm.png"),	
	loadImage("./images/spark.png"),
	loadImage("./images/cutter.png"),
	loadImage("./images/ice.png")
}
					
weaponuIcons = {
	loadImage("./images/homingu.png"),
	loadImage("./images/stingu.png"),
	loadImage("./images/shieldu.png"),
	loadImage("./images/fireu.png"),
	loadImage("./images/stormu.png"),	
	loadImage("./images/sparku.png"),
	loadImage("./images/cutteru.png"),
	loadImage("./images/iceu.png")
}

sigmaIcons = {
	loadImage("./images/one.png"),
	loadImage("./images/two.png"),
	loadImage("./images/three.png"),
	loadImage("./images/four.png"),
	loadImage("./images/five.png")
}

etankIcon = loadImage("./images/etank.png")
heartIcon = loadImage("./images/heart.png")
oneupIcon = loadImage("./images/oneup.png")

upgradeIcons = {
	loadImage("./images/boots.png"),
	loadImage("./images/helmet.png"),
	loadImage("./images/body.png"),
	loadImage("./images/arm.png"),
	loadImage("./images/hado.png")
}
					
upgradeuIcons = {
	loadImage("./images/bootsu.png"),
	loadImage("./images/helmetu.png"),
	loadImage("./images/bodyu.png"),
	loadImage("./images/armu.png")
}

soulLink = {
	dash = loadImage("./images/hpdash.png"),
	bottom = loadImage("./images/hpbackgroundbottom.png"),
	top = loadImage("./images/hpbackgroundtop.png"),
	middle = loadImage("./images/hpbackgroundmiddle.png"),
	dying = false,
	recentFrames = 0
}
				  
sigmaanimation = {
	loadImage("./images/sigmasmirk1.png"),
	loadImage("./images/sigmasmirk2.png"),
	loadImage("./images/sigmasmirk3.png")
}

creditbackground = loadImage("./images/creditbackground.png")
credittext = loadImage("./images/credittext.png")

animated = animatedImage(sigmaanimation, 3, 0.5)
end


local bytetable = {
0x00, 0x02, 0x02, 0x02, 0x071, 0xD1, 0x0E, 0x00, 0x78, 0x01, 0x15, 0x00, 0x10, 0xFB, 0x81, 0x00, 0x00, 0x29, 0x04, 0x04, 0xC9, 0xB3, 0x22, 0x8C, 0x60, 0x00, 0x86, 0xFE, 0x00, 0xFC, 0x00, 0x03, 0x2E, 0xCA, 0xD1, 0x0E, 0x78, 0x01, 0x02, 0x02, 0x03, 0x00, 0x13, 0x04, 0x00, 0x05, 0x06, 0xFF, 0x00, 0x00, 0x00, 0x08, 0x00, 0x01, 0x80, 0x01, 0x02, 0x02, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
}

local fade = 0xF
local framecounter = 0
local startedDeath = false
local exitMenuPressStart = { start = true }
local exitMenuPressRight = { right = true }
local imagesloaded = false

function DrawGUIOverlay()
	--Had to check for loaded images here as loading them at script start was failing, bug with c++ functions and lua at init
	if imagesloaded == false then
		loadImages()
		imagesloaded = true
	end
	--Draw weapons
	local weaponCount = 0
	
	for i = 1, 8 do
		if weapons[myweapons[i]] then
		
			gui.gdoverlay(i*16, 207, weaponIcons[i], 0, 0, 256, 224 , 1.0)
			weaponCount = weaponCount + 1
		else
			gui.gdoverlay(i*16, 207, weaponuIcons[i], 0, 0, 256, 224 , 1.0)
		end
	end
    
	--If we have hado, stop drawing hearts/subtanks
	if not upgrades.hado or locations.sigma < 2 then
		--Draw hearts  
		for i = 1, 8 do
			if hearts[myhearts[i]] then
				gui.gdoverlay( i * 16, 199, heartIcon, 0, 0, 256, 224 , 1.0)
			end
		end
		
		--Draw subtanks
		for i = 1, 4 do
			if tanks[mytanks[i]] then
				gui.gdoverlay( ((i + 2) * 16) + 8, 199, etankIcon, 0, 0, 256, 224 , 1.0)
			end
		end
	end
	
	--Draw Current Sigma
	if weaponCount == 8 and locations.sigma == 0 then 
		gui.gdoverlay(146, 207, sigmaIcons[locations.sigma + 1], 0, 0, 256, 224 , 1.0)
	elseif locations.sigma > 0 then
		gui.gdoverlay(146, 207, sigmaIcons[locations.sigma + 1], 0, 0, 256, 224 , 1.0)
	end
	
	--Draw Current Upgrades
	for i = 1, 4 do
		if upgrades[myupgrades[i]] then
			gui.gdoverlay(148 + (i * 16), 207, upgradeIcons[i], 0, 0, 256, 224 , 1.0)
		else
			gui.gdoverlay(148 + (i * 16), 207, upgradeuIcons[i], 0, 0, 256, 224 , 1.0)
		end
	end
	
	--Draw Hado upgrade over helmet if we have it
	if upgrades[myupgrades[5]] then
		gui.gdoverlay(180, 207, upgradeIcons[5], 0, 0, 256, 224 , 1.0)
	end
	
	--Reads selected weapon every frame (multiple of 2 so divided by two for 1 - 8)
	--Then draws a box around the icons
	selectedWeapon = memory.readbyte(0x7E0BDB) / 2
	if selectedWeapon ~= 0 then
		gui.box(selectedWeapon * 16 + 1, 208, (selectedWeapon * 16) + 16, 223, "#FFFFFF00", "#FFFF00FF")
	end
	
	--Draw partner location
	if locations.partnerlocation > 0 and locations.partnerlocation < 10 then
		gui.gdoverlay(locations.partnerlocation * 16, 216, oneupIcon, 0, 0, 256, 224 , 1.0)
	end
	
	if opts.hpshare then
		
		soulLink.recentFrames = soulLink.recentFrames + 1
		
		xhp = memory.readbyte(0x7E0BCF)
		if xhp > hearts.maxlife then
			xhp = hearts.maxlife
		end
		
		if soulLink.dying == true then
			SoulLinkDeath()
		end		
		
		
		local tanks = (hearts.maxlife - 16) / 2 
		
		--print(tanks)
		
		
		--Draws all stages of the health bar
		gui.gdoverlay(8, 78, soulLink["bottom"], 0, 0, 256, 224 , 1.0) --Bottom Section
		
		for j = 1, 8 do
			gui.gdoverlay(8, 79 - (j * 4), soulLink["middle"], 0, 0, 256, 224 , 1.0) -- Original Bar
		end
		
		for j = 1, tanks do
			gui.gdoverlay(8, 47 - (j * 4), soulLink["middle"], 0, 0, 256, 224 , 1.0) --Any additional bar from tanks
		end
		
		gui.gdoverlay(8, 43 - (tanks * 4), soulLink["top"], 0, 0, 256, 224 , 1.0) --Top Section
		
		for i = 1, xhp do
			gui.gdoverlay(12, 79 - (i * 2), soulLink["dash"], 0, 0, 256, 224 , 1.0) --HP Dashes
		end
	end
	
	if(gamefinished) then
		scrollCredits()
	end
end



function animateIcon(icon, offx, offy, transparent)
	
	if icon.animationTimer >= icon.frameCount then
		icon.index = icon.index + 1
		if icon.index > icon.maxFrames then
			icon.index = 1
		end
		
		icon.animationTimer = 1
	end
	
	gui.gdoverlay(offx, offy, icon.images[icon.index], 0, 0, 256, 224 , 1.0)

	icon.animationTimer = icon.animationTimer + 1
end		


function SoulLinkDeath()
	--print("State: " .. memory.readbyte(0x7E0C32))
	--memory.readbyte(0x7E1F13) --Turns to 1 if screen is frozen for doors/health etc
	if not startedDeath and (memory.readbyte(0x7E0C32) == 8 or memory.readbyte(0x7E0C32) == 1 or memory.readbyte(0x7E0C32) == 2 or memory.readbyte(0x7E1F13) == 1) then --if we are in iframes, recovering
		return --wait
	elseif not startedDeath and memory.readbyte(0x7E1F10) == 6 then --we are in the weapon select menu
		print("Getting you out of that menu, sorry")
		soulLink.recentFrames = 0
		if (soulLink.recentFrames % 2 == 0) then 
			joypad.set(1, exitMenuPressStart)
		else
			joypad.set(1, exitMenuPressRight)
		end
		return --wait
	elseif not startedDeath and memory.readbyte(0x7E1F11) ~= 2 and soulLink.recentFrames < 120 then --count 120 frames before cancelling death
		return --wait
	elseif not startedDeath and memory.readbyte(0x7E1F11) ~= 2 then --if we are in anything other than normal state, cancel death
		print("State says you aren't in a stage, won't kill you: " .. memory.readbyte(0x7E1F11))
		soulLink.dying = false
		return
	else --otherwise let's die!
		startedDeath = true
	end 
	
	animateIcon(animated, 80, 60, "#000000")
	gui.text(60, 160, "Your soul linked partner has died!")
	
	if framecounter == 1 then
		memory.writebyte(0x7E0C13, 0) --Sets iframe count to 0
		memory.writebyte(0x7E125F, 0) --Sets c sting invuln count to 0
	end
	if framecounter < 15 then
		fade = fade - 1
		memory.writebyte(0x7E00B3, fade) --Writes current fade we want
	elseif framecounter == 15 then
		print("Killing X...")
		memory.writebyte(0x7E0BCF, 1) --Sets X's health
		--print("Iframe: " .. memory.readbyte(0x7E0C13) .. " State: " .. memory.readbyte(0x7E0C32))
		playerposx = memory.readword(0x7E0BAD)
		playerposy = memory.readword(0x7E0BB0)		
		
		for k = 1, 64 do
			memory.writebyte(0x7E0E68 + (k-1), bytetable[k])
		end
	
		memory.writeword(0x7E0E68 + 0x5, playerposx)
		memory.writeword(0x7E0E68 + 0x22, playerposx)
		
		memory.writeword(0x7E0E68 + 0x8, playerposy)
		memory.writeword(0x7E0E68 + 0x24, playerposy)
		
		memory.writeword(0x7E0E68, 0x01) --Activates enemy
	elseif framecounter == 210 then
		framecounter = 0
		fade = 0xF
		memory.writebyte(0x7E00B3, fade) --Incase for some reason fade isn't lifted, let us see again
		soulLink.dying = false
		startedDeath = false
		soulLink.recentFrames = 0
		return
	end
	framecounter = framecounter + 1
	
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
		DrawGUIOverlay()
		gui.text(5, 2, msg) --254-40
	end
end
