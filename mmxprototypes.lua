local shotsFired = 0

local firedData = {
{name = "Lemon", shots = 0},
{name = "Green", shots = 0},
{name = "Unknown", shots = 0},
{name = "Blue", shots = 0},
{name = "Hadouken", shots = 0},
{name = "Unknown", shots = 0},
{name = "Unknown", shots = 0},
{name = "Homing.T", shots = 0},
{name = "C.Sting", shots = 0},
{name = "R.Shield", shots = 0},
{name = "Fire.W", shots = 0},
{name = "Storm.T", shots = 0},
{name = "E.Spark", shots = 0},
{name = "E.Cutter", shots = 0},
{name = "S.Ice", shots = 0},
{name = "Unknown", shots = 0},
{name = "Homing.T Charged", shots = 0},
{name = "C.Sting Charged", shots = 0},
{name = "R.Shield Charged", shots = 0},
{name = "Fire.W Charged", shots = 0},
{name = "Storm.T Charged", shots = 0},
{name = "E.Spark Charged", shots = 0},
{name = "E.Cutter Charged", shots = 0},
{name = "S.Ice Charged", shots = 0},
{name = "Unknown", shots = 0},
{name = "Unknown", shots = 0},
{name = "Unknown", shots = 0},
{name = "Unknown", shots = 0},
{name = "Unknown", shots = 0},
{name = "Purple", shots = 0}
}

local dashCount = 0

local busterTable = {
{active = false, value = 0, bullet = 0 },
{active = false, value = 0, bullet = 0 },
{active = false, value = 0, bullet = 0 },
{active = false, value = 0, bullet = 0 },
{active = false, value = 0, bullet = 0 },
{active = false, value = 0, bullet = 0 },
{active = false, value = 0, bullet = 0 },
{active = false, value = 0, bullet = 0 }
}


local jumpActive = false
local jumpCount = 0

function DrawGUI()

	local dashTimer = memory.readbyte(0x7E0BFA)
	local xSprite = memory.readbyte(0x7E0BBF)
	
	if dashTimer == 30 and xSprite == 55 then
		dashCount = dashCount + 1
	end
	
	if not jumpActive and xSprite == 25 then
		jumpActive = true
		jumpCount = jumpCount + 1
	elseif jumpActive and xSprite == 28 then
		jumpActive = false
	end
	

--Tracks bullets as they fire
	for i = 1,8 do --There is 8 ammo data slots
		local address = 0x7E1228 + ( (i-1) * 64 )
		busterTable[i].value = memory.readbyte(address)
		busterTable[i].bullet = memory.readbyte(address + 0x0A)
		
		---Lemons, Greens, Blues, Purples
		if busterTable[i].active == false and busterTable[i].value == 1 then -- and busterTable[i].bullet == 0 then -- Normal shots
			firedData[busterTable[i].bullet+1].shots = firedData[busterTable[i].bullet+1].shots + 1
			busterTable[i].active = true
		end
		
		if busterTable[i].active == true and busterTable[i].value == 0 then -- resets the counter once the bullet has dissapeared
			busterTable[i].active = false
		end
	end
-------------------------------



------------------counts the total amount of shots from individual data
shotsFired = 0
for k = 1, 30 do
	if k ~= 3 then -- particles of purple charge we do not want to count
	
		if k == 11 then --Fire Wave shoots 30 shots in a second. Tracking it by seconds used
			shotsFired = math.ceil(shotsFired + firedData[k].shots / 30)
		elseif k == 17 then --Charge Homing created 5 shots
			shotsFired = math.ceil(shotsFired + firedData[k].shots / 5)
		elseif k == 9 then --Sting creates 4 shots
			shotsFired = math.ceil(shotsFired + firedData[k].shots / 4)
		elseif k == 21 then --Charged Storm creates 2 shots
			shotsFired = math.ceil(shotsFired + firedData[k].shots / 2)
		elseif k == 22 then --Charged Spark creates 2 shots
			shotsFired = math.ceil(shotsFired + firedData[k].shots / 2)
		elseif k == 23 then --Charged Cutter creates 4 shots
			shotsFired = math.ceil(shotsFired + firedData[k].shots / 4)
		else
			shotsFired = shotsFired + firedData[k].shots
		end
	end
end





input = joypad.get(1)

if(input["select"]) then
	
	local x = 183
	local y = 50
	
	
	gui.text(x, 2,  firedData[1].name .. ": " .. firedData[1].shots, "#FFFF00", "#000000")
	gui.text(x, 10, firedData[2].name .. ": " .. firedData[2].shots, "#FFFF00", "#000000")
	gui.text(x, 18, firedData[4].name .. ": " .. firedData[4].shots, "#FFFF00", "#000000")
	gui.text(x, 26, firedData[30].name .. ": " .. firedData[30].shots, "#FFFF00", "#000000")
	gui.text(x, 34, firedData[5].name .. ": " .. firedData[5].shots, "#FFFF00", "#000000")
	gui.text(x, 42, "----------", "#FFFF00", "#000000")
	
	
	
	for k = 8, 15 do
		local shot = firedData[k].shots
		local cshot = firedData[k+9].shots
		
		if k == 11 then
			shot = math.ceil(shot / 30)
		elseif k+9 == 17 then --Charge Homing created 5 shots
			cshot = math.ceil(cshot / 5)
		elseif k == 9 or k+9 == 23 then --Sting & Charged Cutter creates 4 shots
			cshot = math.ceil(cshot / 4)
		elseif k+9 == 21 or k+9 == 22 then --Charged Storm & Charged Spark creates 2 shots
			cshot = math.ceil(cshot / 2)
		end
		gui.text(x, y, firedData[k].name .. ": " .. shot .. " (" .. cshot .. ")", "#FFFF00", "#000000")
		y = y + 8
	end
	
	gui.text(x, y, "----------", "#FFFF00", "#000000")
	y = y + 8
	
	gui.text(x, y, "Total Shots: " .. shotsFired, "#FFFF00", "#000000")
	y = y + 8
	gui.text(x, y, "----------", "#FFFF00", "#000000")
	y = y + 8
	gui.text(x, y, "Dashes: " .. dashCount, "#FFFF00", "#000000")
	y = y + 8
	gui.text(x, y, "Jumps: " .. jumpCount, "#FFFF00", "#000000")
	
end

end

gui.register(DrawGUI)
