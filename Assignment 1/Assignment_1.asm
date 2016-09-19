;TITLE: Assignment #1		(Assignment_1.asm)

; Author:	Jeanvally G.Beato
; Email:  beatoj@oregonstate.edu
; Course:  CS271-400    
; Assignment: # 1  
; Assignment Due Date:  4/10/16           
; Description:  This program prompts the user to enter two numbers.  It then
;				displays the sum, difference, product (integer) quotient & remainder.

INCLUDE Irvine32.inc

.data
programmer		BYTE	"Name:  Jeanvally G.Beato", 0
programTitle	BYTE	"Program Title:  Assignment #1", 0
instructions	BYTE	"Please enter 2 numbers.  This program will calculate the sum, difference, product, quotient & remainder.", 0
goodbye			BYTE	"Thanks for stopping by.  Have a great day!", 0
tryagain		BYTE	"Please make sure Number 2 is smaller than Number 1.  Try again...", 0
extraCredit2	BYTE	"Extra Credit: Validate the second number to be less than the first", 0
extraCredit1	BYTE	"Extra Credit: Repeat until user chooses to quit", 0
playAgainPrompt	BYTE	"Would you like to play again?  Enter 1 for yes or 2 for no", 0
playAgainChoice	DWORD	?
input_1			BYTE	"First number: ", 0
input_2			BYTE	"Second number: ", 0
print_sum		BYTE	"Sum: ", 0
print_diff		BYTE	"Difference: ", 0
print_product	BYTE	"Product: ", 0
print_quotient	BYTE	"Quotient: ", 0
print_remaind	BYTE	"Remainder: ", 0
number_1		DWORD	?
number_2		DWORD	?
sum				DWORD	?
difference		DWORD	?
product			DWORD	?
quotient		DWORD	?
remainder		DWORD	?

.code
main PROC
	call Clrscr

	;Introduction of programmer
		mov		edx, OFFSET programmer
		call WriteString
		call CrLf

	;Display program title
		mov		edx, OFFSET programTitle
		call WriteString
		call CrLf
	
	;Display Extra Credit
		mov		edx, OFFSET extraCredit1
		call WriteString
		call CrLf

	;Display Extra Credit
		mov		edx, OFFSET extraCredit2
		call WriteString
		call CrLf

USERINPUT:

	;Display instructions
		mov		edx, OFFSET instructions
		call WriteString
		call CrLf

	;Get user input for 1st number
		mov			edx, OFFSET input_1
		call	WriteString
		call	ReadInt
		mov			number_1, eax

	;Get user input for 2nd number
		mov			edx, OFFSET input_2
		call	WriteString
		call	ReadInt
		mov			number_2, eax

	;Check if number_1 is GREATER than number2
		mov eax, number_2
		mov ebx, number_1
		cmp ebx, eax
		ja CALCULATIONS				;jump to CALCULATIONS if ebx is ABOVE than eax

	;If number 1 is LESS than number 2, try again
		mov edx, OFFSET tryagain
		call WriteString
		call CrLf
		jmp USERINPUT			


CALCULATIONS:
	;Perform addition
		mov eax, number_1		;move number 1 to eax register
		add eax, number_2		;add number 2 to eax register
		mov sum, eax			;move value from eax to sum
		mov eax, 0				;zero out eax

	;Perform addition
		mov eax, number_1		;move number 1 to eax register
		sub eax, number_2		;subtract number 2 from value in eax register
		mov difference, eax		;move value from eax to diff
		mov eax, 0				;zero out eax

	;Perform multiplication	
		mov eax, number_1		;move number 1 to eax register
		mov ebx, number_2		;move number 2 to ebx register
		mul ebx					;multiplies eax with ebx
		mov product, eax		;move value from eax to product
		mov eax, 0				;zero out eax

	;Perform division
		mov edx, 0				;initializes edx so the amount it can hold is not too large
		mov eax, number_1		;move number 1 to eax register
		mov ebx, number_2		;move number 2 to ebx register
		div ebx					;divides value in ebx into value in eax
		mov quotient, eax		;move value from eax to quotient
		mov remainder, edx		;move value from edx to remainder

	;Print calculated values
		mov		edx, OFFSET print_sum
		call WriteString
		mov eax, sum
		call WriteDec
		call CrLf

		mov		edx, OFFSET print_diff
		call WriteString
		mov eax, difference
		call WriteDec
		call CrLf

		mov		edx, OFFSET print_product
		call WriteString
		mov eax, product
		call WriteDec
		call CrLf

		mov		edx, OFFSET print_quotient
		call WriteString
		mov eax, quotient
		call WriteDec
		call CrLf

		mov		edx, OFFSET print_remaind
		call WriteString
		mov eax, remainder
		call WriteDec
		call CrLf

	;Ask if user wants to play again
		mov		edx, OFFSET playAgainPrompt
		call WriteString
		call CrLf
		call ReadInt
		call CrLf
		mov playAgainChoice, eax
		mov eax, 1
		cmp eax, playAgainChoice
		je USERINPUT					;jump if EQUAL

	;Goodbye message
		mov		edx, OFFSET goodbye
		call WriteString
		call CrLf

	exit	; exit to operating system

main ENDP
END main
