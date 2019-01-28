'Robot
'Author: Tyler Vergis-Mayo
'Code Completed On: mm/dd/yyyy

#picaxe 20m2
setfreq m32

symbol servoDir = b0
symbol wheelDir = b1
symbol speed = b2

symbol rmb = b.7
symbol rmf = b.4
symbol lmb = b.6
symbol lmf = b.5

symbol lpwm = c.2
symbol rpwm = c.3

symbol rx = c.4
symbol state = pinc.7

symbol servotx = c.5 

init:
low rmb, rmf, lmb, lmf

pwmout lpwm, 49, 0
pwmout rpwm, 49, 0

main:


	if state = 1 then
		low rmb, rmf, lmb, lmf
		pause 10000
		goto main
	end if
	
	
	serin  rx, T19200_32,("data"),speed,wheelDir,servoDir
	sertxd("Speed: ", #speed, "Wheel Dir. ", #wheelDir, "servoDir", #servoDir, cr,lf)
	if wheelDir="F" then
		goto FWD
	elseif wheelDir="R" then
		goto BACK
	endif
	

FWD:

select speed
	
case 0
	pwmout lpwm, 49, 0
	pwmout rpwm, 49, 0
case 1
	pwmout lpwm, 49, 110
	pwmout rpwm, 49, 110
case 2
	pwmout lpwm, 49, 220
	pwmout rpwm, 49, 220
case 3
	pwmout lpwm, 49, 330
	pwmout rpwm, 49, 330
case 4
	pwmout lpwm, 49, 440
	pwmout rpwm, 49, 440
case 5
	pwmout lpwm, 49, 550
	pwmout rpwm, 49, 550
case 6
	pwmout lpwm, 49, 660
	pwmout rpwm, 49, 660
case 7
	pwmout lpwm, 49, 770
	pwmout rpwm, 49, 770
case 8
	pwmout lpwm, 49, 880
	pwmout rpwm, 49, 880
case 9
	pwmout lpwm, 49, 1023
	pwmout rpwm, 49, 1023
	
end select

if servoDir="R" then
	serout servotx, t19200_32,("data", "R")
	high lmf
	low rmf
elseif servoDir="L" then
	serout servotx, t19200_32,("data", "L")
	high rmf
	low lmf
else
	serout servotx, t19200_32,("data", "S")
	high lmf, rmf
endif

goto main

BACK:

select speed
	
case 0
	pwmout lpwm, 49, 0
	pwmout rpwm, 49, 0
case 1
	pwmout lpwm, 49, 110
	pwmout rpwm, 49, 110
case 2
	pwmout lpwm, 49, 220
	pwmout rpwm, 49, 220
case 3
	pwmout lpwm, 49, 330
	pwmout rpwm, 49, 330
case 4
	pwmout lpwm, 49, 440
	pwmout rpwm, 440
case 5
	pwmout lpwm, 49, 550
	pwmout rpwm, 49, 550
case 6
	pwmout lpwm, 49, 660
	pwmout rpwm, 49, 660
case 7
	pwmout lpwm, 49, 770	
	pwmout rpwm, 49, 770
case 8
	pwmout lpwm, 49, 880	
	pwmout rpwm, 49, 880	
case 9
	pwmout lpwm, 49, 1023
	pwmout rpwm, 49, 1023
	
end select

if servoDir="R" then
	serout servotx, t19200_32,("data", "R")
	low rmf, lmf
	high lmb
elseif servoDir="L" then
	serout servotx, t19200_32,("data", "L")
	low rmf, lmf
	high rmb
else
	serout servotx, t19200_32,("data", "S")
	low rmf, lmf
	high rmb, lmb
endif

goto main


