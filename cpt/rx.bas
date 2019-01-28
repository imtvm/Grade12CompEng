setfreq m32

symbol rx = b.7
symbol tx = b.6
symbol val = b1
symbol steer = b2
symbol buffer = b3
symbol state = pinc.0

symbol buzzer = B.5 'Assigns the buzzer to the pin B.4
symbol speed = 4 'The Speed that the song is played

pwmout c.2, 39, 0 'left motor fwd
pwmout c.3, 39, 0 'left motor bck
pwmout c.5, 39, 0 'right motor fwd
pwmout B.1, 39, 0 'right motor bck

init:
gosub startUpSong

main:

val = ""
steer = ""

serin [100], rx, t19200_32, val, steer
'serin [100], rx, t19200_32, steer

'sertxd(#steer,cr,lf)
'sertxd(#val,cr,lf)

if val = 1 then
	sertxd("Back",cr,lf)
	pwmout c.3, 39, 158 'left motor bck
	pwmout B.1, 39, 158 'right motor bck
	pwmout c.2, 39, 0 'left motor fwd
	pwmout c.5, 39, 0 'right motor fwd
	'high c.3, b.5
	'low c.2, b.6
else if val = 2 then
	sertxd("Fwd",cr,lf)
	pwmout c.2, 39, 158 'left motor fwd
	pwmout c.5, 39, 158 'right motor fwd
	pwmout c.3, 39, 0 'left motor bck
	pwmout B.1, 39, 0 'right motor bck
	'low c.3, b.5
	'high c.2, b.6
else if val = 3 then
	sertxd("Stop",cr,lf)
	pwmout c.2, 39, 0 'left motor fwd
	pwmout c.5, 39, 0 'right motor fwd
	pwmout c.3, 39, 0 'left motor bck
	pwmout B.1, 39, 0 'right motor bck
	'low c.2, c.3, b.5, b.6
end if

if steer = 4 then
	sertxd("Left",cr,lf)
	pwmout c.3, 39, 0 'left motor bck
	pwmout c.2, 39, 100 'right motor bck
	'serout tx, t19200_32, (4)
	'low c.2, c.3
else if steer = 5 then
	sertxd("Right",cr,lf)
	pwmout c.5, 39, 100 'left motor bck
	pwmout B.1, 39, 0 'right motor bck
	'serout tx, t19200_32, (5)
	'low b.5, b.6
else if steer = 6 then
	sertxd("Straight",cr,lf)
	'serout tx, t19200_32, (6)
end if

goto main

startUpSong: 'Plays the startup music
	
	tune buzzer, speed, ($65,$65,$C0,$C0,$43,$42,$65,$65,$C0,$C0) 'Plays the song when called
	
	return 'Returns from this sub-proceadure back to the proceadure that called it
