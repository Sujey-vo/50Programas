// Programa 24. Contar vocales y consonantes
// Alumno: Judith Sujey Villegas Olivares
// NoControl: B23211037 - ISC  

.section .data
cadena: .asciz "Hola, este es un ejemplo de conteo de vocales y consonantes."
mensaje_vocales: .asciz "Total de vocales: "
mensaje_consonantes: .asciz "Total de consonantes: "
buffer: .skip 4 // buffer para la conversión de números a cadena

.section .bss
vocales: .skip 4         // Espacio para el contador de vocales
consonantes: .skip 4     // Espacio para el contador de consonantes

.section .text
.global _start

_start:
    // Inicializar los contadores
    mov w1, #0                   // w1 = contador de vocales
    ldr x10, =vocales            // Cargar dirección de "vocales"
    str w1, [x10]                // Guardar en la dirección de "vocales"
    mov w2, #0                   // w2 = contador de consonantes
    ldr x11, =consonantes        // Cargar dirección de "consonantes"
    str w2, [x11]                // Guardar en la dirección de "consonantes"

    // Cargar dirección de la cadena
    ldr x0, =cadena

contar_caracteres:
    ldrb w3, [x0], #1            // Cargar un byte de la cadena y avanzar
    cbz w3, imprimir_resultados  // Si es NULL, fin de cadena

    // Verificar si es una vocal (minúsculas y mayúsculas)
    cmp w3, #'a'
    b.eq es_vocal
    cmp w3, #'e'
    b.eq es_vocal
    cmp w3, #'i'
    b.eq es_vocal
    cmp w3, #'o'
    b.eq es_vocal
    cmp w3, #'u'
    b.eq es_vocal
    cmp w3, #'A'
    b.eq es_vocal
    cmp w3, #'E'
    b.eq es_vocal
    cmp w3, #'I'
    b.eq es_vocal
    cmp w3, #'O'
    b.eq es_vocal
    cmp w3, #'U'
    b.eq es_vocal

    // Si no es vocal, verificar si es una consonante (letra alfabética)
    cmp w3, #'a'
    bge es_consonante            // Si >= 'a', podría ser consonante minúscula
    cmp w3, #'A'
    bge es_consonante            // Si >= 'A', podría ser consonante mayúscula
    b contar_caracteres          // Si no es vocal ni consonante, omitir

es_vocal:
    ldr w1, [x10]                // Cargar contador de vocales
    add w1, w1, #1               // Incrementar en 1
    str w1, [x10]                // Guardar contador actualizado
    b contar_caracteres

es_consonante:
    ldr w2, [x11]                // Cargar contador de consonantes
    add w2, w2, #1               // Incrementar en 1
    str w2, [x11]                // Guardar contador actualizado
    b contar_caracteres

imprimir_resultados:
    // Imprimir mensaje de vocales
    mov x0, #1                   // File descriptor para stdout
    ldr x1, =mensaje_vocales      // Cargar mensaje de vocales
    mov x8, #64                  // syscall write
    svc #0

    // Imprimir contador de vocales
    ldr w2, [x10]                // Cargar contador de vocales
    mov w0, w2                   // Mover el valor del contador de vocales a w0
    ldr x1, =buffer              // Cargar dirección del buffer
    bl itoa                      // Llamada a la subrutina para convertir a string
    mov x0, #1                   // File descriptor para stdout
    mov x8, #64                  // syscall write
    svc #0

    // Imprimir mensaje de consonantes
    mov x0, #1                   // File descriptor para stdout
    ldr x1, =mensaje_consonantes   // Cargar mensaje de consonantes
    mov x8, #64                  // syscall write
    svc #0

    // Imprimir contador de consonantes
    ldr w2, [x11]                // Cargar contador de consonantes
    mov w0, w2                   // Mover el valor del contador de consonantes a w0
    ldr x1, =buffer              // Cargar dirección del buffer
    bl itoa                      // Llamada a la subrutina para convertir a string
    mov x0, #1                   // File descriptor para stdout
    mov x8, #64                  // syscall write
    svc #0

    // Salir del programa
    mov x8, #93                  // syscall exit
    mov x0, #0                   // estado de salida
    svc #0

itoa:  // Subrutina para convertir un número a cadena
    mov x2, #10                  // Divisor (base 10)
    mov x3, x0                   // Copiar número a x3
    mov x4, #0                   // Índice para el buffer
itoa_loop:
    udiv x5, x3, x2              // Dividir número entre 10
    msub x6, x5, x2, x3          // Obtener el residuo (dígito)
    add x6, x6, #'0'             // Convertir dígito a carácter
    strb w6, [x1, x4]            // Guardar dígito en el buffer
    add x4, x4, #1               // Incrementar índice
    mov x3, x5                   // Preparar nuevo valor para la siguiente iteración
    cmp x3, #0                   // Verificar si ya terminamos
    bne itoa_loop                // Si no, seguir iterando
    mov w0, #0                   // Null terminator para la cadena
    strb w0, [x1, x4]            // Añadir el terminador null
    ret
