pause 100
setfreq m16		'set internal clock speed to 16MHz
#picaxe 28x2


dirsB=%00001111		'Set pin direction on PortB(b0-b3=OUTPUT, b4-b7=INPUT)
hi2csetup i2cmaster, %11010000, i2cfast, i2cbyte	'Initialize DS3231 RTC Module
pause 40

'###################Define Sysmbols for HD44780 pins

symbol LCD_ENABLE=c.7		'Enable pin on HD44780 LCD module
symbol LCD_RS=c.6			'Register Select pin on HD77480, HIGH=Data, LOW=Command
symbol TIME_SET_BUTTON=pinC.0
symbol ALARM_SET_BUTTON=pinA.2
symbol MP3_Player_TX=A.3
symbol ALARM_TOGGLE=pinB.7
symbol incbutton=pinc.1
symbol decbutton=pinc.5
symbol RTC_INT=pinc.3

symbol outbyte =b0
symbol counter = b1
symbol bcdnum = b2
symbol nibblecount=b3

'Time Variables
symbol seconds = b4
symbol mins = b5
symbol hour = b6
symbol day = b7
symbol date = b8
symbol month = b9
symbol year = b10
symbol temp = b11
symbol hour12=b24
symbol am_pm=b25
symbol bcdmax=b26
symbol bcdmin=b27
symbol work=b28
symbol ampm_bit=b29
symbol digit1=b30
symbol digit2=b31

'DS3231 Register Variables
symbol controlE=b32
symbol controlF=b33
symbol mode_set=b34
mode_set=0

'Set initial values for date and time
;let seconds = $55
;let mins = $59
;let hour = %01110010
;let day = $01
;let date = $31
;let month = $12
;let year = $16
;
;
;hi2cout 0, (seconds, mins, hour, day, date, month, year)	'write Time/Date values to registers
;pause 10

'store LCD headings in EEPROM
eeprom 0,("Time: ")
eeprom 12,("Date: ")
eeprom 18, ("SET HOUR:")
eeprom 27, ("SET MINUTES:")
eeprom 39, ("SET SECONDS:")
eeprom 51, ("SET MONTH:")
eeprom 61, ("SET DAY:")
eeprom 69, ("SET YEAR:")
eeprom 78, ("SET AM/PM:")
eeprom 88, ("AM")
eeprom 90, ("PM")
eeprom 92, ("SET ALARM (HR):")
eeprom 107, ("SET ALARM (MIN):")

LOW LCD_ENABLE
LOW LCD_RS

pause 100

'############Initialization sequence for HD44780 Module#############

for counter = 0 to 6
	lookup counter ,($33, $32, $28, $10, $01, $06, $0C), outbyte	
	gosub WRITE_LCD_INST
	pause 40
next counter

'#####################################################################

SETINT %00000000, %00000100, C	'set interrupt condition (LOW on pin c.2)
pause 100

main:

outbyte=$0C			'Turn off cursor
gosub write_lcd_inst


if TIME_SET_BUTTON=1 then 
	'sertxd("Set Time selected",cr,lf)
	mode_set=0		'Set for Time
	gosub SET_TIME
elseif ALARM_SET_BUTTON=1 then 
	'sertxd("Set Alarm selected",cr,lf)
	mode_set=1		'Set for Alarm
	gosub SET_ALARM
else
	gosub DISPLAY_TIME
end if

goto main

'############################################################
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


outbyte=$80
gosub WRITE_LCD_INST

for counter = 0 to 5
	read counter,outbyte
	gosub WRITE_LCD_DATA
next counter

outbyte=$C0
gosub WRITE_LCD_INST


for counter = 12 to 16
	read counter,outbyte
	gosub WRITE_LCD_DATA
next counter


bcdtoascii seconds, b12, b13
bcdtoascii mins, b14, b15
bcdtoascii hour12, b16, b17
bcdtoascii date, b18, b19
bcdtoascii month, b20, b21
bcdtoascii year, b22, b23

outbyte=$86	'Move cursor to Line 1 Position 6
gosub WRITE_LCD_INST

outbyte=b16
gosub write_lcd_data

outbyte=b17
gosub write_lcd_data

outbyte=":"
gosub write_lcd_data

outbyte=b14
gosub write_lcd_data

outbyte=b15
gosub write_lcd_data

outbyte=":"
gosub write_lcd_data

outbyte=b12
gosub write_lcd_data

outbyte=b13
gosub write_lcd_data

