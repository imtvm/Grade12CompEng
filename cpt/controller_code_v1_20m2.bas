'Robot Controller
'Author: Tyler Vergis-Mayo
'Code Completed On: 05/15/2017

setfreq m32 'Sets the frequency of the internal clock to 8mhz or double the clock speed
#picaxe 20m2 'Ensures that the code can only be programmed on the Picaxe 28SX2 chip

'Joystick Input Variabls
symbol xin = b.1 'Sets the x axis of the right joysitck to b.0
symbol xsw = pinb.3 'Sets the button of the right joystick to c.4 
symbol yin = b.2 'Sets the y acis of the left joystick to b.2
symbol ysw = pinb.4 'Sets the button of the left joystic to c.5

'Value Variable
symbol xval = w0 'Creates a word variable with the name xval
symbol yval = w1 'Creates a word variable with the name yval
symbol counter = b4 'Creats a  counter called counterassigned to the b4 byte variable
symbol dir = b5
symbol fwdMin = 522
symbol revMax = 502
symbol dutyCycle = b6
symbol fwdDir = "F"
symbol bckDir = "R"

'BT Transmitter Variables
symbol tx = b.5 'Sets the transmitter to pin b.4

'Shift Registor Variables
symbol dp = c.2 'Sets the data pin of the shift registor to c.0
symbol lp = c.1 'Sets the latch pin of the shift registor to c.1
symbol cp = c.0 'Sets the clock pin of the shift registor to c.2

setint %00110000, %00110000 'Sets an interrupt on the pins c.4 and c.5 to check if they go high

