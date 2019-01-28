#picaxe 20m2

init:
symbol test = w0
high c.2
low c.1

main:
for test = 150 to 500
	pwmout C.2, 99, test
	pause 10
next test

for test = 500 to 150 step -1
	pwmout C.2, 99, test
	pause 10
next test
goto main
