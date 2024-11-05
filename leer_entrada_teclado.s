.data
input_prompt: .asciz "Ingresa un texto: "
buffer: .space 100            // Espacio para almacenar la entrada

.text
.global _start

_start:
    // Imprimir el mensaje de entrada
    mov x0, 1                  // x0 = descriptor de archivo (1 = stdout)
    ldr x1, =input_prompt       // x1 = dirección del mensaje
    mov x2, 15                  // x2 = tamaño del mensaje
    mov x8, 64                  // x8 = syscall número para sys_write
    svc 0                       // Llamada al sistema para escribir

    // Leer la entrada desde el teclado
    mov x0, 0                  // x0 = descriptor de archivo (0 = stdin)
    ldr x1, =buffer            // x1 = dirección del buffer
    mov x2, 100                // x2 = tamaño máximo a leer
    mov x8, 63                 // x8 = syscall número para sys_read
    svc 0                      // Llamada al sistema para leer

    // Imprimir la entrada capturada
    mov x0, 1                  // x0 = descriptor de archivo (1 = stdout)
    ldr x1, =buffer            // x1 = dirección del buffer
    mov x8, 64                 // x8 = syscall número para sys_write
    svc 0                      // Llamada al sistema para escribir

    // Salir del programa
    mov x8, 93                 // x8 = syscall número para sys_exit
    mov x0, 0                  // Código de salida
    svc 0
