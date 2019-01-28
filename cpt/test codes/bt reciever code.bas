#picaxe 08m
setfreq m8

main:
symbol serdata = b0
symbol LED = c.1
low LED
serin c.4, n4800_8, #serdata
sertxd (#serdata, cr,lf)

if serdata = 8 then
	high led
else
	low led
end if

serdata = 0

goto main