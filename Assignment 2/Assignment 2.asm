;TITLE: Assignment #2		(Assignment_2.asm)

; Author:	Jeanvally G.Beato
; Email:  beatoj@oregonstate.edu
; Course:  CS271-400    
; Assignment: # 2  
; Assignment Due Date:  4/17/16           
; Description:  1.  Display the program title and programmer's name. Then get the user's name, and greet the user.
;				2.  Prompt the user to enter the numbers of Fibonacci terms to be displayed.  Advise the user to
;					enter an integer in the range [1 .. 46].
;				3.  Get and validate the user input (n).
;				4.  Calculate and display all of the Fibonacci numbers up to and including the nth term.  The 
;					results should be displayed 5 terms per line with at least 5 spaces between terms.  
;				5.  Display a parting message that includes the user's name, and terminate the program. 

INCLUDE Irvine32.inc

;CONSTANTS
	LOWER= 1
	UPPER= 46

.data
programmer		BYTE	"Name:  Jeanvally G.Beato", 0
programTitle	BYTE	"Program Title:  Assignment #2", 0
namePrompt		BYTE	"Please enter your name: ", 0
usersName		BYTE	50 DUP(0)		;input buffer
usersNameByte	DWORD	?				;holds counter
greetUser		BYTE	"Hello, ", 0
instructions	BYTE	"This program will display the Fibonacci sequence for the number of terms you choose.  The range is 1-46.", 0
numberPrompt	BYTE	"Please enter a number between 1-46: ", 0
numberOfFibs	DWORD	?
goodbye			BYTE	"Thanks for stopping by ", 0
goodbye2		BYTE	". Have a great day!", 0
tryagain		BYTE	"Please make sure the number is between 1-46.  Try again...", 0

previous		DWORD	?
space			BYTE	"     ", 0
column			DWORD	?
current			DWORD	?
new				DWORD	?

.code
main PROC

;a.)	INTRODUCTION
	;Introduction of programmer
		mov		edx, OFFSET programmer
		call WriteString
		call CrLf

	;Display program title
		mov		edx, OFFSET programTitle
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

;b.)	USER INSTRUCTIONS

	;Display instructions
		mov		edx, OFFSET instructions
		call WriteString
		call CrLf

;c.)	GET USER DATA

	;Get user integer input
	;Validate if it's within 1-46.  If not, show error message and have user try again. 
		
		numberOfFibsINPUT:
			mov		edx, OFFSET numberPrompt
			call WriteString
			call ReadInt
			mov		numberOfFibs, eax
			cmp eax, LOWER
			jb invalidInput						;If input LOWER than LOWER LIMIT, jump to error message
			cmp eax, UPPER	
			ja invalidInput						;If input GREATER than HIGHER LIMIT, jump to error message
			jmp continue

	;Error Message

		invalidInput:
			mov edx, OFFSET tryagain
			call WriteString
			jmp numberOfFibsINPUT				;Jump back to get user integer input

		continue:
			call Crlf

;d.)	DISPLAY FIBS

	;Initialize current and previous, and print 0 & 1

		mov current, 1
		mov previous, 0
		mov eax, previous
		call WriteDec							;Dispay 0, the 0(th) Fib number

		mov		edx, OFFSET space				;Spacing	
			call WriteString
		
		mov eax, current
		call WriteDec							;Dispay 1, the 1(th) Fib number

		mov		edx, OFFSET space				;Spacing	
			call WriteString
				
		inc column								;Since two values has already printed
		inc column

	;Start of Fib sequence
			
			cmp numberOfFibs, 0					;If integer was 1, then we're finished
			jbe farewell						
			dec numberOfFibs					;Since we've already printed the 0th #
			mov ecx, numberOfFibs				;Else, set COUNTER to number of fibs entered by use
			
		Label_1:
			mov eax, previous					;Move previous to eax
			mov ebx, current
			add eax, ebx						;Add current to eax
			call WriteDec						;Display nth Fib number on screen

			mov previous, ebx					;copy current to previous
			mov current, eax					;copy new calculated to current

			mov		edx, OFFSET space			
			call WriteString

			inc column
			cmp column, 5
			jae newRow
			;dec ecx
			cmp ecx, 0
			jbe farewell
			;jmp Label_1
			loop Label_1
			jmp farewell

			newRow:
				call CrLf
				mov column, 0
				dec ecx
				cmp ecx, 0
				ja Label_1

;e.)	FAREWELL

	;Goodbye message

		farewell:
			call CrLf
			mov		edx, OFFSET goodbye
			call WriteString
			mov		edx, OFFSET usersName
			call WriteString
			mov		edx, OFFSET goodbye2
			call WriteString
			call CrLf

	exit	; exit to operating system

main ENDP
END main

