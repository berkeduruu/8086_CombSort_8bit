DATA SEGMENT
    arr DB 45H,12H,0AH,2FH,0D6H,0CCH,8AH,2BH
    arrLen EQU $ - arr; size of arr (8)
    gap db 8 ; gap value
    swapped db 1 ; swapped variable
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA
START:

    MOV AX,DATA
    MOV DS,AX   ; Load Data Segment into DS register
    
FIRST_LOOP:
    CMP byte ptr [gap], 1           ; Compare gap with 1
    JE check_swapped    ; If gap == 1, proceed to check swapped flag
    JMP continue_loop   ; If gap != 1, continue the loop

check_swapped:
    ; Check swapped flag
    CMP byte ptr [swapped], 0       ; If swapped == 0 (false), exit the loop
    JE DONE             ; If swapped == 0, exit the loop
    JMP continue_loop   ; If swapped == 1, continue the loop

continue_loop:     
    ; gap = (gap * 10) / 13 operation
    MOV AL, [gap]        ; Load gap into AL register
    MOV BL, 10           ; Load 10 into BL register
    MUL BL                ; AL * BL (gap * 10)
    MOV BL, 13           ; Load 13 into BL register
    DIV BL                ; AL / BL (gap * 10 / 13)
    MOV [gap], AL        ; Store the new gap value in the gap variable
    
    ; if (gap < 1); gap = 1
    CMP AL, 1            ; Compare AL with 1
    JGE skip_update_gap  ; If gap >= 1, skip update
    MOV byte ptr [gap], 1    ; Set gap to 1
    
skip_update_gap:   
    MOV byte ptr [swapped], 0    ; Reset swapped flag to 0
    MOV BH, 0              ; Set i = 0 (start of the loop)
    
SECOND_LOOP:
    ; for i = 0 to n - gap - 1
    MOV AL, [gap]        ; Load gap into AL register
    MOV CL, arrLen       ; Load arrLen into CL register
    SUB CL, AL           ; Calculate n - gap (arrLen - gap)

check_condition:
    CMP BH, CL           ; Compare i with (n - gap)
    JNL FIRST_LOOP        ; If i >= n - gap, exit the loop and go back to the first loop
 
    MOV CX, 0000h          ; Clear CX register (used for index calculation)
    MOV CL, BH             ; Copy i to CL register
    MOV SI, CX             ; Set SI register to index i
    MOV AL, [arr + SI]     ; Load arr[i] into AL register

    MOV CL, [gap]          ; Load gap into CL register
    ADD SI, CX             ; SI = i + gap, to point to arr[i + gap]
    MOV BL, [arr + SI]     ; Load arr[i + gap] into BL register
    
    CMP AL, BL             ; Compare arr[i] with arr[i + gap]
    JB  continue_second_loop ; If arr[i] <= arr[i + gap], for continue without swapping
    
    ; Swap arr[i] and arr[i + gap]
    XCHG [arr + SI], AL    ; Swap arr[i + gap] with AL(stores arr[i])beacuse memory to memory swap cannot execute
    SUB SI, CX             ; SI = i (move back to arr[i])
    XCHG [arr + SI], BL    ; Swap arr[i] with BL(stores arr[i + gap])beacuse memory to memory swap cannot execute
    MOV [swapped], 1       ; Set swapped flag to 1 (swap occurred)
    
    
continue_second_loop:
    INC BH                ; Increment i (BH register used as counter)
    JMP SECOND_LOOP       ; Jump back to continue checking the second loop



DONE:

CODE ENDS
END START