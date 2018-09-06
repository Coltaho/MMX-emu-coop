-- STOP! Are you about to edit this file?
-- If you change ANYTHING, please please PLEASE run the following script:
-- https://www.guidgenerator.com/online-guid-generator.aspx
-- and put in a new GUID in the "guid" field.

-- Author: Coltaho
-- Data source: http://tasvideos.org/GameResources/SNES/MegaManX/RAMMap.html
-- This file is available under Creative Commons CC0

local otherfullAmmo = 0x5C
local fullAmmo = 0xDC

return {
	guid = "048ef982-791a-4e13-b2ae-0093e9e5d791",
	format = "1.14",
	name = "ROCKMAN X",
	match = {"stringtest", addr=0xFFC0, value="ROCKMAN X"},

	--recieving = {"test", addr = 0x7E0B9D, values = {0xFF}},
	running = {"test", addr = 0x7E003B, values = {0x0}}, --Intro demo is playing if this is 2, counts down on intro select screen
	sync = {
		[0x7E1F7B] = {kind=function(value, previousValue, receiving)
						allow = false
						if value > 0 and value < 4 and value > previousValue and receiving then
							message("Partner beat Sigma Stage " .. value)
							allow = true
						elseif value == 4 and value > previousValue and receiving then
							message("Partner finished the game!")
						elseif value > previousValue then
							allow = true
						end
						if value == 4 and not receiving then
							gamefinished = true
						end
						locations.sigma = value
						return allow, value
					end}, --Unlocked Sigma Stage
		[0x7E0BCF] = {kind=function(value, previousValue, receiving)
						allow = false
						if (opts.hpshare and value ~= previousValue) then
							if value > 32 or soulLink.dying == true then
								allow = false
							elseif receiving and value == 0 then
								if soulLink.recentFrames > 400 then
									soulLink.dying = true
									print("We are gonna die!")
								end
							elseif not receiving and memory.readbyte(0x7E1F11) ~= 2 then
								allow = false
							elseif not receiving and memory.readbyte(0x7E1F11) == 2 and memory.readbyte(0x7E00B3) ~= 0xF then
								--print("Screen fade at: " .. memory.readbyte(0x7E00B3))
								allow = false
							else
								allow = true 
								print("Health Sync Event")
							end
						end
						return allow, value
					end}, -- Current Health
		[0x7E1F7A] = {kind=function(value, previousValue, receiving)
						if value == previousValue then return false end
						if value == 0x0 and memory.readbyte(0x7E1F9B) == 4 then
							--Intro is done but the game said our stage is the intro. WHAT? Ignore it...
							return false
						end
						if value == 0x0 and memory.readbyte(0x7E1F9B) == 0 and receiving then
							message("Partner entered Intro!")
						elseif value == 0x1 and receiving then
							message("Partner entered Launch Octopus Stage!")
						elseif value == 0x2 and receiving then
							message("Partner entered Sting Chameleon Stage!")
						elseif value == 0x3 and receiving then
							message("Partner entered Armored Armadillo Stage!")
						elseif value == 0x4 and receiving then
							message("Partner entered Flame Mammoth Stage!")
						elseif value == 0x5 and receiving then
							message("Partner entered Storm Eagle Stage!")
						elseif value == 0x6 and receiving then
							message("Partner entered Spark Mandrill Stage!")
						elseif value == 0x7 and receiving then
							message("Partner entered Boomer Kuwanger Stage!")
						elseif value == 0x8 and receiving then
							message("Partner entered Chill Penguin Stage!")
						elseif value == 0x9 and receiving then
							message("Partner entered Sigma Stage 1!")
						elseif value == 0xA and receiving then
							message("Partner entered Sigma Stage 2!")
						elseif value == 0xB and receiving then
							message("Partner entered Sigma Stage 3!")
						elseif value == 0xC and receiving then
							message("Partner entered Sigma Stage 4!")
						end
						if receiving then
							locations.partnerlocation = value
							return false
						else
							return true
						end
					end}, --Let partner know where you be at using the current stage value
		[0x7E1F7C] = {kind="high"}, --Sigma 1 zero intro value
		[0x7E1F7D] = {kind="high"}, --Sigma 1 vile/zero dead value
		[0x7E1F7E] = {kind=function(value, previousValue, receiving)
						if value >= 128 and receiving then
							message("Partner got Hadouken!")
							upgrades.hado = true
						elseif value >= 128 and not receiving then
							message("You got Hadouken!")
							upgrades.hado = true
						elseif value > previousValue and receiving then
							message("Partner visited Hadouken time #" ..value)
						elseif value > previousValue and not receiving then
							message("You visited Hadouken time #" ..value)
						end
						return value > previousValue, value
					end}, --Hado Visits, turns to 128 + visit count when gotten
		[0x7E1F80] = {kind=function(value, previousValue, receiving)
						allow = value ~= previousValue
						if value > previousValue and (value + previousValue ~= 2) and receiving then
							message("Partner got an extra life! (Current: " ..value.. ")")
						elseif value > previousValue and (value + previousValue == 2) and receiving then
							message("Partner gameovered! Lives back to 2!")
						elseif value < previousValue and receiving then
							message("Partner died horribly! (Current: " ..value.. ")")
						end
						return allow, value
					end}, --Extra lives
		[0x7E1F83] = {kind=function(value, previousValue)
						allow=false
						if value > 1 and previousValue == 0 then
							allow=true
						end
						return allow, value
					end}, --Sub Tank
		[0x7E1F84] = {kind=function(value, previousValue)
						allow=false
						if value > 1 and previousValue == 0 then
							allow=true
						end
						return allow, value
					end}, --Sub Tank
		[0x7E1F85] = {kind=function(value, previousValue)
						allow=false
						if value > 1 and previousValue == 0 then
							allow=true
						end
						return allow, value
					end}, --Sub Tank
		[0x7E1F86] = {kind=function(value, previousValue)
						allow=false
						if value > 1 and previousValue == 0 then
							allow=true
						end
						return allow, value
					end}, --Sub Tank
		[0x7E1F9A] = {kind=function(value, previousValue)
						allow=false
						if value > previousValue then
							hearts.maxlife = value
							allow = true
						end
						return allow, value
					end}, --Max health
		[0x7E1F9B] = {kind="high"}, --Intro Done
		[0x7E1F99] = {nameBitmap={"Head (Butt) Upgrade", "Arm (Buster) Upgrade", "Body (Armor) Upgrade", "Boots (Dash) Upgrade", "Eagle Sub-tank", "Armadillo Sub-tank", "Mandrill Sub-tank", "Mammoth Sub-tank"}, kind="bitOr"},		--Upgrade and subtank bitflag
		[0x7E1F9C] = {nameBitmap={"Penguin Heart", "Armadillo Heart", "Eagle Heart", "Chameleon Heart", "Mammoth Heart", "Kuwanger Heart", "Mandrill Heart", "Octopus Heart"}, kind="bitOr"}, --Heart Container bitflag
		[0x7E1F88] = {verb="killed", name="Octopus (got Homing T.)", kind=function(value, previousValue)
						allow=false
						if value > 1 and previousValue == 0 then
							allow=true
							weapons.homing = true
						end
						return allow, otherfullAmmo
					end},
		[0x7E1F8A] = {verb="killed", name="Chameleon (got C. Sting)", kind=function(value, previousValue)
						allow=false
						if value > 20 and previousValue == 0 then
							allow=true
							weapons.sting = true
						end
						return allow, fullAmmo
					end},
		[0x7E1F8C] = {verb="killed", name="Armadillo (got R. Shield)", kind=function(value, previousValue)
						allow=false
						if value > 20 and previousValue == 0 then
							allow=true
							weapons.shield = true
						end
						return allow, otherfullAmmo
					end},
		[0x7E1F8E] = {verb="killed", name="Mammoth (got Fire W.)", kind=function(value, previousValue)
						allow=false
						if value > 20 and previousValue == 0 then
							allow=true
							weapons.fire = true
						end
						return allow, fullAmmo
					end},
		[0x7E1F90] = {stype="gui", verb="killed", name="Eagle (got Storm T.)", kind=function(value, previousValue)
						allow=false
						if value > 20 and previousValue == 0 then
							allow=true
							weapons.storm = true
						end
						return allow, fullAmmo
					end},
		[0x7E1F92] = {verb="killed", name="Mandrill (got E. Spark)", kind=function(value, previousValue)
						allow=false
						if value > 20 and previousValue == 0 then
							allow=true
							weapons.spark = true
						end
						return allow, fullAmmo
					end},
		[0x7E1F94] = {verb="killed", name="Kuwanger (got B. Cutter)", kind=function(value, previousValue)
						allow=false
						if value > 20 and previousValue == 0 then
							allow=true
							weapons.cutter = true
						end
						return allow, fullAmmo
					end},
		[0x7E1F96] = {verb="killed", name="Penguin (got S. Ice)", kind=function(value, previousValue)
						allow=false
						if value > 20 and previousValue == 0 then
							allow=true
							weapons.ice = true
						end
						return allow, fullAmmo
					end},
	}
}
