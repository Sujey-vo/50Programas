.global _start

.section .data
    prompt1: .asciz "Introduce el primer numero: "
    prompt2: .asciz "Introduce el segundo numero: "
    result_msg: .asciz "El resultado de la multiplicacion es: %d\n"

.section .bss
    num1: .skip 4
    num2: .skip 4

.section .text
_start:
    // Imprimir primer mensaje (introducir primer número)
    mov x0, 1                  // Descriptores de archivo: 1 para stdout
    ldr x1, =prompt1            // Dirección del primer mensaje
    bl printf

    // Leer primer número desde entrada estándar
    mov x0, 0                  // Descriptores de archivo: 0 para stdin
    ldr x1, =num1               // Dirección donde almacenar el número
    mov x2, 4                   // Tamaño del número (4 bytes)
    bl read_input

    // Imprimir segundo mensaje (introducir segundo número)
    mov x0, 1                  // Descriptores de archivo: 1 para stdout
    ldr x1, =prompt2            // Dirección del segundo mensaje
    bl printf

    // Leer segundo número desde entrada estándar
    mov x0, 0                  // Descriptores de archivo: 0 para stdin
    ldr x1, =num2               // Dirección donde almacenar el número
    mov x2, 4                   // Tamaño del número (4 bytes)
    bl read_input

    // Cargar los valores de los números en los registros w1 y w2 (32 bits)
    ldr w1, [num1]               // Cargar primer número en w1 (32-bit)
    ldr w2, [num2]               // Cargar segundo número en w2 (32-bit)

    // Multiplicar los dos números (32-bit)
    mul w0, w1, w2               // Multiplicar w1 y w2, almacenar en w0 (32-bit)

    // Imprimir el resultado
    mov x0, 1                   // Descriptores de archivo: 1 para stdout
    ldr x1, =result_msg         // Dirección del mensaje de resultado
    mov x2, w0                  // El resultado de la multiplicación (32-bit)
    bl printf

    // Salir del programa
    mov x0, 0                   // Código de salida
    mov x8, 93                  // Syscall número para exit
    svc 0

// Función para leer entrada
read_input:
    mov x8, 63                  // Syscall para leer
    svc 0
    ret

// Función para imprimir texto
printf:
    mov x8, 64                  // Syscall para printf
    svc 0
    ret
