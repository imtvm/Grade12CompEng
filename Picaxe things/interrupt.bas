setint %00010000, %00010000, C
symbol num = b0

main:
tune b.4, 4,($65,$65,$65,$EA,$C5,$43,$42,$40,$CA,$05,$43,$42,$40,$CA,$05,$43,$42,$43,$C0,$2C,$65,$65,$65,$EA,$C5,$43,$42,$40,$CA,$05,$43,$42,$40,$CA,$05,$43,$42,$43,$C0)
pause 500
goto main

interrupt:
for num = 1 to 5
	pause 200
	high b.0
	pause 200
	low b.0
	pause 200
	high b.1
	pause 200
	low b.1
	pause 200
	high b.2
	pause 200
	low b.2
next num
setint %00010000, %00010000, C
return