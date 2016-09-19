;TITLE: Assignment #6A        (Assignment_6A.asm)

 

; Author:     Jeanvally G.Beato
; Email:  beatoj@oregonstate.edu
; Course:  CS271-400    
; Assignment: # 6A  
; Assignment Due Date:  6/05/16           
; Description:  1.  Implement and test your own ReadVal and WriteVal procedures for unsigned integers. 
;               2.  Implement macros getString and displayString.  The macros may use Irvine's ReadString
;					to get input from the user, and WriteString to display output. 
;					a.)  getString should display a prompt, then get the user's keyboard input into a memory location 
;					b.)  displayString should show the string stored in a specified memory location
;					c.)  readVal should invoke the getString macro to get the user's string of digits. It should
;						 then convert the digit string to numeric, while validating the user's input.
;					d.)  writeVal should convert a numeric value to a string of digits, and invoke the displayString macro to
;						 produce the output
;				3.  Write a small test program that gets 10 valid integers from the user and stores the numeric values in
;					an array.  The program then displays the integers, their sum, and their average.

INCLUDE Irvine32.inc 

;CONSTANTS
	MAXINPUT = 10

;-------------------------------------------------------------------
;MACRO:  displayString
;Description:  Display the string stored in a specific memory location
;Parameters:  stringResult
;-------------------------------------------------------------------
displayString	MACRO stringResult
	push edx
	mov		edx, OFFSET stringResult
	call WriteString
	pop edx

ENDM

;-------------------------------------------------------------------
;MACRO:  getString
;Description:  Display a prompt, then get the user's keyboard input
;and put into a memory location
;Parameters:  address, length
;Note:  Borrowed from Lecture #26, Slide #7
;-------------------------------------------------------------------
getString	MACRO string, length
	push edx
	push ecx
	mov edx, string
	mov ecx, length
	call ReadString
	pop ecx
	pop edx

ENDM

.data

programTitle  BYTE   "PROGRAMMING ASSIGNMENT 6:  Designing low-level I/O procedures", 0
programmer	  BYTE   "Written By:  Jeanvally G.Beato", 0
instructions  BYTE   "Please provide 10 unsigned decimal integers.", 0
instructions2 BYTE   "Each number needs to be small enough to fit inside a 32 bit register.", 0
instructions3 BYTE   "After you have finished inputting the raw numbers I will display a list", 0
instructions4 BYTE   "of the integers, their sum, and their average value.", 0
prompt        BYTE   "Please enter an unsigned number: ", 0
errorMessage  BYTE   "ERROR: You did not enter an unsigned number or your number was too big.", 0
errorMessage2 BYTE	 "Please try again. ", 0
goodbye		  BYTE	 "Thanks for playing!", 0
inputBuffer	  BYTE	 200 DUP(0)					;for user input
temp		  BYTE	 32 DUP(0)

average		  DWORD	 ?
sum			  DWORD  ?
array         DWORD  MAXINPUT    DUP(?)        ;uninitialized array with capacity of 10

spacing       BYTE   " , ", 0 

youEntered    BYTE   "You entered the following numbers: ", 0
theSum	      BYTE   "The sum of these numbers is: ", 0
theAve        BYTE   "The average is: ", 0

EC1			  BYTE   "EXTRA CREDIT:  1.  Number each line of user input and display a running subtotal of the user's numbers.", 0
EC2			  BYTE   "EXTRA CREDIT:  2.  Handle signed integers.", 0
lineNumber	  DWORD  ?
punct		  BYTE   ".) ",0
totalEntered  BYTE   "Total #'s entered: ",0

.code

