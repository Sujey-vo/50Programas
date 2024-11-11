
// Programa 21. Ordenamiento por selección
// Alumno: Judith Sujey Villegas Olivares
// NoControl: B23211037 - ISC

.section .data
array: .word 10, 5, 8, 1, 6  // Arreglo de ejemplo
arr_size: .word 5            // Tamaño del arreglo

.section .text
.global _start

_start:
    // Inicializamos los registros
    ldr x1, =arr_size         // Cargar dirección de tamaño del arreglo en x1
    ldr w1, [x1]              // Leer el valor en w1 (tamaño del arreglo)
    ldr x0, =array            // Dirección base del arreglo en x0

    mov w2, #0                // Índice del elemento mínimo

sort_loop:
    cmp w2, w1
    b.ge end_sort             // Si llegamos al final, salir del bucle

    mov w3, w2                // Asignar índice de inicio
    add x4, x0, w2, sxtw #2   // Actualizar puntero para el elemento actual (64 bits con desplazamiento)

    // Encontrar el elemento mínimo
    mov w5, w2

find_min:
    add w3, w3, #1
    cmp w3, w1
    b.ge swap_values          // Si w3 >= tamaño, realizar intercambio

    add x6, x0, w3, sxtw #2   // Dirección del siguiente elemento
    ldr w7, [x6]              // Leer valor en w7

    add x8, x0, w5, sxtw #2   // Dirección del mínimo actual
    ldr w9, [x8]              // Valor actual del mínimo

    cmp w7, w9
    b.ge find_min
    mov w5, w3                // Actualizar índice del mínimo
    b find_min

swap_values:
    cmp w2, w5
    beq next_iter             // Saltar si el elemento actual ya es el mínimo

    add x6, x0, w2, sxtw #2   // Dirección del elemento actual
    ldr w7, [x6]
    add x8, x0, w5, sxtw #2   // Dirección del mínimo
    ldr w9, [x8]

    str w7, [x8]              // Guardar el valor en la posición del mínimo
    str w9, [x6]              // Guardar el mínimo en la posición actual

next_iter:
    add w2, w2, #1            // Incrementar índice
    b sort_loop

end_sort:
    mov x8, #60               // syscall: exit
    mov x0, #0                // estado de salida
    svc #0
