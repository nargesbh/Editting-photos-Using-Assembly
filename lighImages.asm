%include "in_out.asm"


; syscall
    sys_read     equ     0
    sys_write    equ     1
    sys_open     equ     2
    sys_close    equ     3
    
    sys_lseek    equ     8
    sys_create   equ     85
    sys_unlink   equ     87

    sys_chdir    equ     80
    sys_exit     equ     60
    sys_getdents64 equ   217
    sys_mkdir      equ   83

    stdin        equ     0
    stdout       equ     1
    stderr       equ     3

; access mode
    O_directory  equ    0q0200000
    O_RDONLY     equ    0q000000
    O_WRONLY     equ    0q000001
    O_RDWR       equ    0q000002
    O_CREAT      equ    0q000100
    O_APPEND     equ    0q002000
    
;create permission mode
    sys_IRUSR    equ     0q400     ; user read premission
    sys_IWUSR    equ     0q200     ; user write premission
    sys_makenewdir equ   0q777     ;permission when making new directory

; user define constant
    NewLine      equ     0xA
    bufferlen    equ     999999999
    sum_bufferlen equ     999999999
    ; file_first_read equ     14
    

section .data
    back            db    "/", 0
    ; directory       db    "/home/narges/Desktop/seri7/Image", 0
    ; copy_directory  db    "/home/narges/Desktop/seri7/Image/edited_photo", 0
    edited_photo    db     "edited_photo",0
    end_of_buff     dq    0

    FD_first        dq     0 ; file descriptor of current photo
    FD_copied       dq     0 ; file descriptor of edited folder 
    FDfolder        dq     0 ; file descriptor of first folderr

    offset          dq      0
    width           dq      0
    height          dq      0
    padding         dq      0

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    n               dq      0 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    end_for         dq      0 ;tedade kolle byte hai ke bayad bekhoonim(ba hesab kardane padding)
    ezafe_w         dq      0 ;oon bakhshi ke mazrabe 8 nabood o khoonde nashod



    error_create    db   "error in creating file ", NewLine, 0
    error_close     db   "error in closing file ", NewLine, 0
    error_write     db   "error in writing file ", NewLine, 0
    error_open      db   "error in opening file ", NewLine, 0
    error_append    db   "error in appending file ", NewLine, 0
    error_delete    db   "error in deleting file ", NewLine, 0
    error_read      db   "error in reading file ", NewLine, 0
    error_print     db   "error in printing file ", NewLine, 0
    error_seek      db   "error in seeking file ", NewLine, 0
    error_chdir     db   "error in changing directory ", NewLine, 0
    error_getdents  db   "error in using getdents ",NewLine, 0
    error_mkdir     db   "error in making new directory ", NewLine, 0

    suces_create    db   "file created and opened for R/W ", NewLine, 0
    suces_close     db   "file closed ", NewLine, 0
    suces_write     db   "written to file ", NewLine, 0
    suces_open      db   "file opend for R/W ", NewLine, 0
    suces_append    db   "file apened for appending ", NewLine, 0
    suces_delete    db   "file deleted ", NewLine, 0
    suces_read      db   "reading file ", NewLine, 0
    suces_seek      db   "seeking file ", NewLine, 0
    suces_diropen   db   "opening directory ", NewLine, 0
    scuces_getdens  db   "success in getdense ", NewLine, 0
    suces_mkdir     db   "new directory made ", NewLine, 0

    ;doubledot db ".."

section .bss
    buffer         resb     bufferlen
    sum_buffer     resb     sum_bufferlen
    ; first_read     resb     file_first_read
    concat         resb     1000
    concat_copy    resb     1000
    copy_directory  resb    1000 
    directory       resb    1000

section .text
global _start

createFile:
    mov rax, sys_create
    mov rsi, sys_IRUSR | sys_IWUSR
    syscall
    cmp rax, -1
    jle createerror
    mov rsi, suces_create
    push rax
    call printString
    pop rax
    ret
createerror:
    mov rsi, error_create
    call printString
    ret

openFile:
    mov rax, sys_open
    mov rsi, O_RDWR| O_CREAT
    mov rdx, sys_IRUSR | sys_IWUSR
    syscall
    cmp rax, -1
    jle openerror
    mov rsi, suces_open
    push rax
    call printString
    pop rax
    ret
openerror:
    mov rsi, error_open
    call printString
    ret

; rdi : file descriptor, rsi : buffer, rdx : length
writeFile:
    mov rax, sys_write
    syscall
    cmp rax, -1     ; number of written byte
    jle writeerror
    mov rsi, suces_write
    call printString
    ret
writeerror:
    mov rsi, error_write
    call printString
    ret

; rdi : file descriptor, rsi : buffer, rdx : length
readFile:
    mov rax, sys_read
    syscall
    cmp rax, -1     ; number of read byte
    jle readerror
    mov byte [rsi + rax], 0     ; add a zero
    mov rsi, suces_read
    call printString
    ret
