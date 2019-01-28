#picaxe 08m
setfreq m8

main:

if pinc.3 = 1 then
	serout c.2, n4800_8, (1)
else
	serout c.2, n4800_8, (0)
end if
goto main