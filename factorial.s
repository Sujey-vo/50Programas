.global _start

.section .data
    num: .word 5          // Define el número para el cual se calcula el factorial

.section .text
_start:
    // Inicialización
    ldr x0, =num          // Carga la dirección de 'num' en x0
    ldr w1, [x0]          // Carga el valor de 'num' en w1
    mov w2, #1            // Inicializa el acumulador (factorial) en w2
    mov w3, w1            // Copia el valor de 'num' en el contador w3

factorial_loop:
    cmp w3, #1            // Compara el contador con 1
    ble end_factorial     // Si el contador es 1 o menor, termina el bucle
    mul w2, w2, w3        // Multiplica el acumulador por el contador
    sub w3, w3, #1        // Decrementa el contador
    b factorial_loop      // Salta al inicio del bucle

end_factorial:
    mov w0, w2            // Mueve el resultado final a w0 para su visualización en depuración

    // Finalizar el programa
    mov x8, #93           // Syscall para salir en ARM64
    svc #0                // Llamada al sistema
