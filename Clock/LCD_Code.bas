pause 1000
setfreq m16
sertxd("STARTING PROGRAM", cr, lf)
#picaxe 28x2

dirsB = %00001111
hi2csetup i2cmaster, %11010000, i2cfast, i2cbyte
pause 40

sertxd("INITIALIZING VARIABLES AND OTHER INFO", cr, lf)

'Symbols for the pins on the HD44780
sertxd("1", cr, lf)
symbol LCD_ENABLE = c.7
symbol LCD_RS = c.6
symbol TIME_SET_BUTTON = pinc.0
symbol ALARM_SET_BUTTON = pina.2
symbol MP3_PLAYER_TX = a.3
symbol ALARM_TOGGLE = pinb.7
symbol incbutton = pinc.1
symbol decbutton = pinc.5
symbol TRC_INT = pinc.3
sertxd("2", cr, lf)
symbol outbyte = b0
symbol counter = b1
symbol bcdnum = b2
symbol nibblecount = b3

'Time Variables
sertxd("3", cr, lf)
symbol seconds = b4
symbol mins = b5
symbol hour = b6
symbol day = b7
symbol date = b8
symbol month = b9
symbol year = b10
symbol temp = b11
symbol hour12 = b24
symbol am_pm = b25
symbol bcdmax = b26
symbol bcdmin = b27
symbol work = b28
symbol ampm_bit = b29
symbol digit1 = b30
symbol digit2 = b31

'DS3231 Register Varibales
sertxd("4", cr, lf)
symbol controlE = b32
symbol controlF = b33
symbol mode_set = b34
mode_set = 0

'Set initial values for date and time
sertxd("5", cr, lf)
let seconds = $55
let mins = $59
let hour = %01110010
let day = $01
let date = $31
let month = $12
let year = $16

hi2cout 0, (seconds, mins, hour, day, date, month, year)
pause 10

'Store LCD Headings in EEPROM
sertxd("6", cr, lf)
eeprom 0, ("Time: ")
sertxd("0", cr, lf)
eeprom 12, ("Date: ")
sertxd("12", cr, lf)
eeprom 18, ("SET HOUR:")
sertxd("18", cr, lf)
eeprom 27, ("SET MINUTES:")
sertxd("27", cr, lf)
eeprom 39, ("SET SECONDS:")
sertxd("39", cr, lf)
eeprom 51, ("SET MONTH:")
sertxd("51", cr, lf)
eeprom 61, ("SET DAY:")
sertxd("61", cr, lf)
eeprom 69, ("SET YEAR:")
sertxd("69", cr, lf)
eeprom 78, ("SET AM/PM:")
sertxd("78", cr, lf)
eeprom 88, ("AM")
sertxd("88", cr, lf)
eeprom 90, ("PM:")
sertxd("90", cr, lf)
eeprom 93, ("SET ALARM (HR):") 
sertxd("93", cr, lf)
eeprom 108, ("SET ALARM (MIN):")
sertxd("108", cr, lf)

low LCD_ENABLE
sertxd("LOW LCD ENABLE", cr, lf)
low LCD_RS
sertxd("LOW REGISTER SELECT", cr, lf)

setint %00000000, %00000100, C
sertxd("SET INTERUPT AND PAUSE", cr, lf)
pause 100

'Initialization sequence for HD44780

sertxd("INITIALIZIONG HD44780", cr, lf)

for counter = 0 to 6
	lookup counter, ($33, $32, $28, $10, $01, $06, $0C), outbyte
	gosub WRITE_LCD_INST
	pause 40
next counter

'#################################################################################################################

main:

sertxd("ENTERING THE MAIN METHOD", cr, lf)

outbyte = $0C
gosub WRITE_LCD_INST

if TIME_SET_BUTTON = 1 then
	mode_set = 0
	gosub SET_TIME
elseif ALARM_SET_BUTTON = 1 then
	mode_set = 1
	gosub SET_ALARM
else
	gosub DISPLAY_TIME
end if

goto main

'#################################################################################################################

DISPLAY_TIME:

hi2cin 0, (seconds, mins, hour, day, date, month, year)

hour12 = hour & $1F
ampm_bit = hour & %00100000

if ampm_bit = 32 then
	low a.1
	high a.0
else
	high a.1
	low a.0
end if

