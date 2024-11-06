.global main
.section .text

main:
    # Reservar espacio en la pila para almacenar dos enteros
    sub sp, sp, 16               // Reservar 16 bytes en la pila

    # Leer el primer número
    ldr x0, =input_msg            // Cargar la dirección del mensaje de entrada
    bl printf                     // Llamar a printf para mostrar el mensaje
    ldr x0, =format               // Cargar la dirección del formato para scanf
    mov x1, sp                    // Pasar la dirección del primer entero en la pila
    bl scanf                      // Llamar a scanf para leer el número

    # Leer el segundo número
    ldr x0, =input_msg            // Cargar la dirección del mensaje de entrada
    bl printf                     // Mostrar mensaje para el segundo número
    ldr x0, =format               // Cargar el formato para scanf
    add x1, sp, 8                 // Pasar la dirección del segundo entero en la pila
    bl scanf                      // Llamar a scanf para leer el segundo número

    # Realizar la multiplicación
    ldr w0, [sp]                  // Cargar el primer número en w0
    ldr w1, [sp, 8]               // Cargar el segundo número en w1
    mul w2, w0, w1                // Multiplicar w0 y w1, almacenar el resultado en w2

    # Imprimir el resultado
    ldr x0, =result_msg           // Cargar la dirección del mensaje de resultado
    mov x1, x2                    // Pasar el resultado a x1 para printf
    bl printf                     // Llamar a printf para mostrar el resultado

    # Limpiar y finalizar
    add sp, sp, 16                // Restaurar el stack pointer
    mov x0, 0                     // Indicar salida exitosa
    ret

.section .rodata
input_msg: .asciz "Ingrese un número: "
format: .asciz "%d"
result_msg: .asciz "El resultado de la multiplicación es: %d\n"
