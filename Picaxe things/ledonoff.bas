symbol l1 = c.0
symbol l2 = c.1
symbol l3 = c.2

init:
	low l1
	low l2
	low l3
	
main:
	high l1
	pause 500
	low l1
	pause 500
	high l2
	pause 500
	low l2
	pause 500
	high l3
	pause 500
	low l3
	pause 500
	goto main