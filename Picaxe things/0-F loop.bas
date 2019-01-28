symbol ds = C.0
symbol clock = C.1
symbol latch = C.2

symbol bitcounter = b1
symbol outbyte = b2
symbol outbit = b3
symbol counter = b4

init:
	low ds
	low clock
	low latch
	
	goto main
	
main:
	do
		for counter = 0 to 7
			gosub shift
			pulsout latch, 1
			pause 500
		next counter
	loop

shift:
	lookup counter, ($B6, $2E, $38, $8E, $8E, $1C, $9E, $0), outbyte
	
	for bitcounter = 0 to 7
		outbit = outbyte & 128
		if outbit = 128 then
			high ds
		else
			low ds
		endif
	
		pulsout clock, 1
		outbyte = outbyte*2
	next bitcounter

	return