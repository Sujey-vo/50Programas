.global _start

.section .data
    n: .word 10   // Define el número hasta el cual se quiere sumar

.section .text
_start:
    // Inicialización
    ldr x0, =n       // Carga la dirección de 'n' en x0
    ldr w1, [x0]     // Carga el valor de 'n' en w1
    mov w2, #0       // Inicializa el acumulador (suma) en w2
    mov w3, #1       // Inicializa el contador en w3

sum_loop:
    cmp w3, w1       // Compara el contador con 'n'
    bgt end_loop     // Si el contador es mayor que 'n', termina el bucle
    add w2, w2, w3   // Suma el contador al acumulador
    add w3, w3, #1   // Incrementa el contador
    b sum_loop       // Salta al inicio del bucle

end_loop:
    mov w0, w2       // Mueve el resultado final a w0 para su visualización en depuración

    // Finalizar el programa
    mov x8, #93      // Syscall para salir en ARM64
    svc #0           // Llamada al sistema