main PROC

	;-------------------------------------------------------------------------
	;INTRO
	;-------------------------------------------------------------------------
	call introduction

	;Set up the loop controls
	mov edi, OFFSET array
	mov ecx, MAXINPUT

	;-------------------------------------------------------------------------
	;GET VALUES FROM USER/DISPLAYS VALUES
	;Description:  Display prompt to get integer from user.  Push parameters
	;onto stack, then call ReadVal .  Iterate to next position in array.
	;Go back to top of label if 10 values haven't been received.  Show user
	;entered numbers.
	;-------------------------------------------------------------------------
	userInput:
		displayString prompt		;macro to display user input prompt
		push OFFSET inputBuffer		;push address onto stack by reference
		push SIZEOF inputBuffer		;push size onto stack by value
		call ReadVal

		mov eax, DWORD PTR inputBuffer
		mov [edi], eax
		add edi, 4					;go to next position in array
		loop userInput				;if 10 values haven't been received yet

		;display numbers entered by user
		mov ecx, MAXINPUT			;counter 10 in ecx
		mov esi, OFFSET array
		mov ebx, 0					;we will use ebx for calculating the sum
		displayString youEntered	;macro to display title before displaying user entered numbers
		call CrLf

	;-------------------------------------------------------------------------
	;CALCULATE SUM/AVERAGE AND DISPLAY
	;Description:  Display the sum.  Calculate the average, determine if it 
	;requires rounding up.
	;-------------------------------------------------------------------------
	sums:
		mov eax, [esi]
		add ebx, eax				;adding value in eax to sum in ebx
		push eax					;pushing parameters(eax & temp) then call WriteVal to display numbers
		push OFFSET temp			;push temp by reference
		call WriteVal
		call CrLf
		add esi, 4					;to to next element in array
		loop sums

		;show sum
		mov eax, ebx				;ebx holds sum, putting in eax to display
		mov sum, eax
		displayString theSum		;macro to display sum title
		push sum					;pushing parameters( sum & temp) then call WriteVal to display the sum
		push OFFSET temp			;push temp by reference
		call WriteVal
		call CrLf

		mov ebx, MAXINPUT			;setting ebx to 10
		mov edx, 0					;clear remainder to prepare for division
		div ebx
		
		;check if rounding is necessary
		mov ecx, eax
		mov eax, edx
		mov edx, 2
		mul edx
		cmp eax, ebx
		mov eax, ecx
		mov average, eax
		jb noRounding
		inc eax						;if rounding is required, then increment by 1 in order to round up
		mov average, eax

	noRounding:
		displayString theAve		;macro to display average title
		push average				;push average by value
		push OFFSET temp			;push temp by reference
		call WriteVal
		call CrLf

	;-------------------------------------------------------------------------
	;EXTRA CREDIT
	;-------------------------------------------------------------------------
		displayString totalEntered		;macro to display the running total of the user's numbers entered
		mov eax, lineNumber
		call WriteDec
		call CrLf
		call CrLf

	;-------------------------------------------------------------------------
	;FAREWELL
	;-------------------------------------------------------------------------
	call farewell

	exit

main ENDP

;-------------------------------------------------------------------------
;INTRODUCTION
;
;Description:  Introduce the name of the program, the programmer, and 
;instructions.
;Receives:           None
;Returns:            Prints program, programmer & program description.
;Registers Changed:  EDX
;-------------------------------------------------------------------------

introduction PROC

	;Display program title
		mov           edx, OFFSET programTitle
		call WriteString
		call CrLf
		call CrLf

	;Display programmer
		mov		edx, OFFSET programmer
		call WriteString
		call CrLf

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
		mov		edx, OFFSET instructions4
		call WriteString
		call CrLf

	;Display Extra Credit
		mov		edx, OFFSET EC1
		call WriteString
		call CrLf

		mov		edx, OFFSET EC2
		call WriteString
		call CrLf

		call CrLf

	ret

introduction ENDP


;-------------------------------------------------------------------------
;GOODBYE
;
;Description:  Farewell message
;Receives:           None
;Returns:            Goodbye message
;Registers Changed:  EDX
;-------------------------------------------------------------------------

farewell PROC

	;Display goodbye message
		mov           edx, OFFSET goodbye
		call WriteString
		call CrLf
		call CrLf
	
	ret

farewell ENDP

;-------------------------------------------------------------------------
;READVAL
;
;Description:  Invoke getString(MACRO) to get user's string of digits
;			   Convert digit string to numeric, while validating user's input
;Receives:     OFFSET inputBuffer, SIZEOF inputBuffer
;-------------------------------------------------------------------------

readVal PROC
       
	push ebp						;push old ebp +4
	mov ebp, esp					;set stack frame pointer
	pushad							;save all registers

	;Ask user for number
		asknumber:
			mov eax, 1				;EXTRA CREDIT: Display line #'s
			add lineNumber, eax		
			mov eax, lineNumber
			call WriteDec
			mov edx, OFFSET punct
			call WriteString		;**end of Extra Credit
									
			mov edx, [ebp+12]		;address of inputBuffer
			mov ecx, [ebp+8]		;size of inputBuffer array stored in ecx
			getString edx, ecx		;invoke getString(macro) to get user's string of digits
			
			;Setting up registers for conversion to numeric
			mov esi, edx			;esi now holds address of inputBuffer
			mov eax, 0
			mov ecx, 0
			mov ebx, MAXINPUT		;maxinput is 10

	;Utilize LODSB, which load's a byte from memory at ESI into AX.  ESI is incremented/
	;decremented based on state of Direction Flag.  But the default is forward, unless it is changed.
		loadbytes:
			lodsb					;load's a byte from memory at ESI into AX
			cmp ax, 0				;comparing to check if end of string has been reached
			je done

			cmp ax, 57				;validating to see if char is an int in the ASCII table, 9 is ASCII 57
			ja invalidInput			;jump to error message if it is above
			cmp ax, 48				;validating to see if char is an int in the ASCII table, 0 is ASCII 48
			jb invalidInput			;jump to error message if it is below

		;if no invalid input then, adjust the string for the value of the digit
			sub ax, 48				;subtracting 48 for the value
			xchg eax, ecx			;exchanging the value of the character in ecx, with eax
			mul ebx					;since ebx holds MAXINPUT 10, multiply value of character by 10
			jc invalidInput			;if carry flag is set which determines OF
			jnc valid				;if carry flag is NOT set

		invalidInput:
			mov edx, OFFSET errorMessage
			call WriteString
			call CrLf
			mov edx, OFFSET errorMessage2
			call WriteString
			call CrLf
			jmp asknumber

		valid:
			add eax, ecx			;adding the digit (at a position) to the total
			xchg eax, ecx			;exchanging eax and ecx for the next loop
			jmp loadbytes			;check the next byte
	
		done:
			xchg ecx, eax
			mov DWORD PTR inputBuffer, eax		;saving the int in passed variable, by moving eax to the pointer
			popad								;restores registers
			pop ebp								;restore stack
			ret 8								;return bytes pushed before the call

readVal ENDP

;-------------------------------------------------------------------------
;WRITE VAL
;Description:  Convert numeric value to a string of digits
;			   Invoke displayString(MACRO) to produce
;Receives:     integer(to convert to string) and a string(memory) to produce output
;-------------------------------------------------------------------------

WriteVal PROC
	push ebp						;push old ebp, +4
	mov ebp, esp					;set stack frame pointer
	pushad							;save registers
									;now need to loop through integers
	mov eax, [ebp+12]				;move integer to be converted to a string in eax
	mov edi, [ebp+8]				;move the address to edi to store string
	mov ebx, MAXINPUT				;in order to find the spot of digit
	push 0							;this is the top of stack

	conversion:
		mov edx, 0					;clear remainder	
		div ebx						;divide value by 10 to extract minimal digit
		add edx, 48
		push edx					;push following digit onto stack
		cmp eax, 0					;check if the end has been reached
		jne conversion				;keep looping conversion until end is reached

	pops:
		pop [edi]
		mov eax, [edi]
		inc edi						;edi holds the counter, increment it
		cmp eax, 0					;check if the end has been reached
		jne pops						;keep looping pop until end has been reached

	mov edx, [ebp+8]				;now we can write the string using the macro
	displayString OFFSET temp
	call CrLf

	popad							;restore all registers
	pop ebp							;restore stack
	ret 8							;return bytes pushed before the call
		
WriteVal ENDP

END main