outbyte = $80
gosub WRITE_LCD_INST

for counter = 0 to 5
	read counter, outbyte
	gosub WRITE_LCD_DATA
next counter

outbyte = $C0
gosub WRITE_LCD_INST

for counter = 12 to 16
	read counter, outbyte
	gosub WRITE_LCD_DATA
next counter

bcdtoascii seconds, b12, b13
bcdtoascii mins, b14, b15
bcdtoascii hour12, b16, b17
bcdtoascii date, b18, b19
bcdtoascii month, b20, b21
bcdtoascii year, b22, b23

outbyte = $86
gosub WRITE_LCD_INST

outbyte = b16
gosub WRITE_LCD_DATA

outbyte = b17
gosub WRITE_LCD_DATA

outbyte = ":"
gosub WRITE_LCD_DATA

outbyte = b14
gosub WRITE_LCD_DATA

outbyte = b15
gosub WRITE_LCD_DATA

outbyte = ":"
gosub WRITE_LCD_DATA

outbyte = b12
gosub WRITE_LCD_DATA

outbyte = b13
gosub WRITE_LCD_DATA

outbyte = $C6
gosub WRITE_LCD_INST

outbyte = b20
gosub WRITE_LCD_DATA

outbyte = b21
gosub WRITE_LCD_DATA

outbyte = "-"
gosub WRITE_LCD_DATA

outbyte = b18
gosub WRITE_LCD_DATA

outbyte = b19
gosub WRITE_LCD_DATA

outbyte = "-"
gosub WRITE_LCD_DATA

outbyte = b22
gosub WRITE_LCD_DATA

outbyte = b23
gosub WRITE_LCD_DATA

return

'#################################################################################################################

WRITE_LCD_INST:

low LCD_RS
outbyte = outbyte * 256 | outbyte / 16

for nibblecount = 1 to 2
	pinsB = outbyte
	pulsout LCD_ENABLE, 1
	pause 4
	outbyte = outbyte / 16
next nibblecount

return

'#################################################################################################################

WRITE_LCD_DATA:

high LCD_RS
outbyte = outbyte * 256 | outbyte / 16

for nibblecount = 1 to 2
	pinsB = outbyte
	pulsout LCD_ENABLE, 1
	pause 4
	outbyte = outbyte / 16
next nibblecount

return

'#################################################################################################################

SET_TIME:

outbyte = $01
gosub WRITE_LCD_INST

gosub SET_HOUR
gosub SET_MIN
gosub SET_SECONDS
gosub SET_MONTH
gosub SET_DATE
gosub SET_YEAR
gosub SET_AMPM

do while TIME_SET_BUTTON = 1 loop

outbyte = $0C
gosub WRITE_LCD_DATA

return

'#################################################################################################################

SET_HOUR:

do while TIME_SET_BUTTON = 1 or ALARM_SET_BUTTON = 1 loop

for counter = 18 to 26
	read counter, outbyte
	gosub WRITE_LCD_DATA
next counter

outbyte = $C0
gosub WRITE_LCD_INST
outbyte = $0f
gosub WRITE_LCD_INST

bcdtoascii hour12, digit1, digit2
gosub BCD2ASCII

bcdmax = 12:bcdmin = $01

do

outbyte = $C0
gosub WRITE_LCD_INST

if incbutton = 1 then
	bcdnum = hour & $1F
	gosub bcdinc
	hour = hour & $E0 | bcdnum
	
hour12 = bcdnum
bcdtoascii hour12, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while incbutton = 1 loop
end if

if decbutton = 1 then
	bcdnum = hour & $1F
	gosub bcddec
	hour = hour & $E0 | bcdnum
	
hour12 = bcdnum
bcdtoascii hour12, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while decbutton = 1 loop
end if

if TIME_SET_BUTTON = 1 or ALARM_SET_BUTTON = 1 then exit
loop

if mode_set = 0 then
	hi2cout $02, (hour)
elseif mode_set = 1 then
	hi2cout $09, (hour)
end if

return

'#################################################################################################################

SET_MIN:

do while TIME_SET_BUTTON = 1 or ALARM_SET_BUTTON = 1 loop

outbyte = $01
gosub WRITE_LCD_INST

for counter = 27 to 38
	read counter, outbyte
	gosub WRITE_LCD_DATA
next counter

