// Programa 26. Desplazamientos a la izquierda y derecha
// Alumno: Judith Sujey Villegas Olivares
// NoControl: B23211037 - ISC  

.section .data
mensaje_left: .asciz "Resultado del desplazamiento a la izquierda: "
mensaje_right: .asciz "Resultado del desplazamiento a la derecha: "
buffer: .skip 4 // buffer para la conversión de números a cadena

.section .bss
resultado_left: .skip 4         // Espacio para el resultado de desplazamiento a la izquierda
resultado_right: .skip 4        // Espacio para el resultado de desplazamiento a la derecha

.section .text
.global _start

_start:
    // Cargar el número base y la cantidad de bits para el desplazamiento
    mov w1, #8              // w1 = 8 (1000 en binario)
    mov w2, #2              // w2 = 2 (cantidad de bits para desplazar)

    // Desplazamiento a la izquierda
    lsl w3, w1, w2          // w3 = w1 << w2
    ldr x10, =resultado_left
    str w3, [x10]           // Guardar el resultado de desplazamiento a la izquierda

    // Desplazamiento a la derecha
    lsr w3, w1, w2          // w3 = w1 >> w2
    ldr x11, =resultado_right
    str w3, [x11]           // Guardar el resultado de desplazamiento a la derecha

    // Imprimir el resultado del desplazamiento a la izquierda
    mov x0, #1              // File descriptor para stdout
    ldr x1, =mensaje_left   // Cargar mensaje para desplazamiento a la izquierda
    mov x8, #64             // syscall write
    svc #0

    // Imprimir el resultado de desplazamiento a la izquierda
    ldr w3, [x10]           // Cargar el resultado de desplazamiento a la izquierda
    mov w0, w3              // Mover el valor a w0
    ldr x1, =buffer         // Cargar dirección del buffer
    bl itoa                 // Llamada a la subrutina para convertir a string
    mov x0, #1              // File descriptor para stdout
    mov x8, #64             // syscall write
    svc #0

    // Imprimir el resultado del desplazamiento a la derecha
    mov x0, #1              // File descriptor para stdout
    ldr x1, =mensaje_right  // Cargar mensaje para desplazamiento a la derecha
    mov x8, #64             // syscall write
    svc #0

    // Imprimir el resultado de desplazamiento a la derecha
    ldr w3, [x11]           // Cargar el resultado de desplazamiento a la derecha
    mov w0, w3              // Mover el valor a w0
    ldr x1, =buffer         // Cargar dirección del buffer
    bl itoa                 // Llamada a la subrutina para convertir a string
    mov x0, #1              // File descriptor para stdout
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
    mov w0, #0              // Null terminator para la cadena
    strb w0, [x1, x4]       // Añadir el terminador null
    ret

