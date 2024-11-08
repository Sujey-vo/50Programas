.global _start

.section .data
str: .ascii "anilina"            // Cadena de ejemplo
str_len: .quad 7                 // Longitud de la cadena (sin incluir el caracter nulo)
msg_palindromo: .ascii "Es un palindromo\n"
msg_no_palindromo: .ascii "No es un palindromo\n"
len_msg_palindromo: .quad 18     // Longitud del mensaje "Es un palindromo\n"
len_msg_no_palindromo: .quad 19  // Longitud del mensaje "No es un palindromo\n"

.section .text
_start:
    // Cargar la dirección de inicio de la cadena y su longitud
    ldr x0, =str                 // x0 apunta al inicio de la cadena
    ldr x1, =str_len             // Cargar la dirección de str_len
    ldr x1, [x1]                 // Cargar el valor de str_len en x1 (la longitud de la cadena)

    // Calcular los punteros de inicio y final de la cadena
    add x2, x0, x1               // x2 apunta al final de la cadena (un byte después del último caracter)
    sub x2, x2, #1               // Ajustar x2 para que apunte al último caracter

check_palindrome:
    cmp x0, x2                   // Comparar los punteros de inicio y final
    bge is_palindrome            // Si se encuentran o se cruzan, es un palíndromo

    // Comparar caracteres en x0 y x2
    ldrb w3, [x0]                // Cargar el caracter en x0 en w3
    ldrb w4, [x2]                // Cargar el caracter en x2 en w4
    cmp w3, w4                   // Comparar los caracteres
    bne not_palindrome           // Si son diferentes, no es un palíndromo

    // Mover los punteros hacia el centro
    add x0, x0, #1               // Avanzar x0 hacia adelante
    sub x2, x2, #1               // Retroceder x2 hacia atrás
    b check_palindrome           // Repetir el bucle

is_palindrome:
    // Mostrar mensaje "Es un palíndromo"
    ldr x0, =msg_palindromo      // Dirección del mensaje
    ldr x1, =len_msg_palindromo  // Longitud del mensaje
    ldr x1, [x1]                 // Cargar el valor de la longitud
    mov x2, x1                   // Tamaño de bytes a escribir
    mov x8, #64                  // Syscall write (64 en ARM64)
    mov x1, #1                   // File descriptor 1 (stdout)
    svc #0
    b end                        // Salir del programa

not_palindrome:
    // Mostrar mensaje "No es un palíndromo"
    ldr x0, =msg_no_palindromo   // Dirección del mensaje
    ldr x1, =len_msg_no_palindromo // Longitud del mensaje
    ldr x1, [x1]                 // Cargar el valor de la longitud
    mov x2, x1                   // Tamaño de bytes a escribir
    mov x8, #64                  // Syscall write (64 en ARM64)
    mov x1, #1                   // File descriptor 1 (stdout)
    svc #0

end:
    // Finalizar el programa
    mov x8, #93                  // Syscall exit (93 en ARM64)
    svc #0
