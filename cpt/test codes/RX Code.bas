'##########################Bluetooth Receiver Code#####################################
'#TER4M1 Computer Engineering Technology - Robotics and Control Systems	      	  #
'#Bluetooth Controlled Racer WITH MODS								  #
'######################################################################################



#picaxe 20m2
setfreq m32		'Set clock speed to 32Mhz

'Set up some variables and initialize MP3 Player
init:	

symbol set_pwm1=b.1
symbol set_pwm2=c.3

pwmout set_pwm1, 49, 0		'initialize PWM for left motor
pwmout set_pwm2, 49, 0		'initialize PWM for right motor
pause 5
symbol speed=b0
symbol direction=b1
symbol steer=b2
symbol RX=c.2
symbol lmf=c.4
symbol lmb=c.5
symbol rmf=c.0
symbol rmb=c.1
symbol slave_interrupt_pin=b.2
symbol servotx=b.5
symbol BT_State=pinc.6


high servotx

pause 100


'##############Main Program Loop##################

main:

if BT_State=0 then	'Check State pin of HC-06, LOW means BT not paired
	low lmf		'Turn off motors to prevent run-away car
	low lmb
	low rmf
	low rmb
	pause 10000		'Pause a little to allow Bluetooth to re-pair
else			'Turn off BT disconnected LED indicator
end if
	

serin [100],RX, T19200_32,direction
sertxd(direction,cr,lf)

if direction=2 then
	'goto FWD
	sertxd("F ",#direction,cr,lf)
	high lmf, rmf
	low lmb, rmb
elseif direction=3 then
	'goto BACK
	sertxd("B ",#direction,cr,lf)
	low lmf, rmf
	high lmb, rmb
elseif direction = 1 then
	sertxd("S ",#direction,cr,lf)
	low lmf, rmf, lmb, rmb
elseif direction = 0 then
	sertxd("WTF IDK WHAT TO DO I WASNT WARNED FOR A 0",cr,lf)
endif

if steer="R" then
	serout servotx, t19200_32,("data", "R")
	low rmf, lmf
	high lmb
elseif steer="L" then
	serout servotx, t19200_32,("data", "L")
	low rmf, lmf
	high rmb
else
	serout servotx, t19200_32,("data", "S")
	low rmf, lmf
	high rmb, lmb
endif

goto main

end

'#############Forward Subprocedure###############
;FWD:
;
;select speed
;	
;case 0
;	pwmduty set_pwm1, 0
;	pwmduty set_pwm2, 0
;case 1
;	pwmduty set_pwm1, 110
;	pwmduty set_pwm2, 110
;case 2
;	pwmduty set_pwm1, 220
;	pwmduty set_pwm2, 220
;case 3
;	pwmduty set_pwm1, 330
;	pwmduty set_pwm2, 330
;case 4
;	pwmduty set_pwm1, 440
;	pwmduty set_pwm2, 440
;case 5
;	pwmduty set_pwm1, 550
;	pwmduty set_pwm2, 550
;case 6
;	pwmduty set_pwm1, 660
;	pwmduty set_pwm2, 660
;case 7
;	pwmduty set_pwm1, 770
;	pwmduty set_pwm2, 770
;case 8
;	pwmduty set_pwm1, 880
;	pwmduty set_pwm2, 880
;case 9
;	pwmduty set_pwm1, 1023
;	pwmduty set_pwm2, 1023
;	
;end select
;
;high slave_interrupt_pin	'trigger interrupt on Picaxe 08M2
;pause 100
;
;if steer="R" then
;	serout servotx, t19200_32,("data", "R")
;	high LW_pin1	'left wheel
;	low LW_pin2
;	low RW_pin1	'right wheel
;	low RW_pin2
;elseif steer="L" then
;	serout servotx, t19200_32,("data", "L")
;	low LW_pin1
;	low LW_pin2
;	high RW_pin1
;	low RW_pin2
;else
;	serout servotx, t19200_32,("data", "S")
;	high LW_pin1
;	low LW_pin2
;	high RW_pin1
;	low RW_pin2	
;endif
;
;low slave_interrupt_pin
;
;
;goto main
;
;'################Reverse Subprocedure################
;BACK:
;
;select speed
;	
;case 0
;	pwmduty set_pwm1, 0
;	pwmduty set_pwm2, 0
;case 1
;	pwmduty set_pwm1, 110
;	pwmduty set_pwm2, 110
;case 2
;	pwmduty set_pwm1, 220
;	pwmduty set_pwm2, 220
;case 3
;	pwmduty set_pwm1, 330
;	pwmduty set_pwm2, 330
;case 4
;	pwmduty set_pwm1, 440
;	pwmduty set_pwm2, 440
;case 5
;	pwmduty set_pwm1, 550
;	pwmduty set_pwm2, 550
;case 6
;	pwmduty set_pwm1, 660
;	pwmduty set_pwm2, 660
;case 7
;	pwmduty set_pwm1, 770	
;	pwmduty set_pwm2, 770
;case 8
;	pwmduty set_pwm1, 880	
;	pwmduty set_pwm2, 880	
;case 9
;	pwmduty set_pwm1, 1023
;	pwmduty set_pwm2, 1023
;	
;end select
;
;high slave_interrupt_pin	'trigger interrupt on Picaxe 08M2
;pause 100
;
;if steer="R" then
;	serout serial_TX, t19200_32,("data", "R")
;	low LW_pin1	'left wheel
;	high LW_pin2
;	low RW_pin1	'right wheel
;	low RW_pin2
;elseif steer="L" then
;	serout serial_TX, t19200_32,("data", "L")
;	low LW_pin1
;	low LW_pin2
;	low RW_pin1
;	high RW_pin2
;else
;	serout serial_TX, t19200_32,("data", "S")
;	low LW_pin1
;	high LW_pin2
;	low RW_pin1
;	high RW_pin2
;endif
;
;low slave_interrupt_pin
;
;goto main
;