symbol d4 = C.0
symbol d5 = C.1
symbol d6 = C.2
symbol d7 = C.3
symbol l = C.4
symbol reg = C.5 'low instruct high data
symbol rw = C.6 ' always stay low
symbol counter = b0
symbol outbyte = b1

init:
	low rw
	low d4
	low d5
	low d6
	low d7
	low l
	
main:
	for counter = 0 to 2
	gosub writeData
	pulsout l, 1
	goto main
	
writeData:
	
	lookup counter, ($FC, $60, $DA, $F2, $66, $B6, $BE, $E0) outbyte
	
	S
	
	return