outbyte=$C6		'Move cursor to Line 2 Position 6
gosub WRITE_LCD_INST

outbyte=b20
gosub write_lcd_data

outbyte=b21
gosub write_lcd_data

outbyte="-"
gosub write_lcd_data

outbyte=b18
gosub write_lcd_data

outbyte=b19
gosub write_lcd_data

outbyte ="-"
gosub write_lcd_data

outbyte=b22
gosub write_lcd_data

outbyte=b23
gosub write_lcd_data

return

'############################################################################

WRITE_LCD_INST:	'Write Commands to LCD

low LCD_RS
outbyte=outbyte * 256 | outbyte / 16

for nibblecount= 1 to 2
	'pinsB=outbyte / 16
	pinsB=outbyte
	pulsout LCD_ENABLE,1
	pause 4
	outbyte=outbyte / 16	'change to outbyte * 16 for Line 1 method
next nibblecount
return


WRITE_LCD_DATA:	'Write Data to LCD

high LCD_RS
outbyte=outbyte * 256 | outbyte / 16

for nibblecount= 1 to 2
	'pinsB=outbyte / 16
	pinsB=outbyte
	pulsout LCD_ENABLE,1
	pause 4
	outbyte=outbyte / 16	'change to outbyte * 16 for Line 1 method
next nibblecount
return

'######################################################################
SET_TIME:

outbyte=$01			'Clear display
gosub write_lcd_inst

gosub SET_HOUR
gosub SET_MIN
gosub SET_SECONDS
gosub SET_MONTH
gosub SET_DATE
gosub SET_YEAR
gosub SET_AMPM
do while TIME_SET_BUTTON=1 loop

outbyte=$0C
gosub WRITE_LCD_INST
return


'#######################################################################
SET_HOUR:

'sertxd(#mode_set,cr,lf)

do while TIME_SET_BUTTON=1 or ALARM_SET_BUTTON=1 loop

for counter = 18 to 26		'Display "Set Hour"
	read counter,outbyte
	gosub WRITE_LCD_DATA
next counter


outbyte=$C0			'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST

outbyte=$0F			'Turn on blinking cursor
gosub write_lcd_inst

bcdtoascii hour12, digit1, digit2	'ADD THIS TO ALL TIME SUBS
gosub BCD2ASCII

bcdmax=$12:bcdmin=$01

do

outbyte=$C0			'Move cursor to Line 2 Position 0 ADD THIS TO ALL TIME SUBS
gosub WRITE_LCD_INST

if incbutton=1 then
	
	bcdnum=hour & $1F
	gosub bcdinc
	hour=hour & $E0 | bcdnum
	
	
hour12=bcdnum
bcdtoascii hour12, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while incbutton=1 loop
endif

if decbutton=1 then
	
	bcdnum=hour & $1F
	gosub bcddec
	hour=hour &$E0 | bcdnum

hour12=bcdnum
bcdtoascii hour12, digit1, digit2
gosub BCD2ASCII

outbyte=$C0		'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while decbutton=1 loop
endif


if TIME_SET_BUTTON=1 or ALARM_SET_BUTTON=1 then exit
loop

if mode_set=0 then
	hi2cout $02, (hour)
elseif mode_set=1 then
	hi2cout $09,(hour)
end if

return

'################################################################################################

SET_MIN:
do while TIME_SET_BUTTON=1 or ALARM_SET_BUTTON=1 loop

outbyte=$01			'Clear display
gosub write_lcd_inst

for counter = 27 to 38		'Display "Set Minute"
	read counter,outbyte
	gosub WRITE_LCD_DATA
next counter


outbyte=$C0			'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST

outbyte=$0F			'Turn on blinking cursor
gosub write_lcd_inst

bcdtoascii mins, digit1, digit2	'ADD THIS TO ALL TIME SUBS
gosub BCD2ASCII


bcdmax=$59:bcdmin=$00

do

outbyte=$C0			'Move cursor to Line 2 Position 0 ADD THIS TO ALL TIME SUBS
gosub WRITE_LCD_INST



if incbutton=1 then
	
	bcdnum=mins
	gosub bcdinc
	mins=bcdnum

bcdtoascii mins, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while incbutton=1 loop
endif

if decbutton=1 then
	
	bcdnum=mins
	gosub bcddec
	mins=bcdnum

bcdtoascii mins, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while decbutton=1 loop
endif


if TIME_SET_BUTTON=1 or ALARM_SET_BUTTON=1 then exit
loop

if mode_set=0 then
	hi2cout $01, (mins)
