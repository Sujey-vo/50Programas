.global main
.section .text

main:
    sub sp, sp, 16           

    ldr x0, =format           
    mov x1, sp                
    bl scanf                  
    ldr w1, [sp]              

    ldr x0, =format           
    add x1, sp, 8             
    bl scanf                  
    ldr w2, [sp, 8]           

    udiv w0, w1, w2           

    ldr x0, =result           
    mov x1, x0                
    bl printf                 

    add sp, sp, 16            
    mov x0, 0                 
    ret                       

.section .rodata
format: .asciz "%d"
result: .asciz "El resultado es: %d\n"
