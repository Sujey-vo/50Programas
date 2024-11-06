.global main
.section .text

main:
    # Reservar espacio en la pila para dos enteros
    sub sp, sp, 16

    # Leer el primer número (argumento 1 de scanf)
    mov x1, 1               # Número de argumentos para scanf
    ldr x0, =format          # Dirección de la cadena de formato
    adr x2, [sp]             # Dirección de la pila para el primer número
    bl scanf

    # Leer el segundo número (argumento 2 de scanf)
    ldr x0, =format          # Dirección de la cadena de formato
    add x2, x2, 8            # Dirección de la pila para el segundo número
    bl scanf

    # Sumar los números y almacenar el resultado en x3
    ldr x1, [sp]             # Cargar el primer número en x1
    ldr x2, [sp, #8]         # Cargar el segundo número en x2
    add x3, x1, x2           # Sumar los dos números y almacenar el resultado en x3

    # Imprimir el resultado en la salida estándar (stdout)

mov x1, x3               # Primer argumento para printf (el resultado de la suma)
    ldr x0, =result           # Dirección de la cadena de formato
    bl printf

    # Terminar el programa
    mov x0, 0
    ret

.section .rodata
format: .asciz "%ld"           # Formato para leer un número largo
result: .asciz "La suma es: %ld\n"  # Mensaje con el resultado
