// Programa 23. Transposición de una matriz
// Alumno: Judith Sujey Villegas Olivares
// NoControl: B23211037 - ISC  

.section .data
matriz_original: .word 1, 2, 3, 4, 5, 6, 7, 8, 9     // Matriz de 3x3
matriz_transpuesta: .space 36                        // Espacio para la matriz transpuesta (3x3)
mensaje: .asciz "Matriz transpuesta:\n"
formato_num: .asciz "%d "

.section .text
.global _start

_start:
    ldr x0, =matriz_original         // Dirección de la matriz original en x0
    ldr x1, =matriz_transpuesta      // Dirección de la matriz transpuesta en x1

    mov w2, #0                       // Fila de la matriz original
bucle_filas:
    cmp w2, #3                       // Si hemos procesado 3 filas, terminamos
    bge imprimir_matriz              // Salta a imprimir si se ha alcanzado la última fila

    mov w3, #0                       // Columna de la matriz original
bucle_columnas:
    cmp w3, #3                       // Si hemos procesado 3 columnas, pasa a la siguiente fila
    bge siguiente_fila

    // Calcular índice de la matriz original: index = (fila * 3 + columna) * 4
    mov w4, w2                       // Copia de fila en w4
    add w4, w4, w2                   // w4 = fila * 2
    add w4, w4, w2                   // w4 = fila * 3
    add w4, w4, w3                   // w4 += columna
    lsl w4, w4, #2                   // index = index * 4 (multiplicación para bytes)
    ldr w5, [x0, w4, sxtw]           // Cargar el elemento en w5

    // Calcular índice de la matriz transpuesta: trans_index = (columna * 3 + fila) * 4
    mov w6, w3                       // Copia de columna en w6
    add w6, w6, w3                   // w6 = columna * 2
    add w6, w6, w3                   // w6 = columna * 3
    add w6, w6, w2                   // w6 += fila
    lsl w6, w6, #2                   // trans_index = trans_index * 4
    str w5, [x1, w6, sxtw]           // Almacenar el elemento en la matriz transpuesta

    add w3, w3, #1                   // columna++
    b bucle_columnas

siguiente_fila:
    add w2, w2, #1                   // fila++
    b bucle_filas

imprimir_matriz:
    // Imprimir mensaje inicial
    mov x0, #1                       // stdout
    ldr x1, =mensaje                 // Dirección del mensaje
    mov x2, #20                      // Longitud del mensaje
    mov x8, #64                      // syscall: write
    svc #0

    // Imprimir matriz transpuesta
    ldr x1, =matriz_transpuesta      // Dirección de la matriz transpuesta
    mov w2, #9                       // Número de elementos a imprimir

imprimir_bucle:
    cbz w2, fin                      // Si w2 es 0, terminar
    ldr w3, [x1], #4                 // Cargar el elemento actual y avanzar la dirección

    // Convertir y mostrar el número (syscall write)
    mov x0, #1                       // stdout
    mov x1, x3                       // Elemento actual
    mov x8, #64                      // syscall: write
    svc #0

    sub w2, w2, #1                   // Decrementar el contador
    b imprimir_bucle                 // Repetir para el siguiente elemento

fin:
    mov x8, #93                      // syscall: exit
    mov x0, #0                       // estado de salida
    svc #0
