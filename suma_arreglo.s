.global main
.section .text

main:
    // Definir el arreglo con 5 elementos y asegurar la alineación de 32 bits
    .section .data
arr:    
    .word 10, 20, 30, 40, 50         // Arreglo con 5 elementos
    .align 4                         // Alineación de 32 bits (4 bytes)
arr_size: 
    .word 5                          // Tamaño del arreglo

    // Inicializar los registros
    mov w2, #0                       // w2 = 0 (para almacenar la suma)
    ldr x3, =arr_size                // Cargar la dirección de arr_size en x3 (64 bits)
    ldr w3, [x3]                     // Cargar el tamaño del arreglo en w3 (32 bits)

    mov w4, #0                       // w4 = 0 (índice del arreglo)
    ldr x0, =arr                      // Dirección base del arreglo en x0 (64 bits)

sum_loop:
    // Comprobar si hemos recorrido todo el arreglo
    cmp w4, w3                       // Comparar índice con el tamaño del arreglo
    beq done                         // Si el índice es igual al tamaño, terminamos

    // Cargar el valor del arreglo
    ldr w5, [x0, w4, lsl #2]         // Cargar el elemento del arreglo en w5 (base en x0, desplazado por el índice)

    // Sumar el valor al acumulador
    add w2, w2, w5                   // w2 = w2 + w5

    // Incrementar el índice
    add w4, w4, #1                   // w4 = w4 + 1 (usamos w4 en lugar de x4 para el índice)

    // Volver al inicio del bucle
    b sum_loop

done:
    // Terminar el programa
    mov x0, 0                        // Código de salida
    ret