readerror:
    mov rsi, error_read
    call printString
    ret


; rdi : file descriptor
closeFile:
    mov rax, sys_close
    syscall
    cmp rax, -1     ; 0 successful
    jle closeerror
    mov rsi, suces_close
    call printString
    ret
closeerror:
    mov rsi, error_close
    call printString
    ret


opendirectory:
	mov rax, sys_open
	mov rsi, O_directory
	syscall
    cmp rax,-1
    jle openerror
    mov     rsi, suces_diropen
    call    printString
    ret
makeDirectory:
    mov     rax, sys_mkdir
    mov     rsi, sys_makenewdir
    syscall
    cmp     rax, -1  
    jle     makeDirectoryerror
    mov     rsi, suces_mkdir
    call    printString
    ret
makeDirectoryerror:
    mov     rsi, error_mkdir
    call    printString
    ret

getdents:
	mov rax, sys_getdents64
	mov rdi, [FDfolder]
	mov rsi, sum_buffer
	mov rdx, sum_bufferlen
	syscall

    cmp rax, -1

    jle     getdents_error
    mov     rsi, scuces_getdens
    call    printString
    ret


    ; mov [end_of_buff], rax
    
    ; xor rdx, rdx
    ; mov r11, sum_buffer
    ; add [end_of_buff],r11 
getdents_error:
    mov     rsi, error_getdents
    call    printString
    ret

read_files:
    add rdx,r11
    cmp rdx,[end_of_buff]
    jge end_read
    xor r11,r11 
    mov r11w,[rdx+16]
    mov r12, rdx
    add r12,18 
    xor r13,r13 
    mov r13b, [r12]
    cmp r13, 8
    jne read_files

    inc r12

    push r12
    push r11
    push r13
    push rdx

    call check_file

    pop rdx
    pop r13
    pop r11
    pop r12

    jmp read_files 

check_file:
    xor r9,r9
    xor r10,r10

    ;after this function we have path+fileName in "concat"
    call for

    ;opening the file
    mov rdi, concat
    call openFile
    mov [FD_first], rax

    ;reading the file
    mov rdi, [FD_first]
    mov rsi, buffer
    mov rdx, bufferlen
    call readFile

    ; mov rdi, rsi 
    ; call printString
    cmp word[buffer], "BM"
    je bitmap


    ;closing the file
    mov rdi,[FD_first]
    call closeFile

    ret

bitmap:
    push rax 
    mov rax, 3
    call writeNum
    call newLine
    pop rax
    xor r9,r9
    xor r10,r10

    call for_sec_directory

    ;opening the file
    mov rdi, concat_copy
    call openFile
    mov [FD_copied], rax



    xor r14, r14
    add r14,10 ;for finding offset to start of pixel 
    mov eax, [buffer+r14]
    mov [offset], eax

    add r14,4 ;r14=14
    mov eax, [buffer+r14]
    cmp eax, 12
    je os

    jmp windows
    


os:

    add r14,4 ;r14=18
    mov ax, [buffer+r14]
    mov [width], ax 

    add r14,2 ;r14=20
    mov ax, [buffer+r14]
    mov [height], ax 


    mov r14, [offset]

    jmp find_padding

windows:
    add r14,4 ;r14=18
    mov eax, [buffer+r14]
    mov [width], eax 

    add r14,4 ;r14=22
    mov eax, [buffer+r14]
    mov [height], eax 

    mov r14, [offset]

    jmp find_padding

find_padding:

    mov rax, [width] ;hesab kardane padding ke mishe 4-(w%4)

    push rdx 

    xor rdx,rdx

    mov rbx, 4

    idiv rbx ;(w%4)

    cmp rdx, 0 ;0 halate khase ke bayad kollan padding ro 0 return kone
    je aft_pad

    sub rbx, rdx  ;4-(w%4)

    mov [padding], rbx 

    jmp aft_pad

aft_pad: ;hesab kardane [h*(w+p)] * 3  va mirizim to end_for ke befahmim chand ta pxel darim------ hesab kardane w*3/8 
;[(h*w*3)] + (h*p) bayad bashe

    pop rdx

    mov rbx, [width] ;rbx = w

    imul rbx,3 ;rbx = w*3

    imul rbx, [height] ;rbx = h*w*3

    mov rcx, [height]

    imul rcx, [padding] ;rcx = h*p

    add rbx, rcx ;rbx = [(h*w*3)] + (h*p)]

    mov [end_for], rbx

    ; CHERA W*3/8????????!!!!!!!!!!!!!

    mov rax,3
    imul rax, [width] ;rax = w*3

    mov rcx, 8

    push rdx 

    xor rdx, rdx

    idiv rcx ;rax = w*3/8

    mov [ezafe_w],rdx ;rdx bayad bashe dg? mishe oon pixel hai ke mazrabe 8 nabood o khooonde nashod?

    pop rdx



