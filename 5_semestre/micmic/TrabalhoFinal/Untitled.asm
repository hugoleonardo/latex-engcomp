;PISCA
LIST P=16F628
INCLUDE<P16F628.INC>

#DEFINE BANK0 BCF STATUS,RP0
#DEFINE BANK1 BSF STATUS,RP0

#DEFINE BOTAO_P1 PORTA,0
#DEFINE BOTAO_P2 PORTA,1
#DEFINE BOTAO_P3 PORTA,2
#DEFINE BOTAO_P4 PORTA,3
#DEFINE BOTAO_START PORTA,4

#DEFINE LED_P1 PORTB,0
#DEFINE LED_P2 PORTB,1
#DEFINE LED_P3 PORTB,2
#DEFINE LED_P4 PORTB,3

#DEFINE CONTADOR B'00000000'; ARMAZENA O NUMERO DE BOTOES QUE JA FORAM PRESSIONADOS

;CONTADOR EQU B'00000001'
CHOQUE_P1 EQU B'00000001'
CHOQUE_P2 EQU B'00000010'
CHOQUE_P3 EQU B'00000100'
CHOQUE_P4 EQU B'00001000'

;STATUS GUARDA OS BOTOES QUE JA FORAM PRESSIONADOS

ORG 0X00
GOTO INICIO

INICIO
	BANK1
	MOVLW B'00011111'
	MOVWF TRISA
	MOVLW B'00000000'
	MOVWF TRISB
	BANK0
	CLRF PORTA
	CLRF PORTB

START
	BCF STATUS,0
	BCF STATUS,1
	BCF STATUS,2
	BCF STATUS,3
	BCF STATUS,4
	BTFSS BOTAO_START ; TESTE SE O BOTAO FOI PRESSIONADO
	GOTO MAIN ; SE O BOTAO FOI PRESSIONADO VAI PRA MAIN
	GOTO START	

MAIN
	BTFSC BOTAO_P1; TESTE SE O BOTAO ESTA PRESSIONADO
	CALL BOTAO_P1_PRESS; SE PRESSIONADO GUARDA NO STATUS
	BTFSC BOTAO_P2
	CALL BOTAO_P2_PRESS
	BTFSC BOTAO_P3
	CALL BOTAO_P3_PRESS
	BTFSC BOTAO_P4
	CALL BOTAO_P4_PRESS
	;BTFSC STATUS,0
	;MOVLW CONTADOR
	GOTO CHECAR_CONTADOR
	;GOTO DAR_CHOQUE
	GOTO MAIN

CHECAR_CONTADOR
	BTFSC CONTADOR,0
	RETURN
	BTFSC CONTADOR,1
	RETURN
	GOTO DAR_CHOQUE

DAR_CHOQUE ;TEM QUE ACHAR O PRIMEIRO ZERO
	BTFSS STATUS,0
	MOVLW CHOQUE_P1
	BTFSS STATUS,1
	MOVLW CHOQUE_P2
	BTFSS STATUS,2
	MOVLW CHOQUE_P3
	BTFSS STATUS,3
	MOVLW CHOQUE_P4
	MOVWF PORTB
	GOTO START

BOTAO_P1_PRESS
	BTFSC STATUS,0
	RETURN
	BSF STATUS,0
	MOVLW CONTADOR
	ADDLW 1
	RETURN

BOTAO_P2_PRESS
	BTFSC STATUS,1
	RETURN
	BSF STATUS,1
	MOVLW CONTADOR
	ADDLW 1	
	RETURN

BOTAO_P3_PRESS
	BTFSC STATUS,2
	RETURN
	BSF STATUS,2
	MOVLW CONTADOR
	ADDLW 1
	RETURN

BOTAO_P4_PRESS
	BTFSC STATUS,3
	RETURN
	BSF STATUS,3
	MOVLW CONTADOR
	ADDLW 1 ; CONTADOR++
	RETURN
END