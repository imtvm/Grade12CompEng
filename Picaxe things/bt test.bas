symbol btn = pinB.4
symbol led = C.2
symbol tx = B.7
symbol rx = B.5
symbol com = w0

init:
low led
high tx

main:

if btn = 1 then
	serout tx, 9600, ("1")
end if

serin [150], rx, 9600, com

if com = "1" then
	high led
else
	low led
end if

goto main