main: 'Main proceadure that is looped infinitly
	
	low dp 'Sets the data pin low
	for counter= 0 to 7 'Runs the code in the for loop 8 times
		pulsout cp,1 'Pulses the clock pin to set every led low
	next counter'Tells the code to run the next interation
	
	pulsout lp, 1 'Pulses the latch pin to tell the shift register to make everything low
	
	xval = 0 'Resets the xval variable
	yval = 0 'Resets the yval variable
	
	readadc10 xin, xval 'Reads a value from 0-1023 on pin xin and assigns it to the xval variable
	readadc10 yin, yval 'Reads a valee from 0-1023 on pin yin and assigns it to the yval variable
	
	
	
	if xval < 300 then
		dir="L"
	elseif xval > 700 then
		dir="R"
	else
		dir="S"		
	endif

	select yval	'start decision structure
	
	case 0 to fwdMin
		'gosub back
		serout TX, t19200_32,("data",fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
	case revMax to 1023
		'gosub fwd
		serout TX, t19200_32,("data",bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
	end select
	
;	if xval>580 AND xval <= 635 then 'Checks to see if xval is equal to a number within the specified range
;		
;		high dp 'Sets the data pin to high
;		pulsout cp,1 'Pulses the clock pin
;		low dp 'Sets the data pin low
;		for counter= 0 to 6 'Runs the code in the for loop 7 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;	elseif xval>635 AND xval <= 690 then 'Checks to see if xval is equal to a number within the specified range
;		
;		high dp 'Sets the data pin to high
;		for counter= 0 to 1 'Runs the code in the for loop 2 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		low dp 'Sets the data pin low
;		for counter= 0 to 5 'Runs the code in the for loop 6 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;	
;	elseif xval>690 AND xval <= 745 then 'Checks to see if xval is equal to a number within the specified range
;		
;		high dp 'Sets the data pin to high
;		for counter= 0 to 2 'Runs the code in the for loop 3 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		low dp 'Sets the data pin low
;		for counter= 0 to 4 'Runs the code in the for loop 5 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		
;	elseif xval>745 AND xval <= 800 then 'Checks to see if xval is equal to a number within the specified range
;		
;		high dp 'Sets the data pin to high
;		for counter= 0 to 3 'Runs the code in the for loop 4 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		low dp 'Sets the data pin low
;		for counter= 0 to 3 'Runs the code in the for loop 4 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		
;	elseif xval>800 AND xval <= 855 then 'Checks to see if xval is equal to a number within the specified range
;		
;		high dp 'Sets the data pin to high
;		for counter= 0 to 4 'Runs the code in the for loop 5 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		low dp 'Sets the data pin low
;		for counter= 0 to 2 'Runs the code in the for loop 3 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		
;	elseif xval>855 AND xval <= 910 then 'Checks to see if xval is equal to a number within the specified range
;		
;		high dp 'Sets the data pin to high
;		for counter= 0 to 5 'Runs the code in the for loop 6 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		low dp 'Sets the data pin low
;		for counter= 0 to 1 'Runs the code in the for loop 2 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		
;	elseif xval>910 AND xval <= 965 then 'Checks to see if xval is equal to a number within the specified range
;		
;		high dp 'Sets the data pin to high
;		for counter= 0 to 6 'Runs the code in the for loop 7 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		low dp 'Sets the data pin low
;		pulsout cp,1 'Pulses the clock pin
;		
;	elseif xval>965 AND xval <= 1023 then 'Checks to see if xval is equal to a number within the specified range
;		
;		high dp 'Sets the data pin to high
;		for counter= 0 to 7 'Runs the code in the for loop 8 times
;			pulsout cp,1 'Pulses the clock pin
;		next counter'Tells the code to run the next interation
;		
;	endif 'Ends the if statment
;	
;	pulsout lp, 1 'Pulses the latch pin to turn on the leds according to the value of xval

goto main

fwd:		'Potentiometer in forward position

dutyCycle = yval - revMax * 21 / 10 MAX 1023

select dutyCycle
	
case 0 to 110
	
		serout TX, t19200_32,("data",0)
		pause 50
		serout TX, t19200_32,(fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50			
case 111 to 220
	
		serout TX, t19200_32,("data",1)
		pause 50
		serout TX, t19200_32,(fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 221 to 330
	
		serout TX, t19200_32,("data",2)
		pause 50
		serout TX, t19200_32,(fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 331 to 440
	
		serout TX, t19200_32,("data",3)
		pause 50
		serout TX, t19200_32,(fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 441 to 550
	
		serout TX, t19200_32,("data",4)
		pause 50
		serout TX, t19200_32,(fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 551 to 660
	
		serout TX, t19200_32,("data",5)
		pause 50
		serout TX, t19200_32,(fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 661 to 770
	
		serout TX, t19200_32,("data",6)
		pause 50
		serout TX, t19200_32,(fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 771 to 880
	
		serout TX, t19200_32,("data",7)
		pause 50
		serout TX, t19200_32,(fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 881 to 990
	
		serout TX, t19200_32,("data",8)
		pause 50
		serout TX, t19200_32,(fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 991 to 1023
	
		serout TX, t19200_32,("data",9)
		pause 50
		serout TX, t19200_32,(fwdDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
end select

return

back:	'Potentiometer in reverse position

dutyCycle = fwdMin - yval * 21 / 10 MAX 1023

select dutyCycle
	
case 0 to 110
	
		serout TX, t19200_32,("data",0)
		pause 50
		serout TX, t19200_32,(bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50			
case 111 to 220
	
		serout TX, t19200_32,("data",1)
		pause 50
		serout TX, t19200_32,(bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 221 to 330
	
		serout TX, t19200_32,("data",2)
		pause 50
		serout TX, t19200_32,(bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 331 to 440
	
		serout TX, t19200_32,("data",3)
		pause 50
		serout TX, t19200_32,(bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 441 to 550
	
		serout TX, t19200_32,("data",4)
		pause 50
		serout TX, t19200_32,(bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 551 to 660
	
		serout TX, t19200_32,("data",5)
		pause 50
		serout TX, t19200_32,(bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 661 to 770
	
		serout TX, t19200_32,("data",6)
		pause 50
		serout TX, t19200_32,(bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 771 to 880
	
		serout TX, t19200_32,("data",7)
		pause 50
		serout TX, t19200_32,(bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 881 to 990
	
		serout TX, t19200_32,("data",8)
		pause 50
		serout TX, t19200_32,(bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
case 991 to 1023
	
		serout TX, t19200_32,("data",9)
		pause 50
		serout TX, t19200_32,(bckDir)
		pause 50
		serout TX, t19200_32,(dir)
		pause 50
end select
	
return

interrupt: 'Code to be run when the interrupt is triggered is in here

if xsw = 1 then 'Checks to see if the button that was pressed was the right joystick
	serout tx, t19200_32, ("sw1", "1") 'Sends a 1 through the tx pin to the BT Transmitter
elseif ysw = 1 then 'Checks to see if the button that was pressed was the left joystick
	serout tx, t19200_32, ("sw2", "1") 'Sends a 1 through the tx pin to the BT Transmitter
end if 'Ends the if statement

setint %00110000, %00110000 'Resets the interrupt so that it can be triggered again

return 'Returns to the places when the interrupt was called
