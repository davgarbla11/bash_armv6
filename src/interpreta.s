.include "src/defs.s"

// Funcion que interpreta un comando
// In: r0 --> cadena a interpretar
// Devuelve: r0 == 0 --> comando ok
//  ERR_NON_VALID error en la instruccion
//  ERR_PARSE error en el parseo de una expresion
.global interpreta
interpreta:
        stmdb sp!, {r4-r10, lr}           // Para poder modificar registros --> salvaguardamos todos!
        sub sp,sp, #TAM_STRING            // Reservamos espacio en la pila para una variable auxilar tipo cadena de tamaño TAM_STRING 
        mov r10, #0          // r10 tiene el codigo de error. Antes de salir de la función lo copiaremos a r0 para retornar dicho valor

        bl ignora_espacios        
        mov r4, r0     		// r4 tiene el comando a interpretar sin espacios al principio

        bl strlen
        cmp r0,#0
        beq f_interpr // Si la cadena está vacía, retornamos

        // Para facilitar interpretacion de evaluacion de registros --> guardamos el puntero a los registros en una var global
comprueba_help:


        // Comparamos con los comandos llamando a starts_with o strcmp (ver utils.s y auxiliar.c, respectivamente)

        // Ejemplo strcmp
        mov r0, r4
        ldr r1, =cmd_help	//primero vemos si es help
        bl strcmp
        cmp r0, #0		// r0=0 es que las cadenas son identicas
        beq ej_help

        // Ejemplo starts with
        @ mov r0, r4
        @ ldr r1, =cmd_help	//primero vemos si es help
        @ bl starts_with
        @ cmp r0, #1		// r0=1 es que empieza por help
        @ beq ej_help
            
        // TODO: Implementa los demas comandos!!!

        mov r0, r4
        ldr r1, =cmd_set_vr	//primero vemos si es set vr
        bl starts_with
        cmp r0, #1		
        beq ej_set_vr

        
        
        b error_cmd   // Si no hemos podido interpretar el comando --> devolvemos código de error

ej_set_vr:
        

        b f_interpr


ej_help:
        ldr r0, =mensaje_ayuda
        bl printString
        b f_interpr
        
error_cmd:
        mov r10, #ERR_NON_VALID
        b f_interpr

        
f_interpr:
        mov r0, r10                  // Copiamos el codigo de error en r0, que guarda el valor de retorno
        add sp, #TAM_STRING         // Liberamos la variable auxiliar
        ldmia sp!, {r4-r10, pc}

.end