elseif mode_set=1 then
	hi2cout $08,(mins)
end if

return

'################################################################################
SET_SECONDS:

do while TIME_SET_BUTTON=1 or ALARM_SET_BUTTON=1 loop

outbyte=$01			'Clear display
gosub write_lcd_inst

for counter = 39 to 50		'Display "SET SECONDS"
	read counter,outbyte
	gosub WRITE_LCD_DATA
next counter


outbyte=$C0			'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST

outbyte=$0F			'Turn on blinking cursor
gosub write_lcd_inst

bcdtoascii seconds, digit1, digit2	'ADD THIS TO ALL TIME SUBS
gosub BCD2ASCII


bcdmax=$59:bcdmin=$00

do

outbyte=$C0			'Move cursor to Line 2 Position 0 ADD THIS TO ALL TIME SUBS
gosub WRITE_LCD_INST

if incbutton=1 then
	bcdnum=seconds
	gosub bcdinc
	seconds=bcdnum

bcdtoascii seconds, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while incbutton=1 loop
endif

if decbutton=1 then
	bcdnum=seconds
	gosub bcddec
	seconds=bcdnum

bcdtoascii seconds, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while decbutton=1 loop
endif


if TIME_SET_BUTTON=1 or ALARM_SET_BUTTON=1 then exit
loop

if mode_set=0 then
	hi2cout 0, (seconds)
elseif mode_set=1 then
	hi2cout $07,(seconds)
end if

return

BCDINC:

bcdnum=bcdnum+1
work=bcdnum & $0F
	if work=10 then
	bcdnum=bcdnum+6
	endif

	if bcdnum > bcdmax then
	bcdnum=bcdmin
	endif
return

BCDDEC:

if bcdnum=bcdmin then
bcdnum=bcdmax
else
bcdnum=bcdnum -1
work = bcdnum & $0F
	if work >= $0F then
	bcdnum=bcdnum - 6
	endif
endif

return


'#######################################################################################


SET_MONTH:

do while TIME_SET_BUTTON=1 loop

outbyte=$01			'Clear display
gosub write_lcd_inst

for counter = 51 to 60		'Display "SET MONTH"
	read counter,outbyte
	gosub WRITE_LCD_DATA
next counter


outbyte=$C0			'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST

outbyte=$0F			'Turn on blinking cursor
gosub write_lcd_inst

bcdtoascii month, digit1, digit2	'ADD THIS TO ALL TIME SUBS
gosub BCD2ASCII

bcdmax=$12:bcdmin=$01

do

outbyte=$C0			'Move cursor to Line 2 Position 0 ADD THIS TO ALL TIME SUBS
gosub WRITE_LCD_INST


if incbutton=1 then
	
	bcdnum=month
	gosub bcdinc

	month=bcdnum

	hi2cout 5, (month)

bcdtoascii month, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while incbutton=1 loop
endif

if decbutton=1 then
	bcdnum=month
	gosub bcddec
	month=bcdnum
	hi2cout 5, (month)

bcdtoascii month, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while decbutton=1 loop
endif

if TIME_SET_BUTTON=1 then exit
loop

return

'#######################################################################################

SET_DATE:

do while TIME_SET_BUTTON=1 loop

outbyte=$01			'Clear display
gosub write_lcd_inst

for counter = 61 to 68	'Display "SET DATE"
	read counter,outbyte
	gosub WRITE_LCD_DATA
next counter


outbyte=$C0			'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST

outbyte=$0F			'Turn on blinking cursor
gosub write_lcd_inst

bcdtoascii date, digit1, digit2	'ADD THIS TO ALL TIME SUBS
gosub BCD2ASCII

bcdmax=$31:bcdmin=$01

do


outbyte=$C0			'Move cursor to Line 2 Position 0 ADD THIS TO ALL TIME SUBS
gosub WRITE_LCD_INST

if incbutton=1 then
	
	bcdnum=date
	gosub bcdinc
	date=bcdnum
	hi2cout 4, (date)

bcdtoascii date, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while incbutton=1 loop
endif

if decbutton=1 then
	bcdnum=date
	gosub bcddec
	date=bcdnum
	hi2cout 4, (date)

bcdtoascii date, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while decbutton=1 loop
endif

if TIME_SET_BUTTON=1 then exit
loop

return

'#######################################################################################

SET_YEAR:
do while TIME_SET_BUTTON=1 loop

outbyte=$01			'Clear display
gosub write_lcd_inst

