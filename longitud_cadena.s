.global main
.section .text

main:
    // Reservar espacio en la pila para la cadena
    sub sp, sp, 64          // Reservar espacio en la pila (64 bytes)

    // Leer la cadena con scanf
    ldr x0, =format         // Cargar la dirección de la cadena de formato ("%s")
    add x1, sp, 0           // Dirección para almacenar la cadena leída
    bl scanf                // Llamada a scanf para leer la cadena

    // Inicializar el contador de longitud en 0
    mov x2, #0              // x2 = 0 (contador de la longitud)

calculate_length:
    // Cargar el siguiente byte de la cadena
    ldrb w3, [sp, x2]       // Cargar un byte de la cadena (carácter en w3)

    // Comprobar si es el carácter nulo ('\0')
    cmp w3, #0              // Comparar el carácter con 0 (fin de la cadena)
    beq done                // Si es 0 (nulo), hemos terminado

    // Incrementar el contador
    add x2, x2, #1          // Incrementar el contador

    // Volver al inicio del bucle
    b calculate_length

done:
    // Imprimir la longitud de la cadena con printf
    ldr x0, =result         // Cargar la dirección de la cadena de formato ("La longitud de la cadena es: %d\n")
    mov w1, w2              // Mover la longitud a w1 (primer argumento para printf)
    bl printf               // Llamada a printf para imprimir el resultado

    // Terminar el programa
    mov x0, 0               // Código de salida
    add sp, sp, 64          // Restaurar el valor de sp
    ret

.section .rodata
format: .asciz "%s"        // Formato para scanf (leer una cadena)
result: .asciz "La longitud de la cadena es: %d\n"  // Mensaje para printf
