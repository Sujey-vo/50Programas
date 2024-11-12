// Programa 25. Operaciones AND, OR, XOR a nivel de bits
// Alumno: Judith Sujey Villegas Olivares
// NoControl: B23211037 - ISC  

.section .data
mensaje_and: .asciz "Resultado de la operacion AND: "
mensaje_or: .asciz "Resultado de la operacion OR: "
mensaje_xor: .asciz "Resultado de la operacion XOR: "
buffer: .skip 4 // buffer para la conversión de números a cadena

.section .bss
resultado_and: .skip 4        // Espacio para el resultado de AND
resultado_or: .skip 4         // Espacio para el resultado de OR
resultado_xor: .skip 4        // Espacio para el resultado de XOR

.section .text
.global _start

_start:
    // Cargar los dos números sobre los que realizaremos las operaciones
    mov w1, #15          // w1 = 15 (1111 en binario)
    mov w2, #9           // w2 = 9  (1001 en binario)

    // Operación AND
    and w3, w1, w2       // w3 = w1 & w2
    ldr x10, =resultado_and
    str w3, [x10]        // Guardar resultado AND

    // Operación OR
    orr w3, w1, w2       // w3 = w1 | w2
    ldr x11, =resultado_or
    str w3, [x11]        // Guardar resultado OR

    // Operación XOR
    eor w3, w1, w2       // w3 = w1 ^ w2
    ldr x12, =resultado_xor
    str w3, [x12]        // Guardar resultado XOR

    // Imprimir el resultado de la operación AND
    mov x0, #1           // File descriptor para stdout
    ldr x1, =mensaje_and  // Cargar mensaje de AND
    mov x8, #64          // syscall write
    svc #0

    // Imprimir el resultado de la operación AND
    ldr w3, [x10]        // Cargar el resultado de AND
    mov w0, w3           // Mover el valor a w0
    ldr x1, =buffer      // Cargar dirección del buffer
    bl itoa              // Llamada a la subrutina para convertir a string
    mov x0, #1           // File descriptor para stdout
    mov x8, #64          // syscall write
    svc #0

    // Imprimir el resultado de la operación OR
    mov x0, #1           // File descriptor para stdout
    ldr x1, =mensaje_or   // Cargar mensaje de OR
    mov x8, #64          // syscall write
    svc #0

    // Imprimir el resultado de la operación OR
    ldr w3, [x11]        // Cargar el resultado de OR
    mov w0, w3           // Mover el valor a w0
    ldr x1, =buffer      // Cargar dirección del buffer
    bl itoa              // Llamada a la subrutina para convertir a string
    mov x0, #1           // File descriptor para stdout
    mov x8, #64          // syscall write
    svc #0

    // Imprimir el resultado de la operación XOR
    mov x0, #1           // File descriptor para stdout
    ldr x1, =mensaje_xor  // Cargar mensaje de XOR
    mov x8, #64          // syscall write
    svc #0

    // Imprimir el resultado de la operación XOR
    ldr w3, [x12]        // Cargar el resultado de XOR
    mov w0, w3           // Mover el valor a w0
    ldr x1, =buffer      // Cargar dirección del buffer
    bl itoa              // Llamada a la subrutina para convertir a string
    mov x0, #1           // File descriptor para stdout
    mov x8, #64          // syscall write
    svc #0

    // Salir del programa
    mov x8, #93          // syscall exit
    mov x0, #0           // estado de salida
    svc #0

itoa:  // Subrutina para convertir un número a cadena
    mov x2, #10          // Divisor (base 10)
    mov x3, x0           // Copiar número a x3
    mov x4, #0           // Índice para el buffer
itoa_loop:
    udiv x5, x3, x2      // Dividir número entre 10
    msub x6, x5, x2, x3  // Obtener el residuo (dígito)
    add x6, x6, #'0'     // Convertir dígito a carácter
    strb w6, [x1, x4]    // Guardar dígito en el buffer
    add x4, x4, #1       // Incrementar índice
    mov x3, x5           // Preparar nuevo valor para la siguiente iteración
    cmp x3, #0           // Verificar si ya terminamos
    bne itoa_loop        // Si no, seguir iterando
    mov w0, #0           // Null terminator para la cadena
    strb w0, [x1, x4]    // Añadir el terminador null
    ret
