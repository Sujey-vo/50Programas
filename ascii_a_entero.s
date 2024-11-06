.global main
.section .text

main:
    // Reservar espacio en la pila para el carácter ASCII
    sub sp, sp, 16          // Reservar espacio en la pila para el carácter ASCII

    // Leer el carácter ASCII con scanf
    ldr x0, =format         // Cargar la dirección de la cadena de formato ("%c")
    add x1, sp, 0           // Dirección del carácter en la pila
    bl scanf                // Llamar a scanf

    // Cargar el carácter ASCII en el registro w2
    ldrb w2, [sp]           // Cargar el carácter (byte) en w2

    // Convertir ASCII a entero (restar el valor ASCII de '0' que es 48)
    sub w2, w2, #48         // Convertir el carácter ASCII a su valor numérico

    // Imprimir el entero con printf
    ldr x0, =result         // Cargar la dirección de la cadena de formato ("El número es: %d\n")
    mov w1, w2              // Mover el valor entero de w2 a w1 (primer argumento para printf)
    bl printf               // Llamar a printf

    // Terminar el programa
    mov x0, 0               // Código de salida
    add sp, sp, 16          // Restaurar el valor de sp
    ret

.section .rodata
format: .asciz "%c"        // Formato para scanf (leer un solo carácter)
result: .asciz "El número es: %d\n" // Mensaje para printf
