;===============================================================================
; @file       G21_TPL3_ED2.asm
;
; @author     Felissia Francisco
;	      Celoria Juan Cruz
;	      Cordoba Ulises
;	      Machado Ezequiel Agustin
;
; @date       dia/mes/año
;
; @version    1.0
;===============================================================================

;===============================================================================
; DIRECTIVAS DE INCLUSIÓN
;===============================================================================
LIST P=16F887			
#include "p16f887.inc"	
	
;===============================================================================
; CONFIGURACIÓN GENERAL DEL MCU
;=============================================================================== 	
__CONFIG _CONFIG1, _XT_OSC & _WDTE_OFF & _MCLRE_ON & _LVP_OFF

;===============================================================================
; DEFINICIÓN DE CONSTANTES
;===============================================================================     
#define CTRL_DSPL_1	PORTC, RC0
#define CTRL_DSPL_2	PORTC, RC1
#define CTRL_DSPL_3	PORTC, RC2    
;===============================================================================
; DEFINICIÓN DE VARIABLES
;=============================================================================== 
cblock 0x20
    DELAY1_Init
    DELAY2_Init
    DELAY3_Init
    DELAY1
    DELAY2
    DELAY3
    DATA_DSPL_1
    DATA_DSPL_2
    DATA_DSPL_3
    NUM_MAX_DSPL 
    COUNTER_DSPL
    COUNTER_SEGMENTS
    SEGMENT_SHADOW
endc	
;===============================================================================
; DECLARACIÓN DE MACROS PARA CONFIGURACIÓN DE REGISTROS
;===============================================================================
; === Display ===

CFG_DSPL macro
    bcf	    STATUS,RP1
    bsf	    STATUS,RP0	   ;Banco 1
    bcf     TRISC, TRISC0 ; RC0 como salida
    bcf     TRISC, TRISC1 ; RC1 como salida
    bcf     TRISC, TRISC2 ; RC2 como salida
    DSPL_ALL_OFF
endm

CFG_DIGITS_DSPL macro
    movlw   d'6'       ;Numero 6 o Letra G en Display1
    movwf   DATA_DSPL_1
    movlw   d'2'	      ;Digito 2 en Display2
    movwf   DATA_DSPL_2
    movlw   d'1'	      ;Digito 1 en Display3
    movwf   DATA_DSPL_3
endm
    
DSPL_ALL_OFF macro
    bcf	    STATUS,RP0
    bcf	    STATUS,RP1
    bsf     CTRL_DSPL_1 ; Apaga RC0
    bsf     CTRL_DSPL_2 ; Apaga RC1
    bsf     CTRL_DSPL_3 ; Apaga RC2
endm

; === Delay ===

CFG_DELAY_3ms33 macro
    movlw   d'1'
    movwf   DELAY1_Init
    movlw   d'5'
    movwf   DELAY2_Init
    movlw   d'220'
    movwf   DELAY3_Init
endm

CFG_DELAY_300ms macro
    movlw   d'3'
    movwf   DELAY1_Init
    movlw   d'130'
    movwf   DELAY2_Init
    movlw   d'255'
    movwf   DELAY3_Init
endm

CFG_DELAY_1s macro
    movlw   d'10'
    movwf   DELAY1_Init
    movlw   d'130'
    movwf   DELAY2_Init
    movlw   d'255'
    movwf   DELAY3_Init
endm

; === Contador ===

CFG_COUNTER_DSPL macro
   movlw .3
   movf COUNTER_DSPL
endm    
;===============================================================================
; INICIALIZACIÓN DEL MCU (CÓDIGO ABSOLUTO)
;===============================================================================    
    ORG     0x00	;Vector de Reset
    GOTO    INICIO	;Salto al inicio del programa principal
    ORG     0x05	;Ubicación Programa Principal en la memoria 
			;de programa
		
;===============================================================================
; INICIALIZACIÓN DE MACROS PARA CONFIGURACIÓN DE REGISTROS
;===============================================================================    	    
INICIO	    ;-----Inicialización de Macros-------
	CFG_DSPL
        ;call    TEST_DSPL
	CFG_DELAY_3ms33
	CFG_DIGITS_DSPL
		
;===============================================================================
; INICIO PROGRAMA PRINCIPAL
;===============================================================================						
MAIN_LOOP
    ;call MUX_DSPL
    GOTO    MAIN_LOOP	
	
;===============================================================================
; SUBRUTINAS
;===============================================================================	 
;***************************
; @brief    Subrutina de reset.
;           
; @details  Resetea el numero del contador a 3
;***************************
;===============================================================================
RST_COUNTER_DSPL
    movlw .3
    movwf COUNTER_DSPL
    return
;===============================================================================
;***************************
; @brief    Subrutina de decremento de contador.
;           
; @details  Disminuye en 1 el contador COUNTER_DSPL.
;***************************
;===============================================================================
DECF_COUNTER_DSPL
    movlw  .1
    subwf  COUNTER_DSPL, F 
    return
;===============================================================================
;***************************
; @brief    Subrutina de tabla de control.
;           
; @details  Retorna que display vamos a utilizar.
;***************************
;===============================================================================
TABLE_CTRL_DSPL_AC
    addwf   PCL, F
    retlw   b'11111111' ; 0: Displays off
    retlw   b'11111110' ; 1: DSPL1
    retlw   b'11111101' ; 2: DSPL2
    retlw   b'11111011' ; 3: DSPL3
;===============================================================================
;***************************
; @brief    Subrutina de tabla de decodificacion.
;           
; @details  Retorna el hexa para mostrar el numero en el display.
;***************************
;===============================================================================  
TABLE_DECO_DSPL_AC
    addwf   PCL, F
    retlw   0xC0 ; 0 en HEX
    retlw   0xF9 ; 1 en HEX
    retlw   0xA4 ; 2 en HEX
    retlw   0xB0 ; 3 en HEX
    retlw   0x99 ; 4 en HEX
    retlw   0x92 ; 5 en HEX
    retlw   0x82 ; 6 en HEX
    retlw   0xF8 ; 7 en HEX
    retlw   0x80 ; 8 en HEX
    retlw   0x98 ; 9 en HEX
    retlw   0x82 ; G en HEX
    retlw   0xFF ; Off     
;===============================================================================    
    END
;===============================================================================


