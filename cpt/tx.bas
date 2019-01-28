setfreq m32

symbol tx = b.7
symbol val = w0
symbol steer = w2
symbol xin = c.1
symbol yin = c.2

main:
readadc10 xin, steer
readadc10 yin, val

'sertxd(#steer,cr,lf)

if val < 400 then
	serout tx, t19200_32, (1)
	sertxd("Back ", "1",cr,lf)
else if val > 600 then
	serout tx, t19200_32, (2)
	sertxd("Fwd ", "2",cr,lf)
else if val >= 380 AND val <= 620 then
	serout tx, t19200_32, (3)
	sertxd("Stp ", "3",cr,lf)
end if

if steer < 400 then
	serout tx, t19200_32, (4)
	sertxd("left ", "4",cr,lf)
else if steer > 600 then
	serout tx, t19200_32, (5)
	sertxd("right ", "5",cr,lf)
else if steer >= 380 AND steer <= 620 then
	serout tx, t19200_32, (6)
	sertxd("straight ", "6",cr,lf)
end if

pause 1000

goto main