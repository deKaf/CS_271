;TITLE: Assignment #5        (Assignment_5.asm)

 

; Author:     Jeanvally G.Beato
; Email:  beatoj@oregonstate.edu
; Course:  CS271-400    
; Assignment: # 5  
; Assignment Due Date:  5/22/16           
; Description:  1.  Introduce the program.
;               2.  Get a user request in the range [min = 10..max = 200] 
;               3.  Generate request random integers in the range [lo = 100..hi = 999], storing them in 
;                   consecurive elements of an array.
;               4.  Display the list of integers before sorting, 10 numbers per line.  
;               5.  Sort the list in decending order (i.e. largest first).  
;               6.  Calculate and display the median value, rounded to the nearest integer. 
;               7.  Display the sorted list, 10 numbers per line. 

INCLUDE Irvine32.inc 

;CONSTANTS
	MIN= 10
	MAX= 200
	LO = 100
	HI = 999


.data

programTitle  BYTE   "Program Title:  Sorting Random Integers (Assignment #5)", 0
programmer            BYTE   "Name:  Jeanvally G.Beato", 0
instructions  BYTE   "This program generates random numbers in the range [100..999], ", 0
instructions2 BYTE   "displays the original list, sorts the list, and calculates the ", 0
instructions3 BYTE   "median value. Finally, it displays the list sorted in descending order.", 0
prompt                BYTE   "How many numbers should be generated? [10..200]: ", 0
errorMessage  BYTE   "Invalid Input.  Try again...", 0

request       DWORD  ?

array         DWORD  MAX    DUP(?)        ;uninitialized array with capacity of 200 (since max is up to 200)

sorted        BYTE   "Sorted List: ", 0
unsorted      BYTE   "Unsorted List: ", 0
printMed      BYTE   "Median: ", 0

spacing               BYTE   "     ", 0 

.code

main PROC

 

	;SEED RANDOM NUMBER GENERATOR
	call Randomize

	;--------------------------------------
	;INTRO
	;Parameters:  none
	;--------------------------------------
	call introduction

	;--------------------------------------
	;GET DATA
	;Parameters:  request (reference)
	;--------------------------------------
	push   OFFSET request                      
	call getUserData

	;--------------------------------------
	;GET FILL ARRAY
	;Parameters: request (by value), array
	;(by reference)
	;--------------------------------------
	push request
	push   OFFSET array                        
	call fillArray

	;--------------------------------------
	;DISPAY LIST (UNSORTED)
	;Parameters:  array (by reference),
	;                       request (by value), 
	;                       title (by reference)
	;--------------------------------------
	push   OFFSET array
	push   request
	push   OFFSET unsorted                            
	call displayList

	;--------------------------------------
	;SORT LIST
	;Parameters:  array (by reference),
	;                       request (by value)
	;--------------------------------------
	push   OFFSET array
	push   request               
	call sortList


	;--------------------------------------
	;DISPLAY MEDIAN
	;Parameters:  array (by reference),
	;                       request (by value)
	;--------------------------------------
	push   OFFSET array
	push   request               
	call displayMedian



	;--------------------------------------
	;DISPAY ARRAY (SORTED)
	;Parameters: array (by reference),
	; request (by value),
	; title (by reference)
	;--------------------------------------
	push OFFSET array
	push request
	push OFFSET sorted
	call displayList

	exit

main ENDP

;-------------------------------------------------------------------------
;INTRODUCTION
;
;Description:  Introduce the name of the program, the programmer, and 
;instructions.
;Receives:                   None
;Returns:                    Prints program, programmer & program description.
;Registers Changed:  EDX
;-------------------------------------------------------------------------

introduction PROC

	;Display program title
		mov           edx, OFFSET programTitle
		call WriteString
		call CrLf
		call CrLf

 

	;Display programmer
		mov edx, OFFSET programmer
		call WriteString
		call CrLf

	;Display instructions
		mov edx, OFFSET instructions
		call WriteString
		call CrLf
		mov edx, OFFSET instructions2
		call WriteString
		call CrLf
		mov edx, OFFSET instructions3
		call WriteString
		call CrLf
		call CrLf

	ret

introduction ENDP

;-------------------------------------------------------------------------
;GET USER DATA
;
;Description:  Asks user for number input, validates & stores.
;Receives:                   request (by reference)
;Returns:                    N/A
;Registers Changed:  EDX, EAX, EBP
;-------------------------------------------------------------------------

getUserData PROC

       

	push ebp						;push old ebp +4
	mov ebp, esp					;set stack frame pointer
	mov ebx, [ebp + 8]				;location of request's address+4 is now in ebx, ebx now points to it

	;Ask user for number
		asknumber:
			mov edx, OFFSET prompt
			call WriteString
			call ReadInt

			cmp eax, MIN
			jge overMIN
			jl invalidInput

		overMIN:
			cmp eax, MAX
			jg invalidInput
			jmp valid

		invalidInput:
			mov edx, OFFSET errorMessage
			call WriteString
			call CrLf
			jmp asknumber

		valid:
			mov [ebx], eax			;store value in ebx, ebx was pointing to request on the stack
			pop ebp					;restore stack
			call CrLf
	
		ret 4 ;return bytes pushed before the call

getUserData ENDP

;-------------------------------------------------------------------------
;FILL ARRAY
;
;Description:  Generate request random integers in the range [100..999],
;                        storing them in consecutive elements of an array.
;Receives:                   request (by value), array (by reference)
;Returns:                    N/A
;Registers Changed:  EAX, EBX, ECX, EDI, EBP
;-------------------------------------------------------------------------

