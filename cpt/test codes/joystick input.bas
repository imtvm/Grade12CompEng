#picaxe 20m2

symbol xval = w0
symbol xin = b.5
symbol yin = b.6
symbol sw = pinb.7
symbol xled = c.2
symbol revMax = 502
symbol duty_cycle = b6

symbol swled = c.0

init:
low swled

main:
readadc xin, xval

sertxd("X: ", #xval, cr,lf)
duty_cycle = speed_val - rev_max * 21 / 10 MAX 1023

pwmout xled, 99, dutyCycle


goto main