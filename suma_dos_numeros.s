.global _start
.global main
.section .text

_start:
    bl main              // Llamar a main
    mov x8, 93           // syscall para exit en ARM64
    mov x0, 0            // Código de salida 0
    svc 0                // Llamar al sistema

main:
    // Reservar espacio en la pila para dos enteros
    sub sp, sp, 16          // Reservar espacio en la pila para dos enteros (8 bytes cada uno)

    // Leer el primer número con scanf
    ldr x0, =format         // Cargar la dirección de la cadena de formato ("%ld")
    add x1, sp, 0           // Cargar la dirección del primer entero en la pila en x1
    bl scanf                // Llamar a scanf

    // Leer el segundo número con scanf
    ldr x0, =format         // Cargar nuevamente la dirección de la cadena de formato
    add x1, sp, 8           // Obtener la dirección en la pila para el segundo entero (8 bytes más)
    bl scanf                // Llamar a scanf

    // Cargar los números en registros
    ldr x2, [sp]            // Cargar el primer número desde la pila en x2
    ldr x3, [sp, 8]         // Cargar el segundo número desde la pila en x3

    // Sumar los números
    add x2, x2, x3          // Sumar los dos números y almacenar el resultado en x2

    // Imprimir el resultado con printf
    ldr x0, =result         // Cargar la dirección de la cadena de formato ("La suma es: %ld\n")
    mov x1, x2              // Mover el resultado de la suma a x1 (primer argumento para printf)
    bl printf               // Llamar a printf

    // Terminar el programa
    mov x0, 0               // Código de salida
    add sp, sp, 16          // Restaurar el valor de sp
    ret

.section .rodata
format: .asciz "%ld"       // Formato para scanf (leer long)
result: .asciz "La suma es: %ld\n"  // Mensaje para printf
