symbol ds = C.0 'Data Pin
symbol clock = C.1 'Clock Pin
symbol latch = C.2 'Latch Pin
symbol x = b0

init:

	low ds
	low clock
	low latch
	
	pause 2000
	
	goto counter

counter:
	
		gosub zero
		
		pause 1000
			
		gosub one
		
		pause 1000
			
		gosub two
		
		pause 1000
			
		gosub three
		
		pause 1000
			
		gosub four
		
		pause 1000
			
		gosub five
		
		pause 1000
			
		gosub six
		
		pause 1000
			
		gosub seven
		
		pause 1000
			
		gosub eight
		
		pause 1000
			
		gosub nine
		
		pause 1000
		
		goto counter

zero:
	sertxd("0")
	high ds
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	pulsout clock, 1
	
	pulsout latch, 1
	
	return

one:
	sertxd("1")
	low ds
	pulsout clock, 1
	high ds
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	
	pulsout latch, 1
	
	return

two:
	sertxd("2")
	high ds
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	high ds
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	high ds
	pulsout clock, 1
	low ds
	pulsout clock, 1
	
	pulsout latch, 1
	
	return

three:
	sertxd("3")
	high ds
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	pulsout clock, 1
	high ds
	pulsout clock, 1
	low ds
	pulsout clock, 1
	
	pulsout latch, 1
	
	return

four:
	sertxd("4")
	low ds
	pulsout clock, 1
	high ds
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	pulsout clock, 1
	high ds
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	
	pulsout latch, 1
	
	return

five:
	sertxd("5")
	high ds
	pulsout clock, 1
	low ds
	pulsout clock, 1
	high ds
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	high ds
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	
	pulsout latch, 1
	
	return

six:
	sertxd("6")
	high ds
	pulsout clock, 1
	low ds
	pulsout clock, 1
	high ds
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	
	pulsout latch, 1
	
	return

seven:
	sertxd("7")
	high ds
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	
	pulsout latch, 1
	
	return

eight:
	sertxd("8")
	high ds
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	
	pulsout latch, 1
	
	return

nine:
	sertxd("9")
	high ds
	pulsout clock, 1
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	pulsout clock, 1
	high ds
	pulsout clock, 1
	pulsout clock, 1
	low ds
	pulsout clock, 1
	
	pulsout latch, 1
	
	return


