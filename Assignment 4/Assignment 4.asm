;TITLE: Assignment #4		(Assignment_4.asm)

; Author:	Jeanvally G.Beato
; Email:  beatoj@oregonstate.edu
; Course:  CS271-400    
; Assignment: # 3  
; Assignment Due Date:  5/08/16           
; Description:  1.  The user is instructed to enter the number of composites to be displayed, and
;					is prompted to enter an integer in the range [1-400].  
;				2.  The user enters a number, n, and the program verifies that 1 <= n <= 400.
;				3.  If n is out of range, the user is reprompted until s/he enters a value in
;					the specified range.  
;				4.  The program then calculates and displays all of the composite numbers up to and
;					including the nth composite.  
;				5.  The results should be displayed 10 composites per line with at least 3 spaces
;					between the numbers. 

INCLUDE Irvine32.inc

;CONSTANTS
	LOWER= 1
	UPPER= 400

.data
programmer		BYTE	"Name:  Jeanvally G.Beato", 0
programTitle	BYTE	"Program Title:  Assignment #4 (Composite Numbers)", 0

instructions	BYTE	"Enter the number of composite numbers you would like to see: ", 0
instructions2	BYTE	"I'll accept orders for up to 400 composites", 0
numberPrompt	BYTE	"Enter the number of composites to display [1...400]: ", 0
errorMessage	BYTE	"You entered a number out of range.  Please enter numbers in [1...400] (inclusive) range.", 0
goodbye			BYTE	"Thank you for playing Composite Numbers!", 0
space			BYTE	" ", 0

userNumber		DWORD	?
currentNumber	DWORD	2
compositeFound	DWORD	0
totalComposites	DWORD	0
perLine			DWORD	0

.code
main PROC

	call introduction
	call getUserData
	call showComposites
	call farewell
	exit

main ENDP

;-------------------------------------------------------------------------
;INTRODUCTION
;
;Introduce the programmer's name and displays instructions
;-------------------------------------------------------------------------

introduction PROC

	;Introduction of programmer

		mov		edx, OFFSET programmer
		call WriteString
		call CrLf

	;Display program title

		mov		edx, OFFSET programTitle
		call WriteString
		call CrLf
		call CrLf

	;Display instructions

		mov		edx, OFFSET instructions
		call WriteString
		call CrLf
		mov		edx, OFFSET instructions2
		call WriteString
		call CrLf
		call CrLf

	ret

introduction ENDP

;-------------------------------------------------------------------------
;GET USER DATA
;
;Get number of composites from user.
;-------------------------------------------------------------------------
	
getUserData PROC

	;Ask for number

		asknumber:
			mov edx, OFFSET numberPrompt
			call WriteString
			call ReadInt
			mov userNumber, eax				;move user entered number into userComposite
			call inputValidation

	ret

getUserData ENDP

;-------------------------------------------------------------------------
;INPUT VALIDATION
;
;Validate that number user entered is within the 1-400 (inclusive) range
;-------------------------------------------------------------------------

inputValidation PROC

			;If number is LESS than 1, jump to error message
			cmp eax, LOWER
			jl error

			;If number is OVER 400, jump to error message
			cmp eax, UPPER
			jg error

			;If the number is within range, then jump to calculations
			jmp finished

			;Error message to display if number out of range

			error:
				mov edx, OFFSET errorMessage
				call WriteString
				call getUserData

			finished:
				ret

inputValidation ENDP

;-------------------------------------------------------------------------
;SHOW COMPOSITES
;
;When a composite number is found, it is printed.
;-------------------------------------------------------------------------

showComposites PROC

	mov eax, userNumber

	compositeSearch:
		mov compositeFound, 0		;set to zero
		call isComposite
		cmp compositeFound, 1		;if a composite number is found, it's displayed & totalComposites is incremented
		je print				
		inc currentNumber			;increment currentNumber
		mov eax, totalComposites	
		cmp eax, userNumber
		jl compositeSearch			;if total composites found is less than number entered by user, continue this loop
		jmp finished				;else, we're done

	print:
		mov eax, currentNumber
		call WriteDec				;print composite number that's found
		mov edx, OFFSET space		
		call WriteString

		inc currentNumber
		inc perLine
		cmp perLine, 10				;if there are 10 on the current line, then go to new line
		je newLine
		jmp compositeSearch			;else, continue with the composite search loop

	newLine:
		call CrLf
		mov perLine, 0				;resets the perLine variable to 0
		jmp compositeSearch			;jumps back to the composite search loop, perLine will get incremented again if a composite is found

	finished:
		ret

showComposites ENDP

;-------------------------------------------------------------------------
;IS COMPOSITE
;
;Checks if a number is composite. 
;-------------------------------------------------------------------------

isComposite PROC
	
	mov ecx, currentNumber
	dec ecx							;we want the divisor to be n-1 as our starting point

	checkComposite:
		cmp ecx, 1					;if ecx is 1, jump to done (there are no composites)
		je finished					;number is prime, NOT composite

		mov edx, 0					;clear dividend
		mov eax, currentNumber		;set eax to dividend
		div ecx						;set ecx as divisor, divide eax/ecx (EAX = QUOTIENT & EDX = REMAINDER)
		cmp edx, 0					;if remainder is 0, then we found a composite number(there exists a # less than n, that divides into n whole with no remainder)
		je found					;...and we jump to found
					
		loop checkComposite			;else, continue loop until we get remainder of 0 or we get prime number 1 & no composite is found

	found:
		mov compositeFound, 1		;composite found, now we exit this process
		inc totalComposites			;increment total composites found by 1

	finished:
		ret

isComposite ENDP


;-------------------------------------------------------------------------
;FAREWELL
;
;Say goodbye to the user
;-------------------------------------------------------------------------

farewell PROC

	call CrLf
	mov		edx, OFFSET goodbye
	call WriteString
	ret

farewell ENDP

END main


