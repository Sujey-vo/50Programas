//Programa 22 Suma de Matrices
// Alumno: Judith Sujey Villegas Olivares
// NoControl: B23211037 - ISC

.section .data
matriz_a: .word 1, 2, 3, 4, 5, 6, 7, 8, 9       // Primera matriz (3x3)
matriz_b: .word 9, 8, 7, 6, 5, 4, 3, 2, 1       // Segunda matriz (3x3)
matriz_resultado: .space 36                     // Espacio para la matriz resultante (3x3)

.section .text
.global _start

_start:
    ldr x0, =matriz_a            // Dirección de la primera matriz en x0
    ldr x1, =matriz_b            // Dirección de la segunda matriz en x1
    ldr x2, =matriz_resultado    // Dirección de la matriz resultante en x2

    mov w3, #9                   // Número total de elementos (3x3)

sumar_matrices:
    cbz w3, fin                  // Si w3 es 0, terminar

    ldr w4, [x0], #4             // Cargar elemento de matriz_a y avanzar dirección
    ldr w5, [x1], #4             // Cargar elemento de matriz_b y avanzar dirección
    add w6, w4, w5               // Sumar los elementos
    str w6, [x2], #4             // Almacenar resultado y avanzar dirección

    sub w3, w3, #1               // Disminuir contador
    b sumar_matrices             // Repetir el bucle

fin:
    mov x8, #93                  // syscall: exit (código 93 en Linux para ARM64)
    mov x0, #0                   // estado de salida
    svc #0
