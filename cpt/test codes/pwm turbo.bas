symbol btn1 = pinc.5
symbol btn2 = pinc.4

init:
high c.2
low c.1

pwmout c.2, 99, 200

main:

if btn1 = 1 AND btn2 = 1 then
	pwmout c.2, 99, 500
else
	pwmout c.2, 99, 200
end if

goto main
