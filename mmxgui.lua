local t = 0
local tt = 0


local gamefinished = false
local pauseframes = 120
local pos = 920
function DrawGUI()

button = joypad.getdown(1)

if(gamefinished) then
	gui.gdoverlay(0, 0, t, 0, 0, 256, 224 , 1.0)
	
	gui.gdoverlay(0, pos/4, tt, 0, 0, 256, 500 , 1.0)
	
	pos = pos - 1
	
	if(pos <= -1104 and pauseframes > 0) then
		pos = -1104
		pauseframes = pauseframes - 1
	elseif(pauseframes <= 0) then
		gamefinished = false
	end
	print(pos)
end

if(button["Y"]) then
t = gui.gdcreateimagestring("./images/creditbackground.png")
tt = gui.gdcreateimagestring("./images/credittext.png")
pos = 920
gamefinished = true
end

if(button["G"]) then
gui.gdcreateimage("./images/homing.png","./images/homing.gdimage")
gui.gdcreateimage("./images/sting.png","./images/sting.gdimage")
gui.gdcreateimage("./images/shield.png","./images/shield.gdimage")
gui.gdcreateimage("./images/fire.png","./images/fire.gdimage")
gui.gdcreateimage("./images/storm.png","./images/storm.gdimage")
gui.gdcreateimage("./images/spark.png","./images/spark.gdimage")
gui.gdcreateimage("./images/cutter.png","./images/cutter.gdimage")
gui.gdcreateimage("./images/ice.png","./images/ice.gdimage")
gui.gdcreateimage("./images/homingu.png","./images/homingu.gdimage")
gui.gdcreateimage("./images/stingu.png","./images/stingu.gdimage")
gui.gdcreateimage("./images/shieldu.png","./images/shieldu.gdimage")
gui.gdcreateimage("./images/fireu.png","./images/fireu.gdimage")
gui.gdcreateimage("./images/stormu.png","./images/stormu.gdimage")
gui.gdcreateimage("./images/sparku.png","./images/sparku.gdimage")
gui.gdcreateimage("./images/cutteru.png","./images/cutteru.gdimage")
gui.gdcreateimage("./images/iceu.png","./images/iceu.gdimage")
gui.gdcreateimage("./images/one.png","./images/one.gdimage")
gui.gdcreateimage("./images/two.png","./images/two.gdimage")
gui.gdcreateimage("./images/three.png","./images/three.gdimage")
gui.gdcreateimage("./images/four.png","./images/four.gdimage")
gui.gdcreateimage("./images/five.png","./images/five.gdimage")
gui.gdcreateimage("./images/etank.png","./images/etank.gdimage")
gui.gdcreateimage("./images/heart.png","./images/heart.gdimage")
gui.gdcreateimage("./images/oneup.png","./images/oneup.gdimage")
gui.gdcreateimage("./images/boots.png","./images/boots.gdimage")
gui.gdcreateimage("./images/helmet.png","./images/helmet.gdimage")
gui.gdcreateimage("./images/body.png","./images/body.gdimage")
gui.gdcreateimage("./images/arm.png","./images/arm.gdimage")
gui.gdcreateimage("./images/hado.png","./images/hado.gdimage")
gui.gdcreateimage("./images/bootsu.png","./images/bootsu.gdimage")
gui.gdcreateimage("./images/helmetu.png","./images/helmetu.gdimage")
gui.gdcreateimage("./images/bodyu.png","./images/bodyu.gdimage")
gui.gdcreateimage("./images/armu.png","./images/armu.gdimage")
gui.gdcreateimage("./images/hpdash.png","./images/hpdash.gdimage")
gui.gdcreateimage("./images/hpbackgroundbottom.png","./images/hpbackgroundbottom.gdimage")
gui.gdcreateimage("./images/hpbackgroundtop.png","./images/hpbackgroundtop.gdimage")
gui.gdcreateimage("./images/hpbackgroundmiddle.png","./images/hpbackgroundmiddle.gdimage")
gui.gdcreateimage("./images/sigmasmirk1.png","./images/sigmasmirk1.gdimage")
gui.gdcreateimage("./images/sigmasmirk2.png","./images/sigmasmirk2.gdimage")
gui.gdcreateimage("./images/sigmasmirk3.png","./images/sigmasmirk3.gdimage")
gui.gdcreateimage("./images/creditbackground.png","./images/creditbackground.gdimage")
gui.gdcreateimage("./images/credittext.png","./credittext.gdimage")
	print("DONE")
end


end


gui.register(DrawGUI)