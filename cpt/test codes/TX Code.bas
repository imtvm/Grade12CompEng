'##########################Bluetooth Transmitter Code##################################
'#TER4M1 Computer Engineering Technology - Robotics and Control Systems	      	  #
'#Bluetooth Controlled Racer								  #
'######################################################################################


#picaxe 20m2
setfreq m32


'Define some symbols for constants, variables, and pin assignments
symbol fwd_min=522
symbol rev_max=502
symbol speed_adc_pin=c.3
symbol servo_adc_pin=b.1
symbol speed_val=w0
symbol servo_val=w1
symbol steer_dir=b27
symbol duty_cycle=w2
symbol TX=b.7
symbol dir_fwd="F"
symbol dir_back="B"
symbol dir_straight = "S"
symbol back = "3"
symbol fwd = "2"
symbol str = "1"



'##############Main Program Loop###############
main:

readadc10 speed_adc_pin, speed_val	'read speed control (pinc.3) potentiometer
readadc10 servo_adc_pin, servo_val	'read position control (pinb.1) potentiometer

;if servo_val < 300 then
;	steer_dir="L"
;elseif servo_val > 700 then
;	steer_dir="R"
;else
;	steer_dir="S"		
;endif

	'start decision structure
	
if speed_val >=0 AND speed_val < 400 then
	'gosub back
	sertxd("back ", back,cr,lf)
	serout TX, t19200_32,(back)
	pause 50
	'serout TX, t19200_32,(steer_dir)
	'pause 50
elseif speed_val >= 601 AND speed_val <= 1023 then
	'gosub fwd
	sertxd("fwd ", fwd, cr,lf)
	serout TX, t19200_32,(fwd)
	pause 50
	'serout TX, t19200_32,(steer_dir)
	'pause 50
elseif speed_val >= 400 AND speed_val <= 600 then
	sertxd("noting ", str, cr,lf)
	serout TX, t19200_32,(str)
	pause 50
	'serout TX, t19200_32,(steer_dir)
	'pause 50
end if


goto main

;fwd:		'Potentiometer in forward position
;duty_cycle = speed_val - rev_max * 21 / 10 MAX 1023
;
;
;select duty_cycle
;	
;case 0 to 110
;	
;		serout TX, t19200_32,("data",0)
;		pause 50
;		serout TX, t19200_32,(dir_fwd)
;		pause 50
;		serout TX, t19200_32,(steer_dir)
;		pause 50
;					
;case 111 to 220
;	
;		serout TX, t19200_32,("data",1)
;		pause 50
;		serout TX, t19200_32,(dir_fwd)
;		pause 50
;		serout TX, t19200_32,(steer_dir)
;		pause 50
;		
;end select
;
;return
;
;
;
;
;back:		'Potentiometer in reverse position
;
;duty_cycle = fwd_min - speed_val * 21 / 10 MAX 1023
;
;select duty_cycle
;	
;case 0 to 110
;	
;		serout TX, t19200_32,("data",0)
;		pause 50
;		serout TX, t19200_32,(dir_back)
;		pause 50
;		serout TX, t19200_32,(steer_dir)
;		pause 50
;				
;case 111 to 220
;	
;		serout TX, t19200_32,("data",1)
;		pause 50
;		serout TX, t19200_32,(dir_back)
;		pause 50
;		serout TX, t19200_32,(steer_dir)
;				
;
;end select
;	
;return

