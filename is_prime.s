.global _start

.section .text
_start:
    mov x0, #29                   // Número que queremos verificar (puedes cambiar el valor aquí)
    bl is_prime                    // Llama a la función is_prime

    // Finaliza el programa
    mov x8, #93                    // Código de salida en Linux
    svc #0

// Función para verificar si un número es primo
// Entrada: x0 (número a verificar)
// Salida:  x1 (1 si es primo, 0 si no es primo)
is_prime:
    mov x1, #1                     // Asume que es primo (1 = primo, 0 = no primo)
    cmp x0, #2                     // Verifica si el número es menor que 2
    blt not_prime                  // Si es menor, no es primo

    // Caso especial para 2, que es el único número primo par
    cmp x0, #2
    beq end_prime                  // Si es 2, es primo

    // Si el número es par y mayor que 2, no es primo
    and x2, x0, #1                 // Verifica si el número es par
    cbz x2, not_prime              // Si es par, no es primo

    // Bucle para probar divisores desde 3 hasta sqrt(x0)
    mov x2, #3                     // Primer divisor impar
    mov x3, x0                     // Copia el número a x3
    bl sqrt_approx                 // Llama a la función para obtener una aproximación de sqrt(x0)

check_divisors:
    cmp x2, x3                     // Si x2 > sqrt(x0), termina el bucle
    bgt end_prime

    udiv x4, x0, x2                // Divide x0 entre x2
    msub x4, x4, x2, x0            // Calcula el resto: x0 - (x4 * x2)
    cbz x4, not_prime              // Si el resto es 0, no es primo

    add x2, x2, #2                 // Pasa al siguiente divisor impar
    b check_divisors               // Repite el bucle

not_prime:
    mov x1, #0                     // Marca como no primo

end_prime:
    ret

// Función auxiliar para obtener una aproximación de la raíz cuadrada de un número
// Entrada: x0 (número), Salida: x0 (aproximación de la raíz cuadrada)
sqrt_approx:
    mov x4, #1
sqrt_loop:
    cmp x4, x0
    bge sqrt_done
    add x4, x4, #1
    mul x5, x4, x4
    cmp x5, x0
    bge sqrt_done
    b sqrt_loop
sqrt_done:
    sub x4, x4, #1
    mov x0, x4
    ret
