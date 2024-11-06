.global main
.section .text

main:
    // Reservar espacio en la pila para un entero
    sub sp, sp, 16          // Reservar espacio en la pila (8 bytes para un entero)

    // Leer el número entero con scanf
    ldr x0, =format         // Cargar la dirección de la cadena de formato ("%d")
    add x1, sp, 0           // Dirección para almacenar el número leído
    bl scanf                // Llamada a scanf para leer el número

    // Cargar el valor entero
    ldr w2, [sp]            // Cargar el número entero desde la pila en w2

    // Convertir el número a su valor ASCII (sumar '0' que es 0x30)
    add w2, w2, #0x30       // Sumar 0x30 (valor ASCII de '0') al número

    // Imprimir el carácter ASCII con printf
    ldr x0, =result         // Cargar la dirección de la cadena de formato ("El carácter es: %c\n")
    mov w1, w2              // Mover el valor ASCII a w1 (primer argumento para printf)
    bl printf               // Llamada a printf para imprimir el resultado

    // Terminar el programa
    mov x0, 0               // Código de salida
    add sp, sp, 16          // Restaurar el valor de sp
    ret

.section .rodata
format: .asciz "%d"        // Formato para scanf (leer un número entero)
result: .asciz "El carácter es: %c\n"  // Mensaje para printf
