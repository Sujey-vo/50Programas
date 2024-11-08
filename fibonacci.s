.global _start

.section .data
fib_series:     .space 80               // Espacio para almacenar hasta 10 elementos de la serie (ajusta si necesitas más)

.section .text
_start:
    mov x0, #10                          // Número de elementos de la serie de Fibonacci que quieres calcular
    ldr x1, =fib_series                  // Dirección base donde guardaremos la serie
    bl fibonacci_series

    // Finaliza el programa
    mov x8, #93                          // Código de salida en Linux
    svc #0

fibonacci_series:
    // Caso especial para los primeros dos números
    mov w2, #0                           // Primer número de Fibonacci
    mov w3, #1                           // Segundo número de Fibonacci

    str w2, [x1], #4                     // Almacena el primer número y mueve el puntero
    str w3, [x1], #4                     // Almacena el segundo número y mueve el puntero

    subs x0, x0, #2                      // Resta 2 al contador ya que ya guardamos dos números
    ble end_fibonacci                    // Si n <= 2, termina

fibonacci_loop:
    add w4, w2, w3                       // Calcula el siguiente número de Fibonacci
    str w4, [x1], #4                     // Almacena el número en memoria y mueve el puntero

    mov w2, w3                           // Actualiza w2 con el valor actual de w3
    mov w3, w4                           // Actualiza w3 con el valor actual de w4

    subs x0, x0, #1                      // Decrementa el contador
    bgt fibonacci_loop                   // Repite hasta que x0 sea 0

end_fibonacci:
    ret
