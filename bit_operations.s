// Programa 27. Establecer, borrar y alternar bits
// Alumno: Judith Sujey Villegas Olivares
// NoControl: B23211037 - ISC  

.section .data
mensaje_set: .asciz "Resultado al establecer el bit: "
mensaje_clear: .asciz "\nResultado al borrar el bit: "
mensaje_toggle: .asciz "\nResultado al alternar el bit: "
buffer: .space 12              // Espacio para el buffer de salida de números

.section .bss
resultado_set: .skip 4          // Espacio para el resultado de establecer el bit
resultado_clear: .skip 4        // Espacio para el resultado de borrar el bit
resultado_toggle: .skip 4       // Espacio para el resultado de alternar el bit

.section .text
.global _start

_start:
    // Cargar el número base y el índice del bit a modificar
    mov w0, #42             // w0 = 42 (101010 en binario)
    mov w1, #1              // w1 = 1 (bit de índice 1)

    // Establecer (set) el bit en la posición w1
    mov w2, #1              // w2 = 1
    lsl w2, w2, w1          // Desplazar w2 a la izquierda por w1 posiciones (bitmask)
    orr w3, w0, w2          // w3 = w0 | (1 << w1) - Establecer el bit
    ldr x10, =resultado_set
    str w3, [x10]           // Guardar el resultado de establecer el bit

    // Borrar (clear) el bit en la posición w1
    mov w2, #1              // w2 = 1
    lsl w2, w2, w1          // Desplazar w2 a la izquierda por w1 posiciones (bitmask)
    mvn w2, w2              // w2 = ~ (1 << w1) - Máscara para borrar el bit
    and w3, w0, w2          // w3 = w0 & ~(1 << w1) - Borrar el bit
    ldr x11, =resultado_clear
    str w3, [x11]           // Guardar el resultado de borrar el bit

    // Alternar (toggle) el bit en la posición w1
    mov w2, #1              // w2 = 1
    lsl w2, w2, w1          // Desplazar w2 a la izquierda por w1 posiciones (bitmask)
    eor w3, w0, w2          // w3 = w0 ^ (1 << w1) - Alternar el bit
    ldr x12, =resultado_toggle
    str w3, [x12]           // Guardar el resultado de alternar el bit

    // Imprimir el resultado de establecer el bit
    mov x0, #1              // File descriptor para stdout
    ldr x1, =mensaje_set    // Cargar mensaje para establecer el bit
    mov x2, #30             // Longitud del mensaje
    mov x8, #64             // syscall write
    svc #0

    ldr w3, [x10]           // Cargar el resultado de establecer el bit
    mov w0, w3              // Mover el valor a w0
    ldr x1, =buffer         // Cargar dirección del buffer
    bl itoa                 // Llamada a la subrutina para convertir a string
    mov x0, #1              // File descriptor para stdout
    mov x2, #12             // Tamaño estimado del buffer
    mov x8, #64             // syscall write
    svc #0

    // Imprimir el resultado de borrar el bit
    mov x0, #1              // File descriptor para stdout
    ldr x1, =mensaje_clear  // Cargar mensaje para borrar el bit
    mov x2, #29             // Longitud del mensaje
    mov x8, #64             // syscall write
    svc #0

    ldr w3, [x11]           // Cargar el resultado de borrar el bit
    mov w0, w3              // Mover el valor a w0
    ldr x1, =buffer         // Cargar dirección del buffer
    bl itoa                 // Llamada a la subrutina para convertir a string
    mov x0, #1              // File descriptor para stdout
    mov x2, #12             // Tamaño estimado del buffer
    mov x8, #64             // syscall write
    svc #0

    // Imprimir el resultado de alternar el bit
    mov x0, #1              // File descriptor para stdout
    ldr x1, =mensaje_toggle // Cargar mensaje para alternar el bit
    mov x2, #30             // Longitud del mensaje
    mov x8, #64             // syscall write
    svc #0

    ldr w3, [x12]           // Cargar el resultado de alternar el bit
    mov w0, w3              // Mover el valor a w0
    ldr x1, =buffer         // Cargar dirección del buffer
    bl itoa                 // Llamada a la subrutina para convertir a string
    mov x0, #1              // File descriptor para stdout
    mov x2, #12             // Tamaño estimado del buffer
    mov x8, #64             // syscall write
    svc #0

    // Salir del programa
    mov x8, #93             // syscall exit
    mov x0, #0              // estado de salida
    svc #0

itoa:  // Subrutina para convertir un número a cadena
    mov x2, #10             // Divisor (base 10)
    mov x3, x0              // Copiar número a x3
    mov x4, #0              // Índice para el buffer
itoa_loop:
    udiv x5, x3, x2         // Dividir número entre 10
    msub x6, x5, x2, x3     // Obtener el residuo (dígito)
    add x6, x6, #'0'        // Convertir dígito a carácter
    strb w6, [x1, x4]       // Guardar dígito en el buffer
    add x4, x4, #1          // Incrementar índice
    mov x3, x5              // Preparar nuevo valor para la siguiente iteración
    cmp x3, #0              // Verificar si ya terminamos
    bne itoa_loop           // Si no, seguir iterando

    // Invertir la cadena en el buffer
    sub x4, x4, #1          // Apuntar al último carácter válido
    mov x5, #0              // Índice inicial
reverse_loop:
    cmp x5, x4              // Comparar índices
    bge end_reverse         // Terminar si ya está invertido
    ldrb w6, [x1, x5]       // Leer carácter desde el inicio
    ldrb w7, [x1, x4]       // Leer carácter desde el final
    strb w7, [x1, x5]       // Intercambiar
    strb w6, [x1, x4]
    add x5, x5, #1          // Mover hacia el centro
    sub x4, x4, #1
    b reverse_loop
end_reverse:
    mov w0, #0              // Null terminator para la cadena
    strb w0, [x1, x4]       // Añadir el terminador null
    ret
