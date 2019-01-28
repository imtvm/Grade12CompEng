'Servo Controller
'Author: Tyler Vergis-Mayo
'Code Completed On: 05/11/2017

#picaxe 08m2 'Ensures that the code can only be programmed on the Picaxe 08M2 chip
setfreq m32 'Sets the frequency of the internal clock to 8mhz or double the clock speed

'SERIAL INFORMATION 
symbol serInPin = C.2 'Sets the serInPin var to pin C.2
symbol command = b0 'Sets the command variable to b0

'SERVO INFORMATION
symbol servoWheel = C.1 'Sets the servo wheel to pin C.1
symbol fwd = 170 'Sets the fwd position to 150
symbol left = 140 'Sets the fwd position to 100
symbol right = 220 'Sets the fwd position to 200

init: 'Only run once right when the MCU is given power

	servo servoWheel, fwd 'Initilizes the servo to the forward position
	
	'goto main 'Goes to the beginning of the main proceadure
	
main: 'Main proceadure that is looped infinitly

	command = "" 'Sets the command varibale to nothing
	
	serin [250], serInPin, t19200_32, ("data"), command 'Checks for a serial input and assigns the data to the command var
	
	if command = "L" then 'Checks to see if the command var is equal to 1
		servopos servoWheel, left 'sets the servo wheel to the left position
	else if command = "R" then 'Checks to see if the command var is equal to 2
		servopos servoWheel, right 'sets the servo wheel to the left position
	else if command = "S" then 'Checks to see if the command var is equal to 3
		servopos servoWheel, fwd 'sets the servo wheel to the left position
	else 'If none are true then the MCU will do nothing
	
	end if 'Ends the if statement
	
	goto main 'Goes to the beginning of the main proceadure