add_pixel:


    cmp r14, [end_for] ;check mikonim pixel ha tamoom shodan ya na
    je pixels_finished


    ; mov r15, [end_for] ;debug

    pxor xmm1,xmm1
    movq xmm1,[buffer+r14] ;r14=offset

    pxor xmm0, xmm0
    punpcklbw xmm1, xmm0 ;xmm1 has pixels

    vpbroadcastw xmm0, [n]

    paddw xmm1, xmm0

    packuswb xmm1, xmm1

    movq [buffer+r14], xmm1

    add r14,16 ;vase in 16 gozashtam ke check konam bebinam be ezafeye akharesh residam ya na

    cmp r14, [end_for]
    jg pixels_finished

    sub r14, 8 ;8 ta kam mikonam chon hanooz be tahesh naresidam

    jmp add_pixel
    
    ; add r14,8

    ; mov r15, [ezafe_w] ;debug

    ; xor r15, r15

    ; call add_ezafe

    ; add r14, [padding]

    ; jmp add_pixel
pixels_finished: ;inja hame pixel haye zarib 8 tamoom shode va khoordehash moonde
    sub r14,8
    mov r15, [end_for]

    sub r15, r14 ;r15 = tedade khoorde pixela

    jmp add_ezafe

add_ezafe:
    cmp r15,0
    je write_new_file

    mov bl,[buffer+r14] 
    add ebx, [n]


    cmp eax,  0xFF
    jg higher


    cmp ebx, 0x00
    jl lower

    dec r15
    inc r14 ;new

    jmp add_ezafe

higher:
    mov byte [buffer+r14], 0xFF
    dec r15
    inc r14 

    jmp add_ezafe

lower:
    mov byte [buffer+r14], 0x00
    dec r15
    inc r14 

    jmp add_ezafe

; end_ezafe:
    ; ret
write_new_file:

    ;writing to new file
    mov rdi, [FD_copied]
    mov rsi, buffer
    mov rdx, [end_for]
    call writeFile 
    

    mov rdi,[FD_copied]
    call closeFile

    mov rdi,[FD_first]
    call closeFile

    ret
end_read:
    mov rax,60
    mov rdi,0
    syscall

_start:

    mov rax, 0
    mov rdi, 0
    mov rsi, directory
    mov rdx, 1000
    syscall
    mov byte [rsi+rax-1], 0

    mov rsi, directory
    call printString
    call newLine

    xor r10, r10
    xor r9,r9
    mov r12, edited_photo

    call make_copydir

    xor rax, rax
    call readNum    
    mov dword [n], eax

    ;old directory
    mov rdi, directory
    call opendirectory
    mov [FDfolder], rax 


    ;making new directory
    mov rdi, copy_directory
    call makeDirectory
    mov [FD_copied], rax

    call getdents
    ; add rax, sum_buffer
    ; mov [end_of_buff], rax


    mov [end_of_buff], rax
    
    xor rdx, rdx
    mov r11, sum_buffer
    add [end_of_buff],r11 


    call read_files

    jmp exit 

exit:
    ; exit program
    mov rax, 60
    xor rdi, rdi
    syscall

;bellow functions are for concatenating path and file name
for:
    mov al, [directory+r10]
    cmp al,0
    je pre2
    mov [concat+r10], al
    inc r10
    jmp for


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
for_sec_directory:
    mov al, [copy_directory+r10]
    cmp al,0
    je pre2_copy
    mov [concat_copy+r10], al
    inc r10
    jmp for_sec_directory

pre2_copy:
    mov al, [back]
    mov [concat_copy+r10], al
    inc r10
    jmp for2_copy

for2_copy:
    mov al, [r12+r9]
    cmp al,0
    je print_copy
    mov [concat_copy+r10], al
    inc r9
    inc r10
    jmp for2_copy
print_copy:
    mov al,0
    mov [concat_copy+r10], al
    ; mov rsi, concat_copy 
    ; call printString
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pre2:
    mov al, [back]
    mov [concat+r10], al
    inc r10
    jmp for2

for2:
    mov al, [r12+r9]
    cmp al,0
    je print
    mov [concat+r10], al
    inc r9
    inc r10
    jmp for2

print:
    mov al,0
    mov [concat+r10], al
    ; mov rsi, concat 
    ; call printString
    ret

make_copydir:
    mov al, [directory+r10]
    cmp al,0
    je pre2_copy_l
    mov [copy_directory+r10], al
    inc r10
    jmp make_copydir

pre2_copy_l:
    mov al, [back]
    mov [copy_directory+r10], al
    inc r10
    jmp for2_copy_l
    ; jmp f_h
    
for2_copy_l:
    mov al, [r12+r9]
    cmp al,0
    je print_copy_l
    mov [copy_directory+r10], al
    inc r9
    inc r10
    ; call print_copy_l
    jmp for2_copy_l

print_copy_l:

    ; mov al,0
    ; mov [copy_directory+r10], al
    ; mov rax,3
    ; call writeNum
    ; call newLine
    mov rsi, copy_directory
    call printString
    ; call newLine
    ; call writeNum
    call newLine
    ret