outbyte = $C0
gosub WRITE_LCD_INST

outbyte = $0F
gosub WRITE_LCD_INST

bcdtoascii mins, digit1, digit2
gosub BCD2ASCII

bcdmax = $59:bcdmin = $00

do
	
outbyte = $C0
gosub WRITE_LCD_INST

if incbutton = 1 then
	bcdnum = mins
	gosub bcdinc
	mins = bcdnum
	
bcdtoascii mins, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while incbutton = 1 loop

end if

if decbutton = 1 then
	bcdnum = mins
	gosub bcddec
	mins = bcdnum
	
bcdtoascii mins, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while decbutton = 1 loop

end if

if TIME_SET_BUTTON = 1 or ALARM_SET_BUTTON = 1 then exit
loop

if mode_set = 0 then
	hi2cout $01, (mins)
elseif mode_set = 1 then
	hi2cout $08, (mins)
end if

return

'#################################################################################################################

SET_SECONDS:

do while TIME_SET_BUTTON = 1 or ALARM_SET_BUTTON = 1 loop

outbyte = $01
gosub WRITE_LCD_INST

for counter = 39 to 50
	read counter, outbyte
	gosub WRITE_LCD_DATA
next counter

outbyte = $C0
gosub WRITE_LCD_INST

outbyte = $0F
gosub WRITE_LCD_INST

bcdtoascii seconds, digit1, digit2
gosub BCD2ASCII

bcdmax = $59:bcdmin = $00

do

outbyte = $C0
gosub WRITE_LCD_INST

if incbutton = 1 then
	bcdnum = seconds
	gosub bcddec
	seconds = bcdnum

bcdtoascii seconds, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while decbutton = 1 loop
end if

if TIME_SET_BUTTON = 1 or ALARM_SET_BUTTON = 1 then exit
loop
if mode_set = 0 then
	hi2cout 0, (seconds)
elseif mode_set = 1 then
	hi2cout $07, (seconds)
end if

return

'#################################################################################################################

BCDINC:

bcdnum = bcdnum + 1
work = bcdnum & $0F

if work = 10 then
bcdnum = bcdnum + 6
endif

if bcdnum > bcdmax then
bcdnum = bcdmin
end if

return

'#################################################################################################################

BCDDEC:

if bcdnum = bcdmin then
bcdnum = bcdmax
else
bcdnum = bcdnum - 1
work = bcdnum & $0F
if work >= $0F then
bcdnum = bcdnum - 6
endif
end if

return

'#################################################################################################################

SET_MONTH:

do while TIME_SET_BUTTON = 1 loop

outbyte = $01
gosub WRITE_LCD_INST

for counter = 51 to 60
	read counter, outbyte
	gosub WRITE_LCD_DATA
next counter

outbyte = $C0
gosub WRITE_LCD_INST

outbyte = $0F
gosub WRITE_LCD_INST

bcdtoascii month, digit1, digit2
gosub BCD2ASCII

bcdmax = $12:bcdmin = $01

do

outbyte = $C0
gosub WRITE_LCD_INST

if incbutton = 1 then
	bcdnum = month
	gosub bcdinc
	month = bcdnum
	hi2cout 5, (month)

bcdtoascii month, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while incbutton = 1 loop
endif

if decbutton = 1 then
	bcdnum = month
	gosub bcddec
	month = bcdnum
	hi2cout 5, (month)
	
bcdtoascii month, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while decbutton = 1 loop
end if

if TIME_SET_BUTTON = 1 then exit
loop

return

'#################################################################################################################

SET_DATE:

do while TIME_SET_BUTTON = 1 loop

outbyte = $01
gosub WRITE_LCD_INST

for counter = 61 to 68
	read counter, outbyte
	gosub WRITE_LCD_DATA
next counter

outbyte = $C0
gosub WRITE_LCD_INST

outbyte = $0F
gosub WRITE_LCD_INST

bcdtoascii date, digit1, digit2
gosub BCD2ASCII

bcdmax = $31:bcdmin = $01

do

outbyte = $C0
gosub WRITE_LCD_INST

if incbutton = 1 then
	bcdnum = date
	gosub bcdinc
	date = bcdnum
	hi2cout 4, (date)
	
bcdtoascii date, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while incbutton = 1 loop
end if