fillArray PROC
	push ebp						;push old ebp, +4
	mov ebp, esp					;set stack frame pointer
	mov ecx, [ebp+12]				;request as count in ecx
	mov esi, [ebp+8]				;address of beginning of array in esi

	;*****NOTE: Reference the nextRand PROC in Lecture #20
	mov eax, HI						;HI global
	sub eax, LO						;HI global - LO global
	inc eax							;add 1 to get number of integers in range

	loopFill:
		call RandomRange			;eax gets value in [0...range-1]
		add eax, LO					;creates the final random integer
		mov [esi], eax				;store integer in current array element
		add esi, 4					;DWORD is 4 bytes to move to next element
		loop loopFill

	pop ebp							;restore stack
	ret 8							;return bytes pushed before the call
		
fillArray ENDP

;-------------------------------------------------------------------------
;DISPLAY LIST
;
;Description:  Display the list of integers
;Receives:                   array(by reference), request (by value), title (by reference)
;Returns:                    N/A
;Registers Changed:  EAX, EBX, EDX, ESI, EBP
;------------------------------------------------------------------------- 

displayList PROC

	;*****NOTE: Borrowed from register setup DEMO5.ASM
	push ebp						;push old ebp, +4
	mov ebp, esp					;set stack frame pointer
	mov esi, [ebp+16]				;address of array in esi
									;since we push 3 parameters, this is now +16 instead of +12
	mov ecx, [ebp+12]				;number of elements in ecx (counter)
	mov ebx, 0						;count per line

	;Title Display
		call CrLf
		mov edx, [ebp + 8]			;since this was last pushed on stack
		call WriteString
		call CrLf

	showCurrent:
		cmp ebx, MIN				;must be at beginning so value outside of range is not displayed
		je nextRow					;if 10 values have been displayed, jump to next row

		mov eax, [esi]				;current element in eax
		call WriteDec

		add esi, 4					;go to next element
		mov edx, OFFSET spacing		;print spacing between values
		call WriteString
		inc ebx
		loop showCurrent			;loop again
		jmp finished				;once ecx = 0, no more loop, skip over to finished

	nextRow:
		call CrLf
		mov ebx, 0
		jmp showCurrent

	finished:
		pop ebp						;restore stack
		ret 12						;return bytes pushed before the call

displayList ENDP

;-------------------------------------------------------------------------
;SORT LIST
;
;Description:  Sort the list of integers before sorting, 10 numbers per line. 
;Receives:                   array(by reference), request (by value)
;Returns:                    N/A
;Registers Changed:  EAX, EBX, EDX, ESI, EBP
;-------------------------------------------------------------------------

sortList PROC


	;*****NOTE: Borrowed from Irvine textbook example programs, BubbleSort.asm
	push ebp						;push old ebp, +4
	mov ebp, esp					;set stack frame pointer
	mov ecx, [ebp+8]				;number of elements in ecx (counter)
	dec ecx							;decrement count by 1

	L1: push ecx					; save outer loop count
		mov esi, [ebp+12]			;address of array in esi, points to first value

	L2: mov eax,[esi]				; get array value
		cmp [esi+4],eax				; compare next element to current element
		jl L3						; if [esi] < [esi+4 or next element], don't exchange
		xchg eax,[esi+4]			; else, exchange the pair
		mov [esi],eax	

	L3: add esi,4					; move pointer to next element, next element is now current element
		loop L2						; inner loop
		pop ecx						; retrieve outer loop count
		loop L1						; repeat outer loop

pop ebp
ret 8

sortList ENDP

;-------------------------------------------------------------------------
;DISPLAY MEDIAN
;
;Description:  It is the middle element of the sorted list.  If the number
;             of elements is even, the median is the average of the middle 
;             two elements(may be rounded). 
;Receives:                   array(by reference), request (by value)
;Returns:                    N/A
;Registers Changed:  EAX, EBX, EDX, ESI, EBP
;------------------------------------------------------------------------- 

displayMedian PROC

	push ebp						;push old ebp, +4
	mov ebp, esp					;set stack frame pointer
	mov esi, [ebp+12]				;address of array in esi, points to first value
	mov ecx, [ebp+8]				;number of elements in ecx (counter)
	mov edx, 0						;clear edx since division will take place

	;check if odd or even # of elements
	mov eax, ecx					;move # of elements to eax
	mov ecx, 2
	div ecx							;eax will hold quotient
	cmp edx, 0						;edx will hold the remainder, if remainder is 0 then EVEN, if 1 then ODD
	je ifEven
	ja ifOdd

	ifOdd:							;eax already holds the index of the median
		mov ebx, 4
		mul ebx						;this gives us the OFFSET of median
		mov ebx, [esi+eax]			;move value stored in median index, into ebx
		mov eax, ebx
		jmp printMedian



	ifEven:							;eax holds index of higher median
		mov ebx, 4
		mul ebx						;this gives us the OFFSET of higher median in eax
		mov ebx, [esi+eax]			;move value stored in higher median index, into ebx

		sub eax, 4					;this gives us the OFFSET of lower median in eax
		mov eax, [esi+eax]			;move value stored in lower median index, into eax
		add eax, ebx				;add both higher & lower median values together
		mov ebx, 2
		div ebx						;eax now holds average of higher & lower median values
		jmp printMedian

	printMedian:
		call CrLf
		call CrLf
		mov edx, OFFSET printMed
		call WriteString
		call WriteDec
		call CrLf
		call CrLf
		jmp finished

	finished:
		pop ebp 
		ret 8

displayMedian ENDP

END main

