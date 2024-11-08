.global _start

.section .data
arr:        .word 10, 25, 30, 45, 50       // Arreglo de ejemplo
arr_size:   .quad 5                        // Tamaño del arreglo
target:     .word 30                       // Valor a buscar
msg_found:  .ascii "Valor encontrado en la posición: "
len_found:  .quad 33                       // Longitud del mensaje
msg_not_found: .ascii "Valor no encontrado\n"
len_not_found: .quad 20                    // Longitud del mensaje de no encontrado
msg_nuevo:  .ascii "\n"
len_msg_nuevo: .quad 1                     // Longitud del salto de línea

.section .text
_start:
    // Cargar la dirección y tamaño del arreglo
    ldr x0, =arr                      // x0 apunta al inicio del arreglo
    ldr x1, =arr_size                 // Cargar la dirección de arr_size
    ldr x1, [x1]                      // Cargar el valor de arr_size en x1 (tamaño del arreglo)
    ldr w2, =target                   // Cargar el valor a buscar en w2 (target)
    
    // Inicializar el índice
    mov x3, #0                        // x3 será el índice

loop:
    cmp x3, x1                        // Comparar el índice con el tamaño del arreglo
    bge not_found                     // Si x3 >= x1, salir del bucle

    // Cargar el elemento actual del arreglo
    ldr w4, [x0, x3, lsl #2]          // Cargar arr[x3] en w4
    cmp w4, w2                        // Comparar el elemento con el target
    beq found                         // Si son iguales, saltar a found

    // Incrementar el índice
    add x3, x3, #1                    // Incrementar el índice
    b loop                            // Repetir el bucle

not_found:
    // Imprimir "Valor no encontrado"
    ldr x0, =msg_not_found
    ldr x1, =len_not_found
    ldr x1, [x1]
    mov x8, #64                       // Syscall write (64 en ARM64)
    mov x2, x1                        // Tamaño de bytes a escribir
    mov x1, #1                        // File descriptor 1 (stdout)
    svc #0
    b end                             // Salir del programa

found:
    // Imprimir "Valor encontrado en la posición: "
    ldr x0, =msg_found
    ldr x1, =len_found
    ldr x1, [x1]
    mov x8, #64                       // Syscall write (64 en ARM64)
    mov x2, x1                        // Tamaño de bytes a escribir
    mov x1, #1                        // File descriptor 1 (stdout)
    svc #0

    // Imprimir la posición como número
    mov x0, x3                        // Cargar la posición en x0
    bl print_number                   // Llamar a la función para imprimir el número

end:
    // Imprimir un salto de línea
    ldr x0, =msg_nuevo
    ldr x1, =len_msg_nuevo
    ldr x1, [x1]
    mov x8, #64                       // Syscall write (64 en ARM64)
    mov x2, x1                        // Tamaño de bytes a escribir
    mov x1, #1                        // File descriptor 1 (stdout)
    svc #0

    // Finalizar el programa
    mov x8, #93                       // Syscall exit (93 en ARM64)
    svc #0

// Función para imprimir un número en consola
print_number:
    mov x2, #10                       // Divisor para obtener dígitos
    mov x5, #0                        // Contador de dígitos

convert_to_string:
    udiv w3, w0, w2                   // w3 = w0 / 10
    msub w4, w3, w2, w0               // w4 = w0 - (w3 * 10), dígito actual
    add w4, w4, #'0'                  // Convertir el dígito a ASCII
    strb w4, [sp, x5, lsl #0]         // Guardar el dígito en el stack
    add x5, x5, #1                    // Incrementar el contador de dígitos
    mov w0, w3                        // Actualizar w0 con el cociente
    cbnz w0, convert_to_string        // Repetir si w0 no es cero

print_digits:
    sub x5, x5, #1                    // Decrementar el contador
    ldrb w1, [sp, x5, lsl #0]         // Cargar el siguiente dígito
    mov x0, #1                        // File descriptor (stdout)
    mov x8, #64                       // Syscall write
    mov x2, #1                        // Tamaño de bytes a escribir
    svc #0
    cbnz x5, print_digits             // Repetir hasta imprimir todos los dígitos

    ret                               // Retornar