if decbutton = 1 then
	bcdnum = date
	gosub bcddec
	date = bcdnum
	hi2cout 4, (date)
	
bcdtoascii date, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while decbutton = 1 loop
end if

if TIME_SET_BUTTON = 1 then exit
loop

return

'#################################################################################################################

SET_YEAR:

do while TIME_SET_BUTTON = 1 loop

outbyte = $01
gosub WRITE_LCD_INST

for counter = 69 to 77
	read counter, outbyte
	gosub WRITE_LCD_DATA
next counter

outbyte = $C0
gosub WRITE_LCD_INST

outbyte = $0F
gosub WRITE_LCD_INST

bcdtoascii year, digit1, digit2
gosub BCD2ASCII

bcdmax = $99:bcdmin = $00

do
	
outbyte = $C0
gosub WRITE_LCD_INST

if incbutton = 1 then
	bcdnum = year
	gosub bcdinc
	year = bcdnum
	hi2cout 6, (year)
	
bcdtoascii year, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while incbutton = 1 loop
end if

if decbutton = 1 then
	bcdnum = year
	gosub bcddec
	year = bcdnum
	hi2cout 6, (year)
	
bcdtoascii year, digit1, digit2
gosub BCD2ASCII

outbyte = $C0
gosub WRITE_LCD_INST

do while decbutton = 1 loop
end if

if TIME_SET_BUTTON = 1 then exit
loop

return

'#################################################################################################################

SET_AMPM:

do while TIME_SET_BUTTON = 1 or ALARM_SET_BUTTON = 1 loop

outbyte = $01
gosub WRITE_LCD_INST

for counter = 78 to 87
	read counter, outbyte
	gosub WRITE_LCD_DATA
next counter

outbyte = $C0
gosub WRITE_LCD_INST

outbyte = $0F
gosub WRITE_LCD_INST

if ampm_bit = 32 then
	for counter = 90 to 91
		read counter, outbyte
		gosub WRITE_LCD_DATA
	next counter
else
	for counter = 88 to 89
		read counter, outbyte
		gosub WRITE_LCD_DATA
	next counter
end if

bcdmax = $01:bcdmin = $00

do

outbyte = $C0
gosub WRITE_LCD_INST

if incbutton = 1 then
	bcdnum = hour & $20 / 32
	gosub bcdinc
	bcdnum = bcdnum * 32
	hour = hour & $DF | bcdnum
	
bcdtoascii bcdnum, digit1, digit2

if digit1 = $32 then
	for counter = 90 to 91
		read counter, outbyte
		gosub WRITE_LCD_DATA
	next counter
else
	for counter = 88 to 89
		read counter, outbyte
		gosub WRITE_LCD_DATA
	next counter
end if

outbyte = $C0
gosub WRITE_LCD_INST

do while incbutton = 1 loop
end if

if TIME_SET_BUTTON = 1 or ALARM_SET_BUTTON = 1 then exit
loop

if mode_set = 0 then
	hi2cout $02, (hour)
else if mode_set = 1 then
	hi2cout $09, (hour, $80)
end if

return

'#################################################################################################################

BCD2ASCII:

outbyte = digit1
gosub WRITE_LCD_DATA
outbyte = digit2
gosub WRITE_LCD_DATA

return

'#################################################################################################################

SET_ALARM:

outbyte = $01
gosub WRITE_LCD_INST

let controlE = %00000101
let controlF = %00000000
hi2cout $0E, (controlE, controlF)

gosub SET_HOUR
gosub SET_MIN
gosub SET_SECONDS
gosub SET_AMPM

do while ALARM_SET_BUTTON = 1 loop

return

'#################################################################################################################

Interrupt:
if pinC.2 = 0 then interrupt
sertxd("ENTERED INTERRUPT ROUTINE", cr, lf)

if ALARM_TOGGLE = 1 then
	serout MP3_PLAYER_TX, t9600_16, ($7E, $FF, $06, $0B, $00, $00, $00, $EF)
	pause 250
	serout MP3_PLAYER_TX, t9600_16, ($7E, $FF, $06, $09, $00, $00, $02, $EF)
	pause 250
	serout MP3_PLAYER_TX, t9600_16, ($7E, $FF, $06, $0F, $00, $01, $02, $EF)
	pause 250
end if

hi2cout $0E, (%00000100)
setint %00000000, %00000100, C

return