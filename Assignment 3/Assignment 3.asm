;TITLE: Assignment #3		(Assignment_3.asm)

; Author:	Jeanvally G.Beato
; Email:  beatoj@oregonstate.edu
; Course:  CS271-400    
; Assignment: # 3  
; Assignment Due Date:  4/24/16           
; Description:  1.  Display the program title and programmer's name.
;				2.  Get the user's name, and greet the user. 
;				3.  Display instructions for the user. 
;				4.  Repeatedly prompt the user to enter a number.  Validate the user input to be in
;					[-100, -1] (inclusive).  Count and accumulate the valid user numbers until a
;					non0negative number is entered. (The non-negative number is discarded).
;				5.  Calculate the (rounded integer) average of the negative numbers. 
;				6.  Display:
;						i.)    the number of negative numbers entered (Note: if no negative numbers
;							   were entered, display a special message and skip to iv.)
;						ii.)   the sum of negative numbers entered			
;						iii.)  the average, rounded to the nearest integer (e.g. -20.5 rounds to -20)
;						iv.)   a parting message (with the user's name)

INCLUDE Irvine32.inc

;CONSTANTS
	LOWER= -100
	UPPER= -1

.data
programmer		BYTE	"Name:  Jeanvally G.Beato", 0
programTitle	BYTE	"Program Title:  Assignment #3 (Integer Accumulator)", 0
namePrompt		BYTE	"Please enter your name: ", 0
usersName		BYTE	50 DUP(0)		;input buffer
usersNameByte	DWORD	?				;holds counter
greetUser		BYTE	"Hello, ", 0

instructions	BYTE	"Please enter numbers in [-100, -1] (inclusive) range.", 0
instructions2	BYTE	"The sum of those numbers as well the number of values entered will be displayed.", 0
instructions3	BYTE	"Enter a non-negative number when you are finished to see the results.", 0

numberPrompt	BYTE	"Enter number: ", 0
numberOfValues	DWORD	?
sum				DWORD	0		;Initialize it to zero
average			DWORD	?
tempNumber		DWORD	?

printValues		BYTE	"Number Of Values: ", 0
printSum		BYTE	"Sum: ", 0
printAverage	BYTE	"Average: ", 0

lineNumber		DWORD	1
comma			BYTE	" .) ", 0
errorMessage	BYTE	"You entered a number below the range.  Please enter numbers in [-100, -1] (inclusive) range.", 0
specialMessage	BYTE	"You did not enter any negative numbers!", 0
goodbye			BYTE	"Thank you for playing Integer Accumulator  It's been a pleasure to meet you, ", 0

EC1				BYTE	"**EC:  Number the lines during user input.", 0

.code
main PROC

;INTRODUCTION

	;Introduction of programmer
		mov		edx, OFFSET programmer
		call WriteString
		call CrLf

	;Display program title
		mov		edx, OFFSET programTitle
		call WriteString
		call CrLf

	;Display Extra Credit
		mov edx, OFFSET EC1
		call WriteString
		call CrLf

	;Get user's name and store it in variable
		mov		edx, OFFSET namePrompt
		call WriteString
		mov edx, OFFSET usersName		;Point to the buffer
		mov ecx, SIZEOF usersName		;Specify max characters
		call ReadString					;Input the string

	;Greet user
		mov		edx, OFFSET greetUser
		call WriteString
		mov		edx, OFFSET usersName
		call WriteString
		call CrLf

;USER INSTRUCTIONS

	;Display instructions
		mov		edx, OFFSET instructions
		call WriteString
		call CrLf
		mov		edx, OFFSET instructions2
		call WriteString
		call CrLf
		mov		edx, OFFSET instructions3
		call WriteString
		call CrLf

;GET USER DATA
	
	;Ask for number

		asknumber:
			mov eax, lineNumber
			call WriteDec
			add eax, 1
			mov lineNumber, eax
			mov edx, OFFSET comma
			call WriteString
			mov edx, OFFSET numberPrompt
			call WriteString
			call ReadInt

			;Input Validation

			;If number is LESS than -100, jump to error message
			cmp eax, -100
			jl error

			;If number is OVER -1 (positive number), then end program
			cmp eax, -1
			jg finished

			;If the number is within range, then jump to calculations

		calculations:
			add eax, sum			;Add sum to the number entered in EAX
			mov sum, eax			;Move the answer into the variable sum
			add numberOfValues, 1	;Incrememt number of values
			jmp asknumber

		error:
			mov edx, OFFSET errorMessage
			call WriteString
			jmp asknumber


;DISPLAY RESULTS
	
	;Display the number of values, sum and average
		
		finished:

		;Print values
			mov		edx, OFFSET printValues
			call WriteString
			mov eax, numberOfValues
			call WriteInt
			call CrLf

		;Print sum
			mov edx, OFFSET printSum
			call WriteString
			mov eax, sum
			call WriteInt
			call CrLf

		;Print average
			;Calculate
				mov eax, sum
				cdq							;extend EAX into EDX
				mov	ebx, numberOfValues
				idiv ebx
				mov average, eax

			;Print
				mov edx, OFFSET printAverage
				call WriteString
				mov eax, average
				call WriteInt
				call CrLf

				jmp farewell

;SPECIAL MESSAGE

	;No negative numbers were entered, special message to display

		special:
			call CrLf
			mov		edx, OFFSET specialMessage
			call WriteString
			jmp farewell

;FAREWELL

	;Goodbye message

		farewell:
			call CrLf
			mov		edx, OFFSET goodbye
			call WriteString
			mov		edx, OFFSET usersName
			call WriteString
			call CrLf

	exit	; exit to operating system

main ENDP
END main

