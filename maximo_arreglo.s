.global _start

.section .data
arr:    .word 12, 35, 7, 89, 22  // Arreglo de ejemplo
arr_size: .quad 5                // Tamaño del arreglo
msg_resultado: .ascii "El maximo es: "
len_msg_resultado: .quad 15      // Longitud del mensaje
msg_nuevo: .ascii "\n"
len_msg_nuevo: .quad 1           // Longitud del salto de línea

.section .bss
max_val: .skip 4                 // Variable para almacenar el valor máximo

.section .text
_start:
    // Cargar la dirección y tamaño del arreglo
    ldr x0, =arr                 // x0 apunta al inicio del arreglo
    ldr x1, =arr_size            // Cargar la dirección de arr_size
    ldr x1, [x1]                 // Cargar el valor de arr_size en x1 (tamaño del arreglo)

    // Inicializar el valor máximo con el primer elemento del arreglo
    ldr w2, [x0]                 // Cargar el primer elemento en w2
    ldr x3, =max_val             // Cargar la dirección de max_val en x3
    str w2, [x3]                 // Guardar el primer elemento en max_val

    // Configurar el índice del bucle
    mov x4, #1                   // Empezar desde el segundo elemento (índice 1)

loop:
    cmp x4, x1                   // Comparar el índice con el tamaño del arreglo
    bge print_result             // Si x4 >= x1, salir del bucle

    // Cargar el elemento actual del arreglo
    ldr w5, [x0, x4, lsl #2]     // Cargar arr[x4] en w5

    // Comparar el elemento actual con el valor máximo
    ldr w6, [x3]                 // Cargar max_val en w6
    cmp w5, w6                   // Comparar w5 con w6
    ble skip                     // Si w5 <= w6, saltar

    // Actualizar el valor máximo
    str w5, [x3]                 // Guardar el nuevo máximo en max_val

skip:
    add x4, x4, #1               // Incrementar el índice
    b loop                       // Repetir el bucle

print_result:
    // Imprimir el mensaje "El maximo es: "
    ldr x0, =msg_resultado
    ldr x1, =len_msg_resultado
    ldr x1, [x1]
    mov x8, #64                  // Syscall write (64 en ARM64)
    mov x2, x1                   // Tamaño de bytes a escribir
    mov x1, #1                   // File descriptor 1 (stdout)
    svc #0

    // Imprimir el valor máximo como número
    ldr w0, [x3]                 // Cargar max_val en w0
    bl print_number              // Llamar a la función para imprimir el número

    // Imprimir un salto de línea
    ldr x0, =msg_nuevo
    ldr x1, =len_msg_nuevo
    ldr x1, [x1]
    mov x8, #64                  // Syscall write (64 en ARM64)
    mov x2, x1                   // Tamaño de bytes a escribir
    mov x1, #1                   // File descriptor 1 (stdout)
    svc #0

    // Finalizar el programa
    mov x8, #93                  // Syscall exit (93 en ARM64)
    svc #0

// Función para imprimir un número en consola
print_number:
    // Configurar variables para el número y dígitos
    mov x2, #10                  // Divisor para obtener dígitos
    mov x5, #0                   // Contador de dígitos

convert_to_string:
    udiv w3, w0, w2              // w3 = w0 / 10
    msub w4, w3, w2, w0          // w4 = w0 - (w3 * 10), dígito actual
    add w4, w4, #'0'             // Convertir el dígito a ASCII
    strb w4, [sp, x5, lsl #0]    // Guardar el dígito en el stack
    add x5, x5, #1               // Incrementar el contador de dígitos
    mov w0, w3                   // Actualizar w0 con el cociente
    cbnz w0, convert_to_string   // Repetir si w0 no es cero

print_digits:
    sub x5, x5, #1               // Decrementar el contador
    ldrb w1, [sp, x5, lsl #0]    // Cargar el siguiente dígito
    mov x0, #1                   // File descriptor (stdout)
    mov x8, #64                  // Syscall write
    mov x2, #1                   // Tamaño de bytes a escribir
    svc #0
    cbnz x5, print_digits        // Repetir hasta imprimir todos los dígitos

    ret                          // Retornar