for counter = 69 to 77		'Display "SET YEAR"
	read counter,outbyte
	gosub WRITE_LCD_DATA
next counter


outbyte=$C0			'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST

outbyte=$0F			'Turn on blinking cursor
gosub write_lcd_inst


bcdtoascii year, digit1, digit2	'ADD THIS TO ALL TIME SUBS
gosub BCD2ASCII

bcdmax=$99:bcdmin=$00

do

outbyte=$C0			'Move cursor to Line 2 Position 0 ADD THIS TO ALL TIME SUBS
gosub WRITE_LCD_INST

if incbutton=1 then
	bcdnum=year
	gosub bcdinc
	year=bcdnum
	hi2cout 6, (year)

bcdtoascii year, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while incbutton=1 loop
endif

if decbutton=1 then
	bcdnum=year
	gosub bcddec
	year=bcdnum
	hi2cout 6, (year)

bcdtoascii year, digit1, digit2
gosub BCD2ASCII

outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
	
do while decbutton=1 loop
endif

if TIME_SET_BUTTON=1 then exit
loop

return

'##################################################################################
SET_AMPM:

do while TIME_SET_BUTTON=1 or ALARM_SET_BUTTON=1 loop

outbyte=$01			'Clear display
gosub write_lcd_inst

for counter = 78 to 87		'Display "SET AM/PM"
	read counter,outbyte
	gosub WRITE_LCD_DATA
next counter


outbyte=$C0			'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST

outbyte=$0F			'Turn on blinking cursor
gosub write_lcd_inst


	if ampm_bit=32 then

		for counter = 90 to 91		'Display "SET AM/PM"
			read counter,outbyte
			gosub WRITE_LCD_DATA
		next counter

	else

		for counter = 88 to 89		'Display "SET AM/PM"
			read counter,outbyte
			gosub WRITE_LCD_DATA
		next counter

	end if


bcdmax=$01:bcdmin=$00

do

outbyte=$C0			'Move cursor to Line 2 Position 0 ADD THIS TO ALL TIME SUBS
gosub WRITE_LCD_INST

if incbutton=1 then
	
	bcdnum=hour & $20 / 32
	gosub bcdinc
	bcdnum = bcdnum * 32
	hour = hour & $DF | bcdnum

bcdtoascii bcdnum, digit1, digit2

	if digit1=$32 then

		for counter = 90 to 91		'Display "PM"
			read counter,outbyte
			gosub WRITE_LCD_DATA
		next counter

	else

		for counter = 88 to 89		'Display "AM"
			read counter,outbyte
			gosub WRITE_LCD_DATA
		next counter

	end if


outbyte=$C0	'Move cursor to Line 2 Position 0
gosub WRITE_LCD_INST
		
do while incbutton=1 loop
endif

if TIME_SET_BUTTON=1 or ALARM_SET_BUTTON=1 then exit
loop

	if mode_set=0 then
		hi2cout $02, (hour)
	elseif mode_set=1 then
		hi2cout $09,(hour, $80)
	end if

return

'##############################################################################
BCD2ASCII:

outbyte=digit1
gosub write_lcd_data
outbyte=digit2
gosub write_lcd_data
return


'##############################################################################
SET_ALARM:

outbyte=$01			'Clear display
gosub write_lcd_inst

let controlE=%00000101
let controlF=%00000000
hi2cout $0E,(controlE, controlF)
	
gosub SET_HOUR
gosub SET_MIN
gosub SET_SECONDS
gosub SET_AMPM
do while ALARM_SET_BUTTON=1 loop

return

'##############################################################################
Interrupt:

if pinC.2=1 then interrupt

sertxd ("Entered Interrupt Routine",cr,lf)	'used to debug if interrupt routine has executed

if ALARM_TOGGLE=1 then		'Alarm Toggle switch is in ON position
	serout MP3_Player_TX, t9600_16,($7E,$FF,$06,$0B,$00,$00,$00,$EF) 'Wake up MP3 player
	pause 250
	serout MP3_Player_TX, t9600_16,($7E,$FF,$06,$09,$00,$00,$02,$EF) 'Select MicroSD Storage
	pause 250
	serout MP3_Player_TX, t9600_16,($7E,$FF,$06,$0F,$00,$01,$02,$EF) 'Play track 2
	pause 250
end if

hi2cout $0E,(%00000100)			'reset Alarm 1 Interrupt on DS3231
setint %00000000, %00000100, C	're-initialize Picaxe Interrupt

